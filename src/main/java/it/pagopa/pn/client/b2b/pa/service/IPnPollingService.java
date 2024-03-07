package it.pagopa.pn.client.b2b.pa.service;


public interface IPnPollingService<PnPollingResponse> {
    PnPollingResponse waitForEvent(String iun, String checkValue);
}