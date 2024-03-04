package it.pagopa.pn.client.b2b.pa.service;

import org.springframework.stereotype.Service;

@Service(PollingStrategy.RAPID_NEW_VERSION)
public class PollingStrategyRepid extends PollingTemplate{


    @Override
    String getMessage() {
        return "TEST CODICE: RAPID_NEW_VERSION";
    }
}
