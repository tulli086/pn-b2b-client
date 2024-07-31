package it.pagopa.pn.cucumber.steps.pa;

import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingResponseV23;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class StepSharedContext {
    private PnPollingResponseV23 pnPollingResponse;

    public StepSharedContext() {
        this.pnPollingResponse = new PnPollingResponseV23();
    }

    public PnPollingResponseV23 getPnPollingResponse() {
        return pnPollingResponse;
    }

    public void setPnPollingResponse(PnPollingResponseV23 pnPollingResponse) {
        this.pnPollingResponse = pnPollingResponse;
    }
}
