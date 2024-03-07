package it.pagopa.pn.client.b2b.pa.polling.model;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.*;
import lombok.Getter;
import lombok.Setter;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;


@Getter
@Setter
public class PnGenericFullSentNotification {
    private String idempotenceToken;
    private String paProtocolNumber;
    private String subject;
    private String _abstract;
    private List<NotificationRecipientV23> recipients = new ArrayList<>();
    private List<NotificationDocument> documents = new ArrayList<>();
    private NotificationFeePolicy notificationFeePolicy;
    private String cancelledIun;
    private FullSentNotificationV23.PhysicalCommunicationTypeEnum physicalCommunicationType;
    private String senderDenomination;
    private String senderTaxId;
    private String group;
    private Integer amount;
    private String paymentExpirationDate;
    private String taxonomyCode;
    private Integer paFee;
    private Integer vat;
    private FullSentNotificationV23.PagoPaIntModeEnum pagoPaIntMode;
    private String senderPaId;
    private String iun;
    private OffsetDateTime sentAt;
    private String cancelledByIun;
    private Boolean documentsAvailable;
    private NotificationStatus notificationStatus;
    private List<NotificationStatusHistoryElement> notificationStatusHistory = new ArrayList<>();
    private List<TimelineElementV23> timeline = new ArrayList<>();
}