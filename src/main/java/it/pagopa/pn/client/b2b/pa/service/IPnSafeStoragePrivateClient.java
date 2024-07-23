package it.pagopa.pn.client.b2b.pa.service;

import it.pagopa.pn.client.b2b.pa.service.utils.SettableApiKey;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestClientException;

public interface IPnSafeStoragePrivateClient extends SettableApiKey {

    FileCreationResponse createFile(String xChecksumValue, String xChecksum, FileCreationRequest fileCreationRequest) throws RestClientException;

    ResponseEntity<FileCreationResponse> createFileWithHttpInfo(String xPagopaSafestorageCxId, String xChecksumValue, String xChecksum, FileCreationRequest fileCreationRequest) throws RestClientException;

    FileDownloadResponse getFile(String fileKey, Boolean metadataOnly, Boolean tags) throws RestClientException;

    ResponseEntity<FileDownloadResponse> getFileWithHttpInfo(String fileKey, String cxId, Boolean metadataOnly, Boolean tags) throws RestClientException;

    OperationResultCodeResponse updateFileMetadata(String fileKey, UpdateFileMetadataRequest updateFileMetadataRequest) throws RestClientException;

    ResponseEntity<OperationResultCodeResponse> updateFileMetadataWithHttpInfo(String fileKey, String cxId, UpdateFileMetadataRequest updateFileMetadataRequest) throws RestClientException;

    AdditionalFileTagsGetResponse additionalFileTagsGet(String fileKey) throws RestClientException;

    ResponseEntity<AdditionalFileTagsGetResponse> additionalFileTagsGetWithHttpInfo(String fileKey, String cxId) throws RestClientException;

    AdditionalFileTagsSearchResponse additionalFileTagsSearch(String logic, Boolean tags) throws RestClientException;

    ResponseEntity<AdditionalFileTagsSearchResponse> additionalFileTagsSearchWithHttpInfo(String cxId, String logic, Boolean tags) throws RestClientException;

    AdditionalFileTagsUpdateResponse additionalFileTagsUpdate(String fileKey, AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest) throws RestClientException;

    ResponseEntity<AdditionalFileTagsUpdateResponse> additionalFileTagsUpdateWithHttpInfo(String fileKey, String cxId, AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest) throws RestClientException;

    AdditionalFileTagsMassiveUpdateResponse additionalFileTagsMassiveUpdate(AdditionalFileTagsMassiveUpdateRequest additionalFileTagsMassiveUpdateRequest) throws RestClientException;

    ResponseEntity<AdditionalFileTagsMassiveUpdateResponse> additionalFileTagsMassiveUpdateWithHttpInfo(String cxId, AdditionalFileTagsMassiveUpdateRequest additionalFileTagsMassiveUpdateRequest) throws RestClientException;
}
