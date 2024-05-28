package it.pagopa.pn.client.b2b.pa.parsing.dto;

import it.pagopa.pn.client.b2b.pa.parsing.model.PnDestinatarioDigitale;
import lombok.Getter;
import lombok.experimental.SuperBuilder;
import org.apache.commons.lang3.tuple.Pair;


@Getter
@SuperBuilder
public class PnLegalFactNotificaAvvenutoSuccessoDelegato extends PnLegalFactNotificaAvvenutoSuccesso {
    private PnDestinatarioDigitale pnDelegato;

    public PnLegalFactNotificaAvvenutoSuccessoDelegato(String iun,
                                                       String data,
                                                       String nomeCognomeRagioneSocialeDestinatario,
                                                       String codiceFiscaleDestinatario,
                                                       String nomeCognomeRagioneSocialeDelegato,
                                                       String codiceFiscaleDelegato) {
        super(nomeCognomeRagioneSocialeDestinatario, codiceFiscaleDestinatario, iun, data);
        this.pnDelegato = new PnDestinatarioDigitale(nomeCognomeRagioneSocialeDelegato, codiceFiscaleDelegato);
    }

    private Pair<PnDestinatarioDigitale, PnDestinatarioDigitale> getDestinatarioAndDelegato() {
        return Pair.of(super.getPnDestinatarioDigitale(), pnDelegato);
    }
}