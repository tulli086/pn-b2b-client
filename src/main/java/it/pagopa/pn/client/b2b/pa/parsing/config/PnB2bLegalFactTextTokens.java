package it.pagopa.pn.client.b2b.pa.parsing.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;


@Data
@Component
@ConfigurationProperties(prefix = "pn.pdf.configuration", ignoreUnknownFields = false)
public class PnB2bLegalFactTextTokens {
    private String nomeCognomeRagioneSociale;
    private String nomeCognomeRagioneSocialeDestinatario;
    private String startNomeCognomeRagioneSocialeDelegato;
    private String endNomeCognomeRagioneSocialeDelegato;
    private String codiceFiscale;
    private String domicilioDigitale;
    private String tipoDomicilioDigitale;
    private String dataOraDecorrenza;
    private String dataOraFine;
    private String iun;
    private String dataNotificaDigitale;
    private String indirizzoFisico;
    private String primaData;
    private String secondaData;
    private String mittente;
    private String cfMittente;
}