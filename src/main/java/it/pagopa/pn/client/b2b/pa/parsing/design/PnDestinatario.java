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
public class PnDestinatario {
    private String nomeCognomeRagioneSociale;
    private String codiceFiscale;


    public PnDestinatario(String nomeCognomeRagioneSociale,
                          String codiceFiscale) {
        this.nomeCognomeRagioneSociale = nomeCognomeRagioneSociale;
        this.codiceFiscale = codiceFiscale;
    }

    public Map<String, Object> getAllValues() {
        Map<String, Object> map = new HashMap<>();
        map.put("nomeCognomeRagioneSociale", nomeCognomeRagioneSociale);
        map.put("codiceFiscale", codiceFiscale);
        return map;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;
        PnDestinatario that = (PnDestinatario) object;
        return Objects.equals(nomeCognomeRagioneSociale, that.nomeCognomeRagioneSociale)
                && Objects.equals(codiceFiscale, that.codiceFiscale);
    }

    @Override
    public int hashCode() {
        return Objects.hash(nomeCognomeRagioneSociale, codiceFiscale);
    }
}