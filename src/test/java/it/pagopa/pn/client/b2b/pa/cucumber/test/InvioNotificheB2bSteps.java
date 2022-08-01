package it.pagopa.pn.client.b2b.pa.cucumber.test;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.*;
import org.junit.jupiter.api.Assertions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.web.client.HttpServerErrorException;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.concurrent.atomic.AtomicReference;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

@PropertySource( value = "file:config/api-keys.properties", ignoreResourceNotFound = true )
public class InvioNotificheB2bSteps extends CucumberSpringIntegration {

    @Autowired
    private PnPaB2bUtils utils;

    private NewNotificationRequest notificationRequest;
    private FullSentNotification notificationResponseComplete;


    @Given("viene predisposta una notifica con oggetto {string} mittente {string} destinatario {string} con codice fiscale {string}")
    public void hoUnaNotificaConOggettoMittenteDestinatarioConCodiceFiscale(String oggetto, 
                                                                            String mittente, 
                                                                            String destinatario, 
                                                                            String cf) {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

        notificationRequest = new NewNotificationRequest()
                .subject(oggetto+" "+ dateFormat.format(calendar.getTime()))
                .cancelledIun("")
                .group("")
                ._abstract("Abstract della notifica")
                .senderDenomination(mittente)
                .senderTaxId("CFComuneMilano")
                .notificationFeePolicy( NewNotificationRequest.NotificationFeePolicyEnum.DELIVERY_MODE )
                .physicalCommunicationType( NewNotificationRequest.PhysicalCommunicationTypeEnum.SIMPLE_REGISTERED_LETTER )
                .paProtocolNumber("" + System.currentTimeMillis())
                .addDocumentsItem( newDocument( "classpath:/sample.pdf" ) )
                .addRecipientsItem( newRecipient( destinatario, cf,"classpath:/sample.pdf"));
    }

    @When("la notifica viene inviata e si riceve una risposta")
    public void laNotificaVieneInviata() {
        Assertions.assertDoesNotThrow(() -> {
            NewNotificationResponse newNotificationRequest = utils.uploadNotification(notificationRequest);
            notificationResponseComplete = utils.waitForRequestAcceptation( newNotificationRequest );
        });
    }

    @Then("la risposta di ricezione non presenta errori")
    public void laNotificaÈStatoCorrettamenteInviata() {
        Assertions.assertDoesNotThrow(() -> {
            Thread.sleep( 10 * 1000);
            utils.verifyNotification( notificationResponseComplete );
        });
        System.out.println("IUN notifica: "+notificationResponseComplete.getIun());
    }

    @And("la notifica può essere correttamente recuperata dal sistema tramite codice IUN")
    public void laNotificaPuòEssereCorrettamenteRecuperataDalSistemaTramiteCodiceIUN() {
        AtomicReference<FullSentNotification> notificationByIun = new AtomicReference<>();

        Assertions.assertDoesNotThrow(() ->
                notificationByIun.set(utils.getNotificationByIun(notificationResponseComplete.getIun()))
        );

        Assertions.assertNotNull(notificationByIun.get());
    }

    private NotificationDocument newDocument(String resourcePath ) {
        return new NotificationDocument()
                .contentType("application/pdf")
                .ref( new NotificationAttachmentBodyRef().key( resourcePath ));
    }

    private NotificationRecipient newRecipient(String prefix, String taxId, String resourcePath ) {
        long epochMillis = System.currentTimeMillis();

        NotificationRecipient recipient = new NotificationRecipient()
                .denomination( prefix + " denomination")
                .taxId( taxId )
                .digitalDomicile( new NotificationDigitalAddress()
                        .type(NotificationDigitalAddress.TypeEnum.PEC)
                        .address( "FRMTTR76M06B715E@pnpagopa.postecert.local")
                )
                .physicalAddress( new NotificationPhysicalAddress()
                        .address("Via senza nome")
                        .municipality("Milano")
                        .province("MI")
                        .foreignState("ITALIA")
                        .zip("40100")
                )
                .recipientType( NotificationRecipient.RecipientTypeEnum.PF )
                .payment( new NotificationPaymentInfo()
                                .creditorTaxId("77777777777")
                                .noticeCode( String.format("30201%13d", epochMillis ) )
                                .noticeCodeOptional( String.format("30201%13d", epochMillis+1 ) )
                                .pagoPaForm( newAttachment( resourcePath ))
                );

        try {
            Thread.sleep(10);
        }
        catch (InterruptedException exc) {
            throw new RuntimeException(exc);
        }

        return recipient;
    }

    private NotificationPaymentAttachment newAttachment(String resourcePath ) {
        return new NotificationPaymentAttachment()
                .contentType("application/pdf")
                .ref( new NotificationAttachmentBodyRef().key( resourcePath ));
    }


}