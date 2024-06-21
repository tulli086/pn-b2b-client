package it.pagopa.pn.client.b2b.pa.parsing.parser;

import it.pagopa.pn.client.b2b.pa.parsing.model.PnParserRecord;
import it.pagopa.pn.client.b2b.pa.parsing.service.IPnParserService;
import org.springframework.core.io.Resource;
import java.util.List;


public interface IPnContentExtractor {
    PnParserRecord.PnParserContent extractContent(Resource resource, String source, IPnParserService.LegalFactType legalFactType);
    PnParserRecord.PnParserContent getContent(String text, List<String> values, IPnParserService.LegalFactType legalFactType);
    String getField(PnTextSlidingWindow pnTextSlidingWindow, List<String> values);
    int countDuplicates(String text, String toSearch);
    String cleanUp(String text, boolean whitespace);
}
