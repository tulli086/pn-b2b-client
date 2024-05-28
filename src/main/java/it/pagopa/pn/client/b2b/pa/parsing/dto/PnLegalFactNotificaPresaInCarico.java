package it.pagopa.pn.client.b2b.pa.parsing.dto;

import it.pagopa.pn.client.b2b.pa.parsing.model.PnDestinatarioAnalogico;
import it.pagopa.pn.client.b2b.pa.parsing.model.PnLegalFact;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import java.util.Map;


@Getter
@Setter
@SuperBuilder
public class PnLegalFactNotificaPresaInCarico extends PnLegalFact {
    private String indirizzoFisico;
    private String mittente;
    private String cfMittente;
    private String primaData;
    private String secondaData;

    public PnLegalFactNotificaPresaInCarico(String iun,
                                            String dataAttestazioneOpponibile,
                                            String nomeCognomeRagioneSocialeDestinatario,
                                            String codiceFiscaleDestinatario,
                                            String domicilioDigitale,
                                            String tipoDomicilioDigitale,
                                            String indirizzoFisico,
                                            String mittente,
                                            String cfMittente,
                                            String primaData,
                                            String secondaData) {
        super(new PnDestinatarioAnalogico(nomeCognomeRagioneSocialeDestinatario, codiceFiscaleDestinatario, domicilioDigitale, tipoDomicilioDigitale, indirizzoFisico), iun, dataAttestazioneOpponibile);
        this.indirizzoFisico = indirizzoFisico;
        this.mittente = mittente;
        this.cfMittente = cfMittente;
        this.primaData = primaData;
        this.secondaData = secondaData;
    }


    public Map<String, Object> getAllValues() {
        return super.getAllValues();
    }
}