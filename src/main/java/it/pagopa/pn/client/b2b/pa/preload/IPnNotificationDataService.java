package it.pagopa.pn.client.b2b.pa.preload;

import it.pagopa.pn.client.b2b.pa.preload.model.PnGenericNotificationData;

public interface IPnNotificationDataService<T extends PnGenericNotificationData> {
    void preloadGeneric(T toLoad, String sha256, String key);
}
