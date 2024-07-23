package it.pagopa.pn.cucumber.utils;

import it.pagopa.pn.client.b2b.pa.service.utils.SettableAuthTokenRadd;
import lombok.Getter;

@Getter
public enum RaddOperator {

    RADD_UPLOADER("UPLOADER", "1234556", SettableAuthTokenRadd.AuthTokenRaddType.ISSUER_1),
    RADD_STANDARD("STANDARD", "1234556", SettableAuthTokenRadd.AuthTokenRaddType.ISSUER_2),
    RADD_WITHOUT_ROLE("WITHOUT_ROLE", "1234556", SettableAuthTokenRadd.AuthTokenRaddType.ISSUER_3);

    private final String name;
    private final String uid;
    private final SettableAuthTokenRadd.AuthTokenRaddType issuerType;

    RaddOperator(String name, String uid, SettableAuthTokenRadd.AuthTokenRaddType issuerType) {
        this.name = name;
        this.uid = uid;
        this.issuerType = issuerType;
    }
}
