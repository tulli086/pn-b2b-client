package it.pagopa.pn.cucumber.steps.microservice;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.service.IPnSafeStoragePrivateClient;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.AdditionalFileTagsUpdateRequest;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.FileCreationRequest;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.FileCreationResponse;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.client.HttpClientErrorException;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@Slf4j
public class SafeStorageSteps {

    private final IPnSafeStoragePrivateClient safeStorageClient;
    private final PnPaB2bUtils b2bUtils;
    private String sha256;

    @Autowired
    public SafeStorageSteps(IPnSafeStoragePrivateClient safeStorageClient, PnPaB2bUtils b2bUtils) {
        this.safeStorageClient = safeStorageClient;
        this.b2bUtils = b2bUtils;
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
        System.out.println("FILEKEY: " + fileKey);
    }

    @When("L'utente chiama l'endpoint senza essere autorizzato ad accedervi")
    public void utenteNonAutorizzato() {
        safeStorageClient.setApiKey("api-key-non-autorizzata");
    }

    @Then("La chiamata restituisce 403")
    public void chiamataEndpoint(DataTable dataTable) {
        Map<String, String> data = dataTable.asMap(String.class, String.class);
        switch (data.get("endpoint")) {
//            case "getFileWithTagsByFileKey" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
//                    safeStorageClient.getFile("test", true, true));
//            case "createFileWithTags" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
//                    safeStorageClient.createFile(null));
            case "updateSingleWithTags" -> {
                String errorMessage = Assertions.assertThrows(HttpClientErrorException.class, () ->
                        safeStorageClient.additionalFileTagsUpdate("test", new AdditionalFileTagsUpdateRequest())).getStatusText();
                Assertions.assertEquals("forbidden", errorMessage.toLowerCase());
            }
//            case "updateMassiveWithTags" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
//                    safeStorageClient.());
            case "getTagsByFileKey" -> {
                String errorMessage = Assertions.assertThrows(HttpClientErrorException.class, () ->
                        safeStorageClient.additionalFileTagsGet("test")).getStatusText();
                Assertions.assertEquals("forbidden", errorMessage.toLowerCase());
            }
            case "searchFileKeyWithTags" -> {
                String errorMessage = Assertions.assertThrows(HttpClientErrorException.class, () ->
                        safeStorageClient.additionalFileTagsSearch("", true)).getStatusText();
                Assertions.assertEquals("forbidden", errorMessage.toLowerCase());
            }
            default -> Assertions.fail("Endpoint non riconosciuto");
        }
    }

    private AdditionalFileTagsUpdateRequest createRequest(String requestType) {
        AdditionalFileTagsUpdateRequest request = new AdditionalFileTagsUpdateRequest();
        List<String> setOperations = new LinkedList<>();
        List<String> deleteOperations = new LinkedList<>();
        switch (requestType) {
            case "ONLY_SET_OPERATIONS" -> {
                setOperations.addAll(List.of("test1", "test2", "test3"));
                request.putSETItem("TODO", setOperations);
            }
            case "ONLY_DELETE_OPERATIONS" -> {
                deleteOperations.addAll(List.of("test1", "test2", "test3"));
                request.putDELETEItem("TODO", setOperations);
            }
            case "SET_AND_DELETE_OPERATIONS" -> {
                setOperations.addAll(List.of("test1", "test2", "test3"));
                deleteOperations.addAll(List.of("test1", "test2", "test3"));
                request.putSETItem("TODO1", setOperations);
                request.putDELETEItem("TODO2", setOperations);
            }
            case "SET_AND_DELETE_ON_SAME_TAG" -> {
                setOperations.addAll(List.of("test1", "test2", "test3"));
                deleteOperations.addAll(List.of("test1", "test2", "test3"));
                request.putSETItem("TODO", setOperations);
                request.putDELETEItem("TODO", setOperations);
            }
        }
        return request;
    }
}
