package it.pagopa.pn.client.b2b.pa.preload.impl;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v21.NotificationAttachmentDigests;
import it.pagopa.pn.client.b2b.pa.preload.design.PnNotificationDataTemplate;
import it.pagopa.pn.client.b2b.pa.preload.model.PnNotificationDataV21;


public class PnNotificationDataDocumentV21 extends PnNotificationDataTemplate<PnNotificationDataV21> {
    @Override
    public void preloadGeneric(PnNotificationDataV21 toLoad, String sha256, String key) {
        toLoad.getNotificationDocument().getRef().setKey(sha256);
        toLoad.getNotificationDocument().getRef().setVersionToken("v1");
        toLoad.getNotificationDocument().digests(new NotificationAttachmentDigests().sha256(key));
    }
}