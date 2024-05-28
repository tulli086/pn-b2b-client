package it.pagopa.pn.client.b2b.pa.parsing.service;

import it.pagopa.pn.client.b2b.pa.parsing.model.IPnLegalFact;
import it.pagopa.pn.client.b2b.pa.parsing.model.PnLegalFact;
import lombok.Getter;

import java.io.IOException;


public interface IPnParserService {
    enum LegalFactType {
        LEGALFACT_NOTIFICA_DOWNTIME,
        LEGALFACT_NOTIFICA_DIGITALE,
        LEGALFACT_NOTIFICA_MANCATO_RECAPITO,
        LEGALFACT_NOTIFICA_PRESA_IN_CARICO,
        LEGALFACT_NOTIFICA_PRESA_IN_CARICO_MULTIDESTINATARIO,
        LEGALFACT_NOTIFICA_AVVENUTO_SUCCESSO,
        LEGALFACT_NOTIFICA_AVVENUTO_SUCCESSO_DELEGATO
    }

    @Getter
    enum LegalFactKeyValues {
        IUN("iun"),
        DATA("data"),
        NOME_COGNOME_RAGIONE_SOCIALE("nomeCognomeRagioneSociale"),
        DESTINATARIO_DIGITALE("destinatarioDigitale"),
        DESTINATARIO("destinatario");
        private final String field;

        LegalFactKeyValues(String field){
            this.field = field;
        }
    }
    String extractSingle(String source, String campo, LegalFactType legalFactType) throws IOException, NoSuchFieldException, IllegalAccessException;
    IPnLegalFact extractMulti(String source, LegalFactType legalFactType) throws IOException;
}