package it.pagopa.pn.client.b2b.pa.parsing.parser;

import it.pagopa.pn.client.b2b.pa.parsing.model.IPnLegalFact;
import it.pagopa.pn.client.b2b.pa.parsing.dto.PnParserParameter;


public interface IPnParser {
    IPnLegalFact parse(String source, PnParserParameter parserParameter);
}