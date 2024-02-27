package it.pagopa.pn.client.b2b.pa.service.utils;

public interface SettableAuthTokenRadd {
    enum AuthTokenRaddType { ISSUER_1, ISSUER_2, ISSUER_ERRATO, DATI_ERRATI, ISSUER_SCADUTO, AUD_ERRATA }

    boolean setAuthTokenRadd(AuthTokenRaddType bearerToken);

    AuthTokenRaddType getAuthTokenRaddSetted();
}
