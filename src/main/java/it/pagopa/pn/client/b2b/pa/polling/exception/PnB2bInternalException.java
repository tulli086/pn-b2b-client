package it.pagopa.pn.client.b2b.pa.polling.exception;

import it.pagopa.pn.commons.exceptions.PnInternalException;
import lombok.Getter;
import lombok.Setter;

public class PnB2bInternalException extends PnInternalException {
    @Getter
    @Setter
    private String internalMessage;

    public PnB2bInternalException(String message, String errorCode, Throwable cause) {
        super(message, errorCode, cause);
    }

    public PnB2bInternalException(String message, String errorCode) {
        super(message, errorCode);
    }
}
