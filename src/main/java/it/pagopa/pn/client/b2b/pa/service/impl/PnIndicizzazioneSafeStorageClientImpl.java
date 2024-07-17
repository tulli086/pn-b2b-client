package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.service.PnIndicizzazioneSafeStorageClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.ApiClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.api.AdditionalFileTagsApi;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsGetResponse;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsSearchResponse;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsUpdateRequest;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsUpdateResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@Slf4j
public class PnIndicizzazioneSafeStorageClientImpl implements PnIndicizzazioneSafeStorageClient {
  private final AdditionalFileTagsApi additionalFileTagsApi;
  private final RestTemplate restTemplate;
  private final String devBasePath;
  private ApiKeyType apiKeySetted;
  private final String apiKeyIndexing;

  //TODO: modificare i valori nel value
  public PnIndicizzazioneSafeStorageClientImpl(
          RestTemplate restTemplate,
          @Value("${pn.safeStorage.base-url.pagopa}") String devBasePath) {
    this.restTemplate = restTemplate;
    this.apiKeyIndexing = "pn-test_api_key";
    this.devBasePath = devBasePath;
    this.additionalFileTagsApi = new AdditionalFileTagsApi(newApiClient(restTemplate, devBasePath, "pn-test", apiKeyIndexing));
    this.apiKeySetted = ApiKeyType.INDEXING;
  }

  private static ApiClient newApiClient(RestTemplate restTemplate, String basePath, String clientId, String apiKey) {
    ApiClient newApiClient = new ApiClient( restTemplate );
    newApiClient.setBasePath( basePath );

    //TODO modificare i valori di api-key e client-id
    newApiClient.addDefaultHeader("x-pagopa-safestorage-cx-id", clientId);
    newApiClient.addDefaultHeader("x-api-key", apiKey );
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
    return additionalFileTagsApi.additionalFileTagsUpdate(fileKey, additionalFileTagsUpdateRequest);
  }

  @Override
  public ResponseEntity<AdditionalFileTagsUpdateResponse> updateSingleWithTagsWithHttpInfo(
      String fileKey, AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest) {
    return additionalFileTagsApi.additionalFileTagsUpdateWithHttpInfo(fileKey, additionalFileTagsUpdateRequest);
  }

  @Override
  public void updateMassiveWithTags() {
  }

  @Override
  public void updateMassiveWithTagsWithHttpInfo() {
  }

  @Override
  public AdditionalFileTagsGetResponse getTagsByFileKey(String fileKey) {
    return additionalFileTagsApi.additionalFileTagsGet(fileKey);
  }
  @Override
  public ResponseEntity<AdditionalFileTagsGetResponse> getTagsByFileKeyWithHttpInfo(String fileKey) {
    return additionalFileTagsApi.additionalFileTagsGetWithHttpInfo(fileKey);
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
  public boolean setApiKeys(ApiKeyType apiKey) {
    if(this.apiKeySetted != ApiKeyType.INDEXING){
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
