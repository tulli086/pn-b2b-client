package it.pagopa.pn.cucumber.steps.pa;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.testclient.IPnRaddFsuClientImpl;
import it.pagopa.pn.client.b2b.pa.testclient.PnExternalServiceClientImpl;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.internalb2bradd.model.*;
import it.pagopa.pn.cucumber.steps.SharedSteps;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import java.io.IOException;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;

import static it.pagopa.pn.cucumber.utils.FiscalCodeGenerator.generateCF;
import static it.pagopa.pn.cucumber.utils.NotificationValue.generateRandomNumber;


@Slf4j
public class RaddFsuSteps {

    private final IPnRaddFsuClientImpl raddFsuClient;
    private final PnExternalServiceClientImpl externalServiceClient;
    private final SharedSteps sharedSteps;
    private final PnPaB2bUtils pnPaB2bUtils;

    private final String defaultQrCodeCf = "MNDLCU98T68C933T";
    private final String qrCodeMNDLCU98T68C933T = "R0pHTi1aUk1KLU5EVkEtMjAyMzA2LVUtMV9QRi00ZGJkZTM0MC0wMWQ5LTRlYTEtOWNhZC05NDM1ZGEwYjY2OGNfNzk4ZDhlMzktYmMxMC00MmUzLWJhNjktMjRhY2MxNDE3MmVl";
    private final String malformedQrCode;
    private final String nonExistentQrCode;
    private ActInquiryResponse actInquiryResponse;
    private String qrCode;
    private String currentUserCf;

    private String operationid;
    private StartTransactionResponse startTransactionResponse;
    private StartTransactionResponse aorStartTransactionResponse;
    private String uid = "1234556";

    private AORInquiryResponse aorInquiryResponse;
    private PnPaB2bUtils.Pair<String,String> documentUploadResponse;

    private final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");


    @Autowired
    public RaddFsuSteps(IPnRaddFsuClientImpl raddFsuClient,PnExternalServiceClientImpl externalServiceClient,
                        PnPaB2bUtils pnPaB2bUtils, SharedSteps sharedSteps) {
        this.raddFsuClient = raddFsuClient;
        this.externalServiceClient = externalServiceClient;
        this.sharedSteps = sharedSteps;
        this.pnPaB2bUtils = pnPaB2bUtils;

        this.malformedQrCode = qrCodeMNDLCU98T68C933T + "MALF";
        this.nonExistentQrCode = qrCodeMNDLCU98T68C933T.replace('L','C');
    }


    @Given("viene verificata la presenza di atti e\\/o attestazioni per l'utente {string}")
    public void vieneVerificataLaPresenzaDiAttiEOAttestazioniPerLUtente(String cf) {
        AORInquiryResponse pf = this.raddFsuClient.aorInquiry("reprehenderit culpa enim", cf, "PF");
        System.out.println(pf);
    }


    @Given("viene richiesto il codice QR per lo IUN {string}")
    public void vieneRichiestoIlCodiceQRPerLoIUN(String iun) {
        HashMap<String, String> quickAccessLink = externalServiceClient.getQuickAccessLink(iun);
        log.debug("quickAccessLink: {}",quickAccessLink.toString());
        this.qrCode = quickAccessLink.get(quickAccessLink.keySet().toArray()[0]);
        log.debug("qrCode: {}",qrCode);
    }


    @Given("Il cittadino mostra il QRCode malformato presente sull{string}operatore")
    public void ilCittadinoMostraIlQRCodeMalformatoPresenteSullAARAllOperatore() {
        this.qrCode = this.malformedQrCode;
    }

    @When("L'operatore scansione il qrCode per recuperare gli atti")
    public void lOperatoreScansioneIlQrCodePerRecuperariGliAtti() {
        ActInquiryResponse actInquiryResponse = raddFsuClient.actInquiry(uid,this.currentUserCf, "PF", qrCode);
        log.info("actInquiryResponse: {}",actInquiryResponse);
        this.actInquiryResponse = actInquiryResponse;
    }


    private void selectUser(String cf){
        switch (cf.toUpperCase()){
            case "MARIO CUCUMBER" -> this.currentUserCf = sharedSteps.getMarioCucumberTaxID();
            case "MARIO GHERKIN" -> this.currentUserCf = sharedSteps.getMarioGherkinTaxID();
            case "SIGNOR CASUALE" -> this.currentUserCf = sharedSteps.getSentNotification().getRecipients().get(0).getTaxId();
            case "SIGNOR GENERATO" -> this.currentUserCf = generateCF(System.nanoTime());
            default ->  this.currentUserCf = cf;
        }
    }

    @When("Il cittadino Signor casuale chiede di verificare la presenza di notifiche")
    public void ilCittadinoSignorCasualeChiedeDiVerificareLaPresenzaDiNotifiche() {
        selectUser("Signor casuale");
        this.aorInquiryResponse = raddFsuClient.aorInquiry(uid, this.currentUserCf, "PF");
    }

    @Given("Il cittadino {string} mostra il QRCode {string}")
    public void ilCittadinoMostraIlQRCode(String cf, String qrCodeType) {
        selectUser(cf);
        qrCodeType = qrCodeType.toLowerCase();
        switch (qrCodeType) {
            case "malformato" -> this.qrCode = malformedQrCode;
            case "inesistente" -> this.qrCode = nonExistentQrCode;
            case "appartenente a terzo" -> {
                if(defaultQrCodeCf.equalsIgnoreCase(cf))throw new IllegalArgumentException();
                this.qrCode = qrCodeMNDLCU98T68C933T;
            }
            case "corretto" -> {
                vieneRichiestoIlCodiceQRPerLoIUN(sharedSteps.getSentNotification().getIun());
            }
            default -> throw new IllegalArgumentException();
        }
    }

    private ActInquiryResponseStatus.CodeEnum getErrorCode(int errorCode){
        switch (errorCode){
            case 0 -> {
                return ActInquiryResponseStatus.CodeEnum.NUMBER_0;
            }
            case 1 -> {
                return ActInquiryResponseStatus.CodeEnum.NUMBER_1;
            }
            case 2 -> {
                return ActInquiryResponseStatus.CodeEnum.NUMBER_2;
            }
            case 3 -> {
                return ActInquiryResponseStatus.CodeEnum.NUMBER_3;
            }
            case 99 -> {
                return ActInquiryResponseStatus.CodeEnum.NUMBER_99;
            }
            default -> throw new IllegalArgumentException();
        }
    }

    @Then("Viene restituito un messaggio di errore {string} con codice di errore {int}")
    public void vieneRestituitoUnMessaggioDiErrore(String errorType, int errorCode) {
        errorType = errorType.toLowerCase();
        ActInquiryResponseStatus.CodeEnum error = getErrorCode(errorCode);
        switch (errorType) {
            case "qrcode non valido", "cf non valido" -> {
                Assertions.assertEquals(false, actInquiryResponse.getResult());
                Assertions.assertNotNull( actInquiryResponse.getStatus());
                Assertions.assertEquals(error, actInquiryResponse.getStatus().getCode());
            }
            default -> throw new IllegalArgumentException();
        }
    }

    @And("la scansione si conclude correttamente")
    public void laScansioneSiConcludeCorrettamente() {
        log.debug("actInquiryResponse {}",actInquiryResponse.toString());
        Assertions.assertEquals(true, actInquiryResponse.getResult());
        Assertions.assertNotNull( actInquiryResponse.getStatus());
        Assertions.assertEquals(ActInquiryResponseStatus.CodeEnum.NUMBER_0, actInquiryResponse.getStatus().getCode());
    }

    @And("vengono caricati i documento di identità del cittadino")
    public void vengonoCaricatiIDocumentoDiIdentitaDelCittadino() {
        uploadDocument(true);
    }

    @And("si inizia il processo di caricamento dei documento di identità del cittadino ma non si porta a conclusione")
    public void siIniziaIlProcessoDiCaricamentoDeiDocumentoDiIdentitàDelCittadinoMaNonSiPortaAConclusione() {
        uploadDocument(false);
    }

    private void uploadDocument(boolean usePresignedUrl){
        try {
            PnPaB2bUtils.Pair<String, String> uploadResponse = pnPaB2bUtils.preloadRadFsuDocument("classpath:/sample.pdf",usePresignedUrl);
            Assertions.assertNotNull(uploadResponse);
            this.documentUploadResponse = uploadResponse;
            log.info("documentUploadResponse: {}",documentUploadResponse);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }


    @Then("Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR")
    public void vengonoVisualizzatiSiaGliAttiSiaLeAttestazioniOpponibiliRiferitiAllaNotificaAssociataAllAAR() {
        this.operationid = generateRandomNumber();
        startTransactionAct(this.operationid);
    }

    @And("Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR utilizzando il precedente operationId")
    public void vengonoVisualizzatiSiaGliAttiSiaLeAttestazioniOpponibiliRiferitiAllaNotificaAssociataAllAARUtilizzandoIlPrecedenteOperationId() {
        startTransactionAct(this.operationid);
    }

    private void startTransactionAct(String operationid){
        ActStartTransactionRequest actStartTransactionRequest =
                new ActStartTransactionRequest()
                        .qrCode(this.qrCode)
                        .versionToken("string")
                        .fileKey(this.documentUploadResponse.getValue1())
                        .operationId(operationid)
                        .recipientTaxId(this.currentUserCf)
                        .recipientType(ActStartTransactionRequest.RecipientTypeEnum.PF)
                        //.operationDate(OffsetDateTime.now()) TODO: controllare
                        .checksum(this.documentUploadResponse.getValue2());
        System.out.println("actStartTransactionRequest: "+actStartTransactionRequest);
        this.startTransactionResponse = raddFsuClient.startActTransaction(uid, actStartTransactionRequest);
        System.out.println("startTransactionResponse: "+startTransactionResponse);
    }
    @And("l'operazione di download degli atti si conclude correttamente")
    public void lOperazioneDiDownloadDegliAttiSiConcludeCorrettamente() {
        Assertions.assertNotNull(this.startTransactionResponse.getUrlList());
        Assertions.assertFalse(this.startTransactionResponse.getUrlList().isEmpty());
        Assertions.assertNotNull(this.startTransactionResponse.getStatus());
        Assertions.assertEquals(StartTransactionResponseStatus.CodeEnum.NUMBER_0,this.startTransactionResponse.getStatus().getCode());
    }


    @And("l'operazione di download degli atti genera un errore {string} con codice {int}")
    public void lOperazioneDiDownloadDegliAttiGeneraUnErroreConCodice(String errorDescription, int erroCode) {
        StartTransactionResponseStatus.CodeEnum error = getErrorCodeStartTransaction(erroCode);
        Assertions.assertNull(this.startTransactionResponse.getUrlList());
        Assertions.assertNotNull(this.startTransactionResponse.getStatus());
        Assertions.assertEquals(error,this.startTransactionResponse.getStatus().getCode());
        Assertions.assertNotNull(this.startTransactionResponse.getStatus().getMessage());
        Assertions.assertEquals(errorDescription.trim().toLowerCase(),this.startTransactionResponse.getStatus().getMessage().toLowerCase());
    }

    private StartTransactionResponseStatus.CodeEnum getErrorCodeStartTransaction(int errorCode){
        switch (errorCode){
            case 0 -> {
                return StartTransactionResponseStatus.CodeEnum.NUMBER_0;
            }
            case 2 -> {
                return StartTransactionResponseStatus.CodeEnum.NUMBER_2;
            }
            case 99 -> {
                return StartTransactionResponseStatus.CodeEnum.NUMBER_99;
            }
            default -> throw new IllegalArgumentException();
        }
    }

    @And("viene conclusa la visualizzati di atti ed attestazioni della notifica")
    public void vieneConclusaLaVisualizzatiDiAttiEdAttestazioniDellaNotifica() {
        CompleteTransactionRequest completeTransactionRequest =
                new CompleteTransactionRequest()
                        .operationId(this.operationid)
                        .operationDate(dateTimeFormatter.format(OffsetDateTime.now()));
        CompleteTransactionResponse completeTransactionResponse = raddFsuClient.completeActTransaction(this.uid, completeTransactionRequest);
        System.out.println(completeTransactionResponse);
        Assertions.assertNotNull(completeTransactionResponse);
    }


    @Given("Il cittadino {string} chiede di verificare la presenza di notifiche")
    public void ilCittadinoChiedeDiVerificareLaPresenzaDiNotifiche(String cf) {
        selectUser(cf);
        AORInquiryResponse aorInquiryResponse = raddFsuClient.aorInquiry(uid, cf, "PF");
        this.aorInquiryResponse = aorInquiryResponse;
    }

    @When("La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente")
    public void laVerificaAorMostraCorrettamenteLeNotificheInStatoIrreperibile() {
        Assertions.assertNotNull(this.aorInquiryResponse);
        Assertions.assertTrue(this.aorInquiryResponse.getResult());
        Assertions.assertNotNull(this.aorInquiryResponse.getStatus());
        Assertions.assertEquals(ResponseStatus.CodeEnum.NUMBER_0,this.aorInquiryResponse.getStatus().getCode());
        log.info("aorInquiryResponse: {}",this.aorInquiryResponse);
    }

    @Then("Vengono recuperati gli atti delle notifiche in stato irreperibile")
    public void vengonoRecuperatiGliAttiDelleNotificheInStatoIrreperibile() {
        try {
            Thread.sleep(10000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        this.operationid = generateRandomNumber();
        AorStartTransactionRequest aorStartTransactionRequest =
                new AorStartTransactionRequest()
                        .versionToken("string")
                        .fileKey(this.documentUploadResponse.getValue1())
                        .operationId(this.operationid)
                        .recipientTaxId(this.currentUserCf)
                        .recipientType(AorStartTransactionRequest.RecipientTypeEnum.PF)
                        .operationDate(dateTimeFormatter.format(OffsetDateTime.now()))
                        //.delegateTaxId("")
                        .checksum(this.documentUploadResponse.getValue2());
        this.aorStartTransactionResponse = raddFsuClient.startAorTransaction(this.uid, aorStartTransactionRequest);
    }

    @And("il recupero degli atti in stato irreperibile si conclude correttamente")
    public void ilRecuperoDegliAttiInStatoIrreperibileSiConcludeCorrettamente() {
        log.info("aorStartTransactionResponse: {}",this.aorStartTransactionResponse);
    }
}
