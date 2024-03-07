package it.pagopa.pn.client.b2b.pa.polling.dto;

import it.pagopa.pn.client.b2b.pa.polling.model.PnGenericFullSentNotification;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;


@Builder
@Getter
@Setter
public class PnPollingResponse {
    private PnGenericFullSentNotification pnGenericFullSentNotification;
    private Boolean result;
}
