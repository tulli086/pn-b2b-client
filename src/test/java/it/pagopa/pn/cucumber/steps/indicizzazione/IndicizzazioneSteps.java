package it.pagopa.pn.cucumber.steps.indicizzazione;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.service.PnIndicizzazioneSafeStorageClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsGetResponse;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsUpdateRequest;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.web.client.HttpClientErrorException;

import java.io.File;
import java.util.Map;

@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@Slf4j
public class IndicizzazioneSteps {
    private final PnIndicizzazioneSafeStorageClient pnIndicizzazioneSafeStorageClient;

    private static final String JSON_PATH = "src/main/resources/test_indicizzazione/";

    @Autowired
    public IndicizzazioneSteps(PnIndicizzazioneSafeStorageClient pnIndicizzazioneSafeStorageClient) {
        this.pnIndicizzazioneSafeStorageClient = pnIndicizzazioneSafeStorageClient;
    }

    @Given("Viene popolato il database")
    public void initDbWithFileWithoutTag(DataTable dataTable) {
        //TODO utilizzare la create non appena disponibile in modo da inizializzare il DB
        Map<String, String> data = dataTable.asMap(String.class, String.class);
        String dbData = data.get("dbData");
        pnIndicizzazioneSafeStorageClient.createFileWithTags();
        System.out.println(dbData);
    }

    @When("Viene chiamato l'updateSingle")
    public void callUpdateSingle(DataTable dataTable) {
        Map<String, String> data = dataTable.asMap(String.class, String.class);
        String requestName = data.get("requestName");
        String fileKeyName = data.get("fileKeyName");
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            AdditionalFileTagsUpdateRequest request =
                    objectMapper.readValue(new File(JSON_PATH + requestName), AdditionalFileTagsUpdateRequest.class);
            pnIndicizzazioneSafeStorageClient.updateSingleWithTags(fileKeyName, request);
        } catch (Exception e) {
            //TODO
        }
    }

    @Then("La response coincide con l'output previsto")
    public void controllaOutput(DataTable dataTable) {
        Map<String, String> data = dataTable.asMap(String.class, String.class);
        String expectedOutput = data.get("expectedOutput");
        String fileKeyName = data.get("fileKeyName");
        ObjectMapper objectMapper = new ObjectMapper();
        AdditionalFileTagsGetResponse response = pnIndicizzazioneSafeStorageClient.getTagsByFileKey(fileKeyName);
        try {
            AdditionalFileTagsGetResponse expectedResponse =
                    objectMapper.readValue(new File(JSON_PATH + expectedOutput), AdditionalFileTagsGetResponse.class);
            Assertions.assertEquals(expectedResponse, response);
        } catch (Exception e) {
            //TODO
        }
    }

    @When("L'utente chiama l'endpoint senza essere autorizzato ad accedervi")
    public void utenteNonAutorizzato() {
        //TODO: disattivare l'autorizzazione dell'utente
    }

    @Then("La chiamata restituisce 403")
    public void chiamataEndpoint(DataTable dataTable) {
        Map<String, String> data = dataTable.asMap(String.class, String.class);

        //TODO: modificare il controllo il base alla risposta effettiva
        switch (data.get("endpoint")) {
            case "getFileWithTagsByFileKey" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
                    pnIndicizzazioneSafeStorageClient.getFileWithTagsByFileKey());
            case "createFileWithTags" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
                    pnIndicizzazioneSafeStorageClient.createFileWithTags());
            case "updateSingleWithTags" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
                    pnIndicizzazioneSafeStorageClient.updateSingleWithTags(
                            "test", new AdditionalFileTagsUpdateRequest()));
            case "updateMassiveWithTags" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
                    pnIndicizzazioneSafeStorageClient.updateMassiveWithTags());
            case "getTagsByFileKey" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
                    pnIndicizzazioneSafeStorageClient.getTagsByFileKey("test"));
            case "searchFileKeyWithTags" -> Assertions.assertThrows(HttpClientErrorException.class, () ->
                    pnIndicizzazioneSafeStorageClient.searchFileKeyWithTags());
            default -> Assertions.fail("Endpoint non riconosciuto");
        }

    }
}
