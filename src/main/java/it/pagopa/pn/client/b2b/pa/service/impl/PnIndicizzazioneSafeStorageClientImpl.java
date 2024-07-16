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
  private String bearerToken;
  private ApiKeyType apiKeySetted;
  private final String apiKeyIndexing;

  //TODO: modificare i valori nel value
  public PnIndicizzazioneSafeStorageClientImpl(
          RestTemplate restTemplate,
          @Value("${pn.external.base-url}") String devBasePath,
          @Value("${pn.external.api-key}") String apiKeyIndexing,
          //TODO: individuare il token corretto
          @Value("${pn.external.bearer-token-user1.pagopa}") String bearerToken) {
    this.restTemplate = restTemplate;
    this.apiKeyIndexing = apiKeyIndexing;
    this.devBasePath = devBasePath;
    this.bearerToken = bearerToken;
    this.additionalFileTagsApi = new AdditionalFileTagsApi(newApiClient(restTemplate, devBasePath, apiKeyIndexing,
        this.bearerToken));
    this.apiKeySetted = ApiKeyType.INDEXING;
  }

  private static ApiClient newApiClient(RestTemplate restTemplate, String basePath, String apiKey, String bearerToken) {
    ApiClient newApiClient = new ApiClient( restTemplate );
    newApiClient.setBasePath( basePath );

    //TODO modificare i valori di api-key e client-id
    newApiClient.addDefaultHeader("x-pagopa-safestorage-cx-id", "test");
    newApiClient.addDefaultHeader("x-api-key", apiKey );
    newApiClient.addDefaultHeader("Authorization", "Bearer =" + bearerToken);
    return newApiClient;
  }

  public void refreshAndSetTokenInteropClient(){
    log.info("webhookClient call interopTokenSingleton");
    this.additionalFileTagsApi.getApiClient().addDefaultHeader("Authorization", "Bearer =" + bearerToken);
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
    this.additionalFileTagsApi.setApiClient(newApiClient(restTemplate, devBasePath, apiKey,
        bearerToken));
  }

  @Override
  public ApiKeyType getApiKeySetted() {
    return this.apiKeySetted;
  }
}
