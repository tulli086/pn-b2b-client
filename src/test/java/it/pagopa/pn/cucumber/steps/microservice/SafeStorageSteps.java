package it.pagopa.pn.cucumber.steps.microservice;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.service.IPnSafeStoragePrivateClient;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.AdditionalFileTagsUpdateRequest;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.AdditionalFileTagsUpdateResponse;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.FileCreationRequest;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.FileCreationResponse;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.beans.factory.annotation.Value;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.List;
import java.util.Map;

@Slf4j
public class SafeStorageSteps {

    private final IPnSafeStoragePrivateClient safeStorageClient;
    private final PnPaB2bUtils b2bUtils;
    private String sha256;
    private List<FileCreationResponse> createdFiles;
    private AdditionalFileTagsUpdateRequest updateRequest;
    private ResponseEntity<AdditionalFileTagsUpdateResponse> updateResponseEntity;

    private final List<String> tagsName;

    @Autowired
    public SafeStorageSteps(IPnSafeStoragePrivateClient safeStorageClient,
                            PnPaB2bUtils b2bUtils,
                            @Value("${pn.safeStorage.tagsName}") List<String> tagsName) {
        this.safeStorageClient = safeStorageClient;
        this.b2bUtils = b2bUtils;
        this.tagsName = tagsName;

        createdFiles = new ArrayList<>();
    }

    private String computeSha(String resourceName) {
        try {
            this.sha256 = this.b2bUtils.computeSha256(resourceName);
            return this.sha256;
        } catch (IOException e) {
            throw new IllegalStateException(e.getMessage() + " NON è stato possibile computare lo sha");
        }
    }

    @And("Viene caricato un nuovo documento")
    public void uploadNewDocument() {
        System.out.println("TODO");
    }

    private String getFileByType(String type) {
        return switch (type) {
            case "PDF" -> "classpath:/multa.pdf";
            case "JSON" -> "classpath:/f24_flat.json";
            default -> "classpath:/multa.pdf";
        };
    }

    @Given("Vengono caricati {int} nuovi documenti pdf")
    public void uploadNewPdfDocument(Integer times) {
        for (int i = 0; i < times; i++) {
            uploadNewDocumentWithDocumentType("PDF");
        }
    }

    @Given("Viene caricato un nuovo documento pdf")
    public void uploadNewPdfDocument() {
        uploadNewDocumentWithDocumentType("PDF");
    }

    @Given("Viene caricato un nuovo documento {string}")
    public void uploadNewDocumentWithDocumentType(String fileType) {
        String resourcePath = getFileByType(fileType);
        String sha256 = computeSha(resourcePath);

        FileCreationRequest request = new FileCreationRequest();
        request.setContentType("application/pdf");
        request.setStatus("SAVED");
        request.setDocumentType("PN_NOTIFICATION_ATTACHMENTS");

        FileCreationResponse fileCreationResponse = this.safeStorageClient.createFile(request);

        String fileKey = fileCreationResponse.getKey();
        String secret = fileCreationResponse.getSecret();
        String url = fileCreationResponse.getUploadUrl();

        this.b2bUtils.loadToPresigned(url, secret, sha256, resourcePath);
        log.info("FILEKEY: " + fileKey);

        this.createdFiles.add(fileCreationResponse);
    }

    //TODO fare metodo separato per caricare il file tramite presigned url
//    private void loadToPresignedUrl(String url, String secret, String sha256, )

    @When("L'utente chiama l'endpoint senza essere autorizzato ad accedervi")
    public void utenteNonAutorizzato() {
        safeStorageClient.setApiKey("api-key-non-autorizzata");
    }

    @Then("La chiamata restituisce 403")
    public void chiamataEndpoint(DataTable dataTable) {
        Map<String, String> data = dataTable.asMap(String.class, String.class);

        //TODO: modificare il controllo il base alla risposta effettiva, dobbiamo utilizzare il resultCode?
        switch (data.get("endpoint")) {
            case "getFileWithTagsByFileKey" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
                    safeStorageClient.getFile("test", true, true));
            case "createFileWithTags" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
                    safeStorageClient.createFile(new FileCreationRequest()));
            case "updateSingleWithTags" -> {
                String errorMessage = Assertions.assertThrows(HttpClientErrorException.class, () ->
                        safeStorageClient.additionalFileTagsUpdate("test", new AdditionalFileTagsUpdateRequest())).getStatusText();
                Assertions.assertEquals("forbidden", errorMessage.toLowerCase());
            }
//            case "updateMassiveWithTags" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
//                    safeStorageClient.updateMassiveWithTags());
            case "getTagsByFileKey" -> {
                String errorMessage = Assertions.assertThrows(HttpClientErrorException.class, () ->
                        safeStorageClient.additionalFileTagsGet("test")).getStatusText();
                Assertions.assertEquals("forbidden", errorMessage.toLowerCase());
            }
            case "searchFileKeyWithTags" -> {
                String errorMessage = Assertions.assertThrows(HttpClientErrorException.class, () ->
                        safeStorageClient.additionalFileTagsSearch("test-id", true)).getStatusText();
                Assertions.assertEquals("forbidden", errorMessage.toLowerCase());
            }
            default -> Assertions.fail("Endpoint non riconosciuto");
        }
    }

    @When("lo si prova a modificare passando una request che presenta elementi con operazioni SET e DELETE sullo stesso tag")
    public void createRequestWithSameAndDeleteOnSameTag() {
        AdditionalFileTagsUpdateRequest request = new AdditionalFileTagsUpdateRequest();
        request.putSETItem("TODOtag", List.of("test1", "test2", "test3"));
        request.putDELETEItem("TODOtag", List.of("test1", "test2", "test3"));
        this.updateRequest = request;
    }

    @When("lo si prova a modificare associandogli nella request uno o più tag che sono già associati al numero massimo di file key consentite")
    public void createRequestWithMaxFileKeys() {
        AdditionalFileTagsUpdateRequest request = new AdditionalFileTagsUpdateRequest();
        //TODO
        this.updateRequest = request;
    }

    @When("lo si prova a modificare passando una request che contiene un numero di operazioni su uno stesso tag superiore al limite consentito")
    public void createRequestWithMaxOperationsOnTag() {
        AdditionalFileTagsUpdateRequest request = new AdditionalFileTagsUpdateRequest();
        //TODO
        this.updateRequest = request;
    }

    @When("lo si prova a modificare passando una request che contiene uno o più tag con valori associati in numero superiore al limite consentito")
    public void createRequestMaxValuesPerTagDocument() {
        AdditionalFileTagsUpdateRequest request = new AdditionalFileTagsUpdateRequest();
        //TODO
        this.updateRequest = request;
    }

    @And("viene invocato l'update passando il suddetto bodyRequest")
    public void callUpdateWithRequestBody() {
        this.updateResponseEntity = this.safeStorageClient.additionalFileTagsUpdateWithHttpInfo(
                "TODOfileKey", "pn-test", updateRequest);
    }

    @Then("la chiamata genera un errore con status code {int}")
    public void checkForStatusCode(Integer statusCode) {
        Assertions.assertEquals(this.updateResponseEntity.getStatusCodeValue(), statusCode);
    }

    public AdditionalFileTagsUpdateRequest createUpdateRequest(Map<String, String> specificationsMap) {
        AdditionalFileTagsUpdateRequest request = new AdditionalFileTagsUpdateRequest();
        return request;
    }

}
