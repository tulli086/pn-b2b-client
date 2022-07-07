package it.pagopa.pn.client.b2b.pa;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.*;
import it.pagopa.pn.client.b2b.pa.impl.IPnPaB2bClient;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.client.LaxRedirectStrategy;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.util.Base64Utils;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StreamUtils;
import org.springframework.web.client.RestTemplate;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class PnPaB2bUtils {

    private final RestTemplate restTemplate;
    private final ApplicationContext ctx;

    private final IPnPaB2bClient client;

    public PnPaB2bUtils(ApplicationContext ctx, IPnPaB2bClient client) {
        this.restTemplate = newRestTemplate();
        this.ctx = ctx;
        this.client = client;
    }

    private static final RestTemplate newRestTemplate() {
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.setRequestFactory(new HttpComponentsClientHttpRequestFactory());
        return restTemplate;
    }


    public void uploadNotification( NewNotificationRequest request) throws IOException {

        List<NotificationDocument> newdocs = new ArrayList<>();
        for (NotificationDocument doc:
             request.getDocuments()) {
            newdocs.add(this.preloadDocument(doc));
        }
        request.setDocuments(newdocs);

        for( NotificationRecipient recipient: request.getRecipients() ) {

            NotificationPaymentInfo paymentInfo = recipient.getPayment();
            paymentInfo.setPagoPaForm( preloadAttachment( paymentInfo.getPagoPaForm() ));
            paymentInfo.setF24flatRate( preloadAttachment( paymentInfo.getF24flatRate() ));
            paymentInfo.setF24standard( preloadAttachment( paymentInfo.getF24standard() ));
        }


        NewNotificationResponse response = client.sendNewNotification( request );
        System.out.println( response );


        System.out.println("Request status for " + response.getNotificationRequestId() );
        NewNotificationRequestStatusResponse status = null;
        for( int i = 0; i < 10; i++ ) {

            status = client.getNotificationRequestStatus( response.getNotificationRequestId() );

            System.out.println( status.getNotificationRequestStatus());
            if ( "ACCEPTED".equals( status.getNotificationRequestStatus() )) {
                break;
            }

            try {
                Thread.sleep( 10 * 1000l);
            } catch (InterruptedException exc) {
                throw new RuntimeException( exc );
            }

        }


        String iun = status.getIun();
        FullSentNotification fsn = client.getSentNotification( iun );

        for (NotificationDocument doc :
                fsn.getDocuments()) {

            var resp = client.getSentNotificationDocument(fsn.getIun(), new BigDecimal(doc.getDocIdx()));
            byte[] content = downloadFile(resp.getUrl());
            String sha256 = computeSha256(new ByteArrayInputStream(content));
            assert sha256.equals(resp.getSha256());
        }

        int i = 0;
        for (NotificationRecipient recipient : fsn.getRecipients()) {

            var resp = client.getSentNotificationAttachment(fsn.getIun(), new BigDecimal(i), "PAGOPA");
            byte[] content = downloadFile(resp.getUrl());
            String sha256 = computeSha256(new ByteArrayInputStream(content));
            assert sha256.equals(resp.getSha256());

/*
            resp = client.getSentNotificationAttachment(fsn.getIun(), new BigDecimal(i), "F24_FLAT");
            content = downloadFile(resp.getUrl());
            sha256 = computeSha256(new ByteArrayInputStream(content));
            assert sha256.equals(resp.getSha256());


            resp = client.getSentNotificationAttachment(fsn.getIun(), new BigDecimal(i), "F24_STANDARD");
            content = downloadFile(resp.getUrl());
            sha256 = computeSha256(new ByteArrayInputStream(content));
            assert sha256.equals(resp.getSha256());
*/
            i++;
        }

        for (LegalFactsId legalFactsId:
                fsn.getTimeline().get(0).getLegalFactsIds()) {
            var resp = client.getLegalFact(fsn.getIun(), LegalFactCategory.SENDER_ACK, URLEncoder.encode(legalFactsId.getKey(), StandardCharsets.UTF_8.toString()) );
            byte[] content = downloadFile(resp.getUrl());
            String  pdfprefix = new String( Arrays.copyOfRange(content, 0, 10), StandardCharsets.UTF_8);
            assert pdfprefix.contains("PDF");
        }


        System.out.println( "Notifica ACCETTATA:" + fsn );
    }


    private NotificationDocument preloadDocument( NotificationDocument document) throws IOException {

        String resourceName = document.getRef().getKey();
        String sha256 = computeSha256( resourceName );

        PreLoadResponse preloadResp = getPreLoadResponse(sha256);
        String key = preloadResp.getKey();
        String secret = preloadResp.getSecret();
        String url = preloadResp.getUrl();

        System.out.format("Attachment resourceKey=%s sha256=%s secret=%s presignedUrl=%s\n",
                resourceName, sha256, secret, url);

        loadToPresigned( url, secret, sha256, resourceName );

        document.getRef().setKey( key );
        document.getRef().setVersionToken("v1");
        document.digests( new NotificationAttachmentDigests().sha256( sha256 ));

        return document;
    }

    private NotificationPaymentAttachment preloadAttachment( NotificationPaymentAttachment attachment) throws IOException {
        if( attachment != null ) {
            String resourceName = attachment.getRef().getKey();

            String sha256 = computeSha256( resourceName );

            PreLoadResponse preloadResp = getPreLoadResponse( sha256 );
            String key = preloadResp.getKey();
            String secret = preloadResp.getSecret();
            String url = preloadResp.getUrl();

            System.out.format("Attachment resourceKey=%s sha256=%s secret=%s presignedUrl=%s\n",
                    resourceName, sha256, secret, url);

            loadToPresigned( url, secret, sha256, resourceName );

            attachment.getRef().setKey( key );
            attachment.getRef().setVersionToken("v1");
            attachment.digests( new NotificationAttachmentDigests().sha256( sha256 ));

            return attachment;
        }
        else {
            return null;
        }

    }


    private void loadToPresigned( String url, String secret, String sha256, String resource ) {
        MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();
        headers.add("Content-type", "application/pdf");
        headers.add("x-amz-checksum-sha256", sha256);
        headers.add("x-amz-meta-secret", secret);

        HttpEntity<Resource> req = new HttpEntity<>( ctx.getResource( resource), headers);
        restTemplate.exchange( URI.create(url), HttpMethod.PUT, req, Object.class);
    }


    private PreLoadResponse getPreLoadResponse(String sha256) {
        PreLoadRequest preLoadRequest = new PreLoadRequest()
                .preloadIdx("0")
                .sha256( sha256 )
                .contentType("application/pdf");
        return client.presignedUploadRequest(
                Collections.singletonList( preLoadRequest)
        ).get(0);
    }

    private String computeSha256( String resName ) throws IOException {
        Resource res = ctx.getResource( resName );
        return computeSha256( res );
    }

    private String computeSha256( Resource res ) throws IOException {

        return computeSha256(res.getInputStream());
    }

    private String computeSha256(  InputStream inStrm) {

        try(inStrm) {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedhash = digest.digest( StreamUtils.copyToByteArray( inStrm ) );
            return bytesToBase64( encodedhash );
        } catch (IOException | NoSuchAlgorithmException exc) {
            throw new RuntimeException( exc );
        }
    }

    private static String bytesToHex(byte[] hash) {
        StringBuilder hexString = new StringBuilder(2 * hash.length);
        for (int i = 0; i < hash.length; i++) {
            String hex = Integer.toHexString(0xff & hash[i]);
            if(hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }

    private byte[] downloadFile(String surl) throws ClientProtocolException, IOException{
        try {
            URL url = new URL(surl);
            return IOUtils.toByteArray(url);
        } catch (Exception e) {
            throw new IllegalStateException(e);
        } finally {
            IOUtils.closeQuietly();
        }

    }

    private static String bytesToBase64(byte[] hash) {
        return Base64Utils.encodeToString( hash );
    }

    public FullSentNotification getNotificationByIun(String iun) {
        return client.getSentNotification( iun );
    }
}
