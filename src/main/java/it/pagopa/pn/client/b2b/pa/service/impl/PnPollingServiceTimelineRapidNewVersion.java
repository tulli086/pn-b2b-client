package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.FullSentNotificationV23;
import it.pagopa.pn.client.b2b.pa.polling.config.PnPnPollingTemplate;
import it.pagopa.pn.client.b2b.pa.polling.strategy.PnPollingStrategy;
import it.pagopa.pn.client.b2b.pa.utils.TimingForTimeline;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.function.Predicate;


@AllArgsConstructor
@Service(PnPollingStrategy.TIMELINE_RAPID_NEW_VERSION)
public class PnPollingServiceTimelineRapidNewVersion extends PnPnPollingTemplate<FullSentNotificationV23> {
    private final TimingForTimeline timingForTimeline;
    private final PnPaB2bUtils pnPaB2bUtils;


    @Override
    protected Predicate<FullSentNotificationV23> checkCondition(String iun, String state) {
        return (fullSentNotificationV23) -> {
            if(!fullSentNotificationV23.getTimeline().isEmpty()) {
                return false;
            }
            return true;
        };
    }

    @Override
    public FullSentNotificationV23 mapper(String iun, String category) {
        //Example use v2.3 for check
        return pnPaB2bUtils.getNotificationByIun(iun);
    }

    @Override
    public FullSentNotificationV23 waitForEvent(String iun, String checkValue) {
        return this.initialize(iun, checkValue);
    }

    protected FullSentNotificationV23 initialize(String iun, String checkValue) {
        TimingForTimeline.TimingResult timingResult = timingForTimeline.getTimingForElement(checkValue);
        super.pollDelay = 0;
        super.atMost = timingResult.waiting();
        super.pollDelay = timingResult.waiting() * timingResult.numCheck();
        return super.initialize(iun, checkValue);
    }
}