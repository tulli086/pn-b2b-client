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
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
public class PnDestinatario {
    private String nomeCognomeRagioneSocialeDestinatario;
    private String codiceFiscaleDestinatario;


    public Map<String, Object> getAllValues() {
        return new HashMap<>() {{
            put("nomeCognomeRagioneSocialeDestinatario", nomeCognomeRagioneSocialeDestinatario);
            put("codiceFiscaleDestinatario", codiceFiscaleDestinatario);
        }};
    }
}