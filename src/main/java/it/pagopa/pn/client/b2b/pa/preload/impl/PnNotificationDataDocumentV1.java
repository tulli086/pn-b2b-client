package it.pagopa.pn.client.b2b.pa.preload.impl;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v1.NotificationAttachmentDigests;
import it.pagopa.pn.client.b2b.pa.preload.design.PnNotificationDataTemplate;
import it.pagopa.pn.client.b2b.pa.preload.model.PnNotificationDataV1;


public class PnNotificationDataDocumentV1 extends PnNotificationDataTemplate<PnNotificationDataV1> {
    @Override
    public void preloadGeneric(PnNotificationDataV1 toLoad, String sha256, String key) {
        toLoad.getNotificationDocument().getRef().setKey(sha256);
        toLoad.getNotificationDocument().getRef().setVersionToken("v1");
        toLoad.getNotificationDocument().digests(new NotificationAttachmentDigests().sha256(key));
    }
}