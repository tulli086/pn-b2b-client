package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.FullSentNotificationV23;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementV23;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingTemplate;
import it.pagopa.pn.client.b2b.pa.polling.mapper.PnGenericFullSentNotificationMapper;
import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingResponse;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingStrategy;
import it.pagopa.pn.client.b2b.pa.utils.TimingForTimeline;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.function.Predicate;


@AllArgsConstructor
@Service(PnPollingStrategy.TIMELINE_RAPID_NEW_VERSION)
public class PnPollingServiceTimelineRapidNewVersion extends PnPollingTemplate<PnPollingResponse> {
    private final TimingForTimeline timingForTimeline;
    private final PnPaB2bUtils pnPaB2bUtils;
    private final PnGenericFullSentNotificationMapper pnGenericFullSentNotificationMapper;


    @Override
    protected Predicate<PnPollingResponse> checkCondition(String iun, String value) {
        return (pnPollingResponse) -> {
            List<TimelineElementV23> isPresentCategory = pnPollingResponse
                    .getPnGenericFullSentNotification()
                    .getTimeline()
                    .stream()
                    .filter(timelineElementV23 -> timelineElementV23.getCategory()
                            .getValue().equals(value))
                    .toList();

            if(pnPollingResponse.getPnGenericFullSentNotification().getTimeline().isEmpty() ||
                    isPresentCategory.isEmpty()) {
                pnPollingResponse.setResult(false);
                return false;
            }

            pnPollingResponse.setResult(true);
            return true;
        };
    }

    @Override
    public PnPollingResponse getPollingResponse(String iun, String value) {
        //Example use v2.3 for check
        FullSentNotificationV23 fullSentNotificationV23 = pnPaB2bUtils.getNotificationByIun(iun);
        return PnPollingResponse.builder()
                .pnGenericFullSentNotification(pnGenericFullSentNotificationMapper.mapToGeneric(fullSentNotificationV23))
                .build();
    }

    @Override
    public PnPollingResponse waitForEvent(String iun, String value) {
        return this.initialize(iun, value);
    }

    protected PnPollingResponse initialize(String iun, String value) {
        TimingForTimeline.TimingResult timingResult = timingForTimeline.getTimingForElement(value);
        super.pollDelay = 0;
        super.atMost = timingResult.waiting();
        super.pollDelay = timingResult.waiting() * timingResult.numCheck();
        return super.initialize(iun, value);
    }
}