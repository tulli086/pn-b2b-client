package it.pagopa.pn.client.b2b.pa.polling.impl;

import it.pagopa.pn.client.b2b.pa.config.PnB2bClientTimingConfigs;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingStrategy;
import it.pagopa.pn.client.b2b.pa.service.IPnPaB2bClient;
import it.pagopa.pn.client.b2b.pa.service.impl.PnPaB2bExternalClientImpl;
import org.springframework.stereotype.Service;

@Service(PnPollingStrategy.VALIDATION_STATUS_NO_ACCEPTATION)
public class PnPollingServiceValidationStatusNoAccepted extends PnPollingServiceValidationStatusAccepted{
    public PnPollingServiceValidationStatusNoAccepted(IPnPaB2bClient b2bClient, PnB2bClientTimingConfigs timingConfigs, PnPaB2bExternalClientImpl pnPaB2bExternalClient) {
        super(b2bClient, timingConfigs, pnPaB2bExternalClient);
    }

    @Override
    protected Integer getAtMost(String value) {
        return this.getTimingConfigs().getWaitingNoAcceptationNumCheck();
    }
}
