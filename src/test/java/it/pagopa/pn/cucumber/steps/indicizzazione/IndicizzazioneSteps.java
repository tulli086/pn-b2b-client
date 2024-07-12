package it.pagopa.pn.cucumber.steps.indicizzazione;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsUpdateRequest;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class IndicizzazioneSteps {
    @Given("Viene popolato il database con un insieme di {string}")
    public void initDbWithFileWithoutTag(String fileNoTag) {
    }

    @When("Viene chiamata l'updateSingle passando come body {string}")
    public void callUpdateSingle(String updateSingleConSet) {
    }

    @Then("Vengono controllati i file {string} modificati")
    public void controllaOutput(String updateSingleConSet) {
    }

}
