package it.pagopa.pn.cucumber.steps.pa;

import com.opencsv.CSVWriter;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.service.impl.PnExternalServiceClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnRaddAlternativeClientImpl;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCRUD.CreateRegistryRequest;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCRUD.CreateRegistryResponse;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCRUD.UpdateRegistryRequest;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCsv.RegistryUploadRequest;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCsv.RegistryUploadResponse;
import it.pagopa.pn.cucumber.steps.SharedSteps;
import it.pagopa.pn.cucumber.steps.dataTable.DataTableTypeRaddAlt;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.opentest4j.AssertionFailedError;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.FileWriter;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static it.pagopa.pn.cucumber.utils.NotificationValue.generateRandomNumber;
import static it.pagopa.pn.cucumber.utils.RaddAltValue.*;
@Slf4j
public class AnagraficaRaddAltSteps {

    private final PnRaddAlternativeClientImpl raddAltClient;
    private final PnExternalServiceClientImpl externalServiceClient;
    private final SharedSteps sharedSteps;
    private final PnPaB2bUtils pnPaB2bUtils;
    private final RaddAltSteps raddAltSteps;
    private final DataTableTypeRaddAlt dataTableTypeRaddAlt;

    private String filePathCsv;
    private String shaCSV;
    private String requestid;
    private CreateRegistryRequest sportelloRaddCrud;

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
    public void vieneGeneratoIlCsv(Map<String, String> dataCsv) throws IOException {

    creazioneCsv(dataTableTypeRaddAlt.convertToListRegistryRequestData(dataCsv));
    RegistryUploadRequest registryUploadRequest=new RegistryUploadRequest().checksum(this.shaCSV);

    RegistryUploadResponse responseUploadCsv= null;
    responseUploadCsv= raddAltClient.uploadRegistryRequests(this.uid, registryUploadRequest );

    try {
        Assertions.assertNotNull(responseUploadCsv);
        Assertions.assertNotNull(responseUploadCsv.getRequestId());
        Assertions.assertNotNull(responseUploadCsv.getUrl());
        Assertions.assertNotNull(responseUploadCsv.getFileKey());
        Assertions.assertNotNull(responseUploadCsv.getSecret());
    }catch (AssertionFailedError assertionFailedError){
        String message = assertionFailedError.getMessage() +
                "{Response Upload CSV: " + (responseUploadCsv == null ? "NULL" : responseUploadCsv) + " }";
        throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
    }

}

    @When("viene generato uno sportello Radd con dati:")
    public void vieneGeneratoSportelloRadd(Map<String, String> dataSportello) {

        this.sportelloRaddCrud = dataTableTypeRaddAlt.convertRegistryRequestData(dataSportello);

        CreateRegistryResponse rispostaCreazione = raddAltClient.addRegistry(uid, sportelloRaddCrud);
        try {
            Assertions.assertNotNull(rispostaCreazione);
            Assertions.assertNotNull(rispostaCreazione.getRequestId());
            this.requestid=rispostaCreazione.getRequestId();

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{Registry Request: " + (sportelloRaddCrud == null ? "NULL" : sportelloRaddCrud) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }


    @When("viene modificato uno sportello Radd con dati:")
    public void vieneModificatoSportelloRadd(Map<String, String> dataSportello) {

        UpdateRegistryRequest aggiornamentoSportelloRadd = dataTableTypeRaddAlt.convertUpdateRegistryRequest(dataSportello);

        try {
            Assertions.assertDoesNotThrow(()->raddAltClient.updateRegistry(uid, this.requestid, aggiornamentoSportelloRadd));
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{Update Request: " + (aggiornamentoSportelloRadd == null ? "NULL" : aggiornamentoSportelloRadd) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    @When("viene cancellato uno sportello Radd con endDate {string}")
    public void vieneCancellatoSportelloRadd(String tipoDate) {

        String endDate= null;
        if(tipoDate.toLowerCase().contains("+")){
            endDate= this.sportelloRaddCrud.getEndValidity().plusDays(Long.parseLong(tipoDate.replace("\\+|g",""))).toString();
        }else if(tipoDate.toLowerCase().contains("-")){
            endDate= this.sportelloRaddCrud.getEndValidity().minusDays(Long.parseLong(tipoDate.replace("\\+|g",""))).toString();
        }else if(tipoDate.toLowerCase().contains("uguale")){
            endDate= this.sportelloRaddCrud.getEndValidity().toString();
        }

        try {
            raddAltClient.deleteRegistry(uid, this.requestid,endDate);
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{endDate: " + (endDate == null ? "NULL" : endDate) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }


    @When("viene richiesta la lista degli sportelli con dati:")
    public void vieneRichiestolaListaDeiSportelliRadd(Map<String, String> dataSportello) {

        try {
            raddAltClient.retrieveRegistries(
                    uid
                    , getValue(dataSportello,RADD_FILTER_LIMIT.key)==null ? null : Integer.parseInt(getValue(dataSportello,RADD_FILTER_FILEKEY.key))
                    , getValue(dataSportello,RADD_FILTER_FILEKEY.key)==null ? null : getValue(dataSportello,RADD_FILTER_FILEKEY.key)
                    , getValue(dataSportello,ADDRESS_RADD_CAP.key)==null ? null : getValue(dataSportello,ADDRESS_RADD_CAP.key)
                    , getValue(dataSportello,ADDRESS_RADD_CITY.key)==null ? null : getValue(dataSportello,ADDRESS_RADD_CITY.key)
                    , getValue(dataSportello,ADDRESS_RADD_PROVINCE.key)==null ? null : getValue(dataSportello,ADDRESS_RADD_PROVINCE.key)
                    , getValue(dataSportello,RADD_EXTERNAL_CODE.key)==null ? null : getValue(dataSportello,RADD_EXTERNAL_CODE.key)); //TODO vedere meglio la gestione del externalCode

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{endDate: " + (this.requestid == null ? "NULL" : this.requestid) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }



    public void creazioneCsv(List<CreateRegistryRequest> csvData) throws IOException {

        String csvFile="target/classes/file"+generateRandomNumber()+".csv";
        this.filePathCsv=csvFile;

        List<String[]> data = new ArrayList<>();
        data.add(new String[]{"addressRow", "cap", "city"});

        for(int i=0;i<csvData.size();i++) {
            data.add(new String[]{csvData.get(i).getAddress().getAddressRow(),
                    csvData.get(i).getAddress().getCap(),
                    csvData.get(i).getAddress().getCity()});


        }

        try (CSVWriter writer = new CSVWriter(new FileWriter(csvFile), ';',
                CSVWriter.DEFAULT_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END)) {
            writer.writeAll(data);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        this.shaCSV = pnPaB2bUtils.computeSha256(this.filePathCsv);
    }

}
