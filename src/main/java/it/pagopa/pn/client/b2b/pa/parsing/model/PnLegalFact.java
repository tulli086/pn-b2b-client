package it.pagopa.pn.client.b2b.pa.parsing.model;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import java.util.HashMap;
import java.util.Map;


@Setter
@Getter
@SuperBuilder
public abstract class PnLegalFact implements IPnLegalFact {
    private PnDestinatarioDigitale pnDestinatarioDigitale;
    private String iun;
    private String dataAttestazioneOpponibile;


    public PnLegalFact(PnDestinatarioDigitale pnDestinatarioDigitale, String iun, String dataAttestazioneOpponibile) {
        this.pnDestinatarioDigitale = pnDestinatarioDigitale;
        this.iun = iun;
        this.dataAttestazioneOpponibile = dataAttestazioneOpponibile;
    }

    @Override
    public Map<String, Object> getAllValues() {
        return new HashMap<>() {{
            put("iun", iun);
            put("dataAttestazioneOpponibile", dataAttestazioneOpponibile);
        }};
    }
}