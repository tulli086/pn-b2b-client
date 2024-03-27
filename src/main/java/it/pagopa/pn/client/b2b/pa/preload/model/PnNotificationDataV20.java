package it.pagopa.pn.client.b2b.pa.preload.model;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationMetadataAttachment;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.NotificationDocument;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model_v2.NotificationPaymentAttachment;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
public class PnNotificationDataV20 extends PnGenericNotificationData {
    private NotificationDocument notificationDocument;
    private NotificationMetadataAttachment notificationMetadataAttachment;
    private NotificationPaymentAttachment notificationPaymentAttachment;

    public PnNotificationDataV20(NotificationDocument notificationDocument) {
        this.notificationDocument = notificationDocument;
    }

    public PnNotificationDataV20(NotificationMetadataAttachment notificationMetadataAttachment) {
        this.notificationMetadataAttachment = notificationMetadataAttachment;
    }

    public PnNotificationDataV20(NotificationPaymentAttachment notificationPaymentAttachment) {
        this.notificationPaymentAttachment = notificationPaymentAttachment;
    }
}