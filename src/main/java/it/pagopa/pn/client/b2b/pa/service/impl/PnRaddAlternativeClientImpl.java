package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.service.IPnRaddAlternativeClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.api.*;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model.*;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.internalb2braddalt.ApiClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.internalb2braddalt.api.*;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.internalb2braddalt.model.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;


@Component
public class PnRaddAlternativeClientImpl implements IPnRaddAlternativeClient {

    private final ApplicationContext ctx;
    private final RestTemplate restTemplate;

    private final String basePath;

    private final ActDocumentInquiryApi actDocumentInquiryApi;
    private final ActTransactionManagementApi actTransactionManagementApi;
    private final AorDocumentInquiryApi aorDocumentInquiryApi;
    private final AorTransactionManagementApi aorTransactionManagementApi;
    private final DocumentUploadApi documentUploadApi;
    private final NotificationInquiryApi notificationInquiryApi;


    public PnRaddAlternativeClientImpl(ApplicationContext ctx, RestTemplate restTemplate, @Value("${pn.radd.base-url}") String basePath) {
        this.ctx = ctx;
        this.restTemplate = restTemplate;
        this.basePath = basePath;

        this.actDocumentInquiryApi = new ActDocumentInquiryApi(newApiClientExternal(restTemplate,basePath));
        this.actTransactionManagementApi = new ActTransactionManagementApi(newApiClientExternal(restTemplate,basePath));
        this.aorDocumentInquiryApi = new AorDocumentInquiryApi(newApiClientExternal(restTemplate,basePath));
        this.aorTransactionManagementApi = new AorTransactionManagementApi(newApiClientExternal(restTemplate,basePath));
        this.documentUploadApi = new DocumentUploadApi(newApiClientExternal(restTemplate,basePath));
        this.notificationInquiryApi = new NotificationInquiryApi(newApiClient(restTemplate,basePath));

    }

    private static ApiClient newApiClient(RestTemplate restTemplate, String basePath ) {
        ApiClient newApiClient = new ApiClient( restTemplate );
        newApiClient.setBasePath( basePath );
        return newApiClient;
    }

    private static it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.ApiClient newApiClientExternal(RestTemplate restTemplate, String basePath ) {
        it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.ApiClient newApiClient = new it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.ApiClient( restTemplate );
        newApiClient.setBasePath( basePath );
        return newApiClient;
    }


    public ActInquiryResponse actInquiry(CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, String uid, String recipientTaxId, String recipientType, String qrCode, String iun) throws RestClientException {
        return this.actDocumentInquiryApi.actInquiryWithHttpInfo(xPagopaPnCxType, xPagopaPnCxId,uid, recipientTaxId, recipientType, qrCode, iun).getBody();
    }

    public AbortTransactionResponse abortActTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, AbortTransactionRequest abortTransactionRequest) throws RestClientException {
        return this.actTransactionManagementApi.abortActTransactionWithHttpInfo(uid, xPagopaPnCxType, xPagopaPnCxId, abortTransactionRequest).getBody();
    }


    public CompleteTransactionResponse completeActTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, CompleteTransactionRequest completeTransactionRequest) throws RestClientException {
        return this.actTransactionManagementApi.completeActTransactionWithHttpInfo(uid, xPagopaPnCxType, xPagopaPnCxId, completeTransactionRequest).getBody();
    }


    public StartTransactionResponse startActTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, ActStartTransactionRequest actStartTransactionRequest) throws RestClientException {
        return this.actTransactionManagementApi.startActTransactionWithHttpInfo(uid, xPagopaPnCxType, xPagopaPnCxId, actStartTransactionRequest).getBody();
    }

    public AORInquiryResponse aorInquiry(CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, String uid, String recipientTaxId, String recipientType) throws RestClientException {
        return this.aorDocumentInquiryApi.aorInquiryWithHttpInfo(xPagopaPnCxType, xPagopaPnCxId, uid, recipientTaxId, recipientType).getBody();
    }


    public AbortTransactionResponse abortAorTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String xPagopaPnCxId, AbortTransactionRequest abortTransactionRequest) throws RestClientException {
        return this.aorTransactionManagementApi.abortAorTransactionWithHttpInfo(uid, xPagopaPnCxType, xPagopaPnCxId, abortTransactionRequest).getBody();
    }


    public CompleteTransactionResponse completeAorTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String xPagopaPnCxId, CompleteTransactionRequest completeTransactionRequest) throws RestClientException {
        return this.aorTransactionManagementApi.completeAorTransactionWithHttpInfo(uid, xPagopaPnCxType,  xPagopaPnCxId, completeTransactionRequest).getBody();
    }


    public StartTransactionResponse startAorTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String xPagopaPnCxId, AorStartTransactionRequest aorStartTransactionRequest) throws RestClientException {
        return this.aorTransactionManagementApi.startAorTransactionWithHttpInfo(uid, xPagopaPnCxType, xPagopaPnCxId, aorStartTransactionRequest).getBody();
    }


    public DocumentUploadResponse documentUpload(CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, String uid, DocumentUploadRequest documentUploadRequest) throws RestClientException {
        return this.documentUploadApi.documentUploadWithHttpInfo(xPagopaPnCxType, xPagopaPnCxId, uid, documentUploadRequest).getBody();
    }

    public OperationsActDetailsResponse getActPracticesByInternalId(String internalId, FilterRequest filterRequest) throws RestClientException {
        return this.notificationInquiryApi.getActPracticesByInternalIdWithHttpInfo(internalId, filterRequest).getBody();
    }

    public OperationsResponse getActPracticesByIun(String iun) throws RestClientException {
        return this.notificationInquiryApi.getActPracticesByIunWithHttpInfo(iun).getBody();
    }

    public OperationActResponse getActTransactionByOperationId(String transactionId) throws RestClientException {
        return this.notificationInquiryApi.getActTransactionByTransactionIdWithHttpInfo(transactionId).getBody();
    }

    public OperationsAorDetailsResponse getAorPracticesByInternalId(String internalId, FilterRequest filterRequest) throws RestClientException {
        return this.notificationInquiryApi.getAorPracticesByInternalIdWithHttpInfo(internalId, filterRequest).getBody();
    }

    public OperationsResponse getAorPracticesByIun(String iun) throws RestClientException {
        return this.notificationInquiryApi.getAorPracticesByIunWithHttpInfo(iun).getBody();
    }

    public OperationAorResponse getAorTransactionByOperationId(String transactionId) throws RestClientException {
        return this.notificationInquiryApi.getAorTransactionByTransactionIdWithHttpInfo(transactionId).getBody();
    }

}
