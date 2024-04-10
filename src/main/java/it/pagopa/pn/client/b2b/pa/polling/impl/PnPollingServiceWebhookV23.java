package it.pagopa.pn.client.b2b.pa.polling.impl;

import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingStrategy;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingTemplate;
import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingParameter;
import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingResponseV23;
import it.pagopa.pn.client.b2b.pa.polling.exception.PnPollingException;
import it.pagopa.pn.client.b2b.pa.service.IPnWebhookB2bClient;
import it.pagopa.pn.client.b2b.pa.utils.TimingForPolling;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.ProgressResponseElementV23;
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


@Service(PnPollingStrategy.WEBHOOK_V23)
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class PnPollingServiceWebhookV23 extends PnPollingTemplate<PnPollingResponseV23> {
    private static final Logger logger = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private final IPnWebhookB2bClient webhookB2bClient;
    private final TimingForPolling timingForPolling;
    private List<ProgressResponseElementV23> progressResponseElementListV23;
    private int retryAfter;


    public PnPollingServiceWebhookV23(TimingForPolling timingForPolling, IPnWebhookB2bClient webhookB2bClient) {
        this.timingForPolling = timingForPolling;
        this.webhookB2bClient = webhookB2bClient;
    }

    @Override
    protected Callable<PnPollingResponseV23> getPollingResponse(String iun, PnPollingParameter pnPollingParameter) {
        return () -> {
            PnPollingResponseV23 pnPollingResponse = new PnPollingResponseV23();
            ResponseEntity<List<ProgressResponseElementV23>> listResponseEntity;
            int deepCount = pnPollingParameter.getDeepCount();

            try {
                ++deepCount;
                pnPollingParameter.setDeepCount(deepCount);
                listResponseEntity = webhookB2bClient.consumeEventStreamHttpV23(pnPollingParameter.getStreamId(), pnPollingParameter.getLastEventId());
                retryAfter = Integer.parseInt(Objects.requireNonNull(listResponseEntity.getHeaders().get("retry-after")).get(0));
                progressResponseElementListV23 = listResponseEntity.getBody();
                pnPollingResponse.setProgressResponseElementListV23(listResponseEntity.getBody());
                logger.info("ELEMENTI NEL WEBHOOK: " + Objects.requireNonNull(progressResponseElementListV23));
                if(deepCount >= 250) {
                    throw new PnPollingException("LOP: PROGRESS-ELEMENTS: "+ progressResponseElementListV23
                            +" WEBHOOK: "+ pnPollingParameter.getStreamId() +" IUN: "+ pnPollingParameter.getValue() +" DEEP: "+deepCount);
                }
            } catch (IllegalStateException illegalStateException) {
                if (deepCount == 249 || deepCount == 248 || deepCount == 247) {
                    throw new PnPollingException((illegalStateException.getMessage() + ("LOP: PROGRESS-ELEMENTS: " + progressResponseElementListV23
                            + " WEBHOOK: " + pnPollingParameter.getStreamId() + " IUN: " + pnPollingParameter.getValue() + " DEEP: " + deepCount)));
                } else {
                    throw illegalStateException;
                }
            }
            return pnPollingResponse;
        };
    }

    @Override
    protected Predicate<PnPollingResponseV23> checkCondition(String iun, PnPollingParameter pnPollingParameter) {
        return (pnPollingResponse) -> {
            if(pnPollingResponse.getProgressResponseElementListV23() == null) {
                pnPollingResponse.setResult(false);
                return false;
            }

            selectLastEventId(pnPollingParameter);
            if(!isWaitTerminated(pnPollingResponse, pnPollingParameter)) {
                pnPollingResponse.setResult(false);
                return false;
            } else if(retryAfter == 0) {
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

    private boolean isWaitTerminated(PnPollingResponseV23 pnPollingResponse, PnPollingParameter pnPollingParameter) {
        ProgressResponseElementV23 progressResponseElementV23 = progressResponseElementListV23
                .stream()
                .filter(toCheckCondition(pnPollingParameter))
                .findAny()
                .orElse(null);
        if(progressResponseElementV23 != null) {
            pnPollingResponse.setProgressResponseElementV23(progressResponseElementV23);
            return true;
        }
        return false;
    }

    private void selectLastEventId(PnPollingParameter pnPollingParameter) {
        ProgressResponseElementV23 lastProgress = progressResponseElementListV23.get(0);
        ProgressResponseElementV23 curProgress = progressResponseElementListV23
                .stream()
                .filter(progressResponseElement -> lastProgress.getEventId().compareTo(progressResponseElement.getEventId()) < 0)
                .findAny()
                .orElse(null);

        if(curProgress != null) {
            pnPollingParameter.setLastEventId(curProgress.getEventId());
        } else {
            pnPollingParameter.setLastEventId(lastProgress.getEventId());
        }
    }

    private Predicate<ProgressResponseElementV23> toCheckCondition(PnPollingParameter pnPollingParameter) {
        return progressResponseElementV23 ->
            progressResponseElementV23.getIun() != null && progressResponseElementV23.getIun().equals(pnPollingParameter.getValue())
                    && progressResponseElementV23.getElement().getCategory() != null && progressResponseElementV23.getElement().getCategory().equals(pnPollingParameter.getPnPollingWebhook().getTimelineElementCategoryV23())
            ||
            progressResponseElementV23.getIun() != null && progressResponseElementV23.getIun().equals(pnPollingParameter.getValue())
                    && (progressResponseElementV23.getNewStatus() != null && (progressResponseElementV23.getNewStatus().equals(pnPollingParameter.getPnPollingWebhook().getNotificationStatusV23())));

    }
}