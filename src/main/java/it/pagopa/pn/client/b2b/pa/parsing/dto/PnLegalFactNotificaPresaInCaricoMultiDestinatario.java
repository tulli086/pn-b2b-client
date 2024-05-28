package it.pagopa.pn.client.b2b.pa.parsing.dto;

import it.pagopa.pn.client.b2b.pa.parsing.model.PnDestinatarioAnalogico;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


@Getter
@Setter
@SuperBuilder
public class PnLegalFactNotificaPresaInCaricoMultiDestinatario extends PnLegalFactNotificaPresaInCarico {
    private List<PnDestinatarioAnalogico> pnDestinatarioAnalogicoList;

    public PnLegalFactNotificaPresaInCaricoMultiDestinatario(String iun,
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
        super(iun, dataAttestazioneOpponibile, nomeCognomeRagioneSocialeDestinatario, codiceFiscaleDestinatario, domicilioDigitale, tipoDomicilioDigitale, indirizzoFisico, mittente, cfMittente, primaData, secondaData );
        this.pnDestinatarioAnalogicoList = new ArrayList<>();
    }


    public void addDestinatario(String nomeCognomeRagioneSocialeDestinatario,
                                String codiceFiscaleDestinatario,
                                String domicilioDigitale,
                                String tipoDomicilioDigitale,
                                String indirizzoFisico) {
        PnDestinatarioAnalogico pnDestinatarioAnalogico = new PnDestinatarioAnalogico(nomeCognomeRagioneSocialeDestinatario,
                codiceFiscaleDestinatario,
                domicilioDigitale,
                tipoDomicilioDigitale,
                indirizzoFisico);
        this.pnDestinatarioAnalogicoList.add(pnDestinatarioAnalogico);
    }

    @Override
    public Map<String, Object> getAllValues() {
        return super.getAllValues();
    }
}
