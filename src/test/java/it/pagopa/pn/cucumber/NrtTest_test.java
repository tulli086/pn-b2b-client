package it.pagopa.pn.cucumber;


import org.junit.platform.suite.api.*;

import static io.cucumber.junit.platform.engine.Constants.*;

@Suite
@IncludeEngines("cucumber")
@SelectClasspathResource("it/pagopa/pn/cucumber")
@ConfigurationParameters({
        @ConfigurationParameter(key = PLUGIN_PROPERTY_NAME, value = "pretty"),
        @ConfigurationParameter(key = PLUGIN_PROPERTY_NAME, value = "json:target/cucumber-report.json," +
                "html:target/cucumber-report.html"),
        @ConfigurationParameter(key = GLUE_PROPERTY_NAME, value = "it.pagopa.pn.cucumber.steps"),
        @ConfigurationParameter(key = EXECUTION_MODE_FEATURE_PROPERTY_NAME, value = "concurrent"),
})
@ExcludeTags({"ignore","uat","appIo", "integration","realNR","mockNormalizzatore","giacenza890Complex","raddAlternativeCsv"})
@IncludeTags({"workflowDigitale", "workflowAnalogico", "pagamentiMultipli","giacenza890Simplified",
            "Async", "f24", "version","AOO_UO", "Annullamento",
            "validation", "RetentionAllegati", "apiKeyManager", "downtimeLogs",
            "legalFact", "letturaDestinatario", "raddAnagrafica", "raddAttoIntero", "restApiValidation"}) //TMP EXCLUDED: ,"partitaIva","raddAlt"
public class NrtTest_test {
}
