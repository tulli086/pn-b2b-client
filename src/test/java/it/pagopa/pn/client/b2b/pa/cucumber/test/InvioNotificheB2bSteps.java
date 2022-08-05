package it.pagopa.pn.client.b2b.pa.cucumber.test;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.*;
import it.pagopa.pn.client.b2b.pa.impl.IPnPaB2bClient;
import org.junit.jupiter.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.lang.invoke.MethodHandles;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicReference;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

@PropertySource( value = "file:config/api-keys.properties", ignoreResourceNotFound = true )
public class InvioNotificheB2bSteps  {

    @Autowired
    private PnPaB2bUtils utils;

    @Autowired
    private IPnPaB2bClient client;

    private NewNotificationRequest notificationRequest;
    private FullSentNotification notificationResponseComplete;
    private HttpClientErrorException notificationSentError;
    private String sha256DocumentDownload;
    private NotificationAttachmentDownloadMetadataResponse downloadResponse;
    private static final Logger logger = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());


    @Given("viene predisposta una notifica con oggetto {string} mittente {string} destinatario {string} con codice fiscale {string}")
    public void NotificaOggettoMittenteDestinatarioConCodiceFiscale(String oggetto, String mittente, String destinatario, String cf) {
        newNotificationRequest(oggetto,mittente,destinatario,cf,"","","","");
    }

    @Given("viene predisposta una notifica con oggetto {string} mittente {string} destinatario {string} con codice fiscale {string} e idempotenceToken {string}")
    public void NotificaOggettoMittenteDestinatarioConCodiceFiscaleIdempotenceToken(String oggetto, String mittente, String destinatario, String cf, String idempotenceToken)  {
        newNotificationRequest(oggetto,mittente,destinatario,cf,idempotenceToken,"","","");
    }

    @Given("viene predisposta una notifica con oggetto {string} mittente {string} destinatario {string} con codice fiscale {string} e creditorTaxId {string}")
    public void NotificaOggettoMittenteDestinatarioConCodiceFiscaleCreditorTaxId(String oggetto, String mittente, String destinatario, String cf, String creditorTaxId) {
        newNotificationRequest(oggetto,mittente,destinatario,cf,"","",creditorTaxId,"");
    }

    @And("viene predisposta e inviata una nuova notifica con uguale codice fiscale del creditore e diverso codice avviso")
    public void vienePredispostaEInviataUnaNuovaNotificaConUgualeCodiceFiscaleDelCreditoreEDiversoCodiceAvviso() {
        newNotificationRequest(notificationRequest.getSubject(),
                notificationRequest.getSenderDenomination(),
                notificationRequest.getRecipients().get(0).getDenomination(),
                notificationRequest.getRecipients().get(0).getTaxId(),
                "",
                "",
                notificationRequest.getRecipients().get(0).getPayment().getCreditorTaxId(),"");
    }

    @And("viene predisposta e inviata una nuova notifica con uguale codice fiscale del creditore e uguale codice avviso")
    public void vienePredispostaEInviataUnaNuovaNotificaConUgualeCodiceFiscaleDelCreditoreEUgualeCodiceAvviso() {
        newNotificationRequest(notificationRequest.getSubject(),
                notificationRequest.getSenderDenomination(),
                notificationRequest.getRecipients().get(0).getDenomination(),
                notificationRequest.getRecipients().get(0).getTaxId(),
                "",
                "",
                notificationRequest.getRecipients().get(0).getPayment().getCreditorTaxId(),
                notificationRequest.getRecipients().get(0).getPayment().getNoticeCode());
    }

    @And("viene predisposta e inviata una nuova notifica con uguale paProtocolNumber e idempotenceToken {string}")
    public void vienePredispostaEInviataUnaNuovaNotificaConUgualePaProtocolNumberEIdempotenceToken(String idempotenceToken) {
        newNotificationRequest(notificationRequest.getSubject(),
                notificationRequest.getSenderDenomination(),
                notificationRequest.getRecipients().get(0).getDenomination(),
                notificationRequest.getRecipients().get(0).getTaxId(),
                idempotenceToken,
                notificationRequest.getPaProtocolNumber(),
                "","");
    }


    @When("la notifica viene inviata e si riceve una risposta")
    public void laNotificaVieneInviataOk() {
        Assertions.assertDoesNotThrow(() -> {
            NewNotificationResponse newNotificationRequest = utils.uploadNotification(notificationRequest);
            notificationResponseComplete = utils.waitForRequestAcceptation( newNotificationRequest );
        });
        try {
            Thread.sleep( 10 * 1000);
        } catch (InterruptedException e) {
            logger.error("Thread.sleep error retry");
            throw new RuntimeException(e);
        }
    }

    @When("la notifica viene inviata")
    public void laNotificaVieneInviataKO() {
        try {
            NewNotificationResponse newNotificationRequest = utils.uploadNotification(notificationRequest);
        } catch (HttpClientErrorException | IOException e) {
            if(e instanceof HttpClientErrorException){
                this.notificationSentError = (HttpClientErrorException)e;
            }
        }
    }

    @And("la notifica può essere correttamente recuperata dal sistema tramite codice IUN")
    public void laNotificaCorrettamenteRecuperataDalSistemaTramiteCodiceIUN() {
        AtomicReference<FullSentNotification> notificationByIun = new AtomicReference<>();

        Assertions.assertDoesNotThrow(() ->
                notificationByIun.set(utils.getNotificationByIun(notificationResponseComplete.getIun()))
        );

        Assertions.assertNotNull(notificationByIun.get());
    }

    @When("viene richiesto il download del documento notificato")
    public void vieneRichiestoIlDownloadDelDocumentoDiPagamento() {
        List<NotificationDocument> documents = notificationResponseComplete.getDocuments();
        this.downloadResponse = client
                .getSentNotificationDocument(notificationResponseComplete.getIun(), new BigDecimal(documents.get(0).getDocIdx()));

        byte[] bytes = Assertions.assertDoesNotThrow(() ->
                utils.downloadFile(this.downloadResponse.getUrl()));
        this.sha256DocumentDownload = utils.computeSha256(new ByteArrayInputStream(bytes));
    }


    @When("viene richiesto il download di un documento inesistente")
    public void vieneRichiestoIlDownloadDiUnDocumentoInesistente() throws IOException {
        List<NotificationDocument> documents = notificationResponseComplete.getDocuments();
        try {
            this.downloadResponse = client
                    .getSentNotificationDocument(notificationResponseComplete.getIun(), new BigDecimal(100));
        } catch (HttpClientErrorException | HttpServerErrorException e) {
            if(e instanceof HttpClientErrorException){
                this.notificationSentError = (HttpClientErrorException)e;
            }
        }

    }

    @Then("il download si conclude correttamente")
    public void ilDownloadSiConcludeCorrettamente() {
        Assertions.assertEquals(this.sha256DocumentDownload,this.downloadResponse.getSha256());
    }

    @Then("l'operazione ha prodotto un errore con status code {string}")
    public void operazioneHaProdottoUnErrore(String statusCode) {
        Assertions.assertTrue((this.notificationSentError != null) &&
                (this.notificationSentError.getStatusCode().toString().substring(0,3).equals(statusCode)));
    }


    @Then("la risposta di ricezione non presenta errori")
    public void laNotificaCorrettamenteInviata() {
        Assertions.assertDoesNotThrow(() -> utils.verifyNotification( notificationResponseComplete ));
    }


    /* UTILITY */

    private void newNotificationRequest(String oggetto, String mittente, String destinatario, String cf,
                                        String idempotenceToken, String paProtocolNumber,String creditorTaxId, String noticeCode ) {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

        notificationRequest = new NewNotificationRequest()
                .subject(oggetto+" "+ dateFormat.format(calendar.getTime()))
                .cancelledIun("")
                .group("")
                .idempotenceToken(idempotenceToken)
                ._abstract("Abstract della notifica")
                .senderDenomination(mittente)
                .senderTaxId("CFComuneMilano")
                .notificationFeePolicy( NewNotificationRequest.NotificationFeePolicyEnum.FLAT_RATE )
                .physicalCommunicationType( NewNotificationRequest.PhysicalCommunicationTypeEnum.REGISTERED_LETTER_890 )
                .paProtocolNumber((paProtocolNumber.equals("") ? "" + System.currentTimeMillis() : paProtocolNumber))
                .addDocumentsItem( newDocument( "classpath:/sample.pdf" ) )
                .addRecipientsItem( newRecipient( destinatario, cf,"classpath:/sample.pdf",creditorTaxId,noticeCode));
    }

    private NotificationDocument newDocument(String resourcePath ) {
        return new NotificationDocument()
                .contentType("application/pdf")
                .ref( new NotificationAttachmentBodyRef().key( resourcePath ));
    }

    private NotificationRecipient newRecipient(String prefix, String taxId, String resourcePath, String creditorTaxId, String noticeCode) {
        long epochMillis = System.currentTimeMillis();

        NotificationRecipient recipient = new NotificationRecipient()
                .denomination( prefix + " denomination")
                .taxId( taxId )
                .digitalDomicile( new NotificationDigitalAddress()
                        .type(NotificationDigitalAddress.TypeEnum.PEC)
                        .address( "FRMTTR76M06B715E@pnpagopa.postecert.local")
                )
                .physicalAddress( new NotificationPhysicalAddress()
                        .address("Via senza nome")
                        .municipality("Milano")
                        .province("MI")
                        .foreignState("ITALIA")
                        .zip("40100")
                )
                .recipientType( NotificationRecipient.RecipientTypeEnum.PF )
                .payment( new NotificationPaymentInfo()
                                .creditorTaxId(creditorTaxId.equals("")?"77777777777":creditorTaxId)
                                .noticeCode(noticeCode.trim().equals("")? String.format("30201%13d", epochMillis ):noticeCode )
                                .noticeCodeOptional( String.format("30201%13d", epochMillis+1 ) )
                                .pagoPaForm( newAttachment( resourcePath ))
                );

        try {
            Thread.sleep(10);
        }
        catch (InterruptedException exc) {
            logger.error("Thread.sleep error retry");
            throw new RuntimeException(exc);
        }

        return recipient;
    }

    private NotificationPaymentAttachment newAttachment(String resourcePath ) {
        return new NotificationPaymentAttachment()
                .contentType("application/pdf")
                .ref( new NotificationAttachmentBodyRef().key( resourcePath ));
    }



}