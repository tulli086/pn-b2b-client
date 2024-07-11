package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.service.IPnIndicizzazioneSafeStorage;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.ApiClient;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsGetResponse;
import org.springframework.stereotype.Component;

@Component()
public class IPnIndicizzazioneSafeStorageImpl implements IPnIndicizzazioneSafeStorage {

  private final ApiClient indicizzazioneClient;

  public IPnIndicizzazioneSafeStorageImpl(ApiClient indicizzazioneClient) {
    this.indicizzazioneClient = indicizzazioneClient;
  }

  @Override
  public String searchFileKeyWithTags() {
    return null;
  }

  @Override
  public String updateMassiveWithTags() {
    return null;
  }

  @Override
  public String updateSingleWithTags() {
    return null;
  }

  @Override
  public String createFileWithTags() {
    return null;
  }

  @Override
  public AdditionalFileTagsGetResponse getFileWithTags(String fileKey) {
    return null;//TODO additionalFileTagsGetWithHttpInfo(fileKey).getBody();
  }

  @Override
  public boolean setApiKeys(ApiKeyType apiKey) {
    return false;
  }

  @Override
  public void setApiKey(String apiKey) {
  }

  @Override
  public ApiKeyType getApiKeySetted() {
    return null;
  }
}
