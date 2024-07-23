package it.pagopa.pn.cucumber.steps.microservice;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.After;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.service.IPnSafeStoragePrivateClient;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.*;
import it.pagopa.pn.cucumber.utils.IndicizzazioneStepsPojo;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.client.HttpClientErrorException;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Slf4j
public class SafeStorageSteps {

    private final IPnSafeStoragePrivateClient safeStorageClient;
    private final PnPaB2bUtils b2bUtils;
    private IndicizzazioneStepsPojo indicizzazioneStepsPojo;

    @Autowired
    public SafeStorageSteps(IPnSafeStoragePrivateClient safeStorageClient, PnPaB2bUtils b2bUtils) {
        this.safeStorageClient = safeStorageClient;
        this.b2bUtils = b2bUtils;
        this.indicizzazioneStepsPojo = new IndicizzazioneStepsPojo();
    }

    private String computeSha(String resourceName) {
        try {
            this.indicizzazioneStepsPojo.setSha256(this.b2bUtils.computeSha256(resourceName));
            return this.indicizzazioneStepsPojo.getSha256();
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

        FileCreationResponse fileCreationResponse = this.safeStorageClient.createFile(sha256, "SHA256", request);

        loadToPresignedUrl(fileCreationResponse, sha256, resourcePath);
    }

    private void loadToPresignedUrl(FileCreationResponse fileCreationResponse, String sha256, String resourcePath) {
        String fileKey = fileCreationResponse.getKey();
        String secret = fileCreationResponse.getSecret();
        String url = fileCreationResponse.getUploadUrl();

        this.b2bUtils.loadToPresigned(url, secret, sha256, resourcePath);
        log.info("FILEKEY: " + fileKey);

        this.indicizzazioneStepsPojo.getCreatedFiles().add(fileCreationResponse);
        log.info("File successfully create");
    }

    @When("L'utente tenta di effettuare l'operazione {string} senza essere autorizzato ad accedervi")
    public void utenteNonAutorizzato(String operation) {
        String wrongApiKey = "api-key-non-autorizzata";
        try {
            switch (operation) {
                case "CREATE_FILE" -> this.safeStorageClient.createFileWithHttpInfo(
                        wrongApiKey, "", "", new FileCreationRequest());
                case "GET_FILE" -> this.safeStorageClient.getFileWithHttpInfo(
                        "test", wrongApiKey, true, true);
                case "UPDATE_SINGLE" -> this.safeStorageClient.additionalFileTagsUpdateWithHttpInfo(
                        "test", wrongApiKey, new AdditionalFileTagsUpdateRequest());
                case "UPDATE_MASSIVE" -> this.safeStorageClient.additionalFileTagsMassiveUpdateWithHttpInfo(wrongApiKey,
                        new AdditionalFileTagsMassiveUpdateRequest());
                case "GET_TAGS" -> this.safeStorageClient.additionalFileTagsGetWithHttpInfo(
                        "PN_NOTIFICATION_ATTACHMENTS-eabd62ef59444526beeab293b2255ace.pdf", wrongApiKey);
                case "SEARCH_FILE" -> this.safeStorageClient.additionalFileTagsSearchWithHttpInfo(
                        wrongApiKey, "AND", true);
            }
        } catch (HttpClientErrorException httpExc) {
            this.indicizzazioneStepsPojo.setHttpException(httpExc);
        }
    }

    @Then("La chiamata genera un errore con status code {int}")
    public void checkForStatusCode(Integer statusCode) {
        Assertions.assertNotNull(this.indicizzazioneStepsPojo.getHttpException());
        Assertions.assertEquals(this.indicizzazioneStepsPojo.getHttpException().getRawStatusCode(), statusCode);
    }

    @And("Il messaggio di errore riporta la dicitura {string}")
    public void checkForStatusCode(String errorMessage) {
        Assertions.assertNotNull(this.indicizzazioneStepsPojo.getHttpException());
        Assertions.assertTrue(this.indicizzazioneStepsPojo.getHttpException().getMessage().contains(errorMessage));
    }


    @When("Si modifica il documento {int} secondo le seguenti operazioni")
    public void updateDocument(Integer documentIndex, DataTable dataTable) {
        Assertions.assertTrue(documentIndex <= this.indicizzazioneStepsPojo.getCreatedFiles().size());
        Map<String, String> data = dataTable.asMap(String.class, String.class);
        String fileKey = this.indicizzazioneStepsPojo.getCreatedFiles().get(documentIndex - 1).getKey();
        try {
            this.indicizzazioneStepsPojo.setUpdateResponseEntity(safeStorageClient.additionalFileTagsUpdateWithHttpInfo(
                    fileKey, "pn-test", createUpdateRequest(data)));
        } catch (HttpClientErrorException e) {
            log.info("Errore durante l'aggiornamento del documento: {}", e.getMessage());
            this.indicizzazioneStepsPojo.setHttpException(e);
        }
    }

    @When("Si modificano i documenti secondo le seguenti operazioni")
    public void updateDocuments(DataTable dataTable) {
        List<Map<String, String>> data = dataTable.asMaps(String.class, String.class);
        try {
            safeStorageClient.additionalFileTagsMassiveUpdate(createMassiveRequest(data));
        } catch (HttpClientErrorException e) {
            log.info("Errore durante l'aggiornamento del documento: {}", e.getMessage());
            this.indicizzazioneStepsPojo.setHttpException(e);
        }
    }

    private AdditionalFileTagsMassiveUpdateRequest createMassiveRequest(List<Map<String, String>> data) {
        AdditionalFileTagsMassiveUpdateRequest request = new AdditionalFileTagsMassiveUpdateRequest();
        Tags tags = new Tags();
        List<Tags> tagsList = data.stream()
                .map(d -> populateTag(tags, d.get("tag"), Integer.parseInt(d.get("documentIndex")), d.get("operation")))
                .toList();
        request.setTags(tagsList);
        return request;
    }

    private Tags populateTag(Tags tags, String tag, Integer documentIndex, String operation) {
        Assertions.assertTrue(documentIndex > 0 && documentIndex <= indicizzazioneStepsPojo.getCreatedFiles().size());
        tags.setFileKey(this.indicizzazioneStepsPojo.getCreatedFiles().get(documentIndex - 1).getKey());
        String[] splittedTags = tag.split(":");
        String tagName = splittedTags[0];
        List<String> tagValues = Arrays.stream(splittedTags[1].split(",")).toList();
        if (operation.equals("SET")) {
            tags.putSETItem(tagName, tagValues);
        } else if (operation.equals("DELETE")) {
            tags.putDELETEItem(tagName, tagValues);
        }
        return tags;
    }

    @And("I primi {int} documenti vengono modificati secondo le seguenti operazioni")
    public void updateNDocuments(Integer documentIndex, DataTable dataTable) {
        Assertions.assertTrue(documentIndex <= this.indicizzazioneStepsPojo.getCreatedFiles().size());
        for (int i = 1; i <= documentIndex; i++) {
            updateDocument(i, dataTable);
        }
    }

    @Then("Il documento {int} è stato correttamente modificato con la seguente lista di tag")
    public void checkDocument(Integer documentIndex, DataTable dataTable) {
        Assertions.assertNotNull(dataTable);
        Map<String, List<String>> tagMap = retrieveDocumentTags(documentIndex);
        List<String> expectedTags = dataTable.asList();

        assert tagMap != null;
        Assertions.assertEquals(expectedTags.size(), tagMap.size());

        expectedTags.forEach(tag -> {
            String[] splittedTags = tag.split(":");
            String tagName = splittedTags[0];
            List<String> tagValues = Arrays.stream(splittedTags[1].split(",")).toList();

            Assertions.assertTrue(tagMap.containsKey(tagName));
            Assertions.assertTrue(tagValues.size() == tagMap.get(tagName).size());
            tagValues.forEach(t -> Assertions.assertTrue(tagMap.get(tagName).contains(t)));
        });
    }

    @Then("Il documento è stato correttamente modificato con la seguente lista di tag")
    public void checkDocument(DataTable dataTable) {
        checkDocument(0, dataTable);
    }

//    @Then("Il documento {int} è stato correttamente modificato con la seguente lista di tag")
//    public void checkDocument(DataTable dataTable) {
////        Assertions.assertNotNull(dataTable);
//
//        Map<String, List<String>> tagMap = safeStorageClient.additionalFileTagsGet(
//                this.indicizzazioneStepsPojo.getCreatedFiles().get(0).getKey()).getTags();
//        List<String> expectedTags = dataTable.asList();
//
//        assert tagMap != null;
//        Assertions.assertEquals(expectedTags.size(), tagMap.size());
//
//        expectedTags.forEach(tag -> {
//            String[] splittedTags = tag.split(":");
//            String tagName = splittedTags[0];
//            List<String> tagValues = Arrays.stream(splittedTags[1].split(",")).toList();
//
//            Assertions.assertTrue(tagMap.containsKey(tagName));
//            Assertions.assertTrue(tagValues.size() == tagMap.get(tagName).size());
//            tagValues.forEach(t -> Assertions.assertTrue(tagMap.get(tagName).contains(t)));
//        });
//    }
//
//    @Then("Il documento è stato correttamente modificato con la seguente lista di tag")
//    public void checkDocument(DataTable dataTable) {
//        checkDocument(0, dataTable);
//    }

    @When("Si effettua una ricerca passando {int} filtri di ricerca")
    public void setSearchFilters(Integer numberOfFilters) {

    }

    @Then("Il documento {int} non contiene la seguente lista di tag")
    public void checkTagsNotPresent(Integer documentIndex, DataTable dataTable) {
        Assertions.assertNotNull(dataTable);
        Map<String, List<String>> tagMap = retrieveDocumentTags(documentIndex);
        List<String> expectedTags = dataTable.asList();

        expectedTags.forEach(tag -> {
            String[] splittedTags = tag.split(":");
            String tagName = splittedTags[0];
            List<String> tagValues = Arrays.stream(splittedTags[1].split(",")).toList();
            if (tagMap.containsKey(tagName)) {
                Assertions.assertNotEquals(tagValues, tagMap.get(tagName));
            }
        });
    }

    private AdditionalFileTagsUpdateRequest createUpdateRequest(
            Map<String, String> specificationsMap) {
        AdditionalFileTagsUpdateRequest request = new AdditionalFileTagsUpdateRequest();
        specificationsMap.forEach((tag, operation) -> {
            String[] splittedTags = tag.split(":");
            String tagName = splittedTags[0];
            List<String> tagValues = Arrays.stream(splittedTags[1].split(",")).toList();

            if (operation.equals("SET")) {
                request.putSETItem(tagName, tagValues);
            } else if (operation.equals("DELETE")) {
                request.putDELETEItem(tagName, tagValues);
            }
        });
        return request;
    }

    private Map<String, List<String>> retrieveDocumentTags(Integer documentIndex) {
        return safeStorageClient.additionalFileTagsGet(indicizzazioneStepsPojo.getCreatedFiles().get(documentIndex).getKey()).getTags();
    }

    @After("@aggiuntaTag")
    public void cleanDocuments() {
        this.indicizzazioneStepsPojo.getCreatedFiles().forEach(file -> {

            AdditionalFileTagsUpdateRequest request = new AdditionalFileTagsUpdateRequest();
            Map<String, List<String>> tagMap = safeStorageClient.additionalFileTagsGet(file.getKey()).getTags();

            log.info("PRE-CANCELLAZIONE: " + tagMap.toString());
            if (!(tagMap == null) && !tagMap.isEmpty()) {
                request.DELETE(tagMap);
                safeStorageClient.additionalFileTagsUpdate(file.getKey(), request);

                log.info("POST-CANCELLAZIONE");
            }
        });
    }


}
