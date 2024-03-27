package it.pagopa.pn.client.b2b.pa.polling.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Builder
@Setter
public class PnPollingParameter {

    private String value;
    private int user = 0;
    private PollingType pollingType;
    private UUID streamId;
    public enum PollingType {SLOW,RAPID,SHORT}

}
