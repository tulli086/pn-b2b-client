package it.pagopa.pn.client.b2b.pa.polling.impl;

import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingStrategy;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingTemplate;
import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingParameter;
import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingResponseV20;
import it.pagopa.pn.client.b2b.pa.polling.exception.PnPollingException;
import it.pagopa.pn.client.b2b.pa.service.IPnWebhookB2bClient;
import it.pagopa.pn.client.b2b.pa.utils.TimingForPolling;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2.ProgressResponseElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import java.lang.invoke.MethodHandles;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.Callable;
import java.util.function.Predicate;


@Service(PnPollingStrategy.WEBHOOK_V20)
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class PnPollingServiceWebhookV20 extends PnPollingTemplate<PnPollingResponseV20> {
    private static final Logger logger = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private final IPnWebhookB2bClient webhookB2bClient;
    private final TimingForPolling timingForPolling;
    private List<ProgressResponseElement> progressResponseElementListV20;
    private int retryAfter;
    private String iun;


    public PnPollingServiceWebhookV20(TimingForPolling timingForPolling, IPnWebhookB2bClient webhookB2bClient) {
        this.timingForPolling = timingForPolling;
        this.webhookB2bClient = webhookB2bClient;
    }

    @Override
    protected Callable<PnPollingResponseV20> getPollingResponse(String iun, PnPollingParameter pnPollingParameter) {
        this.iun = iun;
        return () -> {
            PnPollingResponseV20 pnPollingResponse = new PnPollingResponseV20();
            ResponseEntity<List<ProgressResponseElement>> listResponseEntity;
            int deepCount = pnPollingParameter.getDeepCount();

            try {
                ++deepCount;
                pnPollingParameter.setDeepCount(deepCount);
                listResponseEntity = webhookB2bClient.consumeEventStreamHttp(pnPollingParameter.getStreamId(), pnPollingParameter.getLastEventId());
                retryAfter = Integer.parseInt(Objects.requireNonNull(listResponseEntity.getHeaders().get("retry-after")).get(0));
                progressResponseElementListV20 = listResponseEntity.getBody();
                pnPollingResponse.setProgressResponseElementListV20(listResponseEntity.getBody());
                logger.info("ELEMENTI NEL WEBHOOK: " + Objects.requireNonNull(progressResponseElementListV20));
                if(deepCount >= 250) {
                    throw new PnPollingException("LOP: PROGRESS-ELEMENTS: "+ progressResponseElementListV20
                            +" WEBHOOK: "+ pnPollingParameter.getStreamId() +" IUN: "+ iun +" DEEP: "+deepCount);
                }
            } catch (IllegalStateException illegalStateException) {
                if(deepCount == 249 || deepCount == 248 || deepCount == 247){
                    throw new PnPollingException((illegalStateException.getMessage()+("LOP: PROGRESS-ELEMENTS: "+ progressResponseElementListV20
                            +" WEBHOOK: "+ pnPollingParameter.getStreamId() +" IUN: "+ iun +" DEEP: " + deepCount)));
                } else {
                    throw illegalStateException;
                }
            }
            return pnPollingResponse;
        };
    }

    @Override
    protected Predicate<PnPollingResponseV20> checkCondition(String iun, PnPollingParameter pnPollingParameter) {
        return (pnPollingResponse) -> {
            if(pnPollingResponse.getProgressResponseElementListV20() == null
                    || pnPollingResponse.getProgressResponseElementListV20().isEmpty()) {
                pnPollingResponse.setResult(false);
                return false;
            }

            selectLastEventId(pnPollingParameter);
            if(!isWaitTerminated(pnPollingResponse, pnPollingParameter)) {
                pnPollingResponse.setResult(false);
                return false;
            }

            pnPollingResponse.setResult(true);
            return true;
        };
    }

    @Override
    protected PnPollingResponseV20 getException(Exception exception) {
        PnPollingResponseV20 pollingResponse = new PnPollingResponseV20();
        pollingResponse.setResult(false);
        return pollingResponse;
    }

    @Override
    protected Integer getPollInterval(String value) {
        TimingForPolling.TimingResult timingResult = timingForPolling.getTimingForElement(value, true);
        return timingResult.waiting();
    }

    @Override
    protected Integer getAtMost(String value)  {
        TimingForPolling.TimingResult timingResult = timingForPolling.getTimingForElement(value, true);
        return timingResult.numCheck();
    }

    @Override
    public boolean setApiKeys(ApiKeyType apiKey) {
        return this.webhookB2bClient.setApiKeys(apiKey);
    }

    @Override
    public void setApiKey(String apiKeyString) {
        this.webhookB2bClient.setApiKey(apiKeyString);
    }

    @Override
    public ApiKeyType getApiKeySetted() {
        return this.webhookB2bClient.getApiKeySetted();
    }

    private boolean isWaitTerminated(PnPollingResponseV20 pnPollingResponse, PnPollingParameter pnPollingParameter) {
        ProgressResponseElement progressResponseElementV20 = progressResponseElementListV20
                .stream()
                .filter(toCheckCondition(pnPollingParameter))
                .findAny()
                .orElse(null);
        if(progressResponseElementV20 != null) {
            pnPollingResponse.setProgressResponseElementV20(progressResponseElementV20);
            return true;
        }
        return false;
    }

    private void selectLastEventId(PnPollingParameter pnPollingParameter) {
        ProgressResponseElement lastProgress = progressResponseElementListV20.get(0);
        ProgressResponseElement curProgress = progressResponseElementListV20
                .stream()
                .filter(progressResponseElement -> lastProgress.getEventId().compareTo(progressResponseElement.getEventId()) < 0)
                .findAny()
                .orElse(null);
        pnPollingParameter.setLastEventId(Objects.requireNonNullElse(curProgress, lastProgress).getEventId());
    }

    private Predicate<ProgressResponseElement> toCheckCondition(PnPollingParameter pnPollingParameter) {
        return progressResponseElementV20 ->
                progressResponseElementV20.getIun() != null && progressResponseElementV20.getIun().equals(iun)
                        && progressResponseElementV20.getTimelineEventCategory() != null && progressResponseElementV20.getTimelineEventCategory().equals(pnPollingParameter.getPnPollingWebhook().getTimelineElementCategoryV20())
                ||
                progressResponseElementV20.getIun() != null && progressResponseElementV20.getIun().equals(iun)
                        && (progressResponseElementV20.getNewStatus() != null && (progressResponseElementV20.getNewStatus().equals(pnPollingParameter.getPnPollingWebhook().getNotificationStatusV20())));
    }
}