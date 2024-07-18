package it.pagopa.pn.client.b2b.pa.service.impl;



import it.pagopa.pn.client.b2b.pa.service.IPnSafeStoragePrivateClient;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.ApiClient;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.api.AdditionalFileTagsApi;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.api.FileDownloadApi;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.api.FileMetadataUpdateApi;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.api.FileUploadApi;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.*;
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

    public PnSafeStoragePrivateClientImpl(RestTemplate restTemplate,
                                          @Value("${pn.safeStorage.base-url}")String safeStorageBaseUrl,
                                          @Value("${pn.safeStorage.apikey}")String apiKeySafeStorage,
                                          @Value("${pn.safeStorage.clientId}")String clientIdSafeStorage) {

        this.apiKeySafeStorage = apiKeySafeStorage;
        this.clientIdSafeStorage = clientIdSafeStorage;

        fileUploadApi = new FileUploadApi(newApiClient(restTemplate,safeStorageBaseUrl,apiKeySafeStorage));
        fileMetadataUpdateApi = new FileMetadataUpdateApi(newApiClient(restTemplate,safeStorageBaseUrl,apiKeySafeStorage));
        additionalFileTagsApi = new AdditionalFileTagsApi(newApiClient(restTemplate,safeStorageBaseUrl,apiKeySafeStorage));
        fileDownloadApi = new FileDownloadApi(newApiClient(restTemplate,safeStorageBaseUrl,apiKeySafeStorage));
    }

    private static ApiClient newApiClient(RestTemplate restTemplate, String basePath, String apiKey ) {
        ApiClient newApiClient = new ApiClient( restTemplate );
        newApiClient.setBasePath( basePath );
        newApiClient.addDefaultHeader("x-api-key", apiKey );
        return newApiClient;
    }


    public FileCreationResponse createFile(FileCreationRequest fileCreationRequest) throws RestClientException {
        return createFileWithHttpInfo(clientIdSafeStorage, fileCreationRequest).getBody();
    }

    public ResponseEntity<FileCreationResponse> createFileWithHttpInfo(String cxId, FileCreationRequest fileCreationRequest) throws RestClientException {
        return this.fileUploadApi.createFileWithHttpInfo(cxId,fileCreationRequest);
    }


    public FileDownloadResponse getFile(String fileKey, Boolean metadataOnly, Boolean tags) throws RestClientException {
        return getFileWithHttpInfo(fileKey, clientIdSafeStorage, metadataOnly, tags).getBody();
    }


    public ResponseEntity<FileDownloadResponse> getFileWithHttpInfo(String fileKey, String cxId, Boolean metadataOnly, Boolean tags) throws RestClientException {
        return this.fileDownloadApi.getFileWithHttpInfo(fileKey, cxId, metadataOnly, tags);
    }

    public OperationResultCodeResponse updateFileMetadata(String fileKey, UpdateFileMetadataRequest updateFileMetadataRequest) throws RestClientException {
        return updateFileMetadataWithHttpInfo(fileKey, clientIdSafeStorage, updateFileMetadataRequest).getBody();
    }

    public ResponseEntity<OperationResultCodeResponse> updateFileMetadataWithHttpInfo(String fileKey, String cxId, UpdateFileMetadataRequest updateFileMetadataRequest) throws RestClientException {
        return this.fileMetadataUpdateApi.updateFileMetadataWithHttpInfo(fileKey, cxId, updateFileMetadataRequest);
    }


    public AdditionalFileTagsGetResponse additionalFileTagsGet(String fileKey, String xPagopaSafestorageCxId) throws RestClientException {
        return this.additionalFileTagsApi.additionalFileTagsGet(fileKey, xPagopaSafestorageCxId);
    }


    public AdditionalFileTagsSearchResponse additionalFileTagsSearch(String xPagopaSafestorageCxId, String logic, Boolean tags) throws RestClientException {
        return this.additionalFileTagsApi.additionalFileTagsSearch(xPagopaSafestorageCxId, logic, tags);
    }

    public AdditionalFileTagsUpdateResponse additionalFileTagsUpdate(String fileKey, String xPagopaSafestorageCxId, AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest) throws RestClientException {
        return this.additionalFileTagsApi.additionalFileTagsUpdate(fileKey, xPagopaSafestorageCxId, additionalFileTagsUpdateRequest);
    }



}
