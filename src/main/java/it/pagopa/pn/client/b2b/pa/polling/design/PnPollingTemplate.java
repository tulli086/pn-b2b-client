package it.pagopa.pn.client.b2b.pa.polling.design;

import it.pagopa.pn.client.b2b.pa.service.IPnPollingService;
import lombok.Getter;
import java.util.function.Predicate;
import static java.util.concurrent.TimeUnit.MILLISECONDS;
import static org.awaitility.Awaitility.await;


@Getter
public abstract class PnPollingTemplate<T> implements IPnPollingService<T> {
    protected Integer atMost;
    protected Integer pollInterval;
    protected Integer pollDelay;

    public abstract T waitForEvent(String iun, String value);
    protected T initialize(String iun, String value) {
        return await()
        .atMost(getAtMost(), MILLISECONDS)
        .with()
        .pollInterval(getPollInterval(), MILLISECONDS)
        .pollDelay(getPollDelay(), MILLISECONDS)
        .ignoreExceptions()
        .until(() -> getPollingResponse(iun, value), checkCondition(iun, value));
    }

    protected abstract Predicate<T> checkCondition(String iun, String value);
    protected abstract T getPollingResponse(String iun, String value);
}