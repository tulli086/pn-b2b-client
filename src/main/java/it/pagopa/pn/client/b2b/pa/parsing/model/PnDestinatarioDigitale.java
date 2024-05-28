package it.pagopa.pn.client.b2b.pa.parsing.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import java.util.HashMap;
import java.util.Map;


@Setter
@Getter
@SuperBuilder
@NoArgsConstructor
public class PnDestinatarioDigitale extends PnDestinatario {
    private String domicilioDigitale;
    private String tipoDomicilioDigitale;

    public PnDestinatarioDigitale(String nomeCognomeRagioneSociale, String codiceFiscale, String domicilioDigitale, String tipoDomicilioDigitale) {
        super(nomeCognomeRagioneSociale, codiceFiscale);
        this.domicilioDigitale = domicilioDigitale;
        this.tipoDomicilioDigitale = tipoDomicilioDigitale;
    }

    public PnDestinatarioDigitale(String nomeCognomeRagioneSociale, String codiceFiscale) {
        super(nomeCognomeRagioneSociale, codiceFiscale);
    }

    public Map<String, Object> getAllValues() {
        return new HashMap<>() {{
            putAll(PnDestinatarioDigitale.super.getAllValues());
            put("domicilioDigitale", domicilioDigitale);
            put("tipoDomicilioDigitale", tipoDomicilioDigitale);
        }};
    }
}