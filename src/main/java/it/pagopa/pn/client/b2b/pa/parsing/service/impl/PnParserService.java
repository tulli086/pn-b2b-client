package it.pagopa.pn.client.b2b.pa.parsing.service.impl;

import it.pagopa.pn.client.b2b.pa.parsing.dto.PnLegalFact;
import it.pagopa.pn.client.b2b.pa.parsing.parser.PnLegalFactParser;
//import it.pagopa.pn.client.b2b.pa.parsing.record.PnLegalFact;
import it.pagopa.pn.client.b2b.pa.parsing.service.IPnParserService;
import it.pagopa.pn.client.b2b.pa.parsing.config.PnB2bLegalFactTextTokens;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.io.*;
import java.util.HashMap;


@Slf4j
@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class PnParserService {
    private final PnLegalFactParser pnLegalFactParser;


    public PnParserService(PnLegalFactParser pnLegalFactParser) {
        this.pnLegalFactParser = pnLegalFactParser;
    }

    public String extractSingle(String source, String campo, IPnParserService.LegalFactType legalFactType) throws IOException {
            return pnLegalFactParser.extractSingle(source, campo, legalFactType);
    }

    public HashMap<String, String> extractMulti(String source, IPnParserService.LegalFactType legalFactType) throws IOException {
        return pnLegalFactParser.extractMulti(source, legalFactType);
    }
}