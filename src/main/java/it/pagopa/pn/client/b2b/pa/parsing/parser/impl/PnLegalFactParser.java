package it.pagopa.pn.client.b2b.pa.parsing.parser.impl;

import it.pagopa.pn.client.b2b.pa.parsing.config.PnLegalFactTokens;
import it.pagopa.pn.client.b2b.pa.parsing.model.IPnLegalFact;
import it.pagopa.pn.client.b2b.pa.parsing.dto.PnParserResponse;
import it.pagopa.pn.client.b2b.pa.parsing.dto.*;
import it.pagopa.pn.client.b2b.pa.parsing.model.PnParserRecord;
import it.pagopa.pn.client.b2b.pa.parsing.parser.IPnParser;
import it.pagopa.pn.client.b2b.pa.parsing.parser.PnContentToken;
import it.pagopa.pn.client.b2b.pa.parsing.service.IPnParserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Component;
import lombok.extern.slf4j.Slf4j;

import java.util.Objects;


@Slf4j
@Component
public class PnLegalFactParser implements IPnParserService, IPnParser {
    @Autowired
    private ResourceLoader resourceLoader;
    private PnContentToken contentTokens;


    @Autowired
    public PnLegalFactParser(PnLegalFactTokens pnLegalFactTokens)  {
        this.contentTokens = new PnContentToken(pnLegalFactTokens);
    }

    @Override
    public PnParserResponse extractSingleField(String source, PnParserParameter parserParameter) {
        PnParserResponse pnParserResponse = extractAllField(source, parserParameter);
        if(pnParserResponse == null)
            return null;

        IPnParserService.LegalFactField field = parserParameter.getLegalFactField();
        if(pnParserResponse.getPnLegalFact() instanceof PnLegalFactNotificaDowntime notificaDowntime) {
            pnParserResponse.setField(notificaDowntime.getAllLegalFactValues().fieldValue().get(field));
            return pnParserResponse;
        } else if(pnParserResponse.getPnLegalFact() instanceof PnLegalFactNotificaDigitale notificaDigitale) {
            pnParserResponse.setField(notificaDigitale.getAllLegalFactValues().fieldValue().get(field));
            return pnParserResponse;
        } else if(pnParserResponse.getPnLegalFact() instanceof PnLegalFactNotificaMancatoRecapito notificaMancatoRecapito) {
            pnParserResponse.setField(notificaMancatoRecapito.getAllLegalFactValues().fieldValue().get(field));
            return pnParserResponse;
        }else if(pnParserResponse.getPnLegalFact() instanceof PnLegalFactNotificaPresaInCaricoMultiDestinatario notificaPresaInCaricoMultiDestinatario) {
            if(parserParameter.getMultiDestinatarioPosition() == 0) {
                pnParserResponse.setField(notificaPresaInCaricoMultiDestinatario.getAllLegalFactValues().fieldValue().get(field));
            } else {
                PnParserRecord.PnParserFieldValues parserFieldValues = notificaPresaInCaricoMultiDestinatario.getDestinatariAnalogici().get(parserParameter.getMultiDestinatarioPosition()-1).getAllDestinatarioValues();
                pnParserResponse.setField(parserFieldValues.fieldValue().get(field));
            }
            return pnParserResponse;
        } else if(pnParserResponse.getPnLegalFact() instanceof PnLegalFactNotificaPresaInCarico notificaPresaInCarico) {
            pnParserResponse.setField(notificaPresaInCarico.getAllLegalFactValues().fieldValue().get(field));
            return pnParserResponse;
        } else if(pnParserResponse.getPnLegalFact() instanceof PnLegalFactNotificaAvvenutoAccessoDelegato notificaAvvenutoAccessoDelegato) {
            pnParserResponse.setField(notificaAvvenutoAccessoDelegato.getAllLegalFactValues().fieldValue().get(field));
            return pnParserResponse;
        } else if(pnParserResponse.getPnLegalFact() instanceof PnLegalFactNotificaAvvenutoAccesso notificaAvvenutoAccesso) {
            pnParserResponse.setField(notificaAvvenutoAccesso.getAllLegalFactValues().fieldValue().get(field));
            return pnParserResponse;
        }
        return null;
    }

    @Override
    public PnParserResponse extractAllField(String source, PnParserParameter parserParameter) {
        IPnLegalFact legalFact = parse(source, parserParameter);
        if(legalFact == null) {
            return null;
        }
        return new PnParserResponse(legalFact, parserParameter);
    }

    @Override
    public IPnLegalFact parse(String source, PnParserParameter parserParameter) {
        LegalFactType legalFactType = parserParameter.getLegalFactType();
        PnParserRecord.PnParserContent content = contentTokens.extractContent(resourceLoader.getResource(source), source, legalFactType);
        if(content == null) {
            return null;
        }

        if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_DOWNTIME)) {
            return contentTokens.getLegalFactNotificaDowntime(content);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_DIGITALE)) {
            return contentTokens.getLegalFactNotificaDigitale(content);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_MANCATO_RECAPITO)) {
            return contentTokens.getLegalFactNotificaMancatoRecapito(content);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_PRESA_IN_CARICO)) {
            return contentTokens.getLegalFactNotificaPresaInCarico(content);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_PRESA_IN_CARICO_MULTIDESTINATARIO)) {
            return contentTokens.getLegalFactNotificaPresaInCaricoMultiDestinatario(content);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_AVVENUTO_ACCESSO)) {
            return contentTokens.getLegalFactNotificaAvvenutoAccesso(content);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_AVVENUTO_ACCESSO_DELEGATO)) {
            return contentTokens.getLegalFactNotificaAvvenutoAccessoDelegato(content);
        } else {
            return null;
        }
    }
}