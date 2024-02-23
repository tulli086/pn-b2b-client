package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.service.IPnRaddAlternativeClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.api.*;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model.*;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.privateb2braddalt.ApiClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.privateb2braddalt.api.*;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.privateb2braddalt.model.*;
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
    private final String tokenRadd;

    private final ActOperationsApi actOperationsApi;
    private final AorOperationsApi aorOperationsApi;
    private final DocumentOperationsApi documentOperationsApi;
    private final NotificationInquiryApi notificationInquiryApi;


    public PnRaddAlternativeClientImpl(ApplicationContext ctx, RestTemplate restTemplate, @Value("${pn.radd.base-url}") String basePath,
                                       @Value("${pn.external.bearer-token-radd}") String tokenRadd) {
        this.ctx = ctx;
        this.restTemplate = restTemplate;
        this.basePath = basePath;
        this.tokenRadd=tokenRadd;

        this.actOperationsApi = new ActOperationsApi(newApiClientExternal(restTemplate,basePath, tokenRadd));
        this.aorOperationsApi = new AorOperationsApi(newApiClientExternal(restTemplate,basePath, tokenRadd));
        this.documentOperationsApi = new DocumentOperationsApi(newApiClientExternal(restTemplate,basePath, tokenRadd));
        this.notificationInquiryApi = new NotificationInquiryApi(newApiClient(restTemplate,basePath));

    }

    private static ApiClient newApiClient(RestTemplate restTemplate, String basePath ) {
        ApiClient newApiClient = new ApiClient( restTemplate );
        newApiClient.setBasePath( basePath );
        return newApiClient;
    }

    private static it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.ApiClient newApiClientExternal(RestTemplate restTemplate, String basePath,String token ) {
        it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.ApiClient newApiClient = new it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.ApiClient( restTemplate );
        newApiClient.setBasePath( basePath );
        newApiClient.addDefaultHeader("Authorization", "Bearer " + token);
        return newApiClient;
    }


    public ActInquiryResponse actInquiry(CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, String uid, String recipientTaxId, String recipientType, String qrCode, String iun) throws RestClientException {
        return this.actOperationsApi.actInquiryWithHttpInfo(xPagopaPnCxType, xPagopaPnCxId,uid, recipientTaxId, recipientType, qrCode, iun).getBody();
    }

    public AbortTransactionResponse abortActTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, AbortTransactionRequest abortTransactionRequest) throws RestClientException {
        return this.actOperationsApi.abortActTransactionWithHttpInfo(uid, xPagopaPnCxType, xPagopaPnCxId, abortTransactionRequest).getBody();
    }


    public CompleteTransactionResponse completeActTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, CompleteTransactionRequest completeTransactionRequest) throws RestClientException {
        return this.actOperationsApi.completeActTransactionWithHttpInfo(uid, xPagopaPnCxType, xPagopaPnCxId, completeTransactionRequest).getBody();
    }


    public StartTransactionResponse startActTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, ActStartTransactionRequest actStartTransactionRequest) throws RestClientException {
        return this.actOperationsApi.startActTransactionWithHttpInfo(uid, xPagopaPnCxType, xPagopaPnCxId, actStartTransactionRequest).getBody();
    }

    public AORInquiryResponse aorInquiry(CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, String uid, String recipientTaxId, String recipientType) throws RestClientException {
        return this.aorOperationsApi.aorInquiryWithHttpInfo(xPagopaPnCxType, xPagopaPnCxId, uid, recipientTaxId, recipientType).getBody();
    }


    public AbortTransactionResponse abortAorTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String xPagopaPnCxId, AbortTransactionRequest abortTransactionRequest) throws RestClientException {
        return this.aorOperationsApi.abortAorTransactionWithHttpInfo(uid, xPagopaPnCxType, xPagopaPnCxId, abortTransactionRequest).getBody();
    }


    public CompleteTransactionResponse completeAorTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String xPagopaPnCxId, CompleteTransactionRequest completeTransactionRequest) throws RestClientException {
        return this.aorOperationsApi.completeAorTransactionWithHttpInfo(uid, xPagopaPnCxType,  xPagopaPnCxId, completeTransactionRequest).getBody();
    }


    public StartTransactionResponse startAorTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String xPagopaPnCxId, AorStartTransactionRequest aorStartTransactionRequest) throws RestClientException {
        return this.aorOperationsApi.startAorTransactionWithHttpInfo(uid, xPagopaPnCxType, xPagopaPnCxId, aorStartTransactionRequest).getBody();
    }


    public DocumentUploadResponse documentUpload(CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, String uid, DocumentUploadRequest documentUploadRequest) throws RestClientException {
        return this.documentOperationsApi.documentUploadWithHttpInfo(xPagopaPnCxType, xPagopaPnCxId, uid, documentUploadRequest).getBody();
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

    @Override
    public byte[] documentDownload(String operationType, String operationId, CxTypeAuthFleet xPagopaPnCxType, String xPagopaPnCxId, String attchamentId) throws RestClientException {
        return this.documentOperationsApi.documentDownload(operationType,operationId,xPagopaPnCxType,xPagopaPnCxId, attchamentId);
    }

}
