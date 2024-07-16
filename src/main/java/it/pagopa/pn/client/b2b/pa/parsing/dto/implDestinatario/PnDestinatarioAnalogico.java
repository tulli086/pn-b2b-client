package it.pagopa.pn.client.b2b.pa.parsing.dto.implDestinatario;

import it.pagopa.pn.client.b2b.pa.parsing.dto.PnParserRecord;
import it.pagopa.pn.client.b2b.pa.parsing.parser.IPnParserLegalFact;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;


@Setter
@Getter
@SuperBuilder
@NoArgsConstructor
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

    @Override
    public PnParserRecord.PnParserFieldValues getAllDestinatarioValues() {
        PnParserRecord.PnParserFieldValues parserFieldValues = super.getAllDestinatarioValues();
        parserFieldValues.fieldValue().put(IPnParserLegalFact.LegalFactField.DESTINATARIO_INDIRIZZO_FISICO, indirizzoFisico);
        return parserFieldValues;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (object == null || getClass() != object.getClass()) return false;
        if (!super.equals(object)) return false;
        PnDestinatarioAnalogico that = (PnDestinatarioAnalogico) object;
        return Objects.equals(indirizzoFisico, that.indirizzoFisico);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), indirizzoFisico);
    }

    @Override
    public String toString() {
        return super.toString()
                + ", indirizzoFisico=" + indirizzoFisico
                + ")";
    }

    public static List<PnDestinatarioAnalogico> mapToDestinatarioAnalogico(List<Map<String, String>> listOfMap) {
        List<PnDestinatarioAnalogico> mappedList = new ArrayList<>();
        List<Map<String, String>> observedList = new ArrayList<>();
        PnDestinatarioAnalogico destinatarioAnalogico = new PnDestinatarioAnalogico();

        for(Map<String, String> mappa: listOfMap) {
            boolean containsDestinatario = mappa.keySet().stream().anyMatch(key -> key.contains(IPnParserLegalFact.DESTINATARIO));
            if(!observedList.isEmpty()) {
                boolean isDuplicate = observedList.stream().anyMatch(map -> map.keySet().containsAll(mappa.keySet()));
                if(isDuplicate) {
                    mappedList.add(destinatarioAnalogico);
                    observedList.clear();
                    destinatarioAnalogico = new PnDestinatarioAnalogico();
                }
            }
            if(containsDestinatario) {
                observedList.add(mappa);
                for(String key: mappa.keySet()) {
                    String value = mappa.get(key);
                    if(key.equals(IPnParserLegalFact.LegalFactField.DESTINATARIO_NOME_COGNOME_RAGIONE_SOCIALE.name())) {
                        destinatarioAnalogico.setNomeCognomeRagioneSociale(value);
                    } else if(key.equals(IPnParserLegalFact.LegalFactField.DESTINATARIO_CODICE_FISCALE.name())) {
                        destinatarioAnalogico.setCodiceFiscale(value);
                    } else if(key.equals(IPnParserLegalFact.LegalFactField.DESTINATARIO_DOMICILIO_DIGITALE.name())) {
                        destinatarioAnalogico.setDomicilioDigitale(value);
                    } else if(key.equals(IPnParserLegalFact.LegalFactField.DESTINATARIO_TIPO_DOMICILIO_DIGITALE.name())) {
                        destinatarioAnalogico.setTipoDomicilioDigitale(value);
                    } else if(key.equals(IPnParserLegalFact.LegalFactField.DESTINATARIO_INDIRIZZO_FISICO.name())) {
                        destinatarioAnalogico.setIndirizzoFisico(value);
                    }
                }
            }
        }
        if(!observedList.isEmpty()) {
            mappedList.add(destinatarioAnalogico);
        }
        return mappedList;
    }
}