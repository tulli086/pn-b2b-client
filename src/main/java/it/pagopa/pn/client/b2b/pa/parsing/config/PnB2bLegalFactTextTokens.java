package it.pagopa.pn.client.b2b.pa.parsing.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;


@Data
@Component
@ConfigurationProperties(prefix = "pn.pdf.configuration", ignoreUnknownFields = false)
public class PnB2bLegalFactTextTokens {
    private String startNomeCognomeRagioneSociale;
    private String endNomeCognomeRagioneSociale;

    private String startCodiceFiscale;
    private String endCodiceFiscale;

    private String startDomicilioDigitale;
    private String endDomicilioDigitale;

    private String startTipoDomicilioDigitale;
    private String endTipoDomicilioDigitale;

    private String startTipoDomicilioDigitaleNotificaDigitale;
    private String endTipoDomicilioDigitaleNotificaDigitale;

    private String startTipoDomicilioDigitaleNotificaPresaInCarico;
    private String endTipoDomicilioDigitaleNotificaPresaInCarico;

    private String startDataOraDecorrenza;
    private String endDataOraDecorrenza;

    private String startDataOraFine;
    private String endDataOraFine;

    private String startIun;
    private String endIun;

    private String startIunNotificaPresaInCarico;
    private String endIunNotificaPresaInCarico;

    private String startHash;
    private String endHash;

    private String startDataDestinatario;
    private String endDataDestinatario;

    private String startDataDelegato;
    private String endDataDelegato;

    private String startDataNotificaDigitale;
    private String endDataNotificaDigitale;

    private String startDataNotificaPresaInCarico;
    private String endDataNotificaPresaInCarico;

    private String startIndirizzoFisico;
    private String endIndirizzoFisico;

    private String startPrimaData;
    private String endPrimaData;

    private String startSecondaData;
    private String endSecondaData;

    private String startMittente;
    private String endMittente;

    private String startCfMittente;
    private String endCfMittente;
}