package it.pagopa.pn.client.b2b.pa.polling.design;

import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingParameter;
import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingResponse;
import it.pagopa.pn.client.b2b.pa.polling.IPnPollingService;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import java.util.Map;


@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class PnPollingFactory {
    private final Map<String, IPnPollingService<?>> pollingServiceMap;

    public PnPollingFactory(Map<String, IPnPollingService<?>> pollingServiceMap) {
        this.pollingServiceMap = pollingServiceMap;
    }

    public IPnPollingService<?> getPollingService(String pollingType) {
        IPnPollingService<?> IPnPollingService = pollingServiceMap.get(pollingType);
        if (IPnPollingService == null) {
            throw new RuntimeException("Unsupported IPnPollingService type");
        }

        return IPnPollingService;
    }

    public void execute(String pollingType, String iun, PnPollingParameter pnPollingParameter) {
        IPnPollingService<?> iPnPollingService = pollingServiceMap.get(pollingType);
        PnPollingResponse pnPollingResponse = iPnPollingService.waitForEvent(iun, pnPollingParameter);
    }
}