package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.FullSentNotificationV23;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingTemplate;
import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingResponse;

import java.util.function.Predicate;


//@Service(PnPollingStrategy.TIMELINE_SLOW)
public class PnPollingServiceTimelineSlowOldVersion extends PnPollingTemplate<PnPollingResponse<FullSentNotificationV23>> {

    @Override
    public PnPollingResponse<FullSentNotificationV23> waitForEvent(String iun, String value) {
        return null;
    }

    @Override
    protected Predicate<PnPollingResponse<FullSentNotificationV23>> checkCondition(String iun, String value) {
        //Example use v1 for check
        return null;
    }

    @Override
    protected PnPollingResponse<FullSentNotificationV23> getPollingResponse(String iun, String value) {
        return null;
    }
}