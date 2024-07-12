package it.pagopa.pn.client.b2b.pa.service.impl;

import static it.pagopa.pn.client.b2b.pa.service.utils.InteropTokenSingleton.ENEBLED_INTEROP;

import it.pagopa.pn.client.b2b.pa.service.IPnIndicizzazioneSafeStorage;
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

@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@Slf4j
public class IPnIndicizzazioneSafeStorageImpl implements IPnIndicizzazioneSafeStorage {
  private final AdditionalFileTagsApi additionalFileTagsApi;

  private final RestTemplate restTemplate;
  private final String devBasePath;
  private final String enableInterop;
  private String bearerTokenInterop;
  private final InteropTokenSingleton interopTokenSingleton;
  private ApiKeyType apiKeySetted;

  private final String apiKeyIndexing;

  //TODO: modificare i valori nel value
  public IPnIndicizzazioneSafeStorageImpl(
      RestTemplate restTemplate, InteropTokenSingleton interopTokenSingleton,
      @Value("${pn.external.base-url}") String devBasePath,
      @Value("${pn.interop.enable}") String enableInterop,
      @Value("${pn.external.api-key}") String apiKeyIndexing) {
    this.restTemplate = restTemplate;
    this.apiKeyIndexing = apiKeyIndexing;
    this.enableInterop = enableInterop;
    this.devBasePath = devBasePath;
    this.interopTokenSingleton = interopTokenSingleton;
    if (ENEBLED_INTEROP.equalsIgnoreCase(enableInterop)) {
      this.bearerTokenInterop = interopTokenSingleton.getTokenInterop();
    }
    this.additionalFileTagsApi = new AdditionalFileTagsApi( newApiClient( restTemplate, devBasePath, apiKeyIndexing, bearerTokenInterop, enableInterop) );
    this.apiKeySetted = ApiKeyType.INDEXING;
  }

  private static ApiClient newApiClient(RestTemplate restTemplate, String basePath, String apiKey, String bearerToken, String enableInterop) {
    ApiClient newApiClient = new ApiClient( restTemplate );
    newApiClient.setBasePath( basePath );
    newApiClient.addDefaultHeader("x-api-key", apiKey );
    if (ENEBLED_INTEROP.equalsIgnoreCase(enableInterop)) {
      newApiClient.addDefaultHeader("Authorization", "Bearer " + bearerToken);
    }
    return newApiClient;
  }

  public void refreshAndSetTokenInteropClient(){
    if (ENEBLED_INTEROP.equalsIgnoreCase(enableInterop)) {
      String tokenInterop = interopTokenSingleton.getTokenInterop();
      if(!tokenInterop.equals(this.bearerTokenInterop)){
        log.info("webhookClient call interopTokenSingleton");
        this.bearerTokenInterop = tokenInterop;
        this.additionalFileTagsApi.getApiClient().addDefaultHeader("Authorization", "Bearer " + bearerTokenInterop);
      }
    }
  }

  @Override
  public void getFileWithTagsByFileKey() {
    refreshAndSetTokenInteropClient();
  }

  @Override
  public void createFileWithTags() {
    refreshAndSetTokenInteropClient();
  }

  @Override
  public AdditionalFileTagsUpdateResponse updateSingleWithTags(String fileKey, AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest) {
    refreshAndSetTokenInteropClient();
    return additionalFileTagsApi.additionalFileTagsUpdate(fileKey, additionalFileTagsUpdateRequest);
  }

  @Override
  public void updateMassiveWithTags() {
    refreshAndSetTokenInteropClient();
  }

  @Override
  public AdditionalFileTagsGetResponse getTagsByFileKey(String fileKey) {
    refreshAndSetTokenInteropClient();
    return additionalFileTagsApi.additionalFileTagsGet(fileKey);
  }

  @Override
  public void searchFileKeyWithTags() {
    refreshAndSetTokenInteropClient();
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
    this.additionalFileTagsApi.setApiClient(newApiClient(restTemplate, devBasePath, apiKey, bearerTokenInterop,enableInterop));
  }

  @Override
  public ApiKeyType getApiKeySetted() {
    return this.apiKeySetted;
  }
}
