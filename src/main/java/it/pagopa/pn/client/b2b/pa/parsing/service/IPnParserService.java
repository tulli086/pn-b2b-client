package it.pagopa.pn.client.b2b.pa.parsing.service;

import it.pagopa.pn.client.b2b.pa.parsing.design.IPnLegalFact;
import lombok.Getter;
import java.io.IOException;


public interface IPnParserService {
    enum LegalFactType {
        LEGALFACT_NOTIFICA_DOWNTIME,
        LEGALFACT_NOTIFICA_DIGITALE,
        LEGALFACT_NOTIFICA_MANCATO_RECAPITO,
        LEGALFACT_NOTIFICA_PRESA_IN_CARICO,
        LEGALFACT_NOTIFICA_PRESA_IN_CARICO_MULTIDESTINATARIO,
        LEGALFACT_NOTIFICA_AVVENUTO_ACCESSO,
        LEGALFACT_NOTIFICA_AVVENUTO_ACCESSO_DELEGATO
    }

    @Getter
    enum LegalFactKeyValues {
        IUN("iun"),
        DATA_ATTESTAZIONE_OPPONIBILE("dataAttestazioneOpponibile"),
        NOME_COGNOME_RAGIONE_SOCIALE("nomeCognomeRagioneSociale"),
        CODICE_FISCALE("codiceFiscale"),
        DOMICILIO_DIGITALE("domicilioDigitale"),
        TIPO_DOMICILIO_DIGITALE("tipoDomicilioDigitale"),
        INDIRIZZO_FISICO("indirizzoFisico"),
        MITTENTE("mittente"),
        CF_MITTENTE("cfMittente"),
        PRIMA_DATA("primaData"),
        SECONDA_DATA("secondaData"),
        DATA_ORA_DECORRENZA("dataOraDecorrenza"),
        DATA_ORA_FINE("dataOraFine");

        private final String field;

        LegalFactKeyValues(String field){
            this.field = field;
        }
    }
    String extractSingleField(String source, String field, LegalFactType legalFactType) throws IOException, NoSuchFieldException, IllegalAccessException;
    IPnLegalFact extractAllField(String source, LegalFactType legalFactType) throws IOException;
}