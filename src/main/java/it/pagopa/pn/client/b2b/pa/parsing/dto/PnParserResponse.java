package it.pagopa.pn.client.b2b.pa.parsing.dto;

import it.pagopa.pn.client.b2b.pa.parsing.model.IPnLegalFact;
import lombok.Getter;
import lombok.Setter;


@Getter
public class PnParserResponse  {
    private final IPnLegalFact pnLegalFact;
    @Setter
    private String field;

    public PnParserResponse(IPnLegalFact pnLegalFact) {
        this.pnLegalFact = pnLegalFact;
//        this.field = new ArrayList<>();
    }

//    public void setField(String list) {
//        this.field.add(list);
//    }
}