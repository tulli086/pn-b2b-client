package it.pagopa.pn.client.b2b.pa;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.*;
import it.pagopa.pn.client.b2b.pa.impl.PnPaB2bExternalClientImpl;
import it.pagopa.pn.client.b2b.pa.impl.PnPaB2bInternalClientImpl;
import it.pagopa.pn.client.b2b.pa.springconfig.ApiKeysConfiguration;
import it.pagopa.pn.client.b2b.pa.springconfig.RestTemplateConfiguration;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.PropertySource;

@SpringBootTest( classes = {
        PnPaB2bExternalClientImpl.class,
        PnPaB2bInternalClientImpl.class,
        ApiKeysConfiguration.class,
        RestTemplateConfiguration.class,
        PnPaB2bUtils.class
})
@PropertySource( value = "file:config/api-keys.properties", ignoreResourceNotFound = true )
public class NewNotificationTest {

    @Autowired
    private PnPaB2bUtils utils;

    @Test
    public void insertNewNotification() {
        NewNotificationRequest request = new NewNotificationRequest()
                .subject("Subject")
                .cancelledIun("")
                .group("")
                ._abstract("Abstract della notifica")
                .senderDenomination("Il comune di Milano")
                .senderTaxId("CFComuneMilano")
                .notificationFeePolicy( NewNotificationRequest.NotificationFeePolicyEnum.FLAT_RATE )
                .physicalCommunicationType( NewNotificationRequest.PhysicalCommunicationTypeEnum.REGISTERED_LETTER_890 )
                .paProtocolNumber("" + System.currentTimeMillis())
                .addDocumentsItem( newDocument( "classpath:/sample.pdf" ) )
                .addRecipientsItem( newRecipient( "Ada", "LVLDAA85T50G702B","classpath:/sample.pdf"))
                ;

        utils.uploadNotification( request );
    }


    private NotificationDocument newDocument(String resourcePath ) {
        return new NotificationDocument()
                .contentType("application/pdf")
                .ref( new NotificationAttachmentBodyRef().key( resourcePath ));
    }

    private NotificationPaymentAttachment newAttachment(String resourcePath ) {
        return new NotificationPaymentAttachment()
                .contentType("application/pdf")
                .ref( new NotificationAttachmentBodyRef().key( resourcePath ));
    }

    private NotificationRecipient newRecipient(String prefix, String taxId, String resourcePath ) {
        return new NotificationRecipient()
                .denomination( prefix + " denomination")
                .taxId( taxId )
                .digitalDomicile( new NotificationDigitalAddress()
                        .type(NotificationDigitalAddress.TypeEnum.PEC)
                        .address( "testpagopa2@pnpagopa.postecert.local")
                )
                .physicalAddress( new NotificationPhysicalAddress()
                        .address("Via senza nome")
                        .municipality("Bologna")
                        .province("BO")
                        .zip("40100")
                )
                .recipientType( NotificationRecipient.RecipientTypeEnum.PF )
                .payment( new NotificationPaymentInfo()
                                .creditorTaxId("77777777777")
                                .noticeCode( String.format("30201%13d", System.currentTimeMillis()) )
                                .noticeCodeOptional( String.format("30201%13d", System.currentTimeMillis()) )
                                .pagoPaForm( newAttachment( resourcePath ))
                        //.f24flatRate( newAttachment( resourcePath ) )
                        //.f24standard( newAttachment( resourcePath ) )
                );
    }

}
