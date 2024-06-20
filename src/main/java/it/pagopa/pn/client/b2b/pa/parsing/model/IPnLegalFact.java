package it.pagopa.pn.client.b2b.pa.parsing.model;

import it.pagopa.pn.client.b2b.pa.parsing.parser.impl.PnContentExtractor;
import it.pagopa.pn.client.b2b.pa.parsing.service.IPnParserService;
import java.util.Map;


public interface IPnLegalFact {
    PnParserRecord.PnParserFieldValues getAllLegalFactValues();
}