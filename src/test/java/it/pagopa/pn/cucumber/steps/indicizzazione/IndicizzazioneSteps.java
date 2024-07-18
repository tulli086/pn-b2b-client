package it.pagopa.pn.cucumber.steps.indicizzazione;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.service.PnIndicizzazioneSafeStorageClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.*;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.web.client.HttpClientErrorException;

import java.io.File;
import java.io.IOException;
import java.util.Map;

@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@Slf4j
public class IndicizzazioneSteps {
    private static final String JSON_PATH = "src/main/resources/test_indicizzazione/";
    private static final String TEST_FILE_KEY_NAME = "test_file_key";
    private final PnIndicizzazioneSafeStorageClient pnIndicizzazioneSafeStorageClient;
    private AdditionalFileTagsUpdateResponse updateSingleResponse;

    @Autowired
    public IndicizzazioneSteps(PnIndicizzazioneSafeStorageClient pnIndicizzazioneSafeStorageClient) {
        this.pnIndicizzazioneSafeStorageClient = pnIndicizzazioneSafeStorageClient;
    }

    @Given("Viene caricato un nuovo documento")
    public void initDbWithFileWithoutTag() {
        //TODO utilizzare la create non appena disponibile in modo da inizializzare il DB
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            FileCreationRequest request =
                    objectMapper.readValue(new File(JSON_PATH + "request/UPLOAD_DOCUMENT.json"), FileCreationRequest.class);
            FileCreationResponse response = pnIndicizzazioneSafeStorageClient.createFile(request);
            System.out.println(response);
            String uploadUrl = response.getUploadUrl();
        } catch (IOException e) {
            //TODO
        }
    }

    @When("Viene chiamato l'updateSingle")
    public void callUpdateSingle(DataTable dataTable) {
        Map<String, String> data = dataTable.asMap(String.class, String.class);
        String requestName = data.get("requestName");
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            AdditionalFileTagsUpdateRequest request =
                    objectMapper.readValue(new File(JSON_PATH + requestName), AdditionalFileTagsUpdateRequest.class);
            updateSingleResponse = pnIndicizzazioneSafeStorageClient.updateSingleWithTags(TEST_FILE_KEY_NAME, request);
            updateSingleResponse = new AdditionalFileTagsUpdateResponse();//TODO MATTEO eliminare, solo per testare la valorizzazione
        } catch (IOException e) {
            //TODO
        }
    }

    @Then("I file del database coincidono con quelli attesi")
    public void controllaDatabase(DataTable dataTable) {
        Map<String, String> data = dataTable.asMap(String.class, String.class);
        String expectedOutput = data.get("expectedOutput");
        ObjectMapper objectMapper = new ObjectMapper();
        AdditionalFileTagsGetResponse response = pnIndicizzazioneSafeStorageClient.getTagsByFileKey(TEST_FILE_KEY_NAME);
        try {
            AdditionalFileTagsGetResponse expectedResponse = objectMapper.readValue(
                    new File(JSON_PATH + expectedOutput), AdditionalFileTagsGetResponse.class);
            Assertions.assertEquals(expectedResponse, response);
        } catch (IOException e) {
            //TODO
        }

    }

    @When("L'utente chiama l'endpoint senza essere autorizzato ad accedervi")
    public void utenteNonAutorizzato() {
        pnIndicizzazioneSafeStorageClient.setApiKey("api-key-non-autorizzata");
    }

    @Then("La chiamata restituisce 403")
    public void chiamataEndpoint(DataTable dataTable) {
        Map<String, String> data = dataTable.asMap(String.class, String.class);

        //TODO: modificare il controllo il base alla risposta effettiva, dobbiamo utilizzare il resultCode?
        switch (data.get("endpoint")) {
            case "getFileWithTagsByFileKey" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
                    pnIndicizzazioneSafeStorageClient.getFileWithTagsByFileKey());
            case "createFileWithTags" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
                    pnIndicizzazioneSafeStorageClient.createFileWithTags());
            case "updateSingleWithTags" -> {
                String errorMessage = Assertions.assertThrows(HttpClientErrorException.class, () ->
                        pnIndicizzazioneSafeStorageClient.updateSingleWithTags(
                                TEST_FILE_KEY_NAME, new AdditionalFileTagsUpdateRequest())).getStatusText();
                Assertions.assertEquals("forbidden", errorMessage.toLowerCase());
            }
            case "updateMassiveWithTags" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
                    pnIndicizzazioneSafeStorageClient.updateMassiveWithTags());
            case "getTagsByFileKey" -> {
                String errorMessage = Assertions.assertThrows(HttpClientErrorException.class, () ->
                        pnIndicizzazioneSafeStorageClient.getTagsByFileKey(TEST_FILE_KEY_NAME)).getStatusText();
                Assertions.assertEquals("forbidden", errorMessage.toLowerCase());
            }
            case "searchFileKeyWithTags" -> {
                String errorMessage = Assertions.assertThrows(HttpClientErrorException.class, () ->
                        pnIndicizzazioneSafeStorageClient.searchFileKeyWithTags("test-id", "", true))
                    .getStatusText();
                Assertions.assertEquals("forbidden", errorMessage.toLowerCase());
            }
            default -> Assertions.fail("Endpoint non riconosciuto");
        }
    }

    @Then("La response dell'updateSingle coincide con il response code previsto")
    public void responseCheck(DataTable dataTable) {
        Map<String, String> data = dataTable.asMap(String.class, String.class);
        Assertions.assertEquals(data.get("expectedOutput"), updateSingleResponse.getResultCode());
    }

    @Then("La richiesta va in errore {string} con il messaggio")
    public void get400ErrorMessage(DataTable dataTable, String errorCode) {
        Map<String, String> data = dataTable.asMap(String.class, String.class);
        String errorMessage = data.get("errorMessage");
        Assertions.assertEquals(errorCode, updateSingleResponse.getResultCode());
        switch (errorMessage) {
            case "MaxFileKeys" -> Assertions.assertEquals("TODO", updateSingleResponse.getResultDescription());
            case "MaxOperationsOnTagsPerRequest" ->
                    Assertions.assertEquals("TODO", updateSingleResponse.getResultDescription());
            case "MaxValuesPerTagDocument" ->
                    Assertions.assertEquals("TODO", updateSingleResponse.getResultDescription());
            case "MaxTagsPerDocument" -> Assertions.assertEquals("TODO", updateSingleResponse.getResultDescription());
            case "MaxValuesPerTagPerRequest" ->
                    Assertions.assertEquals("TODO", updateSingleResponse.getResultDescription());
        }
    }
}
