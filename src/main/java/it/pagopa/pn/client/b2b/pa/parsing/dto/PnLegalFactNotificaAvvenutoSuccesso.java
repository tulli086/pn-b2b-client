package it.pagopa.pn.client.b2b.pa.parsing.dto;

import it.pagopa.pn.client.b2b.pa.parsing.model.PnDestinatarioDigitale;
import it.pagopa.pn.client.b2b.pa.parsing.model.PnLegalFact;
import lombok.Getter;
import lombok.experimental.SuperBuilder;
import java.util.Map;


@Getter
@SuperBuilder
public class PnLegalFactNotificaAvvenutoSuccesso extends PnLegalFact {
    public PnLegalFactNotificaAvvenutoSuccesso(String iun,
                                               String dataAttestazioneOpponibile,
                                               String nomeCognomeRagioneSocialeDestinatario,
                                               String codiceFiscaleDestinatario) {
        super(new PnDestinatarioDigitale(nomeCognomeRagioneSocialeDestinatario, codiceFiscaleDestinatario),iun, dataAttestazioneOpponibile);
    }

    @Override
    public Map<String, Object> getAllValues() {
        return super.getAllValues();
    }
}