package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.service.PnIndicizzazioneSafeStorageClient;
import it.pagopa.pn.client.b2b.pa.service.utils.InteropTokenSingleton;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.ApiClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.api.AdditionalFileTagsApi;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsGetResponse;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsUpdateRequest;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsUpdateResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import static it.pagopa.pn.client.b2b.pa.service.utils.InteropTokenSingleton.ENEBLED_INTEROP;

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
    this.additionalFileTagsApi = new AdditionalFileTagsApi(newApiClient(restTemplate, devBasePath, apiKeyIndexing));
    this.apiKeySetted = ApiKeyType.INDEXING;
  }

  private static ApiClient newApiClient(RestTemplate restTemplate, String basePath, String apiKey) {
    ApiClient newApiClient = new ApiClient( restTemplate );
    newApiClient.setBasePath( basePath );

    //TODO modificare i valori di api-key e client-id
    newApiClient.addDefaultHeader("x-pagopa-safestorage-cx-id", "test");
    newApiClient.addDefaultHeader("x-api-key", apiKey );
    return newApiClient;
  }

  @Override
  public void getFileWithTagsByFileKey() {

  }

  @Override
  public void createFileWithTags() {

  }

  @Override
  public AdditionalFileTagsUpdateResponse updateSingleWithTags(String fileKey, AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest) {
    return additionalFileTagsApi.additionalFileTagsUpdate(fileKey, additionalFileTagsUpdateRequest);
  }

  @Override
  public void updateMassiveWithTags() {
  }

  @Override
  public AdditionalFileTagsGetResponse getTagsByFileKey(String fileKey) {
    return additionalFileTagsApi.additionalFileTagsGet(fileKey);
  }

  @Override
  public void searchFileKeyWithTags() {
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
    this.additionalFileTagsApi.setApiClient(newApiClient(restTemplate, devBasePath, apiKey));
  }

  @Override
  public ApiKeyType getApiKeySetted() {
    return this.apiKeySetted;
  }
}
