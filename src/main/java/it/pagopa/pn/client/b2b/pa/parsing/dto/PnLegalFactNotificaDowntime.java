package it.pagopa.pn.client.b2b.pa.parsing.dto;

import it.pagopa.pn.client.b2b.pa.parsing.model.IPnLegalFact;
import it.pagopa.pn.client.b2b.pa.parsing.model.PnLegalFact;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;


@Getter
@Setter
@Builder
public class PnLegalFactNotificaDowntime implements IPnLegalFact {
    private String dataOraDecorrenza;
    private String dataOraFine;

    public PnLegalFactNotificaDowntime(String dataOraDecorrenza, String dataOraFine) {
        this.dataOraDecorrenza = dataOraDecorrenza;
        this.dataOraFine = dataOraFine;
    }

    @Override
    public Map<String, Object> getAllValues() {
        return new HashMap<>() {{
            put("dataOraDecorrenza", dataOraDecorrenza);
            put("dataOraFine", dataOraFine);
        }};
    }
}
