package it.pagopa.pn.client.b2b.pa.parsing.service.impl;

import it.pagopa.pn.client.b2b.pa.parsing.dto.PnParserParameter;
import it.pagopa.pn.client.b2b.pa.parsing.parser.impl.PnLegalFactParser;
import it.pagopa.pn.client.b2b.pa.parsing.dto.PnParserResponse;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;


@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class PnParserService {
    private final PnLegalFactParser pnLegalFactParser;


    public PnParserService(PnLegalFactParser pnLegalFactParser) {
        this.pnLegalFactParser = pnLegalFactParser;
    }

    public PnParserResponse extractSingleField(String source, PnParserParameter parserParameter) {
        if (parserParameter.isValidKeyValues()) {
            return pnLegalFactParser.extractSingleField(source, parserParameter);
        }
        return null;
    }

    public PnParserResponse extractAllField(String source, PnParserParameter parserParameter) {
        return pnLegalFactParser.extractAllField(source, parserParameter);
    }
}