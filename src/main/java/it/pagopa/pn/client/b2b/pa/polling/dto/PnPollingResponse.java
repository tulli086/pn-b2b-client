package it.pagopa.pn.client.b2b.pa.polling.dto;

import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
public class PnPollingResponse<T> {
    private T pnGenericFullSentNotification;
    private Boolean result;
}