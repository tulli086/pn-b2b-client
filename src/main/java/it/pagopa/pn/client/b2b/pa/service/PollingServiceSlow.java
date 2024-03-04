package it.pagopa.pn.client.b2b.pa.service;

import org.springframework.stereotype.Service;

@Service(PollingStrategy.OLD_VERSION_SLOW)
public class PollingServiceSlow extends PollingTemplate{

    @Override
    public String getMessage() {
        return "TEST CODICE: OLD_VERSION_SLOW";
    }
}
