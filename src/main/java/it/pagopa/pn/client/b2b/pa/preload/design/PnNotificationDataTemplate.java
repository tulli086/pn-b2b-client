package it.pagopa.pn.client.b2b.pa.preload.design;

import it.pagopa.pn.client.b2b.pa.preload.IPnNotificationDataService;
import it.pagopa.pn.client.b2b.pa.preload.model.PnGenericNotificationData;


public abstract class PnNotificationDataTemplate<T extends PnGenericNotificationData> implements IPnNotificationDataService<T> {
    public abstract void preloadGeneric(T toLoad, String sha256, String key);
}
