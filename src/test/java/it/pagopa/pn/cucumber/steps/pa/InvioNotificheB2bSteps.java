package it.pagopa.pn.cucumber.steps.pa;


import io.cucumber.java.Transpose;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.*;
import it.pagopa.pn.client.b2b.pa.impl.IPnPaB2bClient;
import it.pagopa.pn.client.b2b.pa.testclient.IPnWebPaClient;
import it.pagopa.pn.client.b2b.pa.testclient.PnExternalServiceClientImpl;
import it.pagopa.pn.client.b2b.pa.testclient.PnGPDClientImpl;
import it.pagopa.pn.client.b2b.pa.testclient.PnPaymentInfoClientImpl;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.gpd.model.*;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.payment_info.model.PaymentInfo;
import it.pagopa.pn.client.web.generated.openapi.clients.webPa.model.NotificationSearchResponse;
import it.pagopa.pn.cucumber.steps.SharedSteps;
import it.pagopa.pn.cucumber.utils.DataTest;
import org.junit.jupiter.api.Assertions;
import org.opentest4j.AssertionFailedError;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestClientException;

import java.io.ByteArrayInputStream;
import java.lang.invoke.MethodHandles;
import java.text.SimpleDateFormat;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.concurrent.atomic.AtomicReference;

import static java.time.OffsetDateTime.now;


public class InvioNotificheB2bSteps {

    @Value("${pn.retention.time.preload}")
    private Integer retentionTimePreLoad;

    @Value("${pn.retention.time.load}")
    private Integer retentionTimeLoad;

    private final PnPaB2bUtils b2bUtils;
    private final IPnWebPaClient webPaClient;
    private final IPnPaB2bClient b2bClient;
    private final PnExternalServiceClientImpl safeStorageClient;
    private final SharedSteps sharedSteps;
    private final PnGPDClientImpl pnGPDClientImpl;

    private final PnPaymentInfoClientImpl pnPaymentInfoClient;
    private PaymentPositionModel paymentPositionModel;
    private PaymentPositionModelBaseResponse paymentPositionModelBaseResponse;

    private List<Object> paymentInfoResponse;

    private PaymentInfo paymentInfo;

    private List<Object> paymentInfoV21;



    private String DeleteGDPresponse;
    private Integer amountGPD;
    private NotificationDocument notificationDocumentPreload;
    private NotificationPaymentAttachment notificationPaymentAttachmentPreload;

    private String sha256DocumentDownload;
    private NotificationAttachmentDownloadMetadataResponse downloadResponse;


    private static final Logger logger = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

    @Autowired
    public InvioNotificheB2bSteps(PnExternalServiceClientImpl safeStorageClient, SharedSteps sharedSteps) {
        this.safeStorageClient = safeStorageClient;
        this.sharedSteps = sharedSteps;
        this.b2bUtils = sharedSteps.getB2bUtils();
        this.b2bClient = sharedSteps.getB2bClient();
        this.webPaClient = sharedSteps.getWebPaClient();
        this.pnGPDClientImpl = sharedSteps.getPnGPDClientImpl();
        this.pnPaymentInfoClient=sharedSteps.getPnPaymentInfoClientImpl();
    }


    @And("la notifica può essere correttamente recuperata dal sistema tramite codice IUN")
    public void notificationCanBeRetrievedWithIUN() {
        AtomicReference<FullSentNotificationV21> notificationByIun = new AtomicReference<>();
        try {
            Assertions.assertDoesNotThrow(() ->
                    notificationByIun.set(b2bUtils.getNotificationByIun(sharedSteps.getSentNotification().getIun()))
            );
            Assertions.assertNotNull(notificationByIun.get());
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }

    @And("la notifica può essere correttamente recuperata dal sistema tramite codice IUN web PA")
    public void notificationCanBeRetrievedWithIUNWebPA() {
        AtomicReference<NotificationSearchResponse> notificationByIun = new AtomicReference<>();
        try {
            Assertions.assertDoesNotThrow(() ->
                    notificationByIun.set(webPaClient.searchSentNotification(OffsetDateTime.now().minusDays(1), OffsetDateTime.now(),null,null,null,sharedSteps.getSentNotification().getIun(),1,null))
            );
            Assertions.assertNotNull(notificationByIun.get());
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }

    @Then("la notifica può essere correttamente recuperata dal sistema tramite Stato {string} dalla web PA {string}")
    public void notificationCanBeRetrievedWithStatusByWebPA(String status, String paType) {
        sharedSteps.selectPA(paType);

        it.pagopa.pn.client.web.generated.openapi.clients.webPa.model.NotificationStatus notificationInternalStatus;
        switch (status) {
            case "ACCEPTED":
                notificationInternalStatus = it.pagopa.pn.client.web.generated.openapi.clients.webPa.model.NotificationStatus.ACCEPTED;
                break;
            case "DELIVERING":
                notificationInternalStatus = it.pagopa.pn.client.web.generated.openapi.clients.webPa.model.NotificationStatus.DELIVERING;
                break;
            case "DELIVERED":
                notificationInternalStatus = it.pagopa.pn.client.web.generated.openapi.clients.webPa.model.NotificationStatus.DELIVERED;
                break;
            case "CANCELLED":
                notificationInternalStatus = it.pagopa.pn.client.web.generated.openapi.clients.webPa.model.NotificationStatus.CANCELLED;
                break;
            case "EFFECTIVE_DATE":
               notificationInternalStatus = it.pagopa.pn.client.web.generated.openapi.clients.webPa.model.NotificationStatus.EFFECTIVE_DATE;
                break;
            case "REFUSED":
                notificationInternalStatus = it.pagopa.pn.client.web.generated.openapi.clients.webPa.model.NotificationStatus.REFUSED;
                break;

            default:
                throw new IllegalArgumentException();
        }

        AtomicReference<NotificationSearchResponse> notificationByIun = new AtomicReference<>();
        try {
            Assertions.assertDoesNotThrow(() ->
                    notificationByIun.set(webPaClient.searchSentNotification(OffsetDateTime.now().minusDays(1), OffsetDateTime.now(),null,notificationInternalStatus,null,null,1,null))
            );
            Assertions.assertNotNull(notificationByIun.get());
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }


    @Then("la notifica viene recuperata dal sistema tramite codice IUN")
    public void laNotificaVieneRecuperataDalSistemaTramiteCodiceIUN() {
        AtomicReference<FullSentNotificationV21> notificationByIun = new AtomicReference<>();
        try {
            notificationByIun.set(b2bUtils.getNotificationByIun(sharedSteps.getSentNotification().getIun()));
        } catch (HttpStatusCodeException e) {
            this.sharedSteps.setNotificationError(e);
        }
    }

    @Given("viene effettuato il pre-caricamento di un documento")
    public void preLoadingOfDocument() {
        NotificationDocument notificationDocument = b2bUtils.newDocument("classpath:/sample.pdf");
        AtomicReference<NotificationDocument> notificationDocumentAtomic = new AtomicReference<>();
        Assertions.assertDoesNotThrow(() -> notificationDocumentAtomic.set(b2bUtils.preloadDocument(notificationDocument)));
        try {
            Thread.sleep( sharedSteps.getWait());
        } catch (InterruptedException e) {
            logger.error("Thread.sleep error retry");
            throw new RuntimeException(e);
        }
        this.notificationDocumentPreload = notificationDocumentAtomic.get();
    }

    @Given("viene effettuato il pre-caricamento di un allegato")
    public void preLoadingOfAttachment() {
        NotificationPaymentAttachment notificationPaymentAttachment = b2bUtils.newAttachment("classpath:/sample.pdf");
        AtomicReference<NotificationPaymentAttachment> notificationDocumentAtomic = new AtomicReference<>();
        Assertions.assertDoesNotThrow(() -> notificationDocumentAtomic.set(b2bUtils.preloadAttachment(notificationPaymentAttachment)));
        try {
            Thread.sleep( sharedSteps.getWait());
        } catch (InterruptedException e) {
            logger.error("Thread.sleep error retry");
            throw new RuntimeException(e);
        }
        this.notificationPaymentAttachmentPreload = notificationDocumentAtomic.get();
    }

    @Then("viene effettuato un controllo sulla durata della retention di {string} precaricato")
    public void retentionCheckPreload(String documentType) {
        String key = "";
        switch (documentType) {
            case "ATTO OPPONIBILE":
                key = this.notificationDocumentPreload.getRef().getKey();
                break;
            case "PAGOPA":
                key = this.notificationPaymentAttachmentPreload.getRef().getKey();
                break;
            default:
                throw new IllegalArgumentException();
        }
        Assertions.assertTrue(checkRetetion(key, retentionTimePreLoad));
    }

    @And("viene effettuato un controllo sulla durata della retention di {string}")
    public void retentionCheckLoad(String documentType) {
        String key = "";
        switch (documentType) {
            case "ATTO OPPONIBILE":
                key = sharedSteps.getSentNotification().getDocuments().get(0).getRef().getKey();
                break;
            case "PAGOPA":
                key = sharedSteps.getSentNotification().getRecipients().get(0).getPayments().get(0).getPagoPa().getAttachment().getRef().getKey();
                break;
            case "F24_STANDARD":
                key = sharedSteps.getSentNotification().getRecipients().get(0).getPayments().get(0).getF24().getMetadataAttachment().getRef().getKey();
                break;
            default:
                throw new IllegalArgumentException();
        }
        Assertions.assertTrue(checkRetetion(key, retentionTimeLoad));
    }

    @And("viene effettuato un controllo sulla durata della retention di {string} per l'elemento di timeline {string}")
    public void retentionCheckLoadForTimelineElement(String documentType, String timelineEventCategory, @Transpose DataTest dataFromTest) throws InterruptedException {
        TimelineElementV20 timelineElement = sharedSteps.getTimelineElementByEventId(timelineEventCategory, dataFromTest);
        switch (documentType) {
            case "ATTACHMENTS":
                for (int i = 0; i < sharedSteps.getSentNotification().getDocuments().size(); i++) {
                    String key = sharedSteps.getSentNotification().getDocuments().get(i).getRef().getKey();
                    Assertions.assertTrue(checkRetention(key, retentionTimeLoad, timelineElement.getTimestamp()));
                }
                break;
            default:
                throw new IllegalArgumentException();
        }
    }


    @Given("viene letta la notifica {string} dal {string}")
    public void vieneLettaLaNotificaDal(String IUN, String pa) {
        sharedSteps.selectPA(pa);
        FullSentNotificationV21 notificationByIun = b2bUtils.getNotificationByIun(IUN);
        sharedSteps.setSentNotification(notificationByIun);
    }

    @When("si tenta il recupero della notifica dal sistema tramite codice IUN {string}")
    public void retrievalAttemptedIUN(String IUN) {
        try {
            b2bUtils.getNotificationByIun(IUN);
        } catch (HttpStatusCodeException e) {
            this.sharedSteps.setNotificationError(e);
        }
    }

    @When("viene richiesto il download del documento {string}")
    public void documentDownload(String type) {
        String downloadType;
        switch (type) {
            case "NOTIFICA":
                List<NotificationDocument> documents = sharedSteps.getSentNotification().getDocuments();
                this.downloadResponse = b2bClient
                        .getSentNotificationDocument(sharedSteps.getSentNotification().getIun(), Integer.parseInt(documents.get(0).getDocIdx()));

                byte[] bytes = Assertions.assertDoesNotThrow(() ->
                        b2bUtils.downloadFile(this.downloadResponse.getUrl()));
                this.sha256DocumentDownload = b2bUtils.computeSha256(new ByteArrayInputStream(bytes));
                return;
            case "PAGOPA":
                downloadType = "PAGOPA";
                break;
            case "F24_FLAT":
                downloadType = "F24_FLAT";
                break;
            case "F24_STANDARD":
                downloadType = "F24_STANDARD";
                break;
            default:
                throw new IllegalArgumentException();
        }
        this.downloadResponse = b2bClient
                .getSentNotificationAttachment(sharedSteps.getSentNotification().getIun(), 0, downloadType,0);
        byte[] bytes = Assertions.assertDoesNotThrow(() ->
                b2bUtils.downloadFile(this.downloadResponse.getUrl()));
        this.sha256DocumentDownload = b2bUtils.computeSha256(new ByteArrayInputStream(bytes));
    }

    @When("viene richiesto il download del documento {string} inesistente")
    public void documentAbsentDownload(String type) {
        String downloadType;
        switch (type) {
            case "NOTIFICA":
                List<NotificationDocument> documents = sharedSteps.getSentNotification().getDocuments();
                try {
                    this.downloadResponse = b2bClient
                            .getSentNotificationDocument(sharedSteps.getSentNotification().getIun(), documents.size());
                } catch (HttpStatusCodeException e) {
                    this.sharedSteps.setNotificationError(e);
                }
                return;
            case "PAGOPA":
                downloadType = "PAGOPA";
                break;
            case "F24_FLAT":
                downloadType = "F24_FLAT";
                break;
            case "F24_STANDARD":
                downloadType = "F24_STANDARD";
                break;
            default:
                throw new IllegalArgumentException();
        }
        try {
            this.downloadResponse = b2bClient
                    .getSentNotificationAttachment(sharedSteps.getSentNotification().getIun(), 100, downloadType,0);
        } catch (HttpStatusCodeException e) {
            this.sharedSteps.setNotificationError(e);
        }
    }

    @Then("il download si conclude correttamente")
    public void correctlyDownload() {
        Assertions.assertEquals(this.sha256DocumentDownload, this.downloadResponse.getSha256());
    }

    @Then("l'operazione ha prodotto un errore con status code {string}")
    public void operationProducedAnError(String statusCode) {
        HttpStatusCodeException httpStatusCodeException = this.sharedSteps.consumeNotificationError();
        Assertions.assertTrue((httpStatusCodeException != null) &&
                (httpStatusCodeException.getStatusCode().toString().substring(0, 3).equals(statusCode)));
    }


    @Then("si verifica la corretta acquisizione della notifica")
    public void correctAcquisitionNotification() {
        Assertions.assertDoesNotThrow(() -> b2bUtils.verifyNotification(sharedSteps.getSentNotification()));
    }


    @And("viene controllato la presenza del taxonomyCode")
    public void checkTaxonomyCode() {
        Assertions.assertNotNull(this.sharedSteps.getSentNotification().getTaxonomyCode());
        if (this.sharedSteps.getNotificationRequest().getTaxonomyCode() != null) {
            Assertions.assertEquals(this.sharedSteps.getNotificationRequest().getTaxonomyCode(),
                    this.sharedSteps.getSentNotification().getTaxonomyCode());
        }

    }


    @And("vengono prodotte le evidenze: metadati e requestID")
    public void evidenceProduced() {
        Assertions.assertNotNull(this.sharedSteps.getNewNotificationResponse());
        logger.info("METADATI: " + '\n' + this.sharedSteps.getNewNotificationResponse());
        logger.info("REQUEST-ID: " + '\n' + this.sharedSteps.getNewNotificationResponse().getNotificationRequestId());
    }


    @Then("si verifica la corretta acquisizione della richiesta di invio notifica")
    public void correctAcquisitionRequest() {
        Assertions.assertNotNull(this.sharedSteps.getNewNotificationResponse());
        Assertions.assertNotNull(this.sharedSteps.getNewNotificationResponse().getNotificationRequestId());
        Assertions.assertNotNull(b2bClient.getNotificationRequestStatus(this.sharedSteps.getNewNotificationResponse().getNotificationRequestId()));
    }


    private boolean checkRetetion(String fileKey, Integer retentionTime) {
        PnExternalServiceClientImpl.SafeStorageResponse safeStorageResponse = safeStorageClient.safeStorageInfo(fileKey);
        System.out.println(safeStorageResponse);
        LocalDateTime localDateTimeNow = LocalDate.now().atStartOfDay();
        OffsetDateTime now = OffsetDateTime.of(localDateTimeNow, ZoneOffset.of("Z"));
        OffsetDateTime retentionUntil = OffsetDateTime.parse(safeStorageResponse.getRetentionUntil());
        logger.info("now: " + now);
        logger.info("retentionUntil: " + retentionUntil);
        long between = ChronoUnit.DAYS.between(now, retentionUntil);
        logger.info("Difference: " + between);
        return retentionTime == between;
    }

    private boolean checkRetention(String fileKey, Integer retentionTime, OffsetDateTime timelineEventTimestamp) throws InterruptedException {
        Thread.sleep(2 * 60 * 1000);
        PnExternalServiceClientImpl.SafeStorageResponse safeStorageResponse = safeStorageClient.safeStorageInfo(fileKey);
        System.out.println(safeStorageResponse);
        OffsetDateTime timelineEventDate = timelineEventTimestamp.atZoneSameInstant(ZoneId.of("Z")).toOffsetDateTime();
        OffsetDateTime retentionUntil = OffsetDateTime.parse(safeStorageResponse.getRetentionUntil());
        logger.info("now: " + timelineEventDate);
        logger.info("retentionUntil: " + retentionUntil);
        OffsetDateTime timelineEventDateDays = timelineEventDate.truncatedTo(ChronoUnit.HOURS);
        OffsetDateTime retentionUntilDays = retentionUntil.truncatedTo(ChronoUnit.HOURS);
        Integer timelineEventDateMinutes = timelineEventDate.getMinute();
        Integer retentionUntilMinutes = retentionUntil.getMinute();
        long between = ChronoUnit.DAYS.between(timelineEventDateDays, retentionUntilDays);
        logger.info("Difference: " + between);
        return retentionTime == between && Math.abs(timelineEventDateMinutes - retentionUntilMinutes) <= 2;
    }

    @And("l'importo della notifica è {int}")
    public void priceNotificationVerify(Integer price) {
        try {
            Assertions.assertEquals(this.sharedSteps.getSentNotification().getAmount(), price);
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }


    @Then("viene verificato lo stato di accettazione con idempotenceToken e paProtocolNumber")
    public void vieneVerificatoLoStatoDiAccettazioneConIdempotenceTokenEPaProtocolNumber() {
        NewNotificationResponse newNotificationResponse = this.sharedSteps.getNewNotificationResponse();
        verifyStatus(null, newNotificationResponse.getPaProtocolNumber(), newNotificationResponse.getIdempotenceToken());

    }

    @Then("viene verificato lo stato di accettazione con requestID")
    public void vieneVerificatoLoStatoDiAccettazioneConRequestID() {
        NewNotificationResponse newNotificationResponse = this.sharedSteps.getNewNotificationResponse();
        verifyStatus(newNotificationResponse.getNotificationRequestId(), null, null);
    }

    @Then("viene verificato lo stato di accettazione con paProtocolNumber")
    public void vieneVerificatoLoStatoDiAccettazioneConPaProtocolNumber() {
        NewNotificationResponse newNotificationResponse = this.sharedSteps.getNewNotificationResponse();
        verifyStatus(null, newNotificationResponse.getPaProtocolNumber(), null);
    }

    private void verifyStatus(String notificationRequestId, String paProtocolNumber, String idempotenceToken) {
        NewNotificationRequestStatusResponseV21 newNotificationRequestStatusResponse = Assertions.assertDoesNotThrow(() ->
                this.b2bClient.getNotificationRequestStatusAllParam(notificationRequestId, paProtocolNumber, idempotenceToken));
        Assertions.assertNotNull(newNotificationRequestStatusResponse.getNotificationRequestStatus());
        logger.debug(newNotificationRequestStatusResponse.getNotificationRequestStatus());
    }






    //Annullamento Notifica
    @And("la notifica non può essere annullata dal sistema tramite codice IUN più volte")
    public void notificationNotCanBeCanceledWithIUN() {
        Assertions.assertDoesNotThrow(() -> {
            RequestStatus resp =  Assertions.assertDoesNotThrow(() ->
                    b2bClient.notificationCancellation(sharedSteps.getSentNotification().getIun()));

            Assertions.assertNotNull(resp);
            Assertions.assertNotNull(resp.getDetails());
            Assertions.assertTrue(resp.getDetails().size()>0);
            Assertions.assertTrue("NOTIFICATION_ALREADY_CANCELLED".equalsIgnoreCase(resp.getDetails().get(0).getCode()));

        });
    }

    @Then("si verifica il corretto annullamento della notifica")
    public void correctCanceledNotification() {
        //Assertions.assertNull(assertionFailedError);
    }




    private void priceVerificationGPD() {

        List<PaymentOptionModelResponse> listPaymentOptionModelResponse = paymentPositionModelBaseResponse.getPaymentOption();
        if (listPaymentOptionModelResponse != null){
            for (PaymentOptionModelResponse paymentOptionModelResponse: listPaymentOptionModelResponse) {
                NotificationPriceResponse notificationPrice = this.b2bClient.getNotificationPrice(paymentPositionModel.getFiscalCode(),paymentPositionModel.getPaymentOption().get(0).getIuv());//serve un taxID e un noticeCode
                try {
                    Assertions.assertEquals(notificationPrice.getIun(), sharedSteps.getSentNotification().getIun());
                    if (amountGPD != null) {
                        logger.info("Costo notifica: {}", notificationPrice.getAmount());
                        Assertions.assertEquals(notificationPrice.getAmount(), amountGPD);
                    }
                } catch (AssertionFailedError assertionFailedError) {
                    sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
                }
            }
        }
    }
    @And("viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore {string} e amount {string} per {string} con (CF)(Piva) {string}")
    public void vieneCreataUnaPosizioneDebitoria(String organitationCode,String amount,String name,String taxId) {

        String iuv = String.format("47%13d44", System.currentTimeMillis());
        logger.info("Iuv generato: " + iuv);
        logger.info("IUPD generate: " + organitationCode +"-64c8e41bfec846e04"+ iuv, System.currentTimeMillis());

        PaymentPositionModel paymentPositionModelSend = new PaymentPositionModel()
                .iupd(String.format(organitationCode+"-64c8e41bfec846e04"+  iuv, System.currentTimeMillis()))
                .type(PaymentPositionModel.TypeEnum.F)
                .companyName("Automation")
                .fullName(name)
                .fiscalCode(taxId)
                .addPaymentOptionItem(new PaymentOptionModel()
                        .iuv(iuv)
                        .amount(Long.parseLong(amount))
                        .description("Test Automation")
                        .isPartialPayment(false)
                        .dueDate(new StringBuilder("2050-09-30T15:30:00"))
                        .retentionDate(new StringBuilder("2050-09-30T15:30:00"))
                        .addTransferItem(new TransferModel()
                                .idTransfer(TransferModel.IdTransferEnum._1)
                                .organizationFiscalCode(organitationCode)
                                .amount(Long.parseLong(amount))
                                .remittanceInformation("Test Automation")
                                .category("9/0301100TS/")
                                .iban("IT30N0103076271000001823603")));

        logger.info("Request: " + paymentPositionModelSend.toString());
        try {

            Assertions.assertDoesNotThrow(() -> {
                paymentPositionModel = pnGPDClientImpl.createPosition(organitationCode, paymentPositionModelSend, null, true);
            });
            Assertions.assertNotNull(paymentPositionModel);

        } catch (AssertionFailedError assertionFailedError) {

            String message = assertionFailedError.getMessage() +
                    "{la posizione debitoria " + (paymentPositionModel == null ? "NULL" : paymentPositionModel.toString()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());

        }
    }

    @And("lettura amount posizione debitoria")
    public void letturaAmountPosizioneDebitoria() {

        String organitationCode=paymentPositionModel.getPaymentOption().get(0).getTransfer().get(0).getOrganizationFiscalCode();
        logger.info("Creditore da cercare: " + organitationCode);



        String noticeCode="3"+paymentPositionModel.getPaymentOption().get(0).getIuv();
        logger.info("NoticeCode da cercare: " + noticeCode);

        //Object messageJson="[{\"creditorTaxId\": \"77777777777\",\"noticeCode\": \""+noticeCode+"\"}]";
        Object messageJson="{\"creditorTaxId\": \"77777777777\",\"noticeCode\": \""+noticeCode+"\"}";
        //Object messageJson="{\"creditorTaxId\": \"77777777777\",\"noticeCode\": \"+noticeCode+"\"}";
        logger.info("Messaggio json da allegare: " + messageJson);



           List<Object> messaggioObj = new ArrayList<Object>();
           messaggioObj.add(messageJson);

        logger.info("Messaggio json da allegare: " + messaggioObj.toString());


        try {
            Assertions.assertDoesNotThrow(() -> {
                List<Object> paymentInfoResponse=pnPaymentInfoClient.getPaymentInfoV21(messaggioObj);
                logger.info("Risposta recupero posizione debitoria: " + paymentInfoResponse.toString());
                //paymentInfoV21.get(0).toString();
                //paymentInfo=pnPaymentInfoClient.getPaymentInfo(organitationCode,noticeCode);
            });
            Assertions.assertNotNull(paymentInfoResponse);
            //Assertions.assertNotNull(paymentInfo);

            //amountGPD=paymentInfo.getAmount();
            //logger.info("Amount: " + amountGPD);


        } catch (AssertionFailedError assertionFailedError) {

            String message = assertionFailedError.getMessage() +
                    "{la posizione debitoria " + (paymentInfo == null ? "NULL" : paymentInfo.toString()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());

        }
    }

    @And("viene cancellata la posizione debitoria")
    public void vieneCancellataLaPosizioneDebitoria() {

        logger.info("Iuv da Cancellare: " + paymentPositionModel.getIupd());
        try {
            Assertions.assertDoesNotThrow(() -> {
                DeleteGDPresponse = pnGPDClientImpl.deletePosition(paymentPositionModel.getPaymentOption().get(0).getTransfer().get(0).getOrganizationFiscalCode(), paymentPositionModel.getIupd(), null);
            });
            logger.info("Risposta evento cancellazione: " + DeleteGDPresponse);
        } catch (AssertionFailedError assertionFailedError) {

            String message = assertionFailedError.getMessage() +
                    "{la posizione debitoria " + (DeleteGDPresponse == null ? "NULL" : DeleteGDPresponse) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());

        }
    }

    @And("viene effettuato il confronto del amount del GPD con quello della notifica")
    public void vieneEffettuatoIlConfrontoDelAmountDelGPDConQuelloDellaNotifica() {
        try {
            Thread.sleep(sharedSteps.getWait());
        } catch (InterruptedException interruptedException) {
            interruptedException.printStackTrace();
        }
            priceVerificationGPD();
    }

    @And("viene effettuato il controllo del amount di GPD = 0")
    public void vieneEffettuatoIlControlloDelAmountDiGPD() {

        try {
            Assertions.assertEquals(amountGPD,0);

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{la posizione debitoria " + (paymentPositionModelBaseResponse == null ? "NULL" : paymentPositionModelBaseResponse.toString()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());

        }
    }



}
