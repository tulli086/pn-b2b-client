package it.pagopa.pn.client.b2b.pa.service;

import it.pagopa.pn.client.b2b.pa.service.PollingService;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class PollingFactory {

    private final Map<String, PollingService> pollingServiceMap;


    public PollingFactory(Map<String, PollingService> pollingServiceMap) {
        this.pollingServiceMap = pollingServiceMap;
    }

    public PollingService getPollingService(String pollingType) {
        PollingService pollingService = pollingServiceMap.get(pollingType);
        if (pollingService == null) {
            throw new RuntimeException("Unsupported pollingService type");
        }

        return pollingService;
    }

    public void execute(String pollingType /*PARAMETRIZE*/) {
        PollingService pollingService = pollingServiceMap.get(pollingType);
        if (pollingService == null) {
            throw new RuntimeException("Unsupported pollingService type");
        }
        pollingService.waitForEvent(/*PARAMETRIZE*/);
    }



}
