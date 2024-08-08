package it.pagopa.pn.cucumber.steps.pa;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.parsing.dto.impLegalFact.PnLegalFactNotificaPresaInCaricoMultiDestinatario;
import it.pagopa.pn.client.b2b.pa.parsing.dto.PnParserParameter;
import it.pagopa.pn.client.b2b.pa.parsing.dto.IPnParserResponse;
import it.pagopa.pn.client.b2b.pa.parsing.dto.implResponse.PnParserLegalFactResponse;
import it.pagopa.pn.client.b2b.pa.parsing.dto.implDestinatario.PnDestinatarioAnalogico;
import it.pagopa.pn.client.b2b.pa.parsing.parser.IPnParserLegalFact;
import it.pagopa.pn.client.b2b.pa.parsing.service.impl.PnParserService;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.lang.reflect.Field;


@Slf4j
public class LegalFactContentVerifySteps {
    private final PnPaB2bUtils b2bUtils;
    private final PnParserService pnParserService;
    @Setter
    private String legalFactUrl;
    @Setter
    private String legalFactType;


    @Autowired
    public LegalFactContentVerifySteps(PnPaB2bUtils b2bUtils, PnParserService pnParserService) {
        this.b2bUtils = b2bUtils;
        this.pnParserService = pnParserService;
    }

    @Then("si verifica se il legalFact è di tipo {string}")
    public void siVerificaSeIlLegalFactEDiTipo(String legalFactType) {
        this.legalFactType = legalFactType;
        byte[] source = b2bUtils.downloadFile(legalFactUrl);
        checkLegalFactType(source, legalFactType);
    }

    @Then("si verifica se il legalFact contiene il campo {string} con value {string}")
    public void siVerificaSeIlLegalFactContieneIlCampoConValue(String legalFactField, String legalFactValue) {
        byte[] source = b2bUtils.downloadFile(legalFactUrl);
        checkLegalFactFieldValue(source, legalFactField, legalFactValue);
    }

    @Then("si verifica se il legalFact contiene i campi per il destinatario")
    public void siVerificaSeIlLegalFactContieneICampiPerIlDestinatario(DataTable dataTable) {
        byte[] source = b2bUtils.downloadFile(legalFactUrl);

        //Creation of a list of map for each dataTable pair
        List<Map<String, String>> listOfMap = dataTable
                .asLists()
                .stream()
                .map(pair -> Map.ofEntries(Map.entry(pair.get(0), pair.get(1))))
                .toList();

        String positionFieldName = Arrays.stream(PnParserParameter.class.getDeclaredFields())
                .filter(field -> field.getType() == int.class)
                .map(Field::getName)
                .findFirst()
                .orElse(null);
        Assertions.assertNotNull(positionFieldName);

        Map<String, String> positionField = listOfMap.stream().filter(mappa -> mappa.keySet().stream().anyMatch(key -> key.contains(positionFieldName))).findAny().get();
        Assertions.assertNotNull(positionField);
        int multiDestinatarioPosition = Integer.parseInt(positionField.get(positionFieldName));

        checkLegalFactDestinatario(source, PnDestinatarioAnalogico.mapToDestinatarioAnalogico(listOfMap), multiDestinatarioPosition);

        List<Map<String, String>> listOfMapCleaned = listOfMap.stream()
                .filter(map -> map.keySet().stream().noneMatch(key -> key.contains(IPnParserLegalFact.DESTINATARIO) || key.contains(positionFieldName)))
                .toList();

        if(!listOfMapCleaned.isEmpty()) {
            listOfMapCleaned.forEach((map) -> map.forEach((legalFactField, legalFactValue) -> checkLegalFactFieldValue(source, legalFactField, legalFactValue)));
        }
    }

    @Then("si verifica se il legalFact contiene i campi")
    public void siVerificaSeIlLegalFactContieneICampi(DataTable dataTable) {
        byte[] source = b2bUtils.downloadFile(legalFactUrl);

        if(IPnParserLegalFact.LegalFactType.valueOf(legalFactType).equals(IPnParserLegalFact.LegalFactType.LEGALFACT_NOTIFICA_PRESA_IN_CARICO_MULTIDESTINATARIO)) {
            //Creation of a list of map for each dataTable pair
            List<Map<String, String>> listOfMap = dataTable
                    .asLists()
                    .stream()
                    .map(pair -> Map.ofEntries(Map.entry(pair.get(0), pair.get(1))))
                    .toList();

            List<Map<String, String>> listOfMapCleaned = listOfMap.stream()
                    .filter(map -> map.keySet().stream().noneMatch(key -> key.contains(IPnParserLegalFact.DESTINATARIO)))
                    .toList();

            listOfMapCleaned.forEach((map) -> map.forEach((legalFactField, legalFactValue) -> checkLegalFactFieldValue(source, legalFactField, legalFactValue)));
            checkLegalFactDestinatario(source, PnDestinatarioAnalogico.mapToDestinatarioAnalogico(listOfMap), 0);
        } else {
            dataTable
                    .asMap()
                    .forEach((legalFactField, legalFactValue) -> checkLegalFactFieldValue(source, legalFactField, legalFactValue));
        }
    }

    @Then("si verifica se il legalFact è di tipo {string} e contiene il campo {string} con value {string}")
    public void siVerificaSeIlLegalFactEDiTipoEContieneIlCampoConValue(String legalFactType, String legalFactField, String legalFactValue) {
        this.legalFactType = legalFactType;
        byte[] source = b2bUtils.downloadFile(legalFactUrl);
        checkLegalFactType(source, legalFactType);
        checkLegalFactFieldValue(source, legalFactField, legalFactValue);
    }

    public void checkLegalFactType(byte[] source, String legalFactType) {
        PnParserParameter pnParserParameter = PnParserParameter.builder()
                .legalFactType(IPnParserLegalFact.LegalFactType.valueOf(legalFactType))
                .legalFactField(IPnParserLegalFact.LegalFactField.valueOf(IPnParserLegalFact.LegalFactField.TITLE.name()))
                .build();
        PnParserLegalFactResponse pnParserLegalFactResponse = (PnParserLegalFactResponse) parseLegalFact(source, pnParserParameter, false);
        assertLegalFactParserResponse(pnParserLegalFactResponse);
        assertLegalFactType(pnParserLegalFactResponse, legalFactType);
    }

    private void checkLegalFactFieldValue(byte[] source, String legalFactField, String legalFactValue) {
        PnParserParameter pnParserParameter = PnParserParameter.builder()
                .legalFactType(IPnParserLegalFact.LegalFactType.valueOf(legalFactType))
                .legalFactField(IPnParserLegalFact.LegalFactField.valueOf(legalFactField))
                .build();
        PnParserLegalFactResponse pnParserLegalFactResponse = (PnParserLegalFactResponse) parseLegalFact(source, pnParserParameter, false);
        assertLegalFactParserResponse(pnParserLegalFactResponse);
        assertLegalFactFieldValue(pnParserLegalFactResponse, legalFactField, legalFactValue);
    }

    private void checkLegalFactDestinatario(byte[] source, List<PnDestinatarioAnalogico> destinatarioAnalogicoList, int multiDestinatarioPosition) {
        PnParserParameter pnParserParameter;
        PnParserLegalFactResponse pnParserLegalFactResponse;
        boolean isAllField;
        if(multiDestinatarioPosition == 0) {
            pnParserParameter = PnParserParameter.builder()
                    .legalFactType(IPnParserLegalFact.LegalFactType.valueOf(legalFactType))
                    .build();
            isAllField = true;
        } else {
            pnParserParameter = PnParserParameter.builder()
                    .legalFactType(IPnParserLegalFact.LegalFactType.valueOf(legalFactType))
                    .multiDestinatarioPosition(multiDestinatarioPosition)
                    .build();
            isAllField = false;
        }
        pnParserLegalFactResponse = (PnParserLegalFactResponse) parseLegalFact(source, pnParserParameter, isAllField);
        assertLegalFactParserResponse(pnParserLegalFactResponse);
        assertLegalFactDestinatario(pnParserLegalFactResponse, destinatarioAnalogicoList, multiDestinatarioPosition);
    }

    private IPnParserResponse parseLegalFact(byte[] source, PnParserParameter pnParserParameter, boolean isAllField) {
        if(isAllField) {
            return pnParserService.extractAllField(source, pnParserParameter);
        } else {
            return pnParserService.extractSingleField(source, pnParserParameter);
        }
    }

    private void assertLegalFactParserResponse(PnParserLegalFactResponse pnParserLegalFactResponse) {
        Assertions.assertNotNull(pnParserLegalFactResponse);
        Assertions.assertNotNull(pnParserLegalFactResponse.getResponse().getPnLegalFact());
        log.info("PN_LEGAL_FACT:\n {}", pnParserLegalFactResponse.getResponse().getPnLegalFact());
    }

    private void assertLegalFactType(PnParserLegalFactResponse pnParserLegalFactResponse, String legalFactType) {
        Assertions.assertEquals(pnParserLegalFactResponse.getResponse().getField(),
                IPnParserLegalFact.LegalFactTypeTitle.getTitleByType(IPnParserLegalFact.LegalFactType.valueOf(legalFactType)));
    }

    private void assertLegalFactFieldValue(PnParserLegalFactResponse pnParserLegalFactResponse, String legalFactField, String legalFactValue) {
        Assertions.assertNotNull(pnParserLegalFactResponse.getResponse().getField());
        Assertions.assertEquals(legalFactValue, pnParserLegalFactResponse.getResponse().getField());
        Assertions.assertEquals(legalFactValue, pnParserLegalFactResponse.getResponse().getPnLegalFact().getAllLegalFactValues().fieldValue().get(IPnParserLegalFact.LegalFactField.valueOf(legalFactField)));
    }

    private void assertLegalFactDestinatario(PnParserLegalFactResponse pnParserLegalFactResponse, List<PnDestinatarioAnalogico> destinatarioAnalogicoList, int multiDestinatarioPosition) {
        assertLegalFactParserResponse(pnParserLegalFactResponse);
        PnLegalFactNotificaPresaInCaricoMultiDestinatario pnLegalFactNotificaPresaInCaricoMultiDestinatario = (PnLegalFactNotificaPresaInCaricoMultiDestinatario) pnParserLegalFactResponse.getResponse().getPnLegalFact();

        if(multiDestinatarioPosition == 0) {
            Assertions.assertEquals(destinatarioAnalogicoList.size(), pnLegalFactNotificaPresaInCaricoMultiDestinatario.getDestinatariAnalogici().size());
            Assertions.assertTrue(destinatarioAnalogicoList.containsAll(pnLegalFactNotificaPresaInCaricoMultiDestinatario.getDestinatariAnalogici())
                    && pnLegalFactNotificaPresaInCaricoMultiDestinatario.getDestinatariAnalogici().containsAll(destinatarioAnalogicoList));
        } else {
            Assertions.assertEquals(multiDestinatarioPosition, pnLegalFactNotificaPresaInCaricoMultiDestinatario.getDestinatariAnalogici().indexOf(destinatarioAnalogicoList.get(0))+1);
            Assertions.assertEquals(destinatarioAnalogicoList.get(0), pnLegalFactNotificaPresaInCaricoMultiDestinatario.getDestinatariAnalogici().get(multiDestinatarioPosition-1));
            Assertions.assertTrue(pnLegalFactNotificaPresaInCaricoMultiDestinatario.getDestinatariAnalogici().containsAll(destinatarioAnalogicoList));
        }
    }
}