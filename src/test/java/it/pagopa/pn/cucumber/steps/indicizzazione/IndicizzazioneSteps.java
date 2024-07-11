package it.pagopa.pn.cucumber.steps.indicizzazione;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsUpdateRequest;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class IndicizzazioneSteps {

    //TODO cambiare il value in tutti i campi

    //    @Value("${pn.external.senderId}")
    private Integer maxTagsPerRequest;

    //    @Value("${pn.external.senderId}")
    private Integer maxOperationsOnTagsPerRequest;

    //    @Value("${pn.external.senderId}")
    private Integer maxFileKeys;

    //    @Value("${pn.external.senderId}")
    private Integer maxMapValuesForSearch;

    //    @Value("${pn.external.senderId}")
    private Integer maxValuesPerTagDocument;

    //    @Value("${pn.external.senderId}")
    private Integer maxTagsPerDocument;

    //    @Value("${pn.external.senderId}")
    private Integer maxValuesPerTagPerRequest;


    @Given("Vengono impostate le configurazioni di default")
    public void setDefaultConfigurations() {
        //TODO come si inseriscono le configurazioni?

        this.maxTagsPerRequest = 50;
        this.maxOperationsOnTagsPerRequest = 50;
        this.maxFileKeys = 5;
        this.maxMapValuesForSearch = 1;
    }

    @And("Viene popolato il database con un insieme di \"FileNoTag\"")
    public void initDbWithFileWithoutTag() {
        //TODO chiamare client per creare file senza tag
    }

    @When("Viene chiamata l'updateSingle passando come body \"UpdateSingleConSet\"")
    public void callUpdateSingle(String fileKey, AdditionalFileTagsUpdateRequest request) {
        //TODO ClientImpl deve chiamare
    }

    @Then("Vengono controllati i file \"UpdateSingleConSet\" modificati")
    public void controllaOutput() {
        
    }

}
