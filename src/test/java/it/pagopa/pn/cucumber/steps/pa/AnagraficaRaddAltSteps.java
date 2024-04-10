package it.pagopa.pn.cucumber.steps.pa;

import com.opencsv.CSVWriter;
import io.cucumber.java.After;
import io.cucumber.java.Transpose;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.service.impl.PnExternalServiceClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnRaddAlternativeClientImpl;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCRUD.*;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCsv.RegistryRequestResponse;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCsv.RegistryUploadRequest;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCsv.RegistryUploadResponse;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCsv.VerifyRequestResponse;
import it.pagopa.pn.cucumber.steps.SharedSteps;
import it.pagopa.pn.cucumber.steps.dataTable.DataTableTypeRaddAlt;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.opentest4j.AssertionFailedError;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.HttpStatusCodeException;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URI;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static it.pagopa.pn.cucumber.utils.NotificationValue.generateRandomNumber;
import static it.pagopa.pn.cucumber.utils.RaddAltValue.*;

@Slf4j
public class AnagraficaRaddAltSteps {

    private final PnRaddAlternativeClientImpl raddAltClient;
    private final SharedSteps sharedSteps;
    private final PnPaB2bUtils pnPaB2bUtils;
    private final DataTableTypeRaddAlt dataTableTypeRaddAlt;

    private String filePathCsv;
    private String shaCSV;
    private String requestid;
    private String registryId;
    private CreateRegistryRequest sportelloRaddCrud;
    private RegistriesResponse sportelliRaddista;


    private String uid = "1234556";

    private static final Integer NUM_CHECK_STATE_CSV = 10;
    private static final Integer WAITING_STATE_CSV = 1000;

    @Autowired
    public AnagraficaRaddAltSteps(PnRaddAlternativeClientImpl raddAltClient, PnPaB2bUtils pnPaB2bUtils,
                                  SharedSteps sharedSteps, DataTableTypeRaddAlt dataTableTypeRaddAlt) {
        this.raddAltClient = raddAltClient;
        this.sharedSteps = sharedSteps;
        this.pnPaB2bUtils = pnPaB2bUtils;
        this.dataTableTypeRaddAlt = dataTableTypeRaddAlt;
    }

    @When("viene caricato il csv con dati:")
    public void vieneGeneratoIlCsv(List<Map<String, String>> dataCsv) throws IOException {
        log.info("dataCsv: {}", dataCsv);
        creazioneCsv(dataCsv);
        RegistryUploadRequest registryUploadRequest = new RegistryUploadRequest().checksum(this.shaCSV);

        RegistryUploadResponse responseUploadCsv = raddAltClient.uploadRegistryRequests(this.uid, registryUploadRequest);
        try {
            Assertions.assertNotNull(responseUploadCsv);
            Assertions.assertNotNull(responseUploadCsv.getRequestId());
            Assertions.assertNotNull(responseUploadCsv.getSecret());
            Assertions.assertNotNull(responseUploadCsv.getUrl());
            Assertions.assertNotNull(responseUploadCsv.getFileKey());
            this.requestid = responseUploadCsv.getRequestId();

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{Response Upload CSV: " + (responseUploadCsv == null ? "NULL" : responseUploadCsv) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }


    @When("viene caricato il csv con restituzione errore con dati:")
    public void vieneGeneratoIlCsvConResituzioneErrore(List<Map<String, String>> dataCsv) throws IOException {
        creazioneCsv(dataCsv);
        RegistryUploadRequest registryUploadRequest = new RegistryUploadRequest().checksum(this.shaCSV);

        try {
            raddAltClient.uploadRegistryRequests(this.uid, registryUploadRequest);
        } catch (HttpStatusCodeException e) {
            this.sharedSteps.setNotificationError(e);
        }
    }

    @When("viene caricato il csv con stesso checksum")
    public void vieneLoStessoCsvPrecedente() {
        RegistryUploadRequest registryUploadRequest = new RegistryUploadRequest().checksum(this.shaCSV);

        try {
            raddAltClient.uploadRegistryRequests(this.uid, registryUploadRequest);
        } catch (HttpStatusCodeException e) {
            this.sharedSteps.setNotificationError(e);
        }

    }

    @When("viene controllato lo stato di caricamento del csv a {string}")
    public void vieneControllatoLoStatoDelCsv(String stato) {

        VerifyRequestResponse responseUploadCsv = null;
        for (int i = 0; i < NUM_CHECK_STATE_CSV; i++) {
            responseUploadCsv = raddAltClient.verifyRequest(this.uid, this.requestid);
            if (responseUploadCsv.getStatus().equalsIgnoreCase(stato)) {
                break;
            }

            try {
                Thread.sleep(WAITING_STATE_CSV);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }

        try {
            Assertions.assertNotNull(responseUploadCsv);
            Assertions.assertNotNull(responseUploadCsv.getStatus());
            Assertions.assertEquals(stato.toUpperCase(), responseUploadCsv.getStatus());
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{Response Upload CSV: " + (responseUploadCsv == null ? "NULL" : responseUploadCsv) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }

    }

    @When("viene controllato lo stato di caricamento del csv a REJECTED con messaggio di errore {string}")
    public void vieneControllatoErroreLoStatoDelCsv(String mesaggioErrore) {

        VerifyRequestResponse responseVerifyCsv = raddAltClient.verifyRequest(this.uid, this.requestid);

        try {
            Assertions.assertNotNull(responseVerifyCsv);
            Assertions.assertNotNull(responseVerifyCsv.getStatus());
            Assertions.assertNotNull(responseVerifyCsv.getError());
            Assertions.assertEquals("REJECTED", responseVerifyCsv.getStatus());
            Assertions.assertEquals(mesaggioErrore, responseVerifyCsv.getError());

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{Response Upload CSV: " + (responseVerifyCsv == null ? "NULL" : responseVerifyCsv) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }

    }


    @When("viene eseguita la richiesta per controllo dello stato di caricamento del csv con restituzione errore")
    public void vieneControllatoErroreSullaRichiestaDelloStatoDelCsv(Map<String, String> richiestaSportello) {

        try {
            raddAltClient.verifyRequest(getValue(richiestaSportello, RADD_UID.key), getValue(richiestaSportello, RADD_REQUESTID.key));
        } catch (HttpStatusCodeException e) {
            this.sharedSteps.setNotificationError(e);
        }

    }

    @When("viene richiesta la lista degli sportelli caricati dal csv:")
    public void vieneRichiestolaListaDeiSportelliRaddDelCsv(Map<String, String> dataSportello) {

        it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCsv.RequestResponse sportello= raddAltClient.retrieveRequestItems(
                getValue(dataSportello, RADD_UID.key)
                , getValue(dataSportello, RADD_REQUESTID.key) == null ? null : this.requestid
                , getValue(dataSportello, RADD_FILTER_LIMIT.key) == null ? null : Integer.parseInt(getValue(dataSportello, RADD_FILTER_LIMIT.key))
                , getValue(dataSportello, RADD_FILTER_LASTKEY.key) == null ? null : getValue(dataSportello, RADD_FILTER_LASTKEY.key));

        try {
            Assertions.assertNotNull(sportello);
            Assertions.assertNotNull(sportello.getItems());

            log.info("lista sportelli: {}",sportello);

            for (int i=0;i<sportello.getItems().size();i++) {
                Assertions.assertNotNull(sportello.getItems().get(i));
                Assertions.assertNotNull(sportello.getItems().get(i).getRequestId());
                Assertions.assertNotNull(sportello.getItems().get(i).getRegistryId());
                Assertions.assertNotNull(sportello.getItems().get(i).getOriginalRequest());
                Assertions.assertNotNull(sportello.getItems().get(i).getOriginalRequest().getOriginalAddress());
            }

        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{endDate: " + (this.requestid == null ? "NULL" : this.requestid) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }


    @When("viene richiesta la lista degli sportelli caricati dal csv con dati errati:")
    public void vieneRichiestolaListaDeiSportelliRaddDelCsvDatiErrati(Map<String, String> dataSportello) {

        try {
            it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCsv.RequestResponse sportello = raddAltClient.retrieveRequestItems(
                    getValue(dataSportello, RADD_UID.key)
                    , getValue(dataSportello, RADD_REQUESTID.key) == null ? null : getValue(dataSportello, RADD_REQUESTID.key)
                    , getValue(dataSportello, RADD_FILTER_LIMIT.key) == null ? null : Integer.parseInt(getValue(dataSportello, RADD_FILTER_LIMIT.key))
                    , getValue(dataSportello, RADD_FILTER_LASTKEY.key) == null ? null : getValue(dataSportello, RADD_FILTER_LASTKEY.key));
        } catch (HttpStatusCodeException e) {
            this.sharedSteps.setNotificationError(e);
        }
    }


    @When("viene generato uno sportello Radd con dati:")
    public void vieneGeneratoSportelloRadd(@Transpose CreateRegistryRequest dataSportello) {

        this.sportelloRaddCrud = dataSportello;

        log.info("Request inserimento: {}", dataSportello);
        CreateRegistryResponse creationResponse=raddAltClient.addRegistry(this.uid,dataSportello);

        try {
            Assertions.assertNotNull(creationResponse);
            Assertions.assertNotNull(creationResponse.getRequestId());

            this.requestid=creationResponse.getRequestId();
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{Response Upload CSV: " + (creationResponse == null ? "NULL" : creationResponse) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }

    @When("viene generato uno sportello Radd con restituzione errore con dati:")
    public void vieneGeneratoConErroreSportelloRadd(@Transpose CreateRegistryRequest dataSportello) {
        try {
            raddAltClient.addRegistry(this.uid, dataSportello);
        } catch (HttpStatusCodeException e) {
        this.sharedSteps.setNotificationError(e);
    }

    }


    @When("viene modificato uno sportello Radd con dati:")
    public void vieneModificatoSportelloRadd(@Transpose UpdateRegistryRequest dataSportello) {
        log.info("Upload Request: {}", dataSportello);
        try {
            Assertions.assertDoesNotThrow(() -> raddAltClient.updateRegistry(this.uid, this.registryId, dataSportello));
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{Response Upload CSV: " + (dataSportello == null ? "NULL" : dataSportello) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }


    @When("viene modificato uno sportello Radd con dati errati:")
    public void vieneModificatoSportelloRadd(Map<String,String> dataSportello) {

        UpdateRegistryRequest aggiornamentoSportelloRadd = dataTableTypeRaddAlt.convertUpdateRegistryRequest(dataSportello);

        try {
            raddAltClient.updateRegistry(
                    getValue(dataSportello, RADD_UID.key),
                    getValue(dataSportello, RADD_REGISTRYID.key),
                    aggiornamentoSportelloRadd);
        } catch (HttpStatusCodeException e) {
            this.sharedSteps.setNotificationError(e);
        }
    }

    @When("viene cancellato uno sportello Radd con dati corretti")
    public void vieneCancellatoSportelloRadd() {

        try {
            raddAltClient.deleteRegistry(this.uid, this.registryId, this.sportelloRaddCrud.getEndValidity());
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{endDate: " + (this.sportelloRaddCrud.getEndValidity() == null ? "NULL" : this.sportelloRaddCrud.getEndValidity()) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }


    @When("viene cancellato uno sportello Radd con dati errati:")
    public void vieneCancellatoSportelloRadd(Map<String,String> richiestaCancellazione) {

        String endDate = getValue(richiestaCancellazione,RADD_END_VALIDITY.key);
        OffsetDateTime endValidity=null;
        if(this.sportelloRaddCrud.getEndValidity()!=null) {
            endValidity = OffsetDateTime.parse(this.sportelloRaddCrud.getEndValidity());
        }else{
                endValidity=OffsetDateTime.now();
        }

        if (endDate!=null) {
            if (endDate.toLowerCase().contains("+")) {
                endDate = endValidity.plusDays(Long.parseLong(endDate.replace("\\+|g", ""))).toString();
            } else if (endDate.toLowerCase().contains("-")) {
                endDate = endValidity.minusDays(Long.parseLong(endDate.replace("\\+|g", ""))).toString();
            } else if (endDate.toLowerCase().contains("corretto")) {
                endDate = this.sportelloRaddCrud.getEndValidity();
            }
        }

        try {
            raddAltClient.deleteRegistry(
                    getValue(richiestaCancellazione, RADD_UID.key),
                    getValue(richiestaCancellazione, RADD_REGISTRYID.key)==null ? null:
                            getValue(richiestaCancellazione, RADD_REGISTRYID.key).equalsIgnoreCase("corretto")? this.registryId: getValue(richiestaCancellazione, RADD_REGISTRYID.key),
                    endDate);
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{endDate: " + (endDate == null ? "NULL" : endDate) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }


    @When("viene richiesta la lista degli sportelli con dati:")
    public void vieneRichiestolaListaDeiSportelliRadd(Map<String, String> dataSportello) {

        RegistriesResponse sportello= raddAltClient.retrieveRegistries(
                this.uid
                , getValue(dataSportello, RADD_FILTER_LIMIT.key) == null ? null : Integer.parseInt(getValue(dataSportello, RADD_FILTER_LIMIT.key))
                , getValue(dataSportello, RADD_FILTER_LASTKEY.key) == null ? null : getValue(dataSportello, RADD_FILTER_LASTKEY.key)
                , getValue(dataSportello, ADDRESS_RADD_CAP.key) == null ? null : getValue(dataSportello, ADDRESS_RADD_CAP.key)
                , getValue(dataSportello, ADDRESS_RADD_CITY.key) == null ? null : getValue(dataSportello, ADDRESS_RADD_CITY.key)
                , getValue(dataSportello, ADDRESS_RADD_PROVINCE.key) == null ? null : getValue(dataSportello, ADDRESS_RADD_PROVINCE.key)
                , getValue(dataSportello, RADD_EXTERNAL_CODE.key) == null ? null : getValue(dataSportello, RADD_EXTERNAL_CODE.key));
        try {
            Assertions.assertNotNull(sportello);
            Assertions.assertNotNull(sportello.getRegistries());
            if(sportello.getRegistries().isEmpty() || sportello.getRegistries().size()==0) {
            }else {
                this.registryId = sportello.getRegistries().get(0).getRegistryId();
                this.sportelliRaddista =sportello;
            }
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{endDate: " + (this.requestid == null ? "NULL" : this.requestid) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }


    @When("viene richiesta la lista degli sportelli con dati errati:")
    public void vieneRichiestolaListaDeiSportelliRaddConDatiErrati(Map<String, String> dataSportello) {

        try {
            raddAltClient.retrieveRegistries(
                    this.uid
                    , getValue(dataSportello, RADD_FILTER_LIMIT.key) == null ? null : Integer.parseInt(getValue(dataSportello, RADD_FILTER_LIMIT.key))
                    , getValue(dataSportello, RADD_FILTER_LASTKEY.key) == null ? null : getValue(dataSportello, RADD_FILTER_LASTKEY.key)
                    , getValue(dataSportello, ADDRESS_RADD_CAP.key) == null ? null : getValue(dataSportello, ADDRESS_RADD_CAP.key)
                    , getValue(dataSportello, ADDRESS_RADD_CITY.key) == null ? null : getValue(dataSportello, ADDRESS_RADD_CITY.key)
                    , getValue(dataSportello, ADDRESS_RADD_PROVINCE.key) == null ? null : getValue(dataSportello, ADDRESS_RADD_PROVINCE.key)
                    , getValue(dataSportello, RADD_EXTERNAL_CODE.key) == null ? null : getValue(dataSportello, RADD_EXTERNAL_CODE.key));
        } catch (HttpStatusCodeException e) {
            this.sharedSteps.setNotificationError(e);
        }
    }


    @When("viene contrallato il numero di valori tornati sia uguale a {int}")
    public void vieneControllatoCheVenganoRitornatiTotValori(Integer numValori) {
        try {
            if(numValori==0){
                Assertions.assertTrue(this.sportelliRaddista.getRegistries().isEmpty());
            }else{
                Assertions.assertEquals(numValori-1,this.sportelliRaddista.getRegistries().size());

            }
        } catch (AssertionFailedError assertionFailedError) {
            String message = assertionFailedError.getMessage() +
                    "{endDate: " + (this.requestid == null ? "NULL" : this.requestid) + " }";
            throw new AssertionFailedError(message, assertionFailedError.getExpected(), assertionFailedError.getActual(), assertionFailedError.getCause());
        }
    }


    public void creazioneCsv(List<Map<String, String>> dataCsv) throws IOException {
        String fileName = "file" + generateRandomNumber() + ".csv";
        this.filePathCsv = "target/classes/" + fileName;


        List<CreateRegistryRequest> csvData = dataTableTypeRaddAlt.convertToListRegistryRequestData(dataCsv);

        List<String[]> data = new ArrayList<>();
        data.add(new String[]{"paese", "città", "provincia","cap","via","dataInizioValidità","dataFineValidità","descrizione","orariApertura","coordinateGeoReferenziali","telefono","capacità","externalCode"});

        for (int i = 0; i < csvData.size(); i++) {
            data.add(new String[]{
                    csvData.get(i).getAddress().getCountry(),
                    csvData.get(i).getAddress().getCity(),
                    csvData.get(i).getAddress().getPr(),
                    csvData.get(i).getAddress().getCap(),
                    csvData.get(i).getAddress().getAddressRow(),
                    csvData.get(i).getStartValidity(),
                    csvData.get(i).getEndValidity(),
                    csvData.get(i).getDescription(),
                    csvData.get(i).getOpeningTime(),
                    csvData.get(i).getGeoLocation().getLatitude()+","+
                    csvData.get(i).getGeoLocation().getLongitude(),
                    csvData.get(i).getPhoneNumber(),
                    getValue(dataCsv.get(i), RADD_CAPACITY.key),
                    csvData.get(i).getExternalCode(),
            });
        }


        try (CSVWriter writer = new CSVWriter(new FileWriter(filePathCsv), ';',
                CSVWriter.DEFAULT_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, CSVWriter.DEFAULT_LINE_END)) {
            writer.writeAll(data);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        this.shaCSV = pnPaB2bUtils.computeSha256("classpath:/" + fileName);
    }


    @After("@raddCsv")
    public void deleteCSV() {
        if (this.filePathCsv != null) {
            URI zip_disk = URI.create(this.filePathCsv);
            File file = new File(zip_disk.getPath());
            boolean deleted = file.delete();
            System.out.println("delete " + deleted);
        }
    }


}