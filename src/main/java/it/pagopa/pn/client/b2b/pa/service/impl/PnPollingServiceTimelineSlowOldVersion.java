package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.FullSentNotification;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingStrategy;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingTemplate;
import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingResponse;
import org.springframework.stereotype.Service;
import java.util.concurrent.Callable;
import java.util.function.Predicate;


@Service(PnPollingStrategy.TIMELINE_SLOW_OLD_VERSION)
public class PnPollingServiceTimelineSlowOldVersion extends PnPollingTemplate<PnPollingResponse<FullSentNotification>> {

    @Override
    public PnPollingResponse<FullSentNotification> waitForEvent(String iun, String value) {
        return null;
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
}