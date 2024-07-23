package it.pagopa.pn.client.b2b.pa.service.impl;


import it.pagopa.pn.client.b2b.pa.service.IPnSafeStoragePrivateClient;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.ApiClient;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.api.AdditionalFileTagsApi;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.api.FileDownloadApi;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.api.FileMetadataUpdateApi;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.api.FileUploadApi;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.AdditionalFileTagsGetResponse;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.AdditionalFileTagsMassiveUpdateRequest;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.AdditionalFileTagsMassiveUpdateResponse;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.AdditionalFileTagsSearchResponse;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.AdditionalFileTagsUpdateRequest;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.AdditionalFileTagsUpdateResponse;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.FileCreationRequest;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.FileCreationResponse;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.FileDownloadResponse;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.OperationResultCodeResponse;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.UpdateFileMetadataRequest;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class PnSafeStoragePrivateClientImpl implements IPnSafeStoragePrivateClient {


    private final FileUploadApi fileUploadApi;
    private final FileDownloadApi fileDownloadApi;
    private final FileMetadataUpdateApi fileMetadataUpdateApi;
    private final AdditionalFileTagsApi additionalFileTagsApi;
    private final String clientIdSafeStorage;
    private final String apiKeySafeStorage;
    private final RestTemplate restTemplate;
    private final String safeStorageBaseUrl;

    public PnSafeStoragePrivateClientImpl(RestTemplate restTemplate,
                                          @Value("${pn.safeStorage.base-url}") String safeStorageBaseUrl,
                                          @Value("${pn.safeStorage.apikey}") String apiKeySafeStorage,
                                          @Value("${pn.safeStorage.clientId}") String clientIdSafeStorage) {

        this.apiKeySafeStorage = apiKeySafeStorage;
        this.clientIdSafeStorage = clientIdSafeStorage;
        this.restTemplate = restTemplate;
        this.safeStorageBaseUrl = safeStorageBaseUrl;

        fileUploadApi = new FileUploadApi(newApiClient(restTemplate, safeStorageBaseUrl, apiKeySafeStorage));
        fileMetadataUpdateApi = new FileMetadataUpdateApi(newApiClient(restTemplate, safeStorageBaseUrl, apiKeySafeStorage));
        additionalFileTagsApi = new AdditionalFileTagsApi(newApiClient(restTemplate, safeStorageBaseUrl, apiKeySafeStorage));
        fileDownloadApi = new FileDownloadApi(newApiClient(restTemplate, safeStorageBaseUrl, apiKeySafeStorage));
    }

    private static ApiClient newApiClient(RestTemplate restTemplate, String basePath, String apiKey) {
        ApiClient newApiClient = new ApiClient(restTemplate);
        newApiClient.setBasePath(basePath);
        newApiClient.addDefaultHeader("x-api-key", apiKey);
        return newApiClient;
    }

    /**
     * Metodi ereditati da IPnSafeStoragePrivateClient
     */
    public FileCreationResponse createFile(String xChecksumValue, String xChecksum, FileCreationRequest fileCreationRequest) throws RestClientException {
        return this.fileUploadApi.createFile(clientIdSafeStorage, xChecksumValue, xChecksum, fileCreationRequest);
    }

    public ResponseEntity<FileCreationResponse> createFileWithHttpInfo(String cxId, String xChecksumValue, String xChecksum, FileCreationRequest fileCreationRequest) throws RestClientException {
        return this.fileUploadApi.createFileWithHttpInfo(cxId, xChecksumValue, xChecksum, fileCreationRequest);
    }

    public FileDownloadResponse getFile(String fileKey, Boolean metadataOnly, Boolean tags) throws RestClientException {
        return this.fileDownloadApi.getFile(fileKey, clientIdSafeStorage, metadataOnly, tags);
    }

    public ResponseEntity<FileDownloadResponse> getFileWithHttpInfo(String fileKey, String cxId, Boolean metadataOnly, Boolean tags) throws RestClientException {
        return this.fileDownloadApi.getFileWithHttpInfo(fileKey, cxId, metadataOnly, tags);
    }

    public OperationResultCodeResponse updateFileMetadata(String fileKey, UpdateFileMetadataRequest updateFileMetadataRequest) throws RestClientException {
        return this.fileMetadataUpdateApi.updateFileMetadata(fileKey, clientIdSafeStorage, updateFileMetadataRequest);
    }

    public ResponseEntity<OperationResultCodeResponse> updateFileMetadataWithHttpInfo(String fileKey, String cxId, UpdateFileMetadataRequest updateFileMetadataRequest) throws RestClientException {
        return this.fileMetadataUpdateApi.updateFileMetadataWithHttpInfo(fileKey, cxId, updateFileMetadataRequest);
    }

    public AdditionalFileTagsGetResponse additionalFileTagsGet(String fileKey) throws RestClientException {
        return this.additionalFileTagsApi.additionalFileTagsGet(fileKey, clientIdSafeStorage);
    }

    public ResponseEntity<AdditionalFileTagsGetResponse> additionalFileTagsGetWithHttpInfo(String fileKey, String cxId) throws RestClientException {
        return this.additionalFileTagsApi.additionalFileTagsGetWithHttpInfo(fileKey, cxId);
    }

    public AdditionalFileTagsSearchResponse additionalFileTagsSearch(String logic, Boolean tags,
        Map<String, String> tagParams) throws RestClientException {
        return this.additionalFileTagsApi.additionalFileTagsSearch(clientIdSafeStorage, logic, tags,
            tagParams);
    }

    public ResponseEntity<AdditionalFileTagsSearchResponse> additionalFileTagsSearchWithHttpInfo(
        String cxId, String logic, Boolean tags, Map<String, String> tagParams)
        throws RestClientException {
        return this.additionalFileTagsApi.additionalFileTagsSearchWithHttpInfo(cxId, logic, tags,
            tagParams);
    }

    public AdditionalFileTagsUpdateResponse additionalFileTagsUpdate(String fileKey, AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest) throws RestClientException {
        return this.additionalFileTagsApi.additionalFileTagsUpdate(fileKey, clientIdSafeStorage, additionalFileTagsUpdateRequest);
    }

    public ResponseEntity<AdditionalFileTagsUpdateResponse> additionalFileTagsUpdateWithHttpInfo(String fileKey, String cxId, AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest) throws RestClientException {
        return this.additionalFileTagsApi.additionalFileTagsUpdateWithHttpInfo(fileKey, cxId, additionalFileTagsUpdateRequest);
    }

    @Override
    public AdditionalFileTagsMassiveUpdateResponse additionalFileTagsMassiveUpdate(AdditionalFileTagsMassiveUpdateRequest additionalFileTagsMassiveUpdateRequest) throws RestClientException {
        return this.additionalFileTagsApi.additionalFileTagsMassiveUpdate(clientIdSafeStorage, additionalFileTagsMassiveUpdateRequest);
    }

    @Override
    public ResponseEntity<AdditionalFileTagsMassiveUpdateResponse> additionalFileTagsMassiveUpdateWithHttpInfo(String cxId, AdditionalFileTagsMassiveUpdateRequest additionalFileTagsMassiveUpdateRequest) throws RestClientException {
        return this.additionalFileTagsApi.additionalFileTagsMassiveUpdateWithHttpInfo(cxId, additionalFileTagsMassiveUpdateRequest);
    }

    /**
     * Metodi ereditati da SettableApiKey
     */
    @Override
    public boolean setApiKeys(ApiKeyType apiKey) {
        return false;
    }

    @Override
    public void setApiKey(String apiKey) {
        this.additionalFileTagsApi.setApiClient(newApiClient(restTemplate, safeStorageBaseUrl, apiKey));
    }

    @Override
    public ApiKeyType getApiKeySetted() {
        return null;
    }
}
