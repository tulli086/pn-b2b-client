package it.pagopa.pn.client.b2b.pa.parsing.service;

import it.pagopa.pn.client.b2b.pa.parsing.dto.PnLegalFact;
import java.io.IOException;
import java.util.HashMap;


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

    String extractSingle(String source, String campo, LegalFactType legalFactType) throws IOException;
    HashMap<String, String> extractMulti(String source, LegalFactType legalFactType) throws IOException;
}