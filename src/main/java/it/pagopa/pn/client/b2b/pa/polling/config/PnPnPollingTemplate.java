package it.pagopa.pn.client.b2b.pa.polling.config;

import it.pagopa.pn.client.b2b.pa.service.IPnPollingService;
import lombok.Getter;
import java.util.function.Predicate;
import static java.util.concurrent.TimeUnit.MILLISECONDS;
import static org.awaitility.Awaitility.await;


@Getter
public abstract class PnPnPollingTemplate<T> implements IPnPollingService<T> {
    protected Integer atMost;
    protected Integer pollInterval;
    protected Integer pollDelay;

    public abstract T waitForEvent(String iun, String checkValue);
    protected T initialize(String iun, String checkValue) {
        return await()
        .atMost(getAtMost(), MILLISECONDS)
        .with()
        .pollInterval(getPollInterval(), MILLISECONDS)
        .pollDelay(getPollDelay(), MILLISECONDS)
        .ignoreExceptions()
        .until(() -> mapper(iun, checkValue), checkCondition(iun, checkValue));
    }

    protected abstract Predicate<T> checkCondition(String iun, String state);
    protected abstract T mapper(String iun, String state);
}