package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.service.PnIndicizzazioneSafeStorageClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.ApiClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.api.AdditionalFileTagsApi;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.api.FileDownloadApi;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.api.FileUploadApi;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Scope;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@Slf4j
public class PnIndicizzazioneSafeStorageClientImpl implements PnIndicizzazioneSafeStorageClient {
  private final AdditionalFileTagsApi additionalFileTagsApi;
  private final FileDownloadApi fileDownloadApi;
  private final FileUploadApi fileUploadApi;
  private final RestTemplate restTemplate;
  private final String devBasePath;
  private ApiKeyType apiKeySetted;
  private final String apiKeyIndexing;
  private final ApplicationContext ctx;

  //TODO: modificare i valori nel value
  public PnIndicizzazioneSafeStorageClientImpl(
          PnPaB2bUtils b2bUtils, RestTemplate restTemplate,
          @Value("${pn.safeStorage.base-url.pagopa}") String devBasePath, ApplicationContext ctx) {
    this.restTemplate = restTemplate;
    this.ctx = ctx;
    this.apiKeyIndexing = "pn-test_api_key";
    this.devBasePath = devBasePath;
    this.additionalFileTagsApi = new AdditionalFileTagsApi(newApiClient(restTemplate, devBasePath, "pn-test", apiKeyIndexing));
    this.fileUploadApi = new FileUploadApi(newApiClient(restTemplate, devBasePath, null, apiKeyIndexing));
    this.fileDownloadApi = new FileDownloadApi(newApiClient(restTemplate, devBasePath, null, apiKeyIndexing));
    this.apiKeySetted = ApiKeyType.INDEXING;
  }

  private static ApiClient newApiClient(RestTemplate restTemplate, String basePath, String clientId, String apiKey) {
    ApiClient newApiClient = new ApiClient(restTemplate);
    newApiClient.setBasePath(basePath);

    //TODO modificare i valori di api-key e client-id
    if (clientId != null) {
      newApiClient.addDefaultHeader("x-pagopa-safestorage-cx-id", clientId);
    }
    newApiClient.addDefaultHeader("x-api-key", apiKey);
    return newApiClient;
  }

  @Override
  public void getFileWithTagsByFileKey() {

  }

  @Override
  public void getFileWithTagsByFileKeyWithHttpInfo() {

  }

  @Override
  public void createFileWithTags() {
  }

  @Override
  public void createFileWithTagsWithHttpInfo() {

  }

  @Override
  public AdditionalFileTagsUpdateResponse updateSingleWithTags(String fileKey,
      AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest) {
    return additionalFileTagsApi.additionalFileTagsUpdate(fileKey, "pn-test", additionalFileTagsUpdateRequest);
  }

  @Override
  public ResponseEntity<AdditionalFileTagsUpdateResponse> updateSingleWithTagsWithHttpInfo(
      String fileKey, AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest) {
    return additionalFileTagsApi.additionalFileTagsUpdateWithHttpInfo(fileKey, "pn-test", additionalFileTagsUpdateRequest);
  }

  @Override
  public void updateMassiveWithTags() {
  }

  @Override
  public void updateMassiveWithTagsWithHttpInfo() {
  }

  @Override
  public AdditionalFileTagsGetResponse getTagsByFileKey(String fileKey) {
    return additionalFileTagsApi.additionalFileTagsGet(fileKey, "pn-test");
  }
  @Override
  public ResponseEntity<AdditionalFileTagsGetResponse> getTagsByFileKeyWithHttpInfo(String fileKey) {
    return additionalFileTagsApi.additionalFileTagsGetWithHttpInfo(fileKey, "pn-test");
  }

  @Override
  public AdditionalFileTagsSearchResponse searchFileKeyWithTags(String id, String logic,
                                                                Boolean tags) {
    return additionalFileTagsApi.additionalFileTagsSearch(id, logic, tags);
  }

  @Override
  public ResponseEntity<AdditionalFileTagsSearchResponse> searchFileKeyWithTagsWithHttpInfo(
          String id, String logic, Boolean tags) {
    return additionalFileTagsApi.additionalFileTagsSearchWithHttpInfo(id, logic, tags);
  }

  @Override
  public FileCreationResponse createFile() {
    return null;
  }

  @Override
  public FileCreationResponse createFile(FileCreationRequest fileCreationRequest) {
    return fileUploadApi.createFile("pn-test", fileCreationRequest);
  }

  @Override
  public ResponseEntity<FileCreationResponse> createFileWithHttpInfo(FileCreationRequest fileCreationRequest) {
    return fileUploadApi.createFileWithHttpInfo("pn-test", fileCreationRequest);
  }


//  private void actionsPostPreload(FileCreationRequest request, FileCreationResponse response) {
//    String sha = "";
//    try {
//      sha = this.b2bUtils.computeSha256("classpath:/sample.pdf");
//    } catch (Exception e) {
//      //TODO
//    }
//
//    MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();
//    headers.add("Content-type", request.getContentType());
//    headers.add("x-amz-checksum-sha256", sha);
//    headers.add("x-amz-meta-secret", response.getSecret());
//    log.info("headers: {}", headers);
//    HttpEntity<Resource> req = new HttpEntity<>(ctx.getResource("classpath:/sample.pdf"), headers);
//    ResponseEntity<Object> returnValue = restTemplate.exchange(URI.create(response.getUploadUrl()), HttpMethod.PUT, req, Object.class);
//  }


  @Override
  public FileDownloadResponse getFile(String fileKey, Boolean metadataOnly, Boolean tags) {
    return this.fileDownloadApi.getFile(fileKey, "pn-test", metadataOnly, tags);
  }

  @Override
  public ResponseEntity<FileDownloadResponse> getFileWithHttpInfo(String fileKey, Boolean metadataOnly, Boolean tags) {
    return this.fileDownloadApi.getFileWithHttpInfo(fileKey, "pn-test", metadataOnly, tags);
  }

  @Override
  public boolean setApiKeys(ApiKeyType apiKey) {
    if (this.apiKeySetted != ApiKeyType.INDEXING) {
      setApiKey(this.apiKeyIndexing);
      this.apiKeySetted = ApiKeyType.INDEXING;
    }
    return true;
  }

  @Override
  public void setApiKey(String apiKey){
    this.additionalFileTagsApi.setApiClient(newApiClient(restTemplate, devBasePath, "pn-test", apiKey));
  }

  @Override
  public ApiKeyType getApiKeySetted() {
    return this.apiKeySetted;
  }
}
