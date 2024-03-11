package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.FullSentNotification;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingStrategy;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingTemplate;
import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingResponse;
import it.pagopa.pn.client.b2b.pa.utils.TimingForTimeline;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.concurrent.Callable;
import java.util.function.Predicate;


@AllArgsConstructor
@Service(PnPollingStrategy.TIMELINE_SLOW_OLD_VERSION)
public class PnPollingServiceTimelineSlowOldVersion extends PnPollingTemplate<PnPollingResponse<FullSentNotification>> {
    private final TimingForTimeline timingForTimeline;

    @Override
    public PnPollingResponse<FullSentNotification> waitForEvent(String iun, String value) {
        return super.waitForEvent(iun, value);
    }

    @Override
    protected Predicate<PnPollingResponse<FullSentNotification>> checkCondition(String iun, String value) {
        //Example use v1 for check
        return null;
    }

    @Override
    protected Callable<PnPollingResponse<FullSentNotification>> getPollingResponse(String iun, String value) {
        return null;
    }

    @Override
    protected Integer getAtMost(String value) {
        TimingForTimeline.TimingResult timingResult = timingForTimeline.getTimingForElement(value);
        return timingResult.waiting() * timingResult.numCheck();
    }

    @Override
    protected Integer getPollInterval(String value) {
        TimingForTimeline.TimingResult timingResult = timingForTimeline.getTimingForElement(value);
        return timingResult.waiting();
    }

    @Override
    public boolean setApiKeys(ApiKeyType apiKey) {
        return false;
    }

    @Override
    public void setApiKey(String apiKey) {

    }

    @Override
    public ApiKeyType getApiKeySetted() {
        return null;
    }
}