package it.pagopa.pn.cucumber.steps.pa;

import it.pagopa.pn.client.b2b.pa.polling.dto.PnPollingResponseV23;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_SINGLETON)
public class StepSharedContext {

    private static final String RESPONSE = "RESPONSE";
    private final ThreadLocal<Map<String, PnPollingResponseV23>> sharedContext = ThreadLocal.withInitial(HashMap::new);

    public PnPollingResponseV23 getResponse() {
        return sharedContext.get().get(RESPONSE);
    }

    public void setResponse(PnPollingResponseV23 response) {
        sharedContext.get().put(RESPONSE, response);
    }


}
