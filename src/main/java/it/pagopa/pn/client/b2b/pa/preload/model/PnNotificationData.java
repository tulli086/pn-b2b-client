package it.pagopa.pn.client.b2b.pa.preload.model;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationDocument;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationMetadataAttachment;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationPaymentAttachment;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
public class PnNotificationData extends PnGenericNotificationData {
    private NotificationDocument notificationDocument;
    private NotificationMetadataAttachment notificationMetadataAttachment;
    private NotificationPaymentAttachment notificationPaymentAttachment;

    public PnNotificationData(NotificationDocument notificationDocument) {
        this.notificationDocument = notificationDocument;
    }

    public PnNotificationData(NotificationMetadataAttachment notificationMetadataAttachment) {
        this.notificationMetadataAttachment = notificationMetadataAttachment;
    }

    public PnNotificationData(NotificationPaymentAttachment notificationPaymentAttachment) {
        this.notificationPaymentAttachment = notificationPaymentAttachment;
    }
}