package it.pagopa.pn.client.b2b.pa.service;

public interface IPnPollingService<T> {
    T waitForEvent(String iun, String checkValue);
}