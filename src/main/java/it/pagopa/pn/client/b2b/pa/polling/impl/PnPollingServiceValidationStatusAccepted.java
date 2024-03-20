package it.pagopa.pn.client.b2b.pa.polling.impl;


import it.pagopa.pn.client.b2b.pa.config.PnB2bClientTimingConfigs;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NewNotificationRequestStatusResponseV23;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingStrategy;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingTemplate;
import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingResponseV23;
import it.pagopa.pn.client.b2b.pa.service.IPnPaB2bClient;
import it.pagopa.pn.client.b2b.pa.service.impl.PnPaB2bExternalClientImpl;
import org.springframework.stereotype.Service;

import java.util.concurrent.Callable;
import java.util.function.Predicate;
@Service(PnPollingStrategy.VALIDATION_STATUS_ACCEPTATION)
public class PnPollingServiceValidationStatusAccepted extends PnPollingTemplate<PnPollingResponseV23> {
    private final IPnPaB2bClient b2bClient;
    private NewNotificationRequestStatusResponseV23 requestStatusResponseV23;
    private final PnB2bClientTimingConfigs timingConfigs;
    private final PnPaB2bExternalClientImpl pnPaB2bExternalClient;

    public PnPollingServiceValidationStatusAccepted(IPnPaB2bClient b2bClient, PnB2bClientTimingConfigs timingConfigs, PnPaB2bExternalClientImpl pnPaB2bExternalClient) {
        this.b2bClient = b2bClient;
        this.timingConfigs = timingConfigs;
        this.pnPaB2bExternalClient = pnPaB2bExternalClient;
    }

    @Override
    protected Callable<PnPollingResponseV23> getPollingResponse(String id, String value) {
        return () -> {
            PnPollingResponseV23 pnPollingResponse = new PnPollingResponseV23();
            NewNotificationRequestStatusResponseV23 statusResponseV23 = b2bClient.getNotificationRequestStatus(id);
            pnPollingResponse.setStatusResponse(statusResponseV23);
            this.requestStatusResponseV23 = statusResponseV23;
            return pnPollingResponse;
        };
    }

    @Override
    protected Predicate<PnPollingResponseV23> checkCondition(String id, String value) {
        return (pnPollingResponse) -> {
            if(pnPollingResponse.getStatusResponse() == null) {
                pnPollingResponse.setResult(false);
                return false;
            }

            if(!pnPollingResponse.getStatusResponse().getNotificationRequestStatus().equalsIgnoreCase(value.trim())) {
                pnPollingResponse.setResult(false);
                return false;
            }
            pnPollingResponse.setResult(true);
            return true;
        };
    }

    @Override
    protected PnPollingResponseV23 getException(Exception exception) {
        PnPollingResponseV23 pollingResponse = new PnPollingResponseV23();
        pollingResponse.setStatusResponse(this.requestStatusResponseV23);
        pollingResponse.setResult(false);
        return pollingResponse;
    }

    @Override
    protected Integer getPollInterval(String value) {
        return timingConfigs.getWorkflowWaitAcceptedMillis();
    }

    @Override
    protected Integer getAtMost(String value) {
        return timingConfigs.getWaitingAcceptationNumCheck();
    }

    @Override
    public boolean setApiKeys(ApiKeyType apiKey) {
        return this.pnPaB2bExternalClient.setApiKeys(apiKey);
    }

    @Override
    public void setApiKey(String apiKeyString) {
        this.pnPaB2bExternalClient.setApiKey(apiKeyString);
    }

    @Override
    public ApiKeyType getApiKeySetted() {return this.pnPaB2bExternalClient.getApiKeySetted(); }

    protected PnB2bClientTimingConfigs getTimingConfigs(){
        return this.timingConfigs;
    }
}
