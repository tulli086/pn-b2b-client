package it.pagopa.pn.cucumber.steps.recipient;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementV23;
import it.pagopa.pn.client.b2b.pa.service.IPnWebMandateClient;
import it.pagopa.pn.client.b2b.pa.service.IPnWebRecipientClient;
import it.pagopa.pn.client.b2b.pa.service.utils.SettableBearerToken;
import it.pagopa.pn.client.web.generated.openapi.clients.externalMandate.model.*;
import it.pagopa.pn.client.web.generated.openapi.clients.externalWebRecipient.model.FullReceivedNotificationV23;
import it.pagopa.pn.client.web.generated.openapi.clients.externalWebRecipient.model.NotificationAttachmentDownloadMetadataResponse;
import it.pagopa.pn.cucumber.steps.SharedSteps;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.time.DateUtils;
import org.junit.jupiter.api.Assertions;
import org.opentest4j.AssertionFailedError;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpStatusCodeException;
import java.io.ByteArrayInputStream;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;

import static org.awaitility.Awaitility.await;


@Slf4j
public class RicezioneNotificheWebDelegheSteps {
    private final IPnWebMandateClient webMandateClient;
    private final IPnWebRecipientClient webRecipientClient;
    private final SharedSteps sharedSteps;
    private final PnPaB2bUtils b2bUtils;
    private MandateDto mandateToSearch;
    private final SettableBearerToken.BearerTokenType baseUser = SettableBearerToken.BearerTokenType.USER_2;
    private final String verificationCode = "24411";
    private HttpStatusCodeException notificationError;
    private final String marioCucumberTaxID;
    private final String marioGherkinTaxID;
    private final String gherkinSrltaxId;
    private final String cucumberSpataxId;
    @Value("${pn.external.senderId}")
    private String senderId;
    @Value("${pn.external.senderId-2}")
    private String senderId2;
    @Value("${pn.external.senderId-GA}")
    private String senderIdGA;
    @Value("${pn.external.senderId-SON}")
    private String senderIdSON;
    @Value("${pn.external.senderId-ROOT}")
    private String senderIdROOT;


    @Autowired
    public RicezioneNotificheWebDelegheSteps(IPnWebMandateClient webMandateClient, SharedSteps sharedSteps) {
        this.webMandateClient = webMandateClient;
        this.sharedSteps = sharedSteps;
        this.webRecipientClient = sharedSteps.getWebRecipientClient();
        this.b2bUtils = sharedSteps.getB2bUtils();
        this.marioCucumberTaxID = sharedSteps.getMarioCucumberTaxID();
        this.marioGherkinTaxID = sharedSteps.getMarioGherkinTaxID();
        this.gherkinSrltaxId = sharedSteps.getGherkinSrltaxId();
        this.cucumberSpataxId = sharedSteps.getCucumberSpataxId();
    }

    private String getTaxIdByUser(String user) {

        return switch (user) {
            case "Mario Cucumber" -> marioCucumberTaxID;
            case "Mario Gherkin" -> marioGherkinTaxID;
            case "GherkinSrl" -> gherkinSrltaxId;
            case "CucumberSpa" -> cucumberSpataxId;
            default -> throw new IllegalArgumentException();
        };
    }

    private UserDto getUserDtoByuser(String user) {

        return switch (user.trim().toLowerCase()) {
            case "mario cucumber" -> new UserDto()
                    .displayName("Mario Cucumber")
                    .firstName("Mario")
                    .lastName("Cucumber")
                    .fiscalCode(marioCucumberTaxID)
                    .person(true);
            case "mario gherkin" -> new UserDto()
                    .displayName("Mario Gherkin")
                    .firstName("Mario")
                    .lastName("Gherkin")
                    .fiscalCode(marioGherkinTaxID)
                    .person(true);
            case "gherkinsrl" -> new UserDto()
                    .displayName("gherkinsrl")
                    .firstName("gherkin")
                    .lastName("srl")
                    .fiscalCode(gherkinSrltaxId)
                    .companyName("gherkinsrl")
                    .person(false);
            case "cucumberspa" -> new UserDto()
                    .displayName("cucumberspa")
                    .firstName("cucumber")
                    .lastName("spa")
                    .fiscalCode(cucumberSpataxId)
                    .companyName("cucumberspa")
                    .person(false);
            default -> throw new IllegalArgumentException();
        };
    }

    private boolean setBearerToken(String user) {
        boolean beenSet = switch (user.trim().toLowerCase()) {
            case "mario cucumber" -> webMandateClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_1);
            case "mario gherkin" -> webMandateClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_2);
            case "gherkinsrl" -> webMandateClient.setBearerToken(SettableBearerToken.BearerTokenType.PG_1);
            case "cucumberspa" -> webMandateClient.setBearerToken(SettableBearerToken.BearerTokenType.PG_2);
            default -> false;
        };

        return !beenSet;
    }

    @And("{string} viene delegato da {string}")
    public void delegateUser(String delegate, String delegator) {
        if (setBearerToken(delegator)) {
            throw new IllegalArgumentException();
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        MandateDto mandate = (new MandateDto()
                .delegator(getUserDtoByuser(delegator))
                .delegate(getUserDtoByuser(delegate))
                .verificationCode(verificationCode)
                .datefrom(sdf.format(new Date()))
                .visibilityIds(new LinkedList<>())
                .status(MandateDto.StatusEnum.PENDING)
                .dateto(sdf.format(DateUtils.addDays(new Date(), 1)))
        );

        System.out.println("MANDATE: " + mandate);
        try {
            webMandateClient.createMandate(mandate);
        } catch (HttpStatusCodeException e) {
            this.notificationError = e;
        }
    }


    @And("{string} viene delegato da {string} per comune {string}")
    public void delegateUser(String delegate, String delegator, String comune) {
        if (setBearerToken(delegator)) {
            throw new IllegalArgumentException();
        }
        OrganizationIdDto organizationIdDto = new OrganizationIdDto();

         switch (comune) {
            case "Comune_1" -> organizationIdDto
                    .name("Comune di Milano")
                    .uniqueIdentifier(senderId);
            case "Comune_2" -> organizationIdDto
                    .name("Comune di Verona")
                    .uniqueIdentifier(senderId2);
            case "Comune_Multi" -> organizationIdDto
                    .name("Comune di Palermo")
                    .uniqueIdentifier(senderIdGA);
            case "Comune_Son" -> organizationIdDto
                    .name("Ufficio per la transizione al Digitale")
                    .uniqueIdentifier(senderIdSON);
            case "Comune_Root" -> organizationIdDto
                    .name("Comune di Aglientu")
                    .uniqueIdentifier(senderIdROOT);
            default -> throw new IllegalStateException();
        }


        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        MandateDto mandate = (new MandateDto()
                .delegator(getUserDtoByuser(delegator))
                .delegate(getUserDtoByuser(delegate))
                .verificationCode(verificationCode)
                .datefrom(sdf.format(new Date()))
                .visibilityIds(Arrays.asList(organizationIdDto))
                .status(MandateDto.StatusEnum.PENDING)
                .dateto(sdf.format(DateUtils.addDays(new Date(), 1)))
        );

        System.out.println("MANDATE: " + mandate);

        try {
            webMandateClient.createMandate(mandate);
        } catch (HttpStatusCodeException e) {
            this.sharedSteps.setNotificationError(e);
        }
    }

    @Given("{string} rifiuta se presente la delega ricevuta {string}")
    public void userRejectIfPresentMandateOfAnotheruser(String delegate, String delegator) {
        if (setBearerToken(delegate)) {
            throw new IllegalArgumentException();
        }
        String delegatorTaxId = getTaxIdByUser(delegator);

        List<MandateDto> mandateList = webMandateClient.searchMandatesByDelegate(delegatorTaxId, null);

        //List<MandateDto> mandateList = webMandateClient.listMandatesByDelegate1(null);
        MandateDto mandateDto = null;
        for (MandateDto mandate : mandateList) {
            log.debug("MANDATE-LIST: {}", mandateList);
            if (Objects.requireNonNull(mandate.getDelegator()).getFiscalCode() != null && mandate.getDelegator().getFiscalCode().equalsIgnoreCase(delegatorTaxId)) {
                mandateDto = mandate;
                break;
            }
        }
        if (mandateDto != null) {
            MandateDto finalMandateDto = mandateDto;
            Assertions.assertDoesNotThrow(() -> webMandateClient.rejectMandate(finalMandateDto.getMandateId()));

        }
    }

    @And("{string} accetta la delega {string}")
    public void userAcceptsMandateOfAnotherUser(String delegate, String delegator) {
        if (setBearerToken(delegate)) {
            throw new IllegalArgumentException();
        }
        String delegatorTaxId = getTaxIdByUser(delegator);

        List<MandateDto> mandateList = webMandateClient.searchMandatesByDelegate(delegatorTaxId, null);
        // List<MandateDto> mandateList = webMandateClient.listMandatesByDelegate1(null);
        System.out.println("MANDATE-LIST: " + mandateList);
        MandateDto mandateDto = mandateList.stream().filter(mandate -> Objects.requireNonNull(mandate.getDelegator()).getFiscalCode() != null && mandate.getDelegator().getFiscalCode().equalsIgnoreCase(delegatorTaxId)).findFirst().orElse(null);

        Assertions.assertNotNull(mandateDto);
        this.mandateToSearch = mandateDto;
        Assertions.assertDoesNotThrow(() -> webMandateClient.acceptMandate(mandateDto.getMandateId(), new AcceptRequestDto().verificationCode(verificationCode)));

    }

    @And("la notifica può essere correttamente letta da {string} con delega")
    public void notificationCanBeCorrectlyReadFromWithMandate(String recipient) {
        sharedSteps.selectUser(recipient);
        Assertions.assertDoesNotThrow(() -> {
            webRecipientClient.getReceivedNotification(sharedSteps.getSentNotification().getIun(), mandateToSearch.getMandateId());
        });
    }

    @Then("come amministratore {string} associa alla delega il primo gruppo disponibile attivo per il delegato {string}")
    public void comeAmministratoreDaVoglioModificareUnaDelegaPerAssociarlaAdUnGruppo(String recipient, String delegato) {
        sharedSteps.selectUser(delegato);

        //TODO Recuperare i gruppi della PG come Admin....
        List<HashMap<String, String>> resp = sharedSteps.getPnExternalServiceClient().pgGroupInfo(webRecipientClient.getBearerTokenSetted());
        String gruppoAttivo = null;
        if (resp != null && !resp.isEmpty()) {
            for (HashMap<String, String> entry : resp) {
                if ("ACTIVE".equals(entry.get("status"))) {
                    gruppoAttivo = entry.get("id");
                    break;
                }
            }
        }


        String xPagopaPnCxRole = "ADMIN";
        //TODO capire dove recuperare il dato
        //Questo è l’identificativo della PG, e come gli altri header viene recuperato dal token JWT di autorizzazione
        String xPagopaPnCxId = switch (webRecipientClient.getBearerTokenSetted()) {
            case PG_1 -> sharedSteps.getIdOrganizationGherkinSrl();
            case PG_2 -> sharedSteps.getIdOrganizationCucumberSpa();
            default -> null;
        };

        List<String> gruppi = new ArrayList<>();
        if (gruppoAttivo != null && !gruppoAttivo.isEmpty()) {
            gruppi.add(gruppoAttivo);
        }

        UpdateRequestDto updateRequestDto = new UpdateRequestDto();
        updateRequestDto.setGroups(gruppi);

        Assertions.assertDoesNotThrow(() -> webMandateClient.updateMandate(xPagopaPnCxId, CxTypeAuthFleet.PG, mandateToSearch.getMandateId(), null, xPagopaPnCxRole, updateRequestDto));

        String delegatorTaxId = getTaxIdByUser(recipient);
        List<MandateDto> mandateList = webMandateClient.searchMandatesByDelegate(delegatorTaxId, null);
        MandateDto mandateDto = null;
        for (MandateDto mandate : mandateList) {
            if (Objects.requireNonNull(mandate.getMandateId()).equalsIgnoreCase(mandateToSearch.getMandateId())) {
                mandateDto = mandate;
                break;
            }
        }
        String gruppoAssegnato = "";
        if (mandateDto != null && mandateDto.getGroups() != null && !mandateDto.getGroups().isEmpty()) {
            gruppoAssegnato = mandateDto.getGroups().get(0).getId();
        }

        Assertions.assertNotNull(gruppoAttivo);
        Assertions.assertEquals(gruppoAttivo, gruppoAssegnato);

    }

    @Then("il documento notificato può essere correttamente recuperato da {string} con delega")
    public void theDocumentCanBeProperlyRetrievedByWithMandate(String recipient) {
        sharedSteps.selectUser(recipient);
        NotificationAttachmentDownloadMetadataResponse downloadResponse = getReceivedNotificationDocument();
        verifySha256(downloadResponse);
    }

    @Then("il documento notificato non può essere correttamente recuperato da {string} con delega restituendo un errore {string}")
    public void theDocumentCanNotBeProperlyRetrievedByWithMandate(String recipient, String statusCode) {
        sharedSteps.selectUser(recipient);

        try {
            Assertions.assertDoesNotThrow(() -> {
                getReceivedNotificationDocument();
            });
        } catch (AssertionFailedError assertionFailedError) {
            System.out.println(assertionFailedError.getCause().toString());
            System.out.println(assertionFailedError.getCause().getMessage());
            System.out.println(assertionFailedError.getCause().getMessage().substring(0, 3).equals(statusCode));
        }

    }

    private NotificationAttachmentDownloadMetadataResponse getReceivedNotificationDocument() {
        return webRecipientClient.getReceivedNotificationDocument(
                sharedSteps.getSentNotification().getIun(),
                Integer.parseInt(Objects.requireNonNull(sharedSteps.getSentNotification().getDocuments().get(0).getDocIdx())),
                UUID.fromString(Objects.requireNonNull(mandateToSearch.getMandateId()))
        );
    }

    @Then("l'allegato {string} può essere correttamente recuperato da {string} con delega")
    public void attachmentCanBeCorrectlyRetrievedFromWithMandate(String attachmentName, String recipient) {
        //TODO Modificare attachmentIdx al momento e 0...............
        sharedSteps.selectUser(recipient);
        NotificationAttachmentDownloadMetadataResponse downloadResponse = webRecipientClient.getReceivedNotificationAttachment(
                sharedSteps.getSentNotification().getIun(),
                attachmentName,
                UUID.fromString(Objects.requireNonNull(mandateToSearch.getMandateId())), 0);

        if (downloadResponse != null && downloadResponse.getRetryAfter() != null && downloadResponse.getRetryAfter() > 0) {
            try {
                await().atMost(downloadResponse.getRetryAfter() * 3L, TimeUnit.MILLISECONDS);
                downloadResponse = webRecipientClient.getReceivedNotificationAttachment(
                        sharedSteps.getSentNotification().getIun(),
                        attachmentName,
                        UUID.fromString(mandateToSearch.getMandateId()), 0);
            } catch (RuntimeException exc) {
                log.error("Await error exception: {}", exc.getMessage());
                throw exc;
            }
        }
        if (!"F24".equalsIgnoreCase(attachmentName)) {
            verifySha256(downloadResponse);
        }
    }

    private void verifySha256(NotificationAttachmentDownloadMetadataResponse downloadResponse) {
        AtomicReference<String> Sha256 = new AtomicReference<>("");
        Assertions.assertDoesNotThrow(() -> {
            byte[] bytes = Assertions.assertDoesNotThrow(() ->
                    b2bUtils.downloadFile(Objects.requireNonNull(downloadResponse).getUrl()));
            Sha256.set(b2bUtils.computeSha256(new ByteArrayInputStream(bytes)));
        });
        Assertions.assertEquals(Sha256.get(), Objects.requireNonNull(downloadResponse).getSha256());
    }

    @And("{string} revoca la delega a {string}")
    public void userRevokesMandate(String delegator, String delegate) {
        if (setBearerToken(delegator)) {
            throw new IllegalArgumentException();
        }

        List<MandateDto> mandateList = webMandateClient.listMandatesByDelegator1();
        System.out.println("MANDATE LIST: " + mandateList);
        MandateDto mandateDto = null;
        for (MandateDto mandate : mandateList) {
            if (Objects.requireNonNull(mandate.getDelegate()).getLastName() != null &&
                    Objects.requireNonNull(mandate.getDelegate().getDisplayName()).equalsIgnoreCase(delegate)) {
                mandateDto = mandate;
                break;
            }
        }

        Assertions.assertNotNull(mandateDto);
        this.mandateToSearch = mandateDto;
        webMandateClient.revokeMandate(mandateDto.getMandateId());
    }

    @And("{string} rifiuta la delega ricevuta da {string}")
    public void delegateRefusesMandateReceivedFromDelegator(String delegate, String delegator) {
        if (setBearerToken(delegate)) {
            throw new IllegalArgumentException();
        }
        String delegatorTaxId = getTaxIdByUser(delegator);

        List<MandateDto> mandateList = webMandateClient.searchMandatesByDelegate(delegatorTaxId, null);
        MandateDto mandateDto = null;
        for (MandateDto mandate : mandateList) {
            if (Objects.requireNonNull(mandate.getDelegator()).getFiscalCode() != null && mandate.getDelegator().getFiscalCode().equalsIgnoreCase(delegatorTaxId)) {
                mandateDto = mandate;
                break;
            }
        }

        Assertions.assertNotNull(mandateDto);
        this.mandateToSearch = mandateDto;
        webMandateClient.rejectMandate(mandateDto.getMandateId());
    }

    @Then("si tenta la lettura della notifica da parte del delegato {string} che produce un errore con status code {string}")
    public void readNotificationWithError(String recipient, String statusCode) {
        sharedSteps.selectUser(recipient);
        HttpClientErrorException httpClientErrorException = null;
        try {
            webRecipientClient.getReceivedNotification(sharedSteps.getSentNotification().getIun(), mandateToSearch.getMandateId());
        } catch (HttpClientErrorException e) {
            httpClientErrorException = e;
        }
        Assertions.assertTrue((httpClientErrorException != null) &&
                (httpClientErrorException.getStatusCode().toString().substring(0, 3).equals(statusCode)));
    }


    @Then("l'operazione di delega ha prodotto un errore con status code {string}")
    public void operationProducedAnErrorWithStatusCode(String statusCode) {
        Assertions.assertTrue((notificationError != null) &&
                (notificationError.getStatusCode().toString().substring(0, 3).equals(statusCode)));
    }

    @And("la notifica può essere correttamente letta da {string}")
    public void notificationCanBeCorrectlyReadFrom(String recipient) {
        sharedSteps.selectUser(recipient);
        Assertions.assertDoesNotThrow(() -> {
            webRecipientClient.getReceivedNotification(sharedSteps.getSentNotification().getIun(), null);
        });
        webRecipientClient.setBearerToken(baseUser);
    }

    @And("lato destinatario la notifica può essere correttamente recuperata da {string} e verifica presenza dell'evento di timeline NOTIFICATION_RADD_RETRIEVED")
    public void notificationCanBeCorrectlyReadFromBytimeline(String recipient) {
        sharedSteps.selectUser(recipient);

        try {
            it.pagopa.pn.client.web.generated.openapi.clients.externalWebRecipient.model.TimelineElementCategoryV23 timelineElementCategoryV23 =
                    it.pagopa.pn.client.web.generated.openapi.clients.externalWebRecipient.model.TimelineElementCategoryV23.NOTIFICATION_RADD_RETRIEVED;
            it.pagopa.pn.client.web.generated.openapi.clients.externalWebRecipient.model.TimelineElementV23 timelineElement = getTimelineElementV23WebRecipient(timelineElementCategoryV23);

            Assertions.assertNotNull(timelineElement);
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }

        webRecipientClient.setBearerToken(baseUser);
    }

    @And("lato desinatario {string} viene verificato che l'elemento di timeline NOTIFICATION_VIEWED non esista")
    public void notificationCanBeCorrectlyReadFromBytimelineNotExist(String recipient) {
        sharedSteps.selectUser(recipient);

        try {
            it.pagopa.pn.client.web.generated.openapi.clients.externalWebRecipient.model.TimelineElementCategoryV23 timelineElementCategoryV23 =
                    it.pagopa.pn.client.web.generated.openapi.clients.externalWebRecipient.model.TimelineElementCategoryV23.NOTIFICATION_VIEWED;
            it.pagopa.pn.client.web.generated.openapi.clients.externalWebRecipient.model.TimelineElementV23 timelineElement = getTimelineElementV23WebRecipient(timelineElementCategoryV23);

            Assertions.assertNull(timelineElement);
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
        webRecipientClient.setBearerToken(baseUser);
    }

    private it.pagopa.pn.client.web.generated.openapi.clients.externalWebRecipient.model.TimelineElementV23 getTimelineElementV23WebRecipient(it.pagopa.pn.client.web.generated.openapi.clients.externalWebRecipient.model.TimelineElementCategoryV23 timelineElementCategoryV23) {

        FullReceivedNotificationV23 result = webRecipientClient.getReceivedNotification(sharedSteps.getSentNotification().getIun(), null);
        log.info("NOTIFICATION_TIMELINE: " + sharedSteps.getSentNotification().getTimeline());

        return result
                .getTimeline()
                .stream()
                .filter(elem -> Objects.requireNonNull(elem.getCategory())
                        .equals(timelineElementCategoryV23))
                .findAny()
                .orElse(null);
    }

    @And("la notifica può essere correttamente letta da {string} per comune {string}")
    public void notificationCanBeCorrectlyReadFromAtPa(String recipient, String pa) {
        sharedSteps.selectPA(pa);
        sharedSteps.selectUser(recipient);
        Assertions.assertDoesNotThrow(() -> {
            webRecipientClient.getReceivedNotification(sharedSteps.getSentNotification().getIun(), null);
        });
    }

    @And("si verifica che l'elemento di timeline della lettura riporti i dati di {string}")
    public void siVerificaCheLElementoDiTimelineDellaLetturaRiportiIDatiDi(String user) {
        TimelineElementV23 timelineElement = getTimelineElementV23();

        String userTaxId = getTaxIdByUser(user);
        System.out.println("TIMELINE ELEMENT: " + timelineElement);
        Assertions.assertNotNull(timelineElement);
        Assertions.assertNotNull(timelineElement.getDetails());
        Assertions.assertNotNull(timelineElement.getDetails().getDelegateInfo());
        Assertions.assertEquals(userTaxId, timelineElement.getDetails().getDelegateInfo().getTaxId());
    }

    @And("si verifica che l'elemento di timeline della lettura non riporti i dati del delegato")
    public void siVerificaCheLElementoDiTimelineDellaLetturaNonRiportiIDatiDi() {
        TimelineElementV23 timelineElement = getTimelineElementV23();

        System.out.println("TIMELINE ELEMENT: " + timelineElement);
        Assertions.assertNotNull(timelineElement);
        Assertions.assertNotNull(timelineElement.getDetails());
        Assertions.assertNull(timelineElement.getDetails().getDelegateInfo());
    }

    private TimelineElementV23 getTimelineElementV23() {
        try {
            await().atMost(sharedSteps.getWorkFlowWait() * 2, TimeUnit.MILLISECONDS);
        } catch (RuntimeException exception) {
            exception.printStackTrace();
        }
        sharedSteps.setSentNotification(sharedSteps.getB2bClient().getSentNotification(sharedSteps.getSentNotification().getIun()));

        return sharedSteps
                .getSentNotification()
                .getTimeline()
                .stream()
                .filter(elem -> Objects.requireNonNull(elem.getCategory())
                        .equals(TimelineElementCategoryV23.NOTIFICATION_VIEWED))
                .findAny()
                .orElse(null);
    }

    //for debug
    @And("{string} visualizza le deleghe")
    public void visualizzaLeDeleghe(String user) {
        if (setBearerToken(user)) {
            throw new IllegalArgumentException();
        }

        List<MandateDto> mandateList = webMandateClient.listMandatesByDelegate1(null);
        List<MandateDto> mandateDtos = webMandateClient.listMandatesByDelegator1();

        System.out.println("TOKEN SETTED (user: +" + user + ") : " + webMandateClient.getBearerTokenSetted());
        System.out.println("MANDATE-LIST (user: +" + user + ") : " + mandateList);
        System.out.println("TOKEN SETTED (user: +" + user + ") : " + webMandateClient.getBearerTokenSetted());
        System.out.println("MANDATE-LIST-DELEGATOR (user: +" + user + ") : " + mandateDtos);
    }
}