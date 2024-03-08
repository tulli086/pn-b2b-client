package it.pagopa.pn.client.b2b.pa.polling.design;

import it.pagopa.pn.client.b2b.pa.service.IPnPollingService;
import java.util.concurrent.Callable;
import java.util.function.Predicate;
import static java.util.concurrent.TimeUnit.MILLISECONDS;
import static org.awaitility.Awaitility.await;


public abstract class PnPollingTemplate<PnPollingResponse> implements IPnPollingService<PnPollingResponse> {
    public PnPollingResponse waitForEvent(String iun, String value, String apiKey) {
        return await()
        .atMost(getAtMost(value), MILLISECONDS)
        .with()
        .pollInterval(getPollInterval(value), MILLISECONDS)
        .ignoreExceptions()
        .until(getPollingResponse(iun, value, apiKey), checkCondition(iun, value));
    }

    protected abstract Predicate<PnPollingResponse> checkCondition(String iun, String value);
    protected abstract Callable<PnPollingResponse> getPollingResponse(String iun, String value, String apiKey);
    protected abstract Integer getPollInterval(String value);
    protected abstract Integer getAtMost(String value);
}