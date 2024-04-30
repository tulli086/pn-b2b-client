package it.pagopa.pn.cucumber.steps;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import io.cucumber.java.Before;
import io.cucumber.java.BeforeAll;
import io.cucumber.java.Scenario;
import io.cucumber.java.Transpose;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.config.PnB2bClientTimingConfigs;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.*;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingFactory;
import it.pagopa.pn.client.b2b.pa.service.IPnPaB2bClient;
import it.pagopa.pn.client.b2b.pa.service.IPnWebPaClient;
import it.pagopa.pn.client.b2b.pa.service.IPnWebRecipientClient;
import it.pagopa.pn.client.b2b.pa.service.IPnWebUserAttributesClient;
import it.pagopa.pn.client.b2b.pa.service.impl.*;
import it.pagopa.pn.client.b2b.pa.service.utils.SettableApiKey;
import it.pagopa.pn.client.b2b.pa.service.utils.SettableBearerToken;
import it.pagopa.pn.client.b2b.pa.config.springconfig.RestTemplateConfiguration;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2.ProgressResponseElement;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.ProgressResponseElementV23;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.StreamMetadataResponseV23;
import it.pagopa.pn.client.web.generated.openapi.clients.externalApiKeyManager.model.RequestNewApiKey;
import it.pagopa.pn.client.web.generated.openapi.clients.externalApiKeyManager.model.ResponseNewApiKey;
import it.pagopa.pn.client.web.generated.openapi.clients.externalUserAttributes.addressBook.model.LegalAndUnverifiedDigitalAddress;
import it.pagopa.pn.client.web.generated.openapi.clients.externalUserAttributes.addressBook.model.LegalChannelType;
import it.pagopa.pn.cucumber.utils.*;
import lombok.Getter;
import lombok.Setter;
import org.junit.jupiter.api.Assertions;
import org.opentest4j.AssertionFailedError;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.boot.convert.DurationStyle;
import org.springframework.context.annotation.Scope;
import org.springframework.util.Base64Utils;
import org.springframework.web.client.HttpStatusCodeException;
import java.io.IOException;
import java.lang.invoke.MethodHandles;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.OffsetDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentLinkedQueue;
import static it.pagopa.pn.cucumber.utils.FiscalCodeGenerator.generateCF;
import static it.pagopa.pn.cucumber.utils.NotificationValue.*;


@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class SharedSteps {
    @Getter
    private final IPnPaB2bClient b2bClient;

    @Getter
    private final IPnWebPaClient webPaClient;

    @Getter
    private final PnGPDClientImpl pnGPDClientImpl;

    @Getter
    private final PnPaymentInfoClientImpl pnPaymentInfoClientImpl;

    @Getter
    private final PnPaB2bUtils b2bUtils;

    @Getter
    private final IPnWebRecipientClient webRecipientClient;

    @Getter
    private final PnExternalServiceClientImpl pnExternalServiceClient;

    @Getter
    private final PnServiceDeskClientImpl serviceDeskClient;

    @Setter
    @Getter
    private NewNotificationResponse newNotificationResponse;

    @Getter
    @Setter
    private NewNotificationRequestV23 notificationRequest;

    @Setter
    private HttpStatusCodeException notificationError;

    @Getter
    private OffsetDateTime notificationCreationDate;

    @Getter
    private final String gherkinSrltaxId = "12666810299";

    @Getter
    private final String cucumberSpataxId = "20517490320"; //

    @Getter
    private SettableApiKey.ApiKeyType apiKeyTypeSetted = SettableApiKey.ApiKeyType.MVP_1;

    @Getter
    private final PnPollingFactory pollingFactory;

    @Getter
    @Setter
    private ProgressResponseElement progressResponseElement;

    @Getter
    @Setter
    private RequestNewApiKey requestNewApiKey;

    @Getter
    @Setter
    private ResponseNewApiKey responseNewApiKey;

    @Getter
    @Setter
    private TimelineElementV23 timelineElementV23;

    @Getter
    @Setter
    private ProgressResponseElementV23 progressResponseElementV23;

    @Getter
    @Setter
    private it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2.StreamMetadataResponse eventStream;

    @Getter
    @Setter
    private StreamMetadataResponseV23 eventStreamV23;

    @Getter
    @Setter
    private List<it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2.ProgressResponseElement> progressResponseElements = null;

    @Getter
    @Setter
    @Value("${pn.external.bearer-token-pg1.id}")
    private String idOrganizationGherkinSrl;

    @Getter
    @Setter
    @Value("${pn.external.bearer-token-pg2.id}")
    private String idOrganizationCucumberSpa;

    @Getter
    @Setter
    private List<ProgressResponseElementV23> progressResponseElementsV23 = null;

    @Value("${pn.interop.base-url}")
    private String interopBaseUrl;

    @Value("${pn.interop.token-oauth2.path}")
    private String tokenOauth2Path;

    @Value("${pn.interop.token-oauth2.client-assertion}")
    private String clientAssertion;

    @Value("${pn.external.utilized.pec:testpagopa3@pec.pagopa.it}")
    private String digitalAddress;

    @Value("${pn.external.api-key-taxID}")
    private String senderTaxId;

    @Value("${pn.external.api-key-2-taxID}")
    private String senderTaxIdTwo;

    @Value("${pn.external.api-key-GA-taxID}")
    private String senderTaxIdGa;

    @Value("${pn.external.api-key-SON-taxID}")
    private String senderTaxIdSON;

    @Value("${pn.external.api-key-ROOT-taxID}")
    private String senderTaxIdROOT;

    @Getter
    @Value("${pn.bearer-token.user1.taxID}")
    private String marioCucumberTaxID;

    @Getter
    @Value("${pn.bearer-token.user2.taxID}")
    private String marioGherkinTaxID;

    private final DataTableTypeUtil dataTableTypeUtil;
    private List<String> iuvGPD;
    private final IPnWebUserAttributesClient iPnWebUserAttributesClient;
    private final PnServiceDeskClientImplNoApiKey serviceDeskClientImplNoApiKey;
    private final PnServiceDeskClientImplWrongApiKey serviceDeskClientImplWrongApiKey;
    private it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.NewNotificationResponse newNotificationResponseV1;
    private it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.NewNotificationResponse newNotificationResponseV2;
    private it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v21.NewNotificationResponse newNotificationResponseV21;
    private it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.NewNotificationRequest notificationRequestV1;
    private it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.NewNotificationRequest notificationRequestV2;
    private it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v21.NewNotificationRequestV21 notificationRequestV21;
    private FullSentNotificationV23 notificationResponseComplete;
    private it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.FullSentNotification notificationResponseCompleteV1;
    private it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.FullSentNotificationV20 notificationResponseCompleteV2;
    private it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v21.FullSentNotificationV21 notificationResponseCompleteV21;
    private String settedPa = "Comune_1";
    private boolean groupToSet = true;
    private String errorCode = null;
    public static Integer lastEventID = 0;
    private final SecureRandom secureRandom = new SecureRandom();
    private final PnB2bClientTimingConfigs timingConfigs;
    private final Duration schedulingDaysSuccessDigitalRefinementDefault = DurationStyle.detectAndParse("6m");
    private final Duration schedulingDaysFailureDigitalRefinementDefault = DurationStyle.detectAndParse("6m");
    private final Duration schedulingDaysSuccessAnalogRefinementDefault = DurationStyle.detectAndParse("2m");
    private final Duration schedulingDaysFailureAnalogRefinementDefault = DurationStyle.detectAndParse("4m");
    private final Duration timeToAddInNonVisibilityTimeCaseDefault = DurationStyle.detectAndParse("10m");
    private final Duration secondNotificationWorkflowWaitingTimeDefault = DurationStyle.detectAndParse("6m");
    private final Duration waitingForReadCourtesyMessageDefault = DurationStyle.detectAndParse("5m");
    private final String gherkinSpaTaxID = "12666810299";
    //  private String cucumberSrlTaxID = "SCTPTR04A01C352E";
    private final String cucumberSrlTaxID = "20517490320";
    private final String cucumberSocietyTaxID = "20517490320";// "DNNGRL83A01C352D";
    private final String gherkinIrreperibileTaxID = "00749900049";
    private final ObjectMapper objMapper = JsonMapper.builder()
            .addModule(new JavaTimeModule())
            .build();
    private static final Integer WAITING_GPD = 2000;
    private static final Logger logger = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    public static final String DEFAULT_PA = "Comune_1";
    private static final String cucumberAnalogicTaxID = "SNCLNN65D19Z131V";
    // private String gherkinSrltaxId = "CCRMCT06A03A433H";
    private static final String gherkinAnalogicTaxID = "05722930657";
    private static final String defaultDigitalAddress = "testpagopa3@pec.pagopa.it";
    private static final String schedulingDeltaDefault = "500";
    private static final Integer workFlowWaitDefault = 31000;
    private static final Integer waitDefault = 10000;
    private static final Integer WORKFLOW_WAIT_UPPER_BOUND = 2900;
    private static final Integer WAIT_UPPER_BOUND = 950;
    private static final String ALLEGATO = "ALLEGATO";
    private static final String EXTENSION = "EXTENSION";
    private static final String SHA_256 = "SHA_256";
    private static final String TAX_ID = "TAX_ID";
    private static final String ADDRESS = "ADDRESS";
    private static final String FILE_NOTFOUND = "FILE_NOTFOUND";
    private static final String FILE_SHA_ERROR = "FILE_SHA_ERROR";
    private static final String TAXID_NOT_VALID = "TAXID_NOT_VALID";
    private static final String INVALID_PARAMETER_MAX_ATTACHMENT = "INVALID_PARAMETER_MAX_ATTACHMENT";
    private static final String FILE_PDF_INVALID_ERROR = "FILE_PDF_INVALID_ERROR";
    private static final String NOT_VALID_ADDRESS = "NOT_VALID_ADDRESS";


    @Autowired
    public SharedSteps(DataTableTypeUtil dataTableTypeUtil, IPnPaB2bClient b2bClient,
                       PnPaB2bUtils b2bUtils, IPnWebRecipientClient webRecipientClient,
                       PnExternalServiceClientImpl pnExternalServiceClient,
                       IPnWebUserAttributesClient iPnWebUserAttributesClient, IPnWebPaClient webPaClient,
                       PnServiceDeskClientImpl serviceDeskClient, PnServiceDeskClientImplNoApiKey serviceDeskClientImplNoApiKey,
                       PnServiceDeskClientImplWrongApiKey serviceDeskClientImplWrongApiKey, PnGPDClientImpl pnGPDClientImpl,
                       PnPaymentInfoClientImpl pnPaymentInfoClientImpl, PnB2bClientTimingConfigs timingConfigs,
                       PnPollingFactory pollingFactory) {
        this.dataTableTypeUtil = dataTableTypeUtil;
        this.b2bClient = b2bClient;
        this.webPaClient = webPaClient;
        this.b2bUtils = b2bUtils;
        this.webRecipientClient = webRecipientClient;
        this.pnExternalServiceClient = pnExternalServiceClient;
        this.iPnWebUserAttributesClient = iPnWebUserAttributesClient;
        this.serviceDeskClient = serviceDeskClient;
        this.serviceDeskClientImplNoApiKey = serviceDeskClientImplNoApiKey;
        this.serviceDeskClientImplWrongApiKey = serviceDeskClientImplWrongApiKey;
        this.pnGPDClientImpl = pnGPDClientImpl;
        this.pnPaymentInfoClientImpl = pnPaymentInfoClientImpl;
        this.iuvGPD = new ArrayList<>();
        this.timingConfigs = timingConfigs;
        this.pollingFactory = pollingFactory;
    }
    @BeforeAll
    public static void before_all() {
        logger.debug("SHARED_GLUE START");
        //only for class activation
    }

    @Before
    public void injectScenarioNameInsideSfl4jMdc(Scenario scenario) {
        String scenarioName = scenario.getName();
        MDC.put(RestTemplateConfiguration.CUCUMBER_SCENARIO_NAME_MDC_ENTRY, scenarioName);
    }

    @Before("@integrationTest")
    public void doSomethingAfter() {
        this.groupToSet = false;
    }

    @Given("viene generata una nuova notifica")
    public void vieneGenerataUnaNotifica(@Transpose NewNotificationRequestV23 notificationRequest) {
        this.notificationRequest = notificationRequest;
    }

    @Given("viene generata una nuova notifica V1")
    public void vieneGenerataUnaNotificaV1(@Transpose it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.NewNotificationRequest notificationRequestV1) {
        this.notificationRequestV1 = notificationRequestV1;
    }

    @Given("viene generata una nuova notifica V2")
    public void vieneGenerataUnaNotificaV2(@Transpose it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.NewNotificationRequest notificationRequestV2) {
        this.notificationRequestV2 = notificationRequestV2;
    }

    @Given("viene generata una nuova notifica V21")
    public void vieneGenerataUnaNotificaV21(@Transpose it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v21.NewNotificationRequestV21 notificationRequestV21) {
        this.notificationRequestV21 = notificationRequestV21;
    }

    @And("destinatario")
    public void destinatario(Map<String, String> data) { //@Transpose NotificationRecipientV21 recipient
        addRecipientToNotification(this.notificationRequest, dataTableTypeUtil.convertNotificationRecipient(data), data);
    }

    @And("al destinatario viene associato lo iuv creato mediante partita debitoria alla posizione {int}")
    public void destinatarioAddIuvGPD(Integer posizione) {
        //int numberofPayment=notificationRequest.getRecipients().get(0).getPayments().size();
        //for(int i=0;i<numberofPayment;i++)
        //this.notificationRequest.getRecipients().get(0).getPayments().get(0).getPagoPa().setNoticeCode(getIuvGPD());
        //this.notificationRequest.getRecipients().get(0).getPayments().get(i).getPagoPa().setNoticeCode(getIuvGPD().get(i))
        Objects.requireNonNull(Objects.requireNonNull(this.notificationRequest.getRecipients().get(0).getPayments()).get(posizione).getPagoPa()).setNoticeCode(getIuvGPD(posizione));
    }

    @And("destinatario V1")
    public void destinatario(@Transpose it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.NotificationRecipient recipient) {
        this.notificationRequestV1.addRecipientsItem(recipient);
    }

    @And("destinatario V2")
    public void destinatario(@Transpose it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.NotificationRecipient recipient) {
        this.notificationRequestV2.addRecipientsItem(recipient);
    }

    /*
    Invio massivo di notifiche irreperibili utili per i test radd
    TODO: migliorare e rendere di utilità generale
     */
    @Given("vengono inviate {int} notifiche per l'utente Signor casuale con il {string} e si aspetta fino allo stato COMPLETELY_UNREACHABLE")
    public void vengonoInviateNotifichePerLUtenteSignorCasualeConIlESiAspettaFinoAlloStatoCOMPLETELY_UNREACHABLE(int numberOfNotification, String pa) {
        List<NewNotificationRequestV23> notificationRequests = new LinkedList<>();
        String generatedFiscalCode = generateCF(System.currentTimeMillis());
        for (int i = 0; i < numberOfNotification; i++) {
            NewNotificationRequestV23 newNotificationRequestV23 = dataTableTypeUtil.convertNotificationRequest(new HashMap<>())
                    .subject("notifica analogica con cucumber")
                    .senderDenomination("Comune di palermo")
                    .physicalCommunicationType(NewNotificationRequestV23.PhysicalCommunicationTypeEnum.AR_REGISTERED_LETTER);

            HashMap<String, String> notificationRecipientMap = new HashMap<>();
            notificationRecipientMap.put("digitalDomicile", "NULL");
            notificationRecipientMap.put("physicalAddress_address", "Via NationalRegistries @fail-Irreperibile_AR");
            NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(notificationRecipientMap);
            addRecipientToNotification(newNotificationRequestV23,
                    updateNotificationRecipientV23(notificationRecipientV23,
                            "signor RaddCasuale",
                            generatedFiscalCode,
                            NotificationRecipientV23.RecipientTypeEnum.PF,
                            null
                            ),
                    notificationRecipientMap);


            this.notificationRequest = newNotificationRequestV23;
            selectPA(pa);
            setSenderTaxIdFromProperties();
            notificationRequests.add(newNotificationRequestV23);
        }//for

        List<Thread> threadList = new LinkedList<>();
        ConcurrentLinkedQueue<FullSentNotificationV23> sentNotifications = new ConcurrentLinkedQueue<>();

        for (NewNotificationRequestV23 notification : notificationRequests) {
            Thread t = new Thread(() -> {
                //INVIO NOTIFICA ED ATTESA ACCEPTED
                NewNotificationResponse internalNotificationResponse = Assertions.assertDoesNotThrow(() -> b2bUtils.uploadNotification(notification));
                try {
                    Thread.sleep(getWait());
                } catch (InterruptedException e) {
                    logger.error("Thread.sleep error retry");
                    throw new RuntimeException(e);
                }
                FullSentNotificationV23 fullSentNotificationV23 = b2bUtils.waitForRequestAcceptation(internalNotificationResponse);
                Assertions.assertNotNull(fullSentNotificationV23);

                //ATTESA ELEMENTO DI TIMELINE
                TimelineElementV23 timelineElementV23 = null;
                for (int i = 0; i < 33; i++) {
                    try {
                        Thread.sleep(getWorkFlowWait());
                    } catch (InterruptedException exc) {
                        throw new RuntimeException(exc);
                    }
                    fullSentNotificationV23 = b2bClient.getSentNotification(fullSentNotificationV23.getIun());
                    logger.info("NOTIFICATION_TIMELINE: " + fullSentNotificationV23.getTimeline());
                    timelineElementV23 = fullSentNotificationV23.getTimeline().stream().filter(elem -> Objects.requireNonNull(elem.getCategory()).equals(TimelineElementCategoryV23.COMPLETELY_UNREACHABLE)).findAny().orElse(null);
                    if (timelineElementV23 != null) {
                        break;
                    }
                }
                Assertions.assertNotNull(timelineElementV23);
                sentNotifications.add(fullSentNotificationV23);
            });

            threadList.add(t);
            t.start();
        }
        int attempts = 0;
        boolean completed = false;

        while (attempts < 50) {
            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            int counter = 0;
            for (Thread thread : threadList) {
                if (!thread.isAlive()) counter++;
            }
            if (counter == threadList.size()) {
                completed = true;
                break;
            } else {
                attempts++;
            }
        }

        Assertions.assertTrue(completed);
        Assertions.assertEquals(sentNotifications.size(), numberOfNotification);
        logger.debug("NOTIFICATION LIST: {}", sentNotifications);
        logger.debug("IUN: ");
        for (FullSentNotificationV23 notificationV23 : sentNotifications) {
            logger.info(notificationV23.getIun());
        }
        logger.debug("End IUN list");
        //la prima notifica viene inserita
        this.notificationResponseComplete = sentNotifications.poll();
        logger.debug("notificationResponseComplete: {}", this.notificationResponseComplete);
    }

    @And("destinatario Mario Cucumber")
    public void destinatarioMarioCucumber() {
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(new HashMap<>());
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "Mario Cucumber",
                        marioCucumberTaxID,
                        null,
                        new NotificationDigitalAddress()
                                .type(NotificationDigitalAddress.TypeEnum.PEC)
                                .address(getDigitalAddressValue())
                        )
                , new HashMap<>());
        /*
        this.notificationRequest.addRecipientsItem(
                dataTableTypeUtil.convertNotificationRecipient(new HashMap<>())
                        .denomination("Mario Cucumber")
                        .taxId(marioCucumberTaxID)
                        .digitalDomicile(new NotificationDigitalAddress()
                                .type(NotificationDigitalAddress.TypeEnum.PEC)
                                .address(getDigitalAddressValue())));

         */
    }

    @And("destinatario Mario Cucumber V1")
    public void destinatarioMarioCucumberV1() {
        this.notificationRequestV1.addRecipientsItem(
                dataTableTypeUtil.convertNotificationRecipientV1(new HashMap<>())
                        .denomination("Mario Cucumber")
                        .taxId(marioCucumberTaxID)
                        .digitalDomicile(new it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.NotificationDigitalAddress()
                                .type(it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.NotificationDigitalAddress.TypeEnum.PEC)
                                .address(getDigitalAddressValue())));
    }

    @And("destinatario Mario Cucumber V2")
    public void destinatarioMarioCucumberV2() {
        this.notificationRequestV2.addRecipientsItem(
                dataTableTypeUtil.convertNotificationRecipientV2(new HashMap<>())
                        .denomination("Mario Cucumber")
                        .taxId(marioCucumberTaxID)
                        .digitalDomicile(new it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.NotificationDigitalAddress()
                                .type(it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.NotificationDigitalAddress.TypeEnum.PEC)
                                .address(getDigitalAddressValue())));
    }

    @And("destinatario Mario Cucumber e:")
    public void destinatarioMarioCucumberParam(Map<String, String> data) { // @Transpose NotificationRecipientV21 recipient
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(data);
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "Mario Cucumber",
                        marioCucumberTaxID,
                        null,
                        null),
                data);
    }

    private NotificationRecipientV23 updateNotificationRecipientV23(NotificationRecipientV23 notificationRecipientV23, String denomination, String taxId, NotificationRecipientV23.RecipientTypeEnum recipientType, NotificationDigitalAddress digitalDomicile) {
        notificationRecipientV23.denomination(denomination).taxId(taxId);

        if(recipientType != null) {
            notificationRecipientV23.recipientType(recipientType);
        }
        if(digitalDomicile != null) {
            notificationRecipientV23.digitalDomicile(digitalDomicile);
        }
        return notificationRecipientV23;
    }

    private void addRecipientToNotification(NewNotificationRequestV23 notificationRequest, NotificationRecipientV23 notificationRecipient, Map<String, String> recipientData) {
        //logger.info("NEW NOTIFICATION REQUEST: {}",notificationRequest);
        //logger.info("NEW NOTIFICATION RECIPIENT: {}",notificationRecipient);
        if (notificationRequest.getNotificationFeePolicy() == NotificationFeePolicy.DELIVERY_MODE
                && NotificationValue.getValue(recipientData, PAYMENT.key) != null) {
            String pagopaFormValue = getValue(recipientData, PAYMENT_PAGOPA_FORM.key);
            if (pagopaFormValue != null && !pagopaFormValue.equalsIgnoreCase("NO")) {
                for (NotificationPaymentItem payments : Objects.requireNonNull(notificationRecipient.getPayments())) {
                    Objects.requireNonNull(payments.getPagoPa()).setApplyCost(true);
                }
            }
        }
        notificationRequest.addRecipientsItem(notificationRecipient);
    }

    @And("destinatario Mario Gherkin")
    public void destinatarioMarioGherkin() {
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(new HashMap<>());
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "Mario Gherkin",
                        marioGherkinTaxID,
                        null,
                        new NotificationDigitalAddress()
                                .type(NotificationDigitalAddress.TypeEnum.PEC)
                                .address(getDigitalAddressValue()))
                , new HashMap<>());
    }

    @And("destinatario Mario Gherkin V1 e:")
    public void destinatarioMarioGherkinParam(@Transpose it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.NotificationRecipient recipient) {
        this.notificationRequestV1.addRecipientsItem(
                recipient
                        .denomination("Mario Gherkin")
                        .taxId(marioGherkinTaxID));
    }

    @And("destinatario Mario Gherkin V2 e:")
    public void destinatarioMarioGherkinParam(@Transpose it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.NotificationRecipient recipient) {
        this.notificationRequestV2.addRecipientsItem(
                recipient
                        .denomination("Mario Gherkin")
                        .taxId(marioGherkinTaxID));
    }

    @And("destinatario Mario Gherkin V21 e:")
    public void destinatarioMarioGherkinParam(@Transpose it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v21.NotificationRecipientV21 recipient) {
        this.notificationRequestV21.addRecipientsItem(
                recipient
                        .denomination("Mario Gherkin")
                        .taxId(marioGherkinTaxID));
    }

    @And("destinatario Mario Gherkin e:")
    public void destinatarioMarioGherkinParam(Map<String, String> data) { //@Transpose NotificationRecipientV21 recipient
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(data);
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "Mario Gherkin",
                        marioGherkinTaxID,
                        null,
                        null)
                , data);
    }

    @And("destinatario Gherkin spa")
    public void destinatarioGherkinSpa() {
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(new HashMap<>());
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "Gherkin_spa",
                        gherkinSpaTaxID,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        new NotificationDigitalAddress()
                                .type(NotificationDigitalAddress.TypeEnum.PEC)
                                .address(getDigitalAddressValue())),
                new HashMap<>());
    }

    @And("destinatario GherkinSrl")
    public void destinatarioPg1() {
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(new HashMap<>());
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "GherkinSrl",
                        gherkinSrltaxId,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        new NotificationDigitalAddress()
                                .type(NotificationDigitalAddress.TypeEnum.PEC)
                                .address(getDigitalAddressValue()))
                , new HashMap<>());
    }

    @And("destinatario GherkinSrl e:")
    public void destinatarioPg1param(Map<String, String> data) { //@Transpose NotificationRecipientV21 recipient
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(data);
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "GherkinSrl",
                        gherkinSrltaxId,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        null)
                , data);
    }

    @And("destinatario CucumberSpa e:")
    public void destinatarioPg2param(Map<String, String> data) { //@Transpose NotificationRecipientV21 recipient
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(data);
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "CucumberSpa",
                        cucumberSpataxId,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        null)
                , data);
    }

    @And("destinatario CucumberSpa")
    public void destinatarioPg2() {
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(new HashMap<>());
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "CucumberSpa",
                        cucumberSpataxId,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        new NotificationDigitalAddress()
                                .type(NotificationDigitalAddress.TypeEnum.PEC)
                                .address(getDigitalAddressValue()))
                , new HashMap<>());
    }

    @And("destinatario Gherkin spa e:")
    public void destinatarioGherkinSpaParam(Map<String, String> data) { //@Transpose NotificationRecipientV21 recipient
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(data);
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "GherkinSpa",
                        gherkinSpaTaxID,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        null)
        , data);
    }

    @And("destinatario Cucumber srl")
    public void destinatarioCucumberSrl() {
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(new HashMap<>());
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "CucumberSrl",
                        cucumberSrlTaxID,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        new NotificationDigitalAddress()
                                .type(NotificationDigitalAddress.TypeEnum.PEC)
                                .address(getDigitalAddressValue()))
                , new HashMap<>());
    }

    @And("destinatario Cucumber srl e:")
    public void destinatarioCucumberSrlParam(Map<String, String> data) { //@Transpose NotificationRecipientV21 recipient
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(data);
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "CucumberSrl",
                        cucumberSrlTaxID,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        null)
        , data);
    }

    @And("destinatario Cucumber Society")
    public void destinatarioCucumberSociety() {
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(new HashMap<>());
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "Cucumber_Society",
                        cucumberSocietyTaxID,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        new NotificationDigitalAddress()
                                .type(NotificationDigitalAddress.TypeEnum.PEC)
                                .address(getDigitalAddressValue()))
        ,new HashMap<>());
    }

    @And("destinatario Cucumber Society e:")
    public void destinatarioCucumberSocietyParam(Map<String, String> data) { //@Transpose NotificationRecipientV21 recipient
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(data);
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "Cucumber_Society",
                        cucumberSocietyTaxID,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        null)
                , data);
    }

    @And("destinatario Signor casuale e:")
    public void destinatarioSignorCasualeMap(Map<String, String> data) {
        try {
            Thread.sleep(new Random().nextInt(500));
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(data);
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "signor RaddCasuale",
                        generateCF(System.currentTimeMillis()),
                        NotificationRecipientV23.RecipientTypeEnum.PF,
                null)
                , data);
    }

    @And("destinatario Signor casuale")
    public void destinatarioSignorCasuale() {
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(new HashMap<>());
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "signor RaddCasuale",
                        generateCF(System.currentTimeMillis()),
                        NotificationRecipientV23.RecipientTypeEnum.PF,
                        new NotificationDigitalAddress()
                                .type(NotificationDigitalAddress.TypeEnum.PEC)
                                .address(getDigitalAddressValue()))
                , new HashMap<>());
    }

    @And("destinatario Gherkin Analogic e:")
    public void destinatarioGherkinAnalogicParam(Map<String, String> data) {
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(data);
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "Gherkin Analogic",
                        gherkinAnalogicTaxID,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        null)
                , data);
    }

    @And("destinatario Gherkin Irreperibile e:")
    public void destinatarioGherkinIrreperibileParam(Map<String, String> data) {
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(data);
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "Gherkin Irreperibile",
                        gherkinIrreperibileTaxID,
                        NotificationRecipientV23.RecipientTypeEnum.PG,
                        null)
                , data);
    }

    @And("destinatario Cucumber Analogic e:")
    public void destinatarioCucumberAnalogicParam(Map<String, String> data) {//@Transpose NotificationRecipientV21 recipient
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(data);
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "Cucumber Analogic",
                        cucumberAnalogicTaxID,
                        null,
                        null)
                , data);
    }

    @And("destinatario Cristoforo Colombo")
    public void destinatarioCristoforoColombo() {
        NotificationRecipientV23 notificationRecipientV23 = dataTableTypeUtil.convertNotificationRecipient(new HashMap<>());
        addRecipientToNotification(this.notificationRequest,
                updateNotificationRecipientV23(notificationRecipientV23,
                        "Cristoforo Colombo",
                        "CLMCST42R12D969Z",
                        null,
                        null)
                , new HashMap<>());
    }

    @And("viene generata una nuova notifica con uguale codice fiscale del creditore e diverso codice avviso")
    public void vienePredispostaEInviataUnaNuovaNotificaConUgualeCodiceFiscaleDelCreditoreEDiversoCodiceAvviso() {
        String creditorTaxId = Objects.requireNonNull(Objects.requireNonNull(notificationRequest.getRecipients().get(0).getPayments()).get(0).getPagoPa()).getCreditorTaxId();
        generateNewNotification();
        Objects.requireNonNull(Objects.requireNonNull(this.notificationRequest.getRecipients().get(0).getPayments()).get(0).getPagoPa()).setCreditorTaxId(creditorTaxId);
    }

    @And("destinatario {string} con uguale codice avviso del destinario numero {int}")
    public void destinatarioConUgualeCodiceAvvisoDelDestinarioN(String recipientName, int recipientNumber, @Transpose NotificationRecipientV23 recipient) {
        Assertions.assertDoesNotThrow(() -> Objects.requireNonNull(notificationRequest.getRecipients().get(recipientNumber - 1).getPayments()).get(0));
        String noticeCode = Objects.requireNonNull(Objects.requireNonNull(notificationRequest.getRecipients().get(recipientNumber - 1).getPayments()).get(0).getPagoPa()).getNoticeCode();
        if (recipientName.trim().equalsIgnoreCase("mario cucumber")) {
            recipient = (recipient.denomination("Mario Cucumber")
                    .taxId(marioCucumberTaxID));
        } else if (recipientName.trim().equalsIgnoreCase("mario gherkin")) {
            recipient = (recipient.denomination("Mario Gherkin")
                    .taxId(marioGherkinTaxID));
        } else {
            throw new IllegalArgumentException();
        }
        Objects.requireNonNull(Objects.requireNonNull(recipient.getPayments()).get(0).getPagoPa()).setNoticeCode(noticeCode);
        this.notificationRequest.addRecipientsItem(recipient);
    }

    @Then("viene generata una nuova notifica valida con uguale codice fiscale del creditore e uguale codice avviso")
    public void vieneGenerataUnaNuovaNotificaConUgualeCodiceFiscaleDelCreditoreEUgualeCodiceAvvisoConTaxIdCorretto() {
        String creditorTaxId = Objects.requireNonNull(Objects.requireNonNull(notificationRequest.getRecipients().get(0).getPayments()).get(0).getPagoPa()).getCreditorTaxId();
        String noticeCode = Objects.requireNonNull(Objects.requireNonNull(notificationRequest.getRecipients().get(0).getPayments()).get(0).getPagoPa()).getNoticeCode();

        this.notificationRequest = (dataTableTypeUtil.convertNotificationRequest(new HashMap<>())
                .addRecipientsItem(dataTableTypeUtil.convertNotificationRecipient(new HashMap<>()).taxId(marioCucumberTaxID)));

        Objects.requireNonNull(Objects.requireNonNull(this.notificationRequest.getRecipients().get(0).getPayments()).get(0).getPagoPa()).setCreditorTaxId(creditorTaxId);
        Objects.requireNonNull(Objects.requireNonNull(this.notificationRequest.getRecipients().get(0).getPayments()).get(0).getPagoPa()).setNoticeCode(noticeCode);
    }

    @And("viene generata una nuova notifica con uguale codice fiscale del creditore e uguale codice avviso")
    public void vienePredispostaEInviataUnaNuovaNotificaConUgualeCodiceFiscaleDelCreditoreEUgualeCodiceAvviso() {
        String creditorTaxId = Objects.requireNonNull(Objects.requireNonNull(notificationRequest.getRecipients().get(0).getPayments()).get(0).getPagoPa()).getCreditorTaxId();
        String noticeCode = Objects.requireNonNull(Objects.requireNonNull(notificationRequest.getRecipients().get(0).getPayments()).get(0).getPagoPa()).getNoticeCode();
        generateNewNotification();
        Objects.requireNonNull(Objects.requireNonNull(this.notificationRequest.getRecipients().get(0).getPayments()).get(0).getPagoPa()).setCreditorTaxId(creditorTaxId);
        Objects.requireNonNull(Objects.requireNonNull(this.notificationRequest.getRecipients().get(0).getPayments()).get(0).getPagoPa()).setNoticeCode(noticeCode);
    }

    @And("viene configurato noticeCodeAlternative uguale a noticeCode")
    public void vieneConfiguratoNoticeCodeAlternativeUgualeNoticeCode() {
        //TODO Controllare...........
        //this.notificationRequest.getRecipients().get(0).getPayments().get(0).getPagoPa().setNoticeCodeAlternative(this.notificationRequest.getRecipients().get(0).getPayment().getNoticeCode());
    }

    @And("viene configurato noticeCodeAlternative diversi a noticeCode")
    public void vieneConfiguratoNoticeCodeAlternativeDiversiNoticeCode() {
        //TODO Controllare...........
        // this.notificationRequest.getRecipients().get(0).getPayments().get(0).getPagoPa().setNoticeCodeAlternative(getValue(new HashMap<>(), PAYMENT_NOTICE_CODE_OPTIONAL.key));
    }

    @And("viene generata una nuova notifica con uguale paProtocolNumber e idempotenceToken {string}")
    public void vienePredispostaEInviataUnaNuovaNotificaConUgualePaProtocolNumberEIdempotenceToken(String idempotenceToken) {
        String paProtocolNumber = notificationRequest.getPaProtocolNumber();
        generateNewNotification();
        this.notificationRequest.setIdempotenceToken(idempotenceToken);
        this.notificationRequest.setPaProtocolNumber(paProtocolNumber);
    }

    @And("viene generata una nuova notifica con uguale paProtocolNumber")
    public void vieneGenerataUnaNuovaNotificaConUgualePaProtocolNumber() {
        String paProtocolNumber = notificationRequest.getPaProtocolNumber();
        generateNewNotification();
        this.notificationRequest.setPaProtocolNumber(paProtocolNumber);
    }

    @And("aggiungo {int} numero allegati")
    public void aggiungoNumeroAllegati(int numAllegati) {
        int i = 0;
        while (i < numAllegati) {
            this.notificationRequest.addDocumentsItem(b2bUtils.newDocument(getDefaultValue(DOCUMENT.key)));
            i++;
        }
    }

    @When("la notifica viene inviata tramite api b2b dal {string} e si attende che lo stato diventi ACCEPTED")
    public void laNotificaVieneInviataOk(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotification();
    }

    @When("la notifica viene inviata tramite api b2b dal {string} con allegato uguale al allegato di pagamento")
    public void laNotificaVieneInviataAllegatiUgualeAlPagamento(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationWithErrorAllegatiUgualiPayment();
    }

    @When("verifica che la notifica inviata tramite api b2b dal {string} non diventi ACCEPTED")
    public void laNotificaVieneInviataNoAccept(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationNoAccept();
    }

    @When("la notifica viene inviata tramite api b2b dal {string} e si controlla con check rapidi che lo stato diventi ACCEPTED")
    public void laNotificaVieneInviataOkRapidCheck(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationRapidCheck();
    }

    @When("la notifica viene inviata tramite api b2b dal {string} e si attende che lo stato diventi ACCEPTED con la versione {string}")
    public void laNotificaVieneInviataOkVersioning(String paType, String version) {
        selectPA(paType);
        switch (version.toLowerCase()) {
            case "v1":
                setSenderTaxIdFromPropertiesV1(version);
                sendNotificationV1();
                break;
            case "v2":
                setSenderTaxIdFromPropertiesV2(version);
                sendNotificationV2();
                break;
            case "v21":
                setSenderTaxIdFromPropertiesV21(version);
                sendNotificationV21();
                break;
        }
    }

    @And("viene effettuato recupero stato della notifica con la V1 dal comune {string}")
    public void retriveStateNotification(String version, String paType) {
        selectPA(paType);
        this.notificationRequestV1= new it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.NewNotificationRequest();
        setSenderTaxIdFromPropertiesV1("V1");
        searchNotificationV1(Base64Utils.encodeToString(getSentNotification().getIun().getBytes()));
    }

    @When("la notifica viene inviata tramite api b2b dal {string} e si attende che lo stato diventi ACCEPTED {string}")
    public void laNotificaVieneInviataOkV21(String paType,String version) {
        selectPA(paType);
        switch (version.toLowerCase()){
           case "v1":
               setSenderTaxIdFromPropertiesV1(version);
               sendNotificationV1();
               break;
           case "v2":
               setSenderTaxIdFromPropertiesV2(version);
               sendNotificationV2();
               break;
           case "v21":
               setSenderTaxIdFromPropertiesV21(version);
               sendNotificationV21();
               break;
       }
    }

    @When("la notifica viene inviata tramite api b2b dal {string} e si attende che lo stato diventi ACCEPTED per controllo GPD")
    public void laNotificaVieneInviataOkGPD(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationGPD();
    }

    @And("la notifica può essere annullata dal sistema tramite codice IUN dal comune {string}")
    public void notificationCanBeCanceledWithIUNByComune(String paType) {
        selectPA(paType);
        Assertions.assertDoesNotThrow(() -> {
            RequestStatus resp = Assertions.assertDoesNotThrow(() ->
                    this.b2bClient.notificationCancellation(getSentNotification().getIun()));
            Assertions.assertNotNull(resp);
            Assertions.assertNotNull(resp.getDetails());
            Assertions.assertFalse(resp.getDetails().isEmpty());
            Assertions.assertTrue("NOTIFICATION_CANCELLATION_ACCEPTED".equalsIgnoreCase(resp.getDetails().get(0).getCode()));
        });
    }

    @And("la notifica non può essere annullata dal sistema tramite codice IUN dal comune {string}")
    public void notificationCaNotBeCanceledWithIUNByComune(String paType) {
        selectPA(paType);
        try {
            this.b2bClient.notificationCancellation(getSentNotification().getIun());
        } catch (HttpStatusCodeException exception) {
            this.notificationError = exception;
        }
    }

    @Then("l'operazione di annullamento ha prodotto un errore con status code {string}")
    public void operationProducedErrorWithStatusCode(String statusCode) {
        Assertions.assertTrue((this.notificationError != null) &&
                (this.notificationError.getStatusCode().toString().substring(0, 3).equals(statusCode)));
    }

    @When("la notifica viene inviata tramite api b2b dal {string} si annulla prima che lo stato diventi REFUSED")
    public void laNotificaVieneInviataRefusedAndCancelled(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationAndCancelPreRefused();
    }

    @When("la notifica viene inviata tramite api b2b dal {string} e si attende che lo stato diventi ACCEPTED e successivamente annullata")
    public void laNotificaVieneInviataOkAndCancelled(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationAndCancel();
    }

    @When("la notifica viene inviata tramite api b2b dal {string} e si attende che lo stato diventi ACCEPTED e successivamente annullata {string}")
    public void laNotificaVieneInviataOkAndCancelledV2(String paType,String versione) {
        selectPA(paType);
        setSenderTaxIdFromPropertiesV2(versione);
        sendNotificationAndCancelV2();
    }

    @When("la notifica viene inviata tramite api b2b dal {string} e si attende che lo stato diventi REFUSED")
    public void laNotificaVieneInviataRefused(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationRefused();
    }

    /*
    TODO: per test normalizzatore
     */
    @When("la notifica viene inviata tramite api b2b dal {string} e si attende che lo stato diventi HTTP_ERROR")
    public void laNotificaVieneInviataHttpError(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationWithError();
        Assertions.assertNotNull(this.notificationError);
        Assertions.assertEquals(400, this.notificationError.getStatusCode().value());
    }

    @When("la notifica viene inviata tramite api b2b senza preload allegato dal {string} e si attende che lo stato diventi REFUSED")
    public void laNotificaVieneInviataSenzaPreloadAllegato(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationWithErrorNotFindAllegato(false);
    }

    @When("la notifica viene inviata tramite api b2b effettuando la preload ma senza caricare nessun allegato dal {string} e si attende che lo stato diventi REFUSED")
    public void laNotificaVieneInviataTramiteApiBBEffettuandoLaPreloadMaSenzaCaricareNessunAllegatoDalESiAttendeCheLoStatoDiventiREFUSED(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationWithErrorNotFindAllegato(true);
    }

    @When("la notifica viene inviata tramite api b2b effettuando la preload ma senza caricare nessun allegato json dal {string} e si attende che lo stato diventi REFUSED")
    public void laNotificaVieneInviataTramiteApiBBEffettuandoLaPreloadMaSenzaCaricareNessunAllegatoJsonDalESiAttendeCheLoStatoDiventiREFUSED(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationWithErrorNotFindAllegatoJson();
    }

    @When("la notifica viene inviata tramite api b2b con sha256 differente dal {string} e si attende che lo stato diventi REFUSED")
    public void laNotificaVieneInviataConShaDifferente(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationWithErrorSha();
    }

    @When("la notifica viene inviata tramite api b2b con sha256 Json differente dal {string} e si attende che lo stato diventi REFUSED")
    public void laNotificaVieneInviataConShaJsonDifferente(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationWithErrorShaJson();
    }

    @When("la notifica viene inviata tramite api b2b con estensione errata dal {string} e si attende che lo stato diventi REFUSED")
    public void laNotificaVieneInviataConEstensioneErrata(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationWithWrongExtension();
    }

    @When("la notifica viene inviata tramite api b2b oversize preload allegato dal {string} e si attende che lo stato diventi REFUSED")
    public void laNotificaVieneInviataPreloadAllegatoOverSize(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationRefusedOverSizeAllegato();
    }

    @When("la notifica viene inviata tramite api b2b injection preload allegato dal {string} e si attende che lo stato diventi REFUSED")
    public void laNotificaVieneInviataPreloadAllegatoInjection(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationRefusedInjectionAllegato();
    }

    @When("la notifica viene inviata tramite api b2b over 15 preload allegato dal {string} e si attende che lo stato diventi REFUSED")
    public void laNotificaVieneInviataPreloadAllegatoOver15(String paType) {
        selectPA(paType);
        setSenderTaxIdFromProperties();
        sendNotificationRefusedOver15Allegato();
    }

    @When("la notifica viene inviata tramite api b2b e si attende che lo stato diventi ACCEPTED")
    public void laNotificaVieneInviataOk() {
        sendNotification();
    }

    @When("la notifica viene inviata dal {string}")
    public void laNotificaVieneInviataDallaPA(String pa) {
        selectPA(pa);
        setSenderTaxIdFromProperties();
        sendNotificationWithError();
    }

    @When("la notifica viene inviata dal {string} dalla {string}")
    public void laNotificaVieneInviataDallaPAV1(String pa, String versione) {
        selectPA(pa);
        if(versione.equalsIgnoreCase("V1")){
            setSenderTaxIdFromPropertiesV1(versione);
        }else if(versione.equalsIgnoreCase("V2")){
            setSenderTaxIdFromPropertiesV2(versione);
        }else if(versione.equalsIgnoreCase("V21")){
            setSenderTaxIdFromPropertiesV21(versione);
        }
        sendNotificationWithError();
    }

    @When("la notifica viene inviata tramite api b2b")
    public void laNotificaVieneInviatatramiteApiB2b() {
        sendNotificationWithError();
    }

    @When("la notifica viene inviata tramite api b2b senza preload allegato dal {string}")
    public void laNotificaVieneInviatatramiteApiB2bSenzaPreloadAllegato(String pa) {
        selectPA(pa);
        setSenderTaxIdFromProperties();
        sendNotificationWithErrorNotFindAllegato(false);
    }

    @And("al destinatario viene associato lo iuv creato mediante partita debitoria per {string} alla posizione {int}")
    public void destinatarioAddIuvGPD(String denominazione,Integer posizione) {
        if (this.notificationRequest != null) {
            Objects.requireNonNull(Objects.requireNonNull(Objects.requireNonNull(this.notificationRequest.getRecipients().get(0).denomination(denominazione).getPayments())).get(posizione).getPagoPa()).setNoticeCode(getIuvGPD(posizione));
        } else if (this.notificationRequestV21 != null) {
            Objects.requireNonNull(Objects.requireNonNull(Objects.requireNonNull(this.notificationRequestV21.getRecipients().get(0).denomination(denominazione).getPayments())).get(posizione).getPagoPa()).setNoticeCode(getIuvGPD(posizione));
        }
    }

    @And("al destinatario viene associato lo iuv creato mediante partita debitoria per {string} per la posizione debitoria {int} del pagamento {int}")
    public void destinatarioAddIuvGPDperUtente(String denominazione, Integer posizioneDebitoria, Integer pagamento) {
        for (NotificationRecipientV23 recipient : this.notificationRequest.getRecipients()) {
            if (recipient.getDenomination().equalsIgnoreCase(denominazione)) {
                Objects.requireNonNull(Objects.requireNonNull(recipient.getPayments()).get(pagamento).getPagoPa()).setNoticeCode(getIuvGPD(posizioneDebitoria));
            }
        }
    }

    @And("viene rimossa se presente la pec di piattaforma di {string}")
    public void vieneRimossaSePresenteLaPecDiPiattaformaDi(String user) {
        selectUser(user);
        try {
            List<LegalAndUnverifiedDigitalAddress> legalAddressByRecipient = this.iPnWebUserAttributesClient.getLegalAddressByRecipient();
            if (legalAddressByRecipient != null && !legalAddressByRecipient.isEmpty()) {
                this.iPnWebUserAttributesClient.deleteRecipientLegalAddress("default", LegalChannelType.PEC);
                logger.info("PEC FOUND AND DELETED");
            }
        } catch (HttpStatusCodeException httpStatusCodeException) {
            if (httpStatusCodeException.getStatusCode().is4xxClientError()) {
                logger.info("PEC NOT FOUND");
            } else {
                throw httpStatusCodeException;
            }
        }
    }

    @Then("si verifica che la notifica non viene accettata causa {string}")
    public void verificaNotificaNoAccept(String causa) {
        switch (causa) {
            case ALLEGATO:
                Assertions.assertTrue(FILE_NOTFOUND.equalsIgnoreCase(errorCode));
                break;
            case EXTENSION, FILE_PDF_INVALID_ERROR:
                Assertions.assertTrue(FILE_PDF_INVALID_ERROR.equalsIgnoreCase(errorCode));
                break;
            case SHA_256:
                Assertions.assertTrue(FILE_SHA_ERROR.equalsIgnoreCase(errorCode));
                break;
            case TAX_ID:
                Assertions.assertTrue(TAXID_NOT_VALID.equalsIgnoreCase(errorCode));
                break;
            case ADDRESS:
                Assertions.assertTrue(NOT_VALID_ADDRESS.equalsIgnoreCase(errorCode));
            case INVALID_PARAMETER_MAX_ATTACHMENT:
                Assertions.assertTrue(INVALID_PARAMETER_MAX_ATTACHMENT.equalsIgnoreCase(errorCode));
                break;
            case NOT_VALID_ADDRESS:
                Assertions.assertTrue(NOT_VALID_ADDRESS.equalsIgnoreCase(errorCode));
                break;
            default:
                throw new IllegalArgumentException();
        }
    }

    private void sendNotification() {
        sendNotification(getWorkFlowWait());
    }

    private void sendNotificationNoAccept() {
        sendNotificationNoAccept(getWorkFlowWait());
    }

    private void sendNotificationRapidCheck() {
        sendNotificationRapid(100);
    }

    private void sendNotification(int wait) {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponse = b2bUtils.uploadNotification(notificationRequest);
                try {
                    Thread.sleep(wait);
                } catch (InterruptedException e) {
                    logger.error("Thread.sleep error retry");
                    throw new RuntimeException(e);
                }
                notificationResponseComplete = b2bUtils.waitForRequestAcceptation(newNotificationResponse);
            });
            try {
                Thread.sleep(wait);
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNotNull(notificationResponseComplete);
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationNoAccept(int wait) {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                try {
                    Thread.sleep(wait);
                } catch (InterruptedException e) {
                    logger.error("Thread.sleep error retry");
                    throw new RuntimeException(e);
                }
                notificationResponseComplete = b2bUtils.waitForRequestNoAcceptation(newNotificationResponse);
            });
            try {
                Thread.sleep(wait);
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNull(notificationResponseComplete);
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationRapid(int wait) {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponse = b2bUtils.uploadNotification(notificationRequest);
                try {
                    Thread.sleep(wait);
                } catch (InterruptedException e) {
                    logger.error("Thread.sleep error retry");
                    throw new RuntimeException(e);
                }
                notificationResponseComplete = b2bUtils.waitForRequestAcceptationShort(newNotificationResponse);
            });
            try {
                Thread.sleep(wait);
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNotNull(notificationResponseComplete);
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationRapidCancellPreRefused() {
        int wait = 1000;
        boolean rifiutata;
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponse = b2bUtils.uploadNotification(notificationRequest);
                RequestStatus resp = Assertions.assertDoesNotThrow(() ->
                        b2bClient.notificationCancellation(new String(Base64Utils.decodeFromString(newNotificationResponse.getNotificationRequestId()))));
                Assertions.assertNotNull(resp);
                Assertions.assertNotNull(resp.getDetails());
                Assertions.assertFalse(resp.getDetails().isEmpty());
                Assertions.assertTrue("NOTIFICATION_CANCELLATION_ACCEPTED".equalsIgnoreCase(resp.getDetails().get(0).getCode()));
            });
            rifiutata = b2bUtils.waitForRequestNotRefused(newNotificationResponse);
            try {
                Thread.sleep(wait);
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertFalse(rifiutata);
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void searchNotificationV1(String requestId) {
        try {
            Assertions.assertDoesNotThrow(() -> b2bClient.getNotificationRequestStatusV1(requestId));
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponseV1 == null ? "NULL" : newNotificationResponseV1.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationV1() {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponseV1 = b2bUtils.uploadNotificationV1(notificationRequestV1);

                try {
                    Thread.sleep(getWorkFlowWait());
                } catch (InterruptedException e) {
                    logger.error("Thread.sleep error retry");
                    throw new RuntimeException(e);
                }
                notificationResponseCompleteV1 = b2bUtils.waitForRequestAcceptationV1(newNotificationResponseV1);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNotNull(notificationResponseCompleteV1);
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponseV1 == null ? "NULL" : newNotificationResponseV1.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationV2() {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponseV2 = b2bUtils.uploadNotificationV2(notificationRequestV2);

                try {
                    Thread.sleep(getWorkFlowWait());
                } catch (InterruptedException e) {
                    logger.error("Thread.sleep error retry");
                    throw new RuntimeException(e);
                }

                notificationResponseCompleteV2 = b2bUtils.waitForRequestAcceptationV2(newNotificationResponseV2);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNotNull(notificationResponseCompleteV2);

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponseV2 == null ? "NULL" : newNotificationResponseV2.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationV21() {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponseV21 = b2bUtils.uploadNotificationV21(notificationRequestV21);
                try {
                    Thread.sleep(getWorkFlowWait());
                } catch (InterruptedException e) {
                    logger.error("Thread.sleep error retry");
                    throw new RuntimeException(e);
                }
                notificationResponseCompleteV21 = b2bUtils.waitForRequestAcceptationV21(newNotificationResponseV21);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNotNull(notificationResponseCompleteV21);
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponseV21 == null ? "NULL" : newNotificationResponseV21.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationAndCancelPreRefused() {
        sendNotificationRapidCancellPreRefused();
    }

    private void sendNotificationAndCancel() {
        sendNotificationRapid(1000);
        Assertions.assertDoesNotThrow(() -> {
            RequestStatus resp = Assertions.assertDoesNotThrow(() ->
                    b2bClient.notificationCancellation(notificationResponseComplete.getIun()));
            Assertions.assertNotNull(resp);
            Assertions.assertNotNull(resp.getDetails());
            Assertions.assertFalse(resp.getDetails().isEmpty());
            Assertions.assertTrue("NOTIFICATION_CANCELLATION_ACCEPTED".equalsIgnoreCase(resp.getDetails().get(0).getCode()));
        });
    }

    private void sendNotificationAndCancelV2() {
        sendNotificationV2();
        Assertions.assertDoesNotThrow(() -> {
            RequestStatus resp = Assertions.assertDoesNotThrow(() ->
                    b2bClient.notificationCancellation(notificationResponseCompleteV2.getIun()));
            Assertions.assertNotNull(resp);
            Assertions.assertNotNull(resp.getDetails());
            Assertions.assertFalse(resp.getDetails().isEmpty());
            Assertions.assertTrue("NOTIFICATION_CANCELLATION_ACCEPTED".equalsIgnoreCase(resp.getDetails().get(0).getCode()));
        });
    }

    private void sendNotificationGPD() {
        sendNotificationRapid(WAITING_GPD);
    }

    private void sendNotificationWithError() {
        try {
            notificationCreationDate = OffsetDateTime.now();
            if (notificationRequest != null) {
                this.newNotificationResponse = b2bUtils.uploadNotification(notificationRequest);
            } else if (notificationRequestV1 != null) {
                this.newNotificationResponseV1 = b2bUtils.uploadNotificationV1(notificationRequestV1);
            } else if (notificationRequestV2 != null) {
                this.newNotificationResponseV2 = b2bUtils.uploadNotificationV2(notificationRequestV2);
            }else if(notificationRequestV21!= null){
                this.newNotificationResponseV21 = b2bUtils.uploadNotificationV21(notificationRequestV21);
            }

        } catch (HttpStatusCodeException | IOException e) {
            if (e instanceof HttpStatusCodeException) {
                this.notificationError = (HttpStatusCodeException) e;
            }
        }
    }

    private void sendNotificationWithErrorNotFindAllegato(boolean noUpload) {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponse = b2bUtils.uploadNotificationNotFindAllegato(notificationRequest, noUpload);
                errorCode = b2bUtils.waitForRequestRefused(newNotificationResponse);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNotNull(errorCode);
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationWithErrorNotFindAllegatoJson() {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponse = b2bUtils.uploadNotificationNotFindAllegatoJson(notificationRequest, true);
                errorCode = b2bUtils.waitForRequestRefused(newNotificationResponse);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }

            Assertions.assertNotNull(errorCode);
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationWithErrorSha() {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponse = b2bUtils.uploadNotificationNotEqualSha(notificationRequest);
                errorCode = b2bUtils.waitForRequestRefused(newNotificationResponse);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNotNull(errorCode);
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationWithErrorAllegatiUgualiPayment() {
        try {
            newNotificationResponse = b2bUtils.uploadNotificationAllegatiUgualiPagamento(notificationRequest);
        } catch (HttpStatusCodeException | IOException e) {
            if (e instanceof HttpStatusCodeException) {
                this.notificationError = (HttpStatusCodeException) e;
            }
        }
    }

    private void sendNotificationWithErrorShaJson() {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponse = b2bUtils.uploadNotificationNotEqualShaJson(notificationRequest);
                errorCode = b2bUtils.waitForRequestRefused(newNotificationResponse);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }

            Assertions.assertNotNull(errorCode);

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationWithWrongExtension() {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponse = b2bUtils.uploadNotificationWrongExtension(notificationRequest);

                errorCode = b2bUtils.waitForRequestRefused(newNotificationResponse);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }

            Assertions.assertNotNull(errorCode);

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationRefused() {
        try {
            Assertions.assertDoesNotThrow(() -> {
                notificationCreationDate = OffsetDateTime.now();
                newNotificationResponse = b2bUtils.uploadNotification(notificationRequest);
                errorCode = b2bUtils.waitForRequestRefused(newNotificationResponse);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNotNull(errorCode);

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationRefusedOverSizeAllegato() {
        try {
            Assertions.assertDoesNotThrow(() -> {
                newNotificationResponse = b2bUtils.uploadNotificationOverSizeAllegato(notificationRequest);
                errorCode = b2bUtils.waitForRequestRefused(newNotificationResponse);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNotNull(errorCode);

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationRefusedInjectionAllegato() {
        try {
            Assertions.assertDoesNotThrow(() -> {
                newNotificationResponse = b2bUtils.uploadNotificationInjectionAllegato(notificationRequest);
                errorCode = b2bUtils.waitForRequestRefused(newNotificationResponse);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNotNull(errorCode);

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    private void sendNotificationRefusedOver15Allegato() {
        try {
            Assertions.assertDoesNotThrow(() -> {
                newNotificationResponse = b2bUtils.uploadNotificationOver15Allegato(notificationRequest);
                errorCode = b2bUtils.waitForRequestRefused(newNotificationResponse);
            });

            try {
                Thread.sleep(getWorkFlowWait());
            } catch (InterruptedException e) {
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(e);
            }
            Assertions.assertNotNull(errorCode);

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{RequestID: " + (newNotificationResponse == null ? "NULL" : newNotificationResponse.getNotificationRequestId()) + " }";
            Assertions.assertTrue(message.contains("400") && message.contains("Max attachment count reached"));
            errorCode = "INVALID_PARAMETER_MAX_ATTACHMENT";
        }
    }

    private void generateNewNotification() {
        assert this.notificationRequest.getRecipients().get(0).getPayments() != null;
        this.notificationRequest = (dataTableTypeUtil.convertNotificationRequest(new HashMap<>())
                .subject(notificationRequest.getSubject())
                .senderDenomination(notificationRequest.getSenderDenomination())
                .addRecipientsItem(dataTableTypeUtil.convertNotificationRecipient(new HashMap<>())
                        .denomination(notificationRequest.getRecipients().get(0).getDenomination())
                        .taxId(notificationRequest.getRecipients().get(0).getTaxId())
                        .recipientType(notificationRequest.getRecipients().get(0).getRecipientType())));
    }

    public HttpStatusCodeException consumeNotificationError() {
        HttpStatusCodeException value = notificationError;
        this.notificationError = null;
        return value;
    }

    public void setSenderTaxIdFromProperties() {
        switch (settedPa) {
            case "Comune_1":
                this.notificationRequest.setSenderTaxId(this.senderTaxId);
                setGrup(SettableApiKey.ApiKeyType.MVP_1);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.MVP_1;
                break;
            case "Comune_2":
                this.notificationRequest.setSenderTaxId(this.senderTaxIdTwo);
                setGrup(SettableApiKey.ApiKeyType.MVP_2);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.MVP_2;
                break;
            case "Comune_Multi":
                this.notificationRequest.setSenderTaxId(this.senderTaxIdGa);
                setGrup(SettableApiKey.ApiKeyType.GA);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.GA;
                break;
            case "Comune_Son":
                this.notificationRequest.setSenderTaxId(this.senderTaxIdSON);
                setGrup(SettableApiKey.ApiKeyType.SON);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.SON;
                break;
            case "Comune_Root":
                this.notificationRequest.setSenderTaxId(this.senderTaxIdROOT);
                setGrup(SettableApiKey.ApiKeyType.ROOT);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.ROOT;
                break;
        }
    }

    public void setSenderTaxIdFromPropertiesV1(String version) {
        switch (settedPa) {
            case "Comune_1":
                this.notificationRequestV1.setSenderTaxId(this.senderTaxId);
                setGrupVersioning(SettableApiKey.ApiKeyType.MVP_1,version);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.MVP_1;
                break;
            case "Comune_2":
                this.notificationRequestV1.setSenderTaxId(this.senderTaxIdTwo);
                setGrupVersioning(SettableApiKey.ApiKeyType.MVP_2,version);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.MVP_2;
                break;
            case "Comune_Multi":
                this.notificationRequestV1.setSenderTaxId(this.senderTaxIdGa);
                setGrupVersioning(SettableApiKey.ApiKeyType.GA,version);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.GA;
                break;
        }
    }

    public void setSenderTaxIdFromPropertiesV2(String version) {
        switch (settedPa) {
            case "Comune_1":
                this.notificationRequestV2.setSenderTaxId(this.senderTaxId);
                setGrupVersioning(SettableApiKey.ApiKeyType.MVP_1,version);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.MVP_1;
                break;
            case "Comune_2":
                this.notificationRequestV2.setSenderTaxId(this.senderTaxIdTwo);
                setGrupVersioning(SettableApiKey.ApiKeyType.MVP_2,version);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.MVP_2;
                break;
            case "Comune_Multi":
                this.notificationRequestV2.setSenderTaxId(this.senderTaxIdGa);
                setGrupVersioning(SettableApiKey.ApiKeyType.GA,version);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.GA;
                break;
        }
    }

    public void setSenderTaxIdFromPropertiesV21(String version) {
        switch (settedPa) {
            case "Comune_1":
                this.notificationRequestV21.setSenderTaxId(this.senderTaxId);
                setGrupVersioning(SettableApiKey.ApiKeyType.MVP_1,version);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.MVP_1;
                break;
            case "Comune_2":
                this.notificationRequestV21.setSenderTaxId(this.senderTaxIdTwo);
                setGrupVersioning(SettableApiKey.ApiKeyType.MVP_2,version);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.MVP_2;
                break;
            case "Comune_Multi":
                this.notificationRequestV21.setSenderTaxId(this.senderTaxIdGa);
                setGrupVersioning(SettableApiKey.ApiKeyType.GA,version);
                apiKeyTypeSetted = SettableApiKey.ApiKeyType.GA;
                break;
        }
    }

    public String getSenderTaxIdFromProperties(String settedPa) {
        switch (settedPa) {
            case "Comune_1":
                return this.senderTaxId;
            case "Comune_2":
                return this.senderTaxIdTwo;
            case "Comune_Multi":
                return this.senderTaxIdGa;
            case "Comune_Son":
                return this.senderTaxIdSON;
            case "Comune_Root":
                return this.senderTaxIdROOT;
            default:
                throw new IllegalArgumentException();
        }
    }

    private void setGrup(SettableApiKey.ApiKeyType apiKeyType) {
        if (groupToSet && this.notificationRequest.getGroup() == null) {
            List<HashMap<String, String>> hashMapsList = pnExternalServiceClient.paGroupInfo(apiKeyType);
            if (hashMapsList == null || hashMapsList.isEmpty()) return;
            String id = null;
            for (HashMap<String, String> elem : hashMapsList) {
                if (elem.get("status").equalsIgnoreCase("ACTIVE")) {
                    id = elem.get("id");
                    break;
                }
            }
            if (id == null) return;
            this.notificationRequest.setGroup(id);
        }
    }

    private void setGrupVersioning(SettableApiKey.ApiKeyType apiKeyType,String version) {
        String group=null;

        switch (version.toLowerCase()){
            case "v1" -> group=this.notificationRequestV1.getGroup();
            case "v2" -> group=this.notificationRequestV2.getGroup();
            case "v21" -> group=this.notificationRequestV21.getGroup();
        }

        if (groupToSet && group == null) {
            List<HashMap<String, String>> hashMapsList = pnExternalServiceClient.paGroupInfo(apiKeyType);
            if (hashMapsList == null || hashMapsList.isEmpty()) return;
            String id = null;
            for (HashMap<String, String> elem : hashMapsList) {
                if (elem.get("status").equalsIgnoreCase("ACTIVE")) {
                    id = elem.get("id");
                    break;
                }
            }
            if (id == null) return;

            switch (version.toLowerCase()){
                case "v1" -> this.notificationRequestV1.setGroup(id);
                case "v2" -> this.notificationRequestV2.setGroup(id);
                case "v21" -> this.notificationRequestV21.setGroup(id);
            }
        }
    }

    public FullSentNotificationV23 getSentNotification() {
        return notificationResponseComplete;
    }

    public it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.FullSentNotification getSentNotificationV1() {
        return notificationResponseCompleteV1;
    }

    public it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.FullSentNotificationV20 getSentNotificationV2() {
        return notificationResponseCompleteV2;
    }

    public  it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v21.FullSentNotificationV21 getSentNotificationV21() {
        return notificationResponseCompleteV21;
    }

    public void setSentNotification(FullSentNotificationV23 notificationResponseComplete) {
        this.notificationResponseComplete = notificationResponseComplete;
    }

    public void setSentNotificationV1(it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.FullSentNotification notificationResponseCompleteV1) {
        this.notificationResponseCompleteV1 = notificationResponseCompleteV1;
    }

    public void setSentNotificationV2(it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.FullSentNotificationV20 notificationResponseCompleteV2) {
        this.notificationResponseCompleteV2 = notificationResponseCompleteV2;
    }

    public void setSentNotificationV21(it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v21.FullSentNotificationV21 notificationResponseCompleteV21) {
        this.notificationResponseCompleteV21 = notificationResponseCompleteV21;
    }

    public void selectPA(String apiKey) {
        switch (apiKey) {
            case "Comune_1":
                this.b2bClient.setApiKeys(IPnPaB2bClient.ApiKeyType.MVP_1);
                this.pollingFactory.setApiKeys(IPnPaB2bClient.ApiKeyType.MVP_1);
                break;
            case "Comune_2":
                this.b2bClient.setApiKeys(IPnPaB2bClient.ApiKeyType.MVP_2);
                this.pollingFactory.setApiKeys(IPnPaB2bClient.ApiKeyType.MVP_2);
                break;
            case "Comune_Multi":
                this.b2bClient.setApiKeys(IPnPaB2bClient.ApiKeyType.GA);
                this.pollingFactory.setApiKeys(IPnPaB2bClient.ApiKeyType.GA);
                break;
            case "Comune_Son":
                this.b2bClient.setApiKeys(IPnPaB2bClient.ApiKeyType.SON);
                this.pollingFactory.setApiKeys(IPnPaB2bClient.ApiKeyType.SON);
                break;
            case "Comune_Root":
                this.b2bClient.setApiKeys(IPnPaB2bClient.ApiKeyType.ROOT);
                this.pollingFactory.setApiKeys(IPnPaB2bClient.ApiKeyType.ROOT);
                break;
            default:
                throw new IllegalArgumentException();
        }
        this.b2bUtils.setClient(b2bClient, pollingFactory);
        this.settedPa = apiKey;
    }

    public void selectUser(String recipient) {
        switch (recipient.trim().toLowerCase()) {
            case "mario cucumber", "ettore fieramosca":
                webRecipientClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_1);
                iPnWebUserAttributesClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_1);
                break;
            case "mario gherkin", "cristoforo colombo":
                webRecipientClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_2);
                iPnWebUserAttributesClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_2);
                break;
            case "gherkinsrl":
                webRecipientClient.setBearerToken(SettableBearerToken.BearerTokenType.PG_1);
                iPnWebUserAttributesClient.setBearerToken(SettableBearerToken.BearerTokenType.PG_1);
                break;
            case "cucumberspa":
                webRecipientClient.setBearerToken(SettableBearerToken.BearerTokenType.PG_2);
                iPnWebUserAttributesClient.setBearerToken(SettableBearerToken.BearerTokenType.PG_2);
                break;
            case "leonardo da vinci":
                webRecipientClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_3);
                iPnWebUserAttributesClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_3);
                break;
            case "dino sauro":
                webRecipientClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_5);
                iPnWebUserAttributesClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_5);
                break;
            case "mario cucumber con credenziali non valide":
                webRecipientClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_SCADUTO);
                iPnWebUserAttributesClient.setBearerToken(SettableBearerToken.BearerTokenType.USER_SCADUTO);
                break;
            default:
                throw new IllegalArgumentException();
        }
    }

    public PnServiceDeskClientImplNoApiKey getServiceDeskClientNoApiKey() {
        return serviceDeskClientImplNoApiKey;
    }

    public PnServiceDeskClientImplWrongApiKey getServiceDeskClientWrongApiKey() {
        return serviceDeskClientImplWrongApiKey;
    }

    public String getGherkinIrreperibileTaxId() {
        return gherkinIrreperibileTaxID;
    }

    public void throwAssertFailerWithIUN(AssertionFailedError assertionFailedError) {
        String message = assertionFailedError.getMessage() +
                "{IUN: " + notificationResponseComplete.getIun() + " }";
        throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
    }

    public <T> T deepCopy(Object obj, Class<T> toClass) {
        try {
            String json = objMapper.writeValueAsString(obj);
            return objMapper.readValue(json, toClass);
        } catch (JsonProcessingException exc) {
            throw new RuntimeException(exc);
        }
    }

    public Integer getWorkFlowWait() {
        if (timingConfigs.getWorkflowWaitMillis() == null) return workFlowWaitDefault + secureRandom.nextInt(WORKFLOW_WAIT_UPPER_BOUND);
        return timingConfigs.getWorkflowWaitMillis() + secureRandom.nextInt(WORKFLOW_WAIT_UPPER_BOUND);
    }

    public Integer getWait() {
        if (timingConfigs.getWaitMillis() == null) return waitDefault + secureRandom.nextInt(WAIT_UPPER_BOUND);
        return timingConfigs.getWaitMillis() + secureRandom.nextInt(WAIT_UPPER_BOUND);
    }

    public String getDigitalAddressValue() {
        if (digitalAddress == null || digitalAddress.equalsIgnoreCase("${pn.external.digitalDomicile.address}"))
            return defaultDigitalAddress;
        return digitalAddress;
    }

    public Duration getSchedulingDaysSuccessDigitalRefinement() {
        if (timingConfigs.getSchedulingDaysSuccessDigitalRefinement() == null) return schedulingDaysSuccessDigitalRefinementDefault;
        return timingConfigs.getSchedulingDaysSuccessDigitalRefinement();
    }

    public Duration getSchedulingDaysFailureDigitalRefinement() {
        if (timingConfigs.getSchedulingDaysFailureDigitalRefinement() == null) return schedulingDaysFailureDigitalRefinementDefault;
        return timingConfigs.getSchedulingDaysFailureDigitalRefinement();
    }

    public Duration getSchedulingDaysSuccessAnalogRefinement() {
        if (timingConfigs.getSchedulingDaysSuccessAnalogRefinement() == null) return schedulingDaysSuccessAnalogRefinementDefault;
        return timingConfigs.getSchedulingDaysSuccessAnalogRefinement();
    }

    public Duration getSchedulingDaysFailureAnalogRefinement() {
        if (timingConfigs.getSchedulingDaysFailureAnalogRefinement() == null) return schedulingDaysFailureAnalogRefinementDefault;
        return timingConfigs.getSchedulingDaysFailureAnalogRefinement();
    }

    public Duration getTimeToAddInNonVisibilityTimeCase() {
        if (timingConfigs.getNonVisibilityTime() == null) return timeToAddInNonVisibilityTimeCaseDefault;
        return timingConfigs.getNonVisibilityTime();
    }

    public Duration getSecondNotificationWorkflowWaitingTime() {
        if (timingConfigs.getSecondNotificationWorkflowWaitingTime() == null) return secondNotificationWorkflowWaitingTimeDefault;
        return timingConfigs.getSecondNotificationWorkflowWaitingTime();
    }

    public Duration getWaitingForReadCourtesyMessage() {
        if (timingConfigs.getWaitingForReadCourtesyMessage() == null) return waitingForReadCourtesyMessageDefault;
        return timingConfigs.getWaitingForReadCourtesyMessage();
    }

    public List<HashMap<String, String>> getGroupsByPa(String settedPa) {
        List<HashMap<String, String>> hashMapsList;
        switch (settedPa) {
            case "Comune_1":
                hashMapsList = this.pnExternalServiceClient.paGroupInfo(SettableApiKey.ApiKeyType.MVP_1);
                break;
            case "Comune_2":
                hashMapsList = this.pnExternalServiceClient.paGroupInfo(SettableApiKey.ApiKeyType.MVP_2);
                break;
            case "Comune_Multi":
                hashMapsList = this.pnExternalServiceClient.paGroupInfo(SettableApiKey.ApiKeyType.GA);
                break;
            case "Comune_Son":
                hashMapsList = this.pnExternalServiceClient.paGroupInfo(SettableApiKey.ApiKeyType.SON);
                break;
            case "Comune_Root":
                hashMapsList = this.pnExternalServiceClient.paGroupInfo(SettableApiKey.ApiKeyType.ROOT);
                break;
            default:
                throw new IllegalArgumentException();
        }
        Assertions.assertNotNull(hashMapsList);
        Assertions.assertFalse(hashMapsList.isEmpty());
        return hashMapsList;
    }

    public String getGroupIdByPa(String settedPa, GroupPosition position) {
        List<HashMap<String, String>> hashMapsList = getGroupsByPa(settedPa);
        String id = null;
        int count = 0;
        for (HashMap<String, String> elem : hashMapsList) {
            if (elem.get("status").equalsIgnoreCase("ACTIVE")) {
                id = elem.get("id");
                count++;
                if (GroupPosition.FIRST.equals(position)) {
                    break;
                }
            }
        }
        Assertions.assertNotNull(id);
        if (!GroupPosition.FIRST.equals(position)) {
            Assertions.assertTrue(count >= 2);
        }
        return id;
    }

    public List<String> getGroupAllActiveByPa(String settedPa) {
        List<HashMap<String, String>> hashMapsList = getGroupsByPa(settedPa);
        List<String> groups = new ArrayList<>();
        String id;
        int count = 0;
        for (HashMap<String, String> elem : hashMapsList) {
            if (elem.get("status").equalsIgnoreCase("ACTIVE")) {
                id = elem.get("id");
                count++;
                groups.add(id);
            }
        }
        Assertions.assertTrue(count >= 2);
        return groups;
    }

    private static EventId getEventId(String iun, DataTest dataFromTest) {
        TimelineElementV23 timelineElement = dataFromTest.getTimelineElement();
        TimelineElementDetailsV23 timelineElementDetails = timelineElement.getDetails();
        DigitalAddress digitalAddress = timelineElementDetails == null ? null : timelineElementDetails.getDigitalAddress();
        DigitalAddressSource digitalAddressSource = timelineElementDetails == null ? null : timelineElementDetails.getDigitalAddressSource();

        EventId event = new EventId();
        event.setIun(iun);
        event.setRecIndex(timelineElementDetails == null ? null : timelineElementDetails.getRecIndex());
        event.setCourtesyAddressType(digitalAddress == null ? null : digitalAddress.getType());
        event.setSource(digitalAddressSource == null ? null : digitalAddressSource.getValue());
        event.setIsFirstSendRetry(dataFromTest.getIsFirstSendRetry());
        event.setSentAttemptMade(timelineElementDetails == null ? null : timelineElementDetails.getSentAttemptMade());
        event.setProgressIndex(dataFromTest.getProgressIndex());
        return event;
    }

    public String getTimelineEventId(String timelineEventCategory, String iun, DataTest dataFromTest) {
        EventId event = getEventId(iun, dataFromTest);
        switch (timelineEventCategory) {
            case "SEND_COURTESY_MESSAGE":
                return TimelineEventId.SEND_COURTESY_MESSAGE.buildEventId(event);
            case "REQUEST_REFUSED":
                return TimelineEventId.REQUEST_REFUSED.buildEventId(event);
            case "AAR_GENERATION":
                return TimelineEventId.AAR_GENERATION.buildEventId(event);
            case "REQUEST_ACCEPTED":
                return TimelineEventId.REQUEST_ACCEPTED.buildEventId(event);
            case "SEND_DIGITAL_DOMICILE":
                return TimelineEventId.SEND_DIGITAL_DOMICILE.buildEventId(event);
            case "SEND_DIGITAL_FEEDBACK":
                return TimelineEventId.SEND_DIGITAL_FEEDBACK.buildEventId(event);
            case "GET_ADDRESS":
                return TimelineEventId.GET_ADDRESS.buildEventId(event);
            case "DIGITAL_SUCCESS_WORKFLOW":
                return TimelineEventId.DIGITAL_SUCCESS_WORKFLOW.buildEventId(event);
            case "SCHEDULE_REFINEMENT":
                return TimelineEventId.SCHEDULE_REFINEMENT_WORKFLOW.buildEventId(event);
            case "REFINEMENT":
                return TimelineEventId.REFINEMENT.buildEventId(event);
            case "ANALOG_SUCCESS_WORKFLOW":
                return TimelineEventId.ANALOG_SUCCESS_WORKFLOW.buildEventId(event);
            case "DIGITAL_FAILURE_WORKFLOW":
                return TimelineEventId.DIGITAL_FAILURE_WORKFLOW.buildEventId(event);
            case "SEND_ANALOG_FEEDBACK":
                return TimelineEventId.SEND_ANALOG_FEEDBACK.buildEventId(event);
            case "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS":
                return TimelineEventId.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS.buildEventId(event);
            case "SEND_ANALOG_PROGRESS":
                return TimelineEventId.SEND_ANALOG_PROGRESS.buildEventId(event);
            case "ANALOG_FAILURE_WORKFLOW":
                return TimelineEventId.ANALOG_FAILURE_WORKFLOW.buildEventId(event);
            case "PREPARE_ANALOG_DOMICILE":
                return TimelineEventId.PREPARE_ANALOG_DOMICILE.buildEventId(event);
            case "SCHEDULE_ANALOG_WORKFLOW":
                return TimelineEventId.SCHEDULE_ANALOG_WORKFLOW.buildEventId(event);
            case "SEND_ANALOG_DOMICILE":
                return TimelineEventId.SEND_ANALOG_DOMICILE.buildEventId(event);
            case "SEND_SIMPLE_REGISTERED_LETTER":
                return TimelineEventId.SEND_SIMPLE_REGISTERED_LETTER.buildEventId(event);
            case "PREPARE_SIMPLE_REGISTERED_LETTER":
                return TimelineEventId.PREPARE_SIMPLE_REGISTERED_LETTER.buildEventId(event);
            case "NOTIFICATION_VIEWED":
                return TimelineEventId.NOTIFICATION_VIEWED.buildEventId(event);
            case "COMPLETELY_UNREACHABLE":
                return TimelineEventId.COMPLETELY_UNREACHABLE.buildEventId(event);
            case "DIGITAL_DELIVERY_CREATION_REQUEST":
                return TimelineEventId.DIGITAL_DELIVERY_CREATION_REQUEST.buildEventId(event);
        }
        return null;
    }

    public TimelineElementV23 getTimelineElementByEventId(String timelineEventCategory, DataTest dataFromTest) {
        List<TimelineElementV23> timelineElementList = notificationResponseComplete.getTimeline();
        String iun;
        if (timelineEventCategory.equals(TimelineElementCategoryV23.REQUEST_REFUSED.getValue())) {
            String requestId = newNotificationResponse.getNotificationRequestId();
            byte[] decodedBytes = Base64.getDecoder().decode(requestId);
            iun = new String(decodedBytes);
        } else {
            // proceed with default flux
            iun = notificationResponseComplete.getIun();
        }
        if (dataFromTest != null && dataFromTest.getTimelineElement() != null) {
            // get timeline event id
            String timelineEventId = getTimelineEventId(timelineEventCategory, iun, dataFromTest);
            if (timelineEventCategory.equals(TimelineElementCategoryV23.SEND_ANALOG_PROGRESS.getValue()) || timelineEventCategory.equals(TimelineElementCategoryV23.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS.getValue())) {
                TimelineElementV23 timelineElementFromTest = dataFromTest.getTimelineElement();
                TimelineElementDetailsV23 timelineElementDetails = timelineElementFromTest.getDetails();
                return timelineElementList.stream().filter(elem -> Objects.requireNonNull(elem.getElementId()).startsWith(timelineEventId) && Objects.equals(Objects.requireNonNull(elem.getDetails()).getDeliveryDetailCode(), Objects.requireNonNull(timelineElementDetails).getDeliveryDetailCode())).findAny().orElse(null);
            }
            return timelineElementList.stream().filter(elem -> Objects.requireNonNull(elem.getElementId()).equals(timelineEventId)).findAny().orElse(null);
        }
        return timelineElementList.stream().filter(elem -> Objects.requireNonNull(elem.getCategory()).getValue().equals(timelineEventCategory)).findAny().orElse(null);
    }

    public String getSchedulingDelta() {
        if (timingConfigs.getSchedulingDeltaMillis() == null) return schedulingDeltaDefault;
        return String.valueOf(timingConfigs.getSchedulingDeltaMillis());
    }

    public void addIuvGPD(String iuvGPD) {
        this.iuvGPD.add("3" + iuvGPD);
    }

    public String getIuvGPD(int posizione) {
        return this.iuvGPD.get(posizione);
    }

    public String getIunVersionamento() {
        if (getSentNotificationV1() != null) {
            return getSentNotificationV1().getIun();
        } else if (getSentNotificationV2() != null) {
            return getSentNotificationV2().getIun();
        } else if (getSentNotificationV21()!= null) {
            return getSentNotificationV21().getIun();
        } else if (getSentNotification()!= null) {
            return getSentNotification().getIun();
        } else {
            return null;
        }
    }

    public List<String> getDatiPagamentoVersionamento(Integer destinatario,Integer pagamento){
        List<String> DatiPagamento = new ArrayList<>();
        if (getSentNotificationV1()!= null) {
            DatiPagamento.add(Objects.requireNonNull(getSentNotificationV1().getRecipients().get(destinatario).getPayment()).getCreditorTaxId());
            DatiPagamento.add(Objects.requireNonNull(getSentNotificationV1().getRecipients().get(destinatario).getPayment()).getNoticeCode());
        } else if (getSentNotificationV2()!= null) {
            DatiPagamento.add(Objects.requireNonNull(getSentNotificationV2().getRecipients().get(destinatario).getPayment()).getCreditorTaxId());
            DatiPagamento.add(Objects.requireNonNull(getSentNotificationV2().getRecipients().get(destinatario).getPayment()).getNoticeCode());
        } else if (getSentNotificationV21()!= null) {
            DatiPagamento.add(Objects.requireNonNull(Objects.requireNonNull(getSentNotificationV21().getRecipients().get(destinatario).getPayments()).get(pagamento).getPagoPa()).getCreditorTaxId());
            DatiPagamento.add(Objects.requireNonNull(Objects.requireNonNull(getSentNotificationV21().getRecipients().get(destinatario).getPayments()).get(pagamento).getPagoPa()).getNoticeCode());
        } else if (getSentNotification()!= null) {
            DatiPagamento.add(Objects.requireNonNull(Objects.requireNonNull(getSentNotification().getRecipients().get(destinatario).getPayments()).get(pagamento).getPagoPa()).getCreditorTaxId());
            DatiPagamento.add(Objects.requireNonNull(Objects.requireNonNull(getSentNotification().getRecipients().get(destinatario).getPayments()).get(pagamento).getPagoPa()).getNoticeCode());
        }
        return DatiPagamento;
    }
}