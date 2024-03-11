package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.FullSentNotificationV23;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementV23;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingStrategy;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingTemplate;
import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingResponse;
import it.pagopa.pn.client.b2b.pa.utils.TimingForTimeline;
import lombok.AllArgsConstructor;
import org.awaitility.core.ConditionTimeoutException;
import org.springframework.stereotype.Service;
import java.util.concurrent.Callable;
import java.util.function.Predicate;


@AllArgsConstructor
@Service(PnPollingStrategy.TIMELINE_RAPID_NEW_VERSION)
public class PnPollingServiceTimelineRapidNewVersion extends PnPollingTemplate<PnPollingResponse<FullSentNotificationV23>> {
    private final TimingForTimeline timingForTimeline;
    private final PnPaB2bExternalClientImpl pnPaB2bExternalClient;

    @Override
    protected Predicate<PnPollingResponse<FullSentNotificationV23>> checkCondition(String iun, String value) {
        return (pnPollingResponse) -> {
            if(pnPollingResponse.getPnGenericFullSentNotification() == null) {
                pnPollingResponse.setResult(false);
                return false;
            }

            TimelineElementV23 isPresentCategory = pnPollingResponse
                    .getPnGenericFullSentNotification()
                    .getTimeline()
                    .stream()
                    .filter(timelineElementV23 -> timelineElementV23.getCategory()
                            .getValue().equals(value))
                    .findAny()
                    .orElse(null);

            if(pnPollingResponse.getPnGenericFullSentNotification().getTimeline().isEmpty() ||
                    isPresentCategory == null) {
                pnPollingResponse.setResult(false);
                return false;
            }
            pnPollingResponse.setResult(true);
            return true;
        };
    }

    @Override
    public Callable<PnPollingResponse<FullSentNotificationV23>> getPollingResponse(String iun, String value) {
        return () -> {
            //Example use v2.3 for check
            PnPollingResponse<FullSentNotificationV23> pnPollingResponse = new PnPollingResponse<>();
            FullSentNotificationV23 fullSentNotificationV23 = pnPaB2bExternalClient.getSentNotification(iun);
            pnPollingResponse.setPnGenericFullSentNotification(fullSentNotificationV23);
            return pnPollingResponse;
        };
    }

    @Override
    public PnPollingResponse<FullSentNotificationV23> waitForEvent(String iun, String value) {
        try{
            return super.waitForEvent(iun, value);
        } catch (ConditionTimeoutException conditionTimeoutException) {
            //Eseguo il catch nel caso in cui checkCondition() non ritornerà mai true
            PnPollingResponse<FullSentNotificationV23> pollingResponse = new PnPollingResponse<>();
            pollingResponse.setResult(false);
            return pollingResponse;
        }
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
        return this.pnPaB2bExternalClient.setApiKeys(apiKey);
    }

    @Override
    public void setApiKey(String apiKeyString) {
        this.pnPaB2bExternalClient.setApiKey(apiKeyString);
    }

    @Override
    public ApiKeyType getApiKeySetted() {
        return this.pnPaB2bExternalClient.getApiKeySetted();
    }
}