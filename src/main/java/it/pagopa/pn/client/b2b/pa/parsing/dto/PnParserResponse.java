package it.pagopa.pn.client.b2b.pa.parsing.dto;

import it.pagopa.pn.client.b2b.pa.parsing.model.IPnLegalFact;
import lombok.Getter;

import java.util.ArrayList;
import java.util.List;


@Getter
public class PnParserResponse  {
    private IPnLegalFact pnLegalFact;
    private PnParserParameter parserParameter;
    private List<String> field;

    public PnParserResponse(IPnLegalFact pnLegalFact, PnParserParameter parserParameter) {
        this.pnLegalFact = pnLegalFact;
        this.parserParameter = parserParameter;
        this.field = new ArrayList<>();
    }

    public void setField(String list) {
        this.field.add(list);
    }
}
