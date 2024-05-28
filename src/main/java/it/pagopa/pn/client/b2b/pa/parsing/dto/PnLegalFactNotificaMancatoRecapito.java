package it.pagopa.pn.client.b2b.pa.parsing.dto;

import it.pagopa.pn.client.b2b.pa.parsing.model.PnDestinatarioDigitale;
import it.pagopa.pn.client.b2b.pa.parsing.model.PnLegalFact;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import java.util.Map;


@Getter
@Setter
@SuperBuilder
public class PnLegalFactNotificaMancatoRecapito extends PnLegalFact {
    private PnDestinatarioDigitale pnDelegato;
    private String primaData;
    private String secondaData;

    public PnLegalFactNotificaMancatoRecapito(String iun,
                                              String dataAttestazioneOpponibile,
                                              String nomeCognomeRagioneSocialeDestinatario,
                                              String codiceFiscaleDestinatario,
                                              String domicilioDigitale,
                                              String tipoDomicilioDigitale,
                                              String primaData,
                                              String secondaData) {
        super(new PnDestinatarioDigitale(nomeCognomeRagioneSocialeDestinatario, codiceFiscaleDestinatario,domicilioDigitale, tipoDomicilioDigitale), iun, dataAttestazioneOpponibile);
        this.primaData = primaData;
        this.secondaData = secondaData;
    }

    public Map<String, Object> getAllValues() {
        return super.getAllValues();
    }
}
