package it.pagopa.pn.cucumber.steps.pa;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.service.IPnRaddAlternativeClient;
import it.pagopa.pn.client.b2b.pa.service.impl.PnExternalServiceClientImpl;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model.*;
import it.pagopa.pn.cucumber.steps.SharedSteps;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.InputStreamSource;
import org.springframework.web.client.HttpStatusCodeException;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import static it.pagopa.pn.cucumber.utils.FiscalCodeGenerator.generateCF;
import static it.pagopa.pn.cucumber.utils.NotificationValue.generateRandomNumber;


@Slf4j
public class RaddAltSteps {

    private final IPnRaddAlternativeClient raddAltClient;
    private final PnExternalServiceClientImpl externalServiceClient;
    private final SharedSteps sharedSteps;
    private final RaddFsuSteps raddFsuSteps;
    private final PnPaB2bUtils pnPaB2bUtils;
    private ActInquiryResponse actInquiryResponse;
    private String qrCode;
    private String currentUserCf;
    @Value("${pn.external.bearer-token-pg1.id}")
    private String idOrganization;
    @Value("${spring.profiles.active}")
    private String ambiente;
    private String operationid;
    private StartTransactionResponse startTransactionResponse;
    private StartTransactionResponse aorStartTransactionResponse;
    private String uid = "1234556";

    private AORInquiryResponse aorInquiryResponse;
    private CompleteTransactionResponse completeTransactionResponse;
    private PnPaB2bUtils.Pair<String, String> documentUploadResponse;

    private AbortTransactionResponse abortActTransaction;

    private HttpStatusCodeException documentUploadError;


    private final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");


    @Autowired
    public RaddAltSteps(IPnRaddAlternativeClient raddAltClient, PnExternalServiceClientImpl externalServiceClient,
                        PnPaB2bUtils pnPaB2bUtils, SharedSteps sharedSteps, RaddFsuSteps raddFsuSteps) {
        this.raddAltClient = raddAltClient;
        this.externalServiceClient = externalServiceClient;
        this.sharedSteps = sharedSteps;
        this.pnPaB2bUtils = pnPaB2bUtils;
        this.raddFsuSteps = raddFsuSteps;

    }


    @Given("viene verificata la presenza di atti e\\/o attestazioni per l'utente {string} per radd alternative")
    public void vieneVerificataLaPresenzaDiAttiEOAttestazioniPerLUtente(String cf) {
        AORInquiryResponse pf = this.raddAltClient.aorInquiry(CxTypeAuthFleet.PG, idOrganization, "reprehenderit culpa enim", cf, "PF");
        System.out.println(pf);
    }


    @When("L'operatore scansione il qrCode per recuperare gli atti della {string}")
    public void lOperatoreScansioneIlQrCodePerRecuperariGliAttiAlternative(String recipientType) {

        ActInquiryResponse actInquiryResponse = raddAltClient.actInquiry(CxTypeAuthFleet.PG,
                idOrganization,
                uid,
                this.currentUserCf,
                recipientType,
                qrCode,
                null);

        log.info("actInquiryResponse: {}", actInquiryResponse);
        this.actInquiryResponse = actInquiryResponse;
    }

    @When("L'operatore usa lo IUN per recuperare gli atti della {string}")
    public void lOperatoreUsoIUNPerRecuperariGliAtti(String recipientType) {

        ActInquiryResponse actInquiryResponse = raddAltClient.actInquiry(CxTypeAuthFleet.PG,
                idOrganization,
                uid,
                this.currentUserCf,
                recipientType,
                null,
                sharedSteps.getIunVersionamento());

        log.info("actInquiryResponse: {}", actInquiryResponse);
        this.actInquiryResponse = actInquiryResponse;
    }


    private ActInquiryResponseStatus.CodeEnum getErrorCodeRaddAlternative(int errorCode) {
        switch (errorCode) {
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
            case 80 -> {
                return ActInquiryResponseStatus.CodeEnum.NUMBER_80;
            }
            case 99 -> {
                return ActInquiryResponseStatus.CodeEnum.NUMBER_99;
            }
            default -> throw new IllegalArgumentException();
        }
    }

    @Then("Viene restituito un messaggio di errore {string} con codice di errore {int} su radd alternative")
    public void vieneRestituitoUnMessaggioDiErrore(String errorType, int errorCode) {
        errorType = errorType.toLowerCase();
        ActInquiryResponseStatus.CodeEnum error = getErrorCodeRaddAlternative(errorCode);
        switch (errorType) {
            case "qrcode non valido", "cf non valido" -> {
                Assertions.assertEquals(false, actInquiryResponse.getResult());
                Assertions.assertNotNull(actInquiryResponse.getStatus());
                Assertions.assertEquals(error, actInquiryResponse.getStatus().getCode());
            }
            case "stampa già eseguita","notifica annullata" -> {
                Assertions.assertEquals(false, actInquiryResponse.getResult());
                Assertions.assertNotNull(actInquiryResponse.getStatus());
                Assertions.assertNotNull(actInquiryResponse.getStatus().getMessage());
                Assertions.assertEquals(errorType.toLowerCase(), actInquiryResponse.getStatus().getMessage().toLowerCase());
                Assertions.assertEquals(error, actInquiryResponse.getStatus().getCode());

            }

            default -> throw new IllegalArgumentException();
        }
    }

    @And("la scansione si conclude correttamente su radd alternative")
    public void laScansioneSiConcludeCorrettamenteAlternative() {
        log.debug("actInquiryResponse {}", actInquiryResponse.toString());
        Assertions.assertEquals(true, actInquiryResponse.getResult());
        Assertions.assertNotNull(actInquiryResponse.getStatus());
        Assertions.assertEquals(ActInquiryResponseStatus.CodeEnum.NUMBER_0, actInquiryResponse.getStatus().getCode());
    }

    @And("vengono caricati i documento di identità del cittadino su radd alternative")
    public void vengonoCaricatiIDocumentoDiIdentitaDelCittadino() {
        uploadDocumentRaddAlternative(true);
    }

    @And("si inizia il processo di caricamento dei documento di identità del cittadino ma non si porta a conclusione su radd alternative")
    public void siIniziaIlProcessoDiCaricamentoDeiDocumentoDiIdentitàDelCittadinoMaNonSiPortaAConclusione() {
        uploadDocumentRaddAlternative(false);
    }

    private void uploadDocumentRaddAlternative(boolean usePresignedUrl) {
        try {
            PnPaB2bUtils.Pair<String, String> uploadResponse = pnPaB2bUtils.preloadRaddAlternativeDocument("classpath:/sample.zip", usePresignedUrl,this.operationid);
            Assertions.assertNotNull(uploadResponse);
            this.documentUploadResponse = uploadResponse;
            log.info("documentUploadResponse: {}", documentUploadResponse);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }


    @Then("Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR su radd alternative")
    public void vengonoVisualizzatiSiaGliAttiSiaLeAttestazioniOpponibiliRiferitiAllaNotificaAssociataAllAAR() {
        this.operationid = generateRandomNumber();
        startTransactionActRaddAlternative(this.operationid);
    }

    @And("Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR utilizzando il precedente operationId su radd alternative")
    public void vengonoVisualizzatiSiaGliAttiSiaLeAttestazioniOpponibiliRiferitiAllaNotificaAssociataAllAARUtilizzandoIlPrecedenteOperationId() {
        startTransactionActRaddAlternative(this.operationid);
    }

    private void startTransactionActRaddAlternative(String operationid) {
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
        System.out.println("actStartTransactionRequest: " + actStartTransactionRequest);
        this.startTransactionResponse = raddAltClient.startActTransaction(uid, CxTypeAuthFleet.PG, null, actStartTransactionRequest);
        System.out.println("startTransactionResponse: " + startTransactionResponse);
    }

    @And("l'operazione di download degli atti si conclude correttamente su radd alternative")
    public void lOperazioneDiDownloadDegliAttiSiConcludeCorrettamente() {
        Assertions.assertNotNull(this.startTransactionResponse.getDownloadUrlList());
        Assertions.assertFalse(this.startTransactionResponse.getDownloadUrlList().isEmpty());
        Assertions.assertNotNull(this.startTransactionResponse.getStatus());
        Assertions.assertEquals(StartTransactionResponseStatus.CodeEnum.NUMBER_0, this.startTransactionResponse.getStatus().getCode());
    }


    @And("l'operazione di download degli atti genera un errore {string} con codice {int} su radd alternative")
    public void lOperazioneDiDownloadDegliAttiGeneraUnErroreConCodice(String errorDescription, int erroCode) {
        StartTransactionResponseStatus.CodeEnum error = getErrorCodeStartTransaction(erroCode);
        Assertions.assertNull(this.startTransactionResponse.getDownloadUrlList());
        Assertions.assertNotNull(this.startTransactionResponse.getStatus());
        Assertions.assertEquals(error, this.startTransactionResponse.getStatus().getCode());
        Assertions.assertNotNull(this.startTransactionResponse.getStatus().getMessage());
        Assertions.assertEquals(errorDescription.trim().toLowerCase(), this.startTransactionResponse.getStatus().getMessage().toLowerCase());
    }

    private StartTransactionResponseStatus.CodeEnum getErrorCodeStartTransaction(int errorCode) {
        //return StartTransactionResponseStatus.CodeEnum.valueOf("NUMBER_"+errorCode);
        switch (errorCode) {
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

    @And("viene conclusa la visualizzati di atti ed attestazioni della notifica su radd alternative")
    public void vieneConclusaLaVisualizzatiDiAttiEdAttestazioniDellaNotifica() {
        CompleteTransactionRequest completeTransactionRequest =
                new CompleteTransactionRequest()
                        .operationId(this.operationid)
                        .operationDate(dateTimeFormatter.format(OffsetDateTime.now()));
        this.completeTransactionResponse = raddAltClient.completeActTransaction(this.uid, CxTypeAuthFleet.PG, idOrganization, completeTransactionRequest);
        System.out.println(completeTransactionResponse);
        Assertions.assertNotNull(completeTransactionResponse);
    }


    @Given("la {string} {string} chiede di verificare la presenza di notifiche")
    public void ilCittadinoChiedeDiVerificareLaPresenzaDiNotifiche(String typeAuthFleet, String cf) {
        selectUserRaddAlternative(cf);
        this.aorInquiryResponse = raddAltClient.aorInquiry(CxTypeAuthFleet.PG,
                idOrganization,
                uid,
                cf,
                typeAuthFleet);
    }

    @When("Il cittadino Signor casuale chiede di verificare la presenza di notifiche su radd alternative")
    public void ilCittadinoSignorCasualeChiedeDiVerificareLaPresenzaDiNotifiche() {
        selectUserRaddAlternative("Signor casuale");
        this.aorInquiryResponse = raddAltClient.aorInquiry(CxTypeAuthFleet.PG,
                idOrganization,
                uid,
                this.currentUserCf,
                "PF");
    }

    @When("La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente su radd alternative")
    public void laVerificaAorMostraCorrettamenteLeNotificheInStatoIrreperibile() {
        Assertions.assertNotNull(this.aorInquiryResponse);
        Assertions.assertTrue(this.aorInquiryResponse.getResult());
        Assertions.assertNotNull(this.aorInquiryResponse.getStatus());
        Assertions.assertEquals(ResponseStatus.CodeEnum.NUMBER_0, this.aorInquiryResponse.getStatus().getCode());
        log.info("aorInquiryResponse: {}", this.aorInquiryResponse);
    }

    @Then("Vengono recuperati gli aar delle notifiche in stato irreperibile della {string} su radd alternative")
    public void vengonoRecuperatiGliAttiDelleNotificheInStatoIrreperibile(String recipientType) {
        this.operationid = generateRandomNumber();
        AorStartTransactionRequest aorStartTransactionRequest =
                new AorStartTransactionRequest()
                        .versionToken("string")
                        .fileKey(this.documentUploadResponse.getValue1())
                        .operationId(this.operationid)
                        .recipientTaxId(this.currentUserCf)
                        .recipientType(recipientType.equalsIgnoreCase("PF")?AorStartTransactionRequest.RecipientTypeEnum.PF:
                                AorStartTransactionRequest.RecipientTypeEnum.PG)
                        .operationDate(dateTimeFormatter.format(OffsetDateTime.now()))
                        //.delegateTaxId("")
                        .checksum(this.documentUploadResponse.getValue2());
        this.aorStartTransactionResponse = raddAltClient.startAorTransaction(this.uid, CxTypeAuthFleet.PG, idOrganization, aorStartTransactionRequest);
    }

    @And("il recupero degli aar in stato irreperibile si conclude correttamente su radd alternative")
    public void ilRecuperoDegliAttiInStatoIrreperibileSiConcludeCorrettamente() {
        log.info("aorStartTransactionResponse: {}", this.aorStartTransactionResponse);

        Assertions.assertNotNull(this.aorStartTransactionResponse.getDownloadUrlList());
        Assertions.assertFalse(this.aorStartTransactionResponse.getDownloadUrlList().isEmpty());
        Assertions.assertNotNull(this.aorStartTransactionResponse.getStatus());
        Assertions.assertEquals(StartTransactionResponseStatus.CodeEnum.NUMBER_0, this.aorStartTransactionResponse.getStatus().getCode());
    }

    @And("il recupero degli aar in stato irreperibile si conclude correttamente e vengono restituiti {int} aar su radd alternative")
    public void ilRecuperoDegliAarInStatoIrreperibileSiConcludeCorrettamenteEVengonoRestituitiTuttiEGliAar(int aarNumber) {
        log.info("aorStartTransactionResponse: {}", this.aorStartTransactionResponse);

        Assertions.assertNotNull(this.aorStartTransactionResponse.getDownloadUrlList());
        Assertions.assertEquals(this.aorStartTransactionResponse.getDownloadUrlList().size(), aarNumber);
        Assertions.assertFalse(this.aorStartTransactionResponse.getDownloadUrlList().isEmpty());
        Assertions.assertNotNull(this.aorStartTransactionResponse.getStatus());
        Assertions.assertEquals(StartTransactionResponseStatus.CodeEnum.NUMBER_0, this.aorStartTransactionResponse.getStatus().getCode());
    }

    @And("il recupero degli aar genera un errore {string} con codice {int} su radd alternative")
    public void ilRecuperoDegliAarGeneraUnErroreConCodice(String errorType, int errorCode) {
        log.info("aorStartTransactionResponse: {}", this.aorStartTransactionResponse);

        errorType = errorType.toLowerCase();
        StartTransactionResponseStatus.CodeEnum error = getErrorCodeStartTransaction(errorCode);

        Assertions.assertNull(this.aorStartTransactionResponse.getDownloadUrlList());
        Assertions.assertNotNull(this.aorStartTransactionResponse.getStatus());
        Assertions.assertEquals(error, this.aorStartTransactionResponse.getStatus().getCode());
        Assertions.assertNotNull(this.aorStartTransactionResponse.getStatus().getMessage());
        Assertions.assertEquals(errorType, this.aorStartTransactionResponse.getStatus().getMessage().toLowerCase());
    }

    @When("La verifica della presenza di notifiche in stato irreperibile genera un errore {string} con codice {int} su radd alternative")
    public void laVerificaDellaPresenzaDiNotificheInStatoIrreperibiGeneraUnErroreConCodice(String errorType, int errorCode) {
        errorType = errorType.toLowerCase();
        ResponseStatus.CodeEnum error = getAorErrorCode(errorCode);
        switch (errorType) {
            case "non ci sono notifiche non consegnate per questo codice fiscale" -> {
                Assertions.assertEquals(false, this.aorInquiryResponse.getResult());
                Assertions.assertNotNull(this.aorInquiryResponse.getStatus());
                Assertions.assertEquals(error, this.aorInquiryResponse.getStatus().getCode());
            }
            default -> throw new IllegalArgumentException();
        }

        log.info("aorInquiryResponse: {}", this.aorInquiryResponse);
    }

    private ResponseStatus.CodeEnum getAorErrorCode(int errorCode) {
        switch (errorCode) {
            case 0 -> {
                return ResponseStatus.CodeEnum.NUMBER_0;
            }
            case 99 -> {
                return ResponseStatus.CodeEnum.NUMBER_99;
            }
            default -> throw new IllegalArgumentException();
        }
    }


    @And("viene chiusa la transazione per il recupero degli aar su radd alternative")
    public void vieneDichiarataCompletataLaTransazionePerIlRecuperoDegliAar() {
        CompleteTransactionRequest completeTransactionRequest =
                new CompleteTransactionRequest()
                        .operationId(this.operationid)
                        .operationDate(dateTimeFormatter.format(OffsetDateTime.now()));
        this.completeTransactionResponse = raddAltClient.completeAorTransaction(this.uid, CxTypeAuthFleet.PG, idOrganization, completeTransactionRequest);
        log.info("completeTransactionResponse: {}", completeTransactionResponse);
    }

    @And("la chiusura delle transazione per il recupero degli aar non genera errori su radd alternative")
    public void laChiusuraDelleTransazionePerIlRecuperoDegliAarNonGeneraErrori() {
        Assertions.assertNotNull(this.completeTransactionResponse);
        Assertions.assertNotNull(this.completeTransactionResponse.getStatus());
        Assertions.assertEquals(TransactionResponseStatus.CodeEnum.NUMBER_0, this.completeTransactionResponse.getStatus().getCode());
    }

    @And("la chiusura delle transazione per il recupero degli aar ha generato l'errore {string} con statusCode {int} su radd alternative")
    public void laChiusuraDelleTransazionePerIlRecuperoDegliAarNonGeneraErrori(String error, int statusCode) {
        Assertions.assertNotNull(this.completeTransactionResponse);
        Assertions.assertNotNull(this.completeTransactionResponse.getStatus());
        Assertions.assertNotNull(this.completeTransactionResponse.getStatus().getCode());
        Assertions.assertEquals(new BigDecimal(statusCode), this.completeTransactionResponse.getStatus().getCode().getValue());
        Assertions.assertEquals(error, this.completeTransactionResponse.getStatus().getMessage());
    }


    @Given("vengono caricati i documento di identità del cittadino senza {string} su radd alternative ")
    public void vengonoCaricatiIDocumentoDiIdentitàDelCittadinoSenza(String without) {
        String sha256;
        try {
            sha256 = pnPaB2bUtils.computeSha256("");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }


        DocumentUploadRequest documentUploadRequest = new DocumentUploadRequest();
        documentUploadRequest = without.equalsIgnoreCase("contentType") ? documentUploadRequest : documentUploadRequest.checksum(sha256);

        try {

            DocumentUploadResponse documentUploadResponse = raddAltClient.documentUpload(CxTypeAuthFleet.PG, idOrganization,"1234556",documentUploadRequest);

            log.debug("DocumentUploadResponse: {}", documentUploadResponse);
        } catch (HttpStatusCodeException httpStatusCodeException) {
            log.debug("HttpStatusCodeException {}", httpStatusCodeException);
            this.documentUploadError = httpStatusCodeException;
        }
    }

    @Then("il caricamente ha prodotto une errore http {int} su radd alternative")
    public void ilCaricamenteHaProdottoUneErroreHttp(int httpError) {
        Assertions.assertNotNull(this.documentUploadError);
        Assertions.assertEquals(this.documentUploadError.getStatusCode().value(), httpError);
    }


    @Then("la transazione viene abortita per gli {string}")
    public void laTransazioneVieneAbortitaAor(String tipologia) {
        switch (tipologia.toLowerCase()) {
            case "aor":
                this.abortActTransaction = this.raddAltClient.abortAorTransaction(this.uid, CxTypeAuthFleet.PG, idOrganization,
                        new AbortTransactionRequest()
                                .operationId(this.operationid)
                                .operationDate(dateTimeFormatter.format(OffsetDateTime.now()))
                                .reason("TEST"));
                break;
            case "act":
                this.abortActTransaction = this.raddAltClient.abortActTransaction(this.uid, CxTypeAuthFleet.PG, idOrganization,
                        new AbortTransactionRequest()
                                .operationId(this.operationid)
                                .operationDate(dateTimeFormatter.format(OffsetDateTime.now()))
                                .reason("TEST"));
                break;
            default:
                throw new IllegalArgumentException();
        }
    }


    @And("l'operazione di abort genera un errore {string} con codice {int} su radd alternative")
    public void lOperazioneDiAbortGeneraUnErroreConCodice(String error, int statusCode) {
        Assertions.assertNotNull(this.abortActTransaction);
        Assertions.assertNotNull(this.abortActTransaction.getStatus());
        Assertions.assertNotNull(this.abortActTransaction.getStatus().getCode());
        Assertions.assertEquals(new BigDecimal(statusCode), this.abortActTransaction.getStatus().getCode().getValue());
        Assertions.assertEquals(error, this.abortActTransaction.getStatus().getMessage());
    }

    private void selectUserRaddAlternative(String cf) {
        switch (cf.toUpperCase()) {
            case "MARIO CUCUMBER" -> this.currentUserCf = sharedSteps.getMarioCucumberTaxID();
            case "MARIO GHERKIN" -> this.currentUserCf = sharedSteps.getMarioGherkinTaxID();
            case "CUCUMBERSPA" -> this.currentUserCf = sharedSteps.getCucumberSpataxId();
            case "SIGNOR CASUALE" ->
                    this.currentUserCf = sharedSteps.getSentNotification().getRecipients().get(0).getTaxId();
            case "GHERKIN IRREPERIBILE" -> this.currentUserCf = sharedSteps.getCucumberSpataxId();
            default -> this.currentUserCf = cf;
        }
    }

    @Given("Il cittadino {string} mostra il QRCode {string} su radd alternative")
    public void ilCittadinoMostraIlQRCodeAlternative(String cf, String qrCodeType) {
        selectUserRaddAlternative(cf);
        qrCodeType = qrCodeType.toLowerCase();
        switch (qrCodeType) {
            case "malformato" -> {
                vieneRichiestoIlCodiceQRPerLoIUN(sharedSteps.getSentNotification().getIun());
                this.qrCode = this.qrCode+"MALF";
            }
            case "inesistente" -> {
                vieneRichiestoIlCodiceQRPerLoIUN(sharedSteps.getSentNotification().getIun());
                char toReplace = this.qrCode.charAt(0);
                char replace = toReplace == 'B' ? 'C' : 'B';
                this.qrCode = this.qrCode.replace(toReplace,replace);
            }
            case "appartenente a terzo" -> {
                if(this.currentUserCf.equalsIgnoreCase(sharedSteps.getSentNotification().getRecipients().get(0).getTaxId())){
                    throw new IllegalArgumentException();
                }
                vieneRichiestoIlCodiceQRPerLoIUN(sharedSteps.getSentNotification().getIun());
            }
            case "corretto" -> {
                vieneRichiestoIlCodiceQRPerLoIUN(sharedSteps.getSentNotification().getIun());
            }
            case "dopo 120gg" -> {
                if(ambiente.equalsIgnoreCase("dev")){
                    vieneRichiestoIlCodiceQRPerLoIUN("");
                }else if(ambiente.equalsIgnoreCase("test")){
                    vieneRichiestoIlCodiceQRPerLoIUN("");
                }else if(ambiente.equalsIgnoreCase("uat")){
                    vieneRichiestoIlCodiceQRPerLoIUN("");
                }else if(ambiente.equalsIgnoreCase("hotfix")){
                    vieneRichiestoIlCodiceQRPerLoIUN("");
                }else{
                    throw new IllegalArgumentException();
                }

            }
            default -> throw new IllegalArgumentException();
        }
    }

    @Given("viene richiesto il codice QR per lo IUN {string} su radd alternative")
    public void vieneRichiestoIlCodiceQRPerLoIUN(String iun) {
        HashMap<String, String> quickAccessLink = externalServiceClient.getQuickAccessLink(iun);
        log.debug("quickAccessLink: {}",quickAccessLink.toString());
        this.qrCode = quickAccessLink.get(quickAccessLink.keySet().toArray()[0]);
        log.debug("qrCode: {}",qrCode);
    }
    @When("L'operatore scansione il qrCode per recuperare gli atti su radd alternative per il recipientType {string}")
    public void lOperatoreScansioneIlQrCodePerRecuperariGliAtti(String recipientType) {
        ActInquiryResponse actInquiryResponse = raddAltClient.actInquiry(CxTypeAuthFleet.PG, idOrganization, uid, this.currentUserCf, recipientType, qrCode, null);
        log.info("actInquiryResponse: {}",actInquiryResponse);
        this.actInquiryResponse = actInquiryResponse;
    }


    @Given("L'operatore esegue il download del frontespizio del operazione {string}")
    public void lOperatoreEsegueDownloadFrontespizio(String operationType) {
        byte[] download = raddAltClient.documentDownload(operationType.equalsIgnoreCase("aor")?"aor":
                        operationType.equalsIgnoreCase("act")?"act": null,
                this.operationid,
                CxTypeAuthFleet.PG,
                idOrganization);

    Assertions.assertNotNull(download);
    }


}
