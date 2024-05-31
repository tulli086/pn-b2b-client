package it.pagopa.pn.client.b2b.pa.parsing.design;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;


@ToString
@Setter
@Getter
@SuperBuilder
@NoArgsConstructor
public class PnDestinatarioDigitale extends PnDestinatario {
    private String domicilioDigitale;
    private String tipoDomicilioDigitale;


    public PnDestinatarioDigitale(String nomeCognomeRagioneSociale,
                                  String codiceFiscale,
                                  String domicilioDigitale,
                                  String tipoDomicilioDigitale) {
        super(nomeCognomeRagioneSociale, codiceFiscale);
        this.domicilioDigitale = domicilioDigitale;
        this.tipoDomicilioDigitale = tipoDomicilioDigitale;
    }

    public PnDestinatarioDigitale(String nomeCognomeRagioneSociale, String codiceFiscale) {
        super(nomeCognomeRagioneSociale, codiceFiscale);
    }

    @Override
    public Map<String, Object> getAllValues() {
        Map<String, Object> map = new HashMap<>(super.getAllValues());
        map.put("domicilioDigitale", domicilioDigitale);
        map.put("tipoDomicilioDigitale", tipoDomicilioDigitale);
        return map;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;
        PnDestinatarioDigitale that = (PnDestinatarioDigitale) object;
        return Objects.equals(domicilioDigitale, that.domicilioDigitale)
                && Objects.equals(tipoDomicilioDigitale, that.tipoDomicilioDigitale);
    }

    @Override
    public int hashCode() {
        return Objects.hash(domicilioDigitale, tipoDomicilioDigitale);
    }
}