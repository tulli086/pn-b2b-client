package it.pagopa.pn.client.b2b.pa.parsing.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import java.util.HashMap;
import java.util.Map;


@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class PnDestinatarioAnalogico extends PnDestinatarioDigitale {
    private String indirizzoFisico;

    public PnDestinatarioAnalogico(String nomeCognomeRagioneSociale,
                                   String codiceFiscale,
                                   String domicilioDigitale,
                                   String tipoDomicilioDigitale,
                                   String indirizzoFisico) {
        super(nomeCognomeRagioneSociale, codiceFiscale, domicilioDigitale, tipoDomicilioDigitale);
        this.indirizzoFisico = indirizzoFisico;
    }

    public Map<String, Object> getAllValues() {
        return new HashMap<>() {{
            putAll(PnDestinatarioAnalogico.super.getAllValues());
            put("indirizzoFisico", indirizzoFisico);
        }};
    }
}
