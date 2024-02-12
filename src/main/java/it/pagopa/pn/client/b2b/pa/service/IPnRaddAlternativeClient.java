package it.pagopa.pn.client.b2b.pa.service;

import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.internalb2braddalt.model.*;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model.*;
import org.springframework.web.client.RestClientException;

public interface IPnRaddAlternativeClient {

    ActInquiryResponse actInquiry(CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, String uid, String recipientTaxId, String recipientType, String qrCode, String iun) throws RestClientException;
    AbortTransactionResponse abortActTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, AbortTransactionRequest abortTransactionRequest) throws RestClientException;
    CompleteTransactionResponse completeActTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, CompleteTransactionRequest completeTransactionRequest) throws RestClientException;
    StartTransactionResponse startActTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, ActStartTransactionRequest actStartTransactionRequest) throws RestClientException;
    AORInquiryResponse aorInquiry(CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, String uid, String recipientTaxId, String recipientType) throws RestClientException;
    AbortTransactionResponse abortAorTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, AbortTransactionRequest abortTransactionRequest) throws RestClientException;
    CompleteTransactionResponse completeAorTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, CompleteTransactionRequest completeTransactionRequest) throws RestClientException;
    StartTransactionResponse startAorTransaction(String uid, CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, AorStartTransactionRequest aorStartTransactionRequest) throws RestClientException;
    DocumentUploadResponse documentUpload(CxTypeAuthFleet xPagopaPnCxType, String  xPagopaPnCxId, String uid, DocumentUploadRequest documentUploadRequest) throws RestClientException;
    OperationsActDetailsResponse getActPracticesByInternalId(String internalId, FilterRequest filterRequest) throws RestClientException;
    OperationsResponse getActPracticesByIun(String iun) throws RestClientException;
    OperationActResponse getActTransactionByOperationId(String transactionId) throws RestClientException;
    OperationsAorDetailsResponse getAorPracticesByInternalId(String internalId, FilterRequest filterRequest) throws RestClientException;
    OperationsResponse getAorPracticesByIun(String iun) throws RestClientException;
    OperationAorResponse getAorTransactionByOperationId(String transactionId) throws RestClientException;

}
