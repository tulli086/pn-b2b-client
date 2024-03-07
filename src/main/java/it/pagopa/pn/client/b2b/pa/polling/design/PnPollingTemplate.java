package it.pagopa.pn.client.b2b.pa.polling.design;

import it.pagopa.pn.client.b2b.pa.service.IPnPollingService;
import lombok.Getter;
import java.util.function.Predicate;
import static java.util.concurrent.TimeUnit.MILLISECONDS;
import static org.awaitility.Awaitility.await;


@Getter
public abstract class PnPollingTemplate<PnPollingResponse> implements IPnPollingService<PnPollingResponse> {
    protected Integer atMost;
    protected Integer pollInterval;
    protected Integer pollDelay;

    public abstract PnPollingResponse waitForEvent(String iun, String value);
    protected PnPollingResponse initialize(String iun, String value) {
        return await()
        .atMost(getAtMost(), MILLISECONDS)
        .with()
        .pollInterval(getPollInterval(), MILLISECONDS)
        .pollDelay(getPollDelay(), MILLISECONDS)
        .ignoreExceptions()
        .until(() -> getPollingResponse(iun, value), checkCondition(iun, value));
    }

    protected abstract Predicate<PnPollingResponse> checkCondition(String iun, String value);
    protected abstract PnPollingResponse getPollingResponse(String iun, String value);
}