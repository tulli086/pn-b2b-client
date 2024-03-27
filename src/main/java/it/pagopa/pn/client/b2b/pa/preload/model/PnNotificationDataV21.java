package it.pagopa.pn.client.b2b.pa.preload.model;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v21.NotificationMetadataAttachment;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v21.NotificationDocument;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v21.NotificationPaymentAttachment;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
public class PnNotificationDataV21 extends PnGenericNotificationData {
    private NotificationDocument notificationDocument;
    private NotificationMetadataAttachment notificationMetadataAttachment;
    private NotificationPaymentAttachment notificationPaymentAttachment;

    public PnNotificationDataV21(NotificationDocument notificationDocument) {
        this.notificationDocument = notificationDocument;
    }

    public PnNotificationDataV21(NotificationMetadataAttachment notificationMetadataAttachment) {
        this.notificationMetadataAttachment = notificationMetadataAttachment;
    }

    public PnNotificationDataV21(NotificationPaymentAttachment notificationPaymentAttachment) {
        this.notificationPaymentAttachment = notificationPaymentAttachment;
    }
}