package it.pagopa.pn.client.b2b.pa.service;

import it.pagopa.pn.client.b2b.pa.service.utils.SettableApiKey;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsGetResponse;

public interface IPnIndicizzazioneSafeStorage extends SettableApiKey {

    String searchFileKeyWithTags();

    String updateMassiveWithTags();

    String updateSingleWithTags();

    String createFileWithTags();

    AdditionalFileTagsGetResponse getFileWithTags(String fileKey);
}
