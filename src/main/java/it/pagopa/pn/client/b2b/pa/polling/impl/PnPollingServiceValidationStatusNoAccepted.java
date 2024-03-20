package it.pagopa.pn.client.b2b.pa.polling.impl;

import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingStrategy;
import it.pagopa.pn.client.b2b.pa.service.IPnPaB2bClient;
import it.pagopa.pn.client.b2b.pa.utils.TimingForTimeline;
import org.springframework.stereotype.Service;

@Service(PnPollingStrategy.VALIDATION_STATUS_NO_ACCEPTATION)
public class PnPollingServiceValidationStatusNoAccepted extends PnPollingServiceValidationStatus {


    public PnPollingServiceValidationStatusNoAccepted(IPnPaB2bClient b2bClient, TimingForTimeline timingForTimeline) {
        super(b2bClient, timingForTimeline);
    }

    @Override
    protected Integer getAtMost(String value) {
        value = value.replace(value, "NO_ACCEPTED_VALIDATION");
        TimingForTimeline.TimingResult timingResult = this.getTimingForTimeline().getTimingForStatusValidation(value);
        return timingResult.numCheck();
    }
}
