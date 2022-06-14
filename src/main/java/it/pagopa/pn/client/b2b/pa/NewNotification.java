package it.pagopa.pn.client.b2b.pa;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication
@PropertySource( value = "file:config/api-keys.properties", ignoreResourceNotFound = true )
public class NewNotification implements CommandLineRunner {

    @Autowired
    private MainBean mainBean;

    public static void main(String[] args) {
        SpringApplication.run(NewNotification.class, args);
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    @Override
    public void run(String... args) throws Exception {
        mainBean.doAll();
        System.exit( 0 );
    }

    @Component
    public static class MainBean {

        @Autowired
        private PnPaB2bUtils utils;


        public void doAll() {
            NewNotificationRequest request = new NewNotificationRequest()
                        .subject("Subject")
                        .cancelledIun("")
                        .group("")
                        ._abstract("Abstract della notifica")
                        .senderDenomination("Il comune di Milano")
                        .senderTaxId("CFComuneMilano")
                        .notificationFeePolicy( NewNotificationRequest.NotificationFeePolicyEnum.FLAT_RATE )
                        .physicalCommunicationType( NewNotificationRequest.PhysicalCommunicationTypeEnum.REGISTERED_LETTER_890 )
                        .paProtocolNumber("protocol" + System.currentTimeMillis())
                        .addDocumentsItem( newDocument( "classpath:/sample.pdf" ) )
                        .addRecipientsItem( newRecipient( "Ada", "LVLDAA85T50G702B","classpath:/sample.pdf"))
                    ;

            utils.uploadNotification( request );
        }


        private NotificationDocument newDocument( String resourcePath ) {
            return new NotificationDocument()
                    .contentType("application/pdf")
                    .ref( new NotificationAttachmentBodyRef().key( resourcePath ));
        }

        private NotificationPaymentAttachment newAttachment( String resourcePath ) {
            return new NotificationPaymentAttachment()
                    .contentType("application/pdf")
                    .ref( new NotificationAttachmentBodyRef().key( resourcePath ));
        }

        private NotificationRecipient newRecipient( String prefix, String taxId, String resourcePath ) {
            return new NotificationRecipient()
                    .denomination( prefix + " denomination")
                    .taxId( taxId )
                    .digitalDomicile( new NotificationDigitalAddress()
                            .type(NotificationDigitalAddress.TypeEnum.PEC)
                            .address( prefix + "@works.demo.it")
                        )
                    .recipientType( NotificationRecipient.RecipientTypeEnum.PF )
                    .payment( new NotificationPaymentInfo()
                            .creditorTaxId("PaTaxId")
                            .noticeCode("NotCode")
                            .pagoPaForm( newAttachment( resourcePath ))
                            //.f24flatRate( newAttachment( resourcePath ) )
                            //.f24standard( newAttachment( resourcePath ) )
                    );
        }

    }

}
