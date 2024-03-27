package it.pagopa.pn.client.b2b.pa.preload.impl;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationAttachmentDigests;
import it.pagopa.pn.client.b2b.pa.preload.design.PnNotificationDataTemplate;
import it.pagopa.pn.client.b2b.pa.preload.model.PnNotificationData;


public class PnNotificationDataDocument extends PnNotificationDataTemplate<PnNotificationData> {
    @Override
    public void preloadGeneric(PnNotificationData toLoad, String sha256, String key) {
        toLoad.getNotificationDocument().getRef().setKey(sha256);
        toLoad.getNotificationDocument().getRef().setVersionToken("v1");
        toLoad.getNotificationDocument().digests(new NotificationAttachmentDigests().sha256(key));
    }
}