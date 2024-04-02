package it.pagopa.pn.cucumber.steps.pa;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.cucumber.java.After;
import io.cucumber.java.DataTableType;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.service.impl.PnExternalServiceClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnRaddAlternativeClientImpl;
import it.pagopa.pn.client.b2b.pa.service.utils.SettableAuthTokenRadd;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model.*;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCRUD.CreateRegistryRequest;
import it.pagopa.pn.cucumber.steps.DataTableTypeUtil;
import it.pagopa.pn.cucumber.steps.SharedSteps;
import it.pagopa.pn.cucumber.steps.dataTable.DataTableTypeRaddAlt;
import it.pagopa.pn.cucumber.utils.Compress;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.InputStreamSource;
import org.springframework.web.client.HttpStatusCodeException;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URI;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import static it.pagopa.pn.cucumber.utils.FiscalCodeGenerator.generateCF;
import static it.pagopa.pn.cucumber.utils.NotificationValue.generateRandomNumber;


@Slf4j
public class AnagraficaRaddAltSteps {

    private final PnRaddAlternativeClientImpl raddAltClient;
    private final PnExternalServiceClientImpl externalServiceClient;
    private final SharedSteps sharedSteps;
    private final PnPaB2bUtils pnPaB2bUtils;
    private final RaddAltSteps raddAltSteps;
    private final DataTableTypeRaddAlt dataTableTypeRaddAlt;

    private String fileCsv;
    private String requestid;
    private String uid = "1234556";
    private final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");


    @Autowired
    public AnagraficaRaddAltSteps(PnRaddAlternativeClientImpl raddAltClient, PnExternalServiceClientImpl externalServiceClient,
                                  PnPaB2bUtils pnPaB2bUtils, SharedSteps sharedSteps,RaddAltSteps raddAltSteps,DataTableTypeRaddAlt dataTableTypeRaddAlt) {
        this.raddAltClient = raddAltClient;
        this.externalServiceClient = externalServiceClient;
        this.sharedSteps = sharedSteps;
        this.pnPaB2bUtils = pnPaB2bUtils;
        this.raddAltSteps=raddAltSteps;
        this.dataTableTypeRaddAlt=dataTableTypeRaddAlt;
    }

@When("viene generato il csv con dati:")
    public void vieneGeneratoIlCsv(Map<String, String> dataCsv){




}

    @When("viene generato uno sportello Radd con dati:")
    public void vieneGeneratoSportelloRadd(Map<String, String> dataSportello){

        CreateRegistryRequest sportello= dataTableTypeRaddAlt.convertRegistryRequestData(dataSportello);

    }

}
