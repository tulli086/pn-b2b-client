package it.pagopa.pn.client.b2b.pa.service;


import it.pagopa.pn.client.b2b.pa.service.utils.SettableApiKey;

public interface IPnPollingService<PnPollingResponse> extends SettableApiKey {
    PnPollingResponse waitForEvent(String iun, String checkValue);
}