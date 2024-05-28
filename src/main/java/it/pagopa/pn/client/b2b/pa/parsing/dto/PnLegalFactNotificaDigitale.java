package it.pagopa.pn.client.b2b.pa.parsing.dto;

import it.pagopa.pn.client.b2b.pa.parsing.model.PnDestinatarioDigitale;
import it.pagopa.pn.client.b2b.pa.parsing.model.PnLegalFact;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.springframework.stereotype.Service;

import java.util.Map;


@Getter
@Setter
@SuperBuilder
public class PnLegalFactNotificaDigitale extends PnLegalFact {
    public PnLegalFactNotificaDigitale(String iun,
                                       String dataAttestazioneOpponibile,
                                       String nomeCognomeRagioneSocialeDestinatario,
                                       String codiceFiscaleDestinatario,
                                       String domicilioDigitale,
                                       String tipoDomicilioDigitale) {
        super(new PnDestinatarioDigitale(nomeCognomeRagioneSocialeDestinatario, codiceFiscaleDestinatario,domicilioDigitale, tipoDomicilioDigitale), iun, dataAttestazioneOpponibile);
    }


    @Override
    public Map<String, Object> getAllValues() {
        return super.getAllValues();
    }
}