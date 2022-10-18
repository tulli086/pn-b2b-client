package it.pagopa.pn.client.b2b.pa.testclient;

import it.pagopa.pn.client.b2b.appIo.generated.openapi.clients.externalAppIO.model.FullReceivedNotification;
import it.pagopa.pn.client.b2b.appIo.generated.openapi.clients.externalAppIO.model.LegalFactDownloadMetadataResponse;
import it.pagopa.pn.client.b2b.appIo.generated.openapi.clients.externalAppIO.model.NotificationAttachmentDownloadMetadataResponse;
import org.springframework.web.client.RestClientException;

public interface IPnAppIOB2bClient {

    NotificationAttachmentDownloadMetadataResponse getSentNotificationDocument(String iun, Integer docIdx, String xPagopaCxTaxid) throws RestClientException;

    LegalFactDownloadMetadataResponse getLegalFact(String iun, String legalFactType, String legalFactId, String xPagopaCxTaxid) throws RestClientException;

    FullReceivedNotification getReceivedNotification(String iun, String xPagopaCxTaxid) throws RestClientException;

}
