package it.pagopa.pn.client.b2b.pa.service;

import it.pagopa.pn.client.b2b.pa.service.utils.SettableApiKey;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsGetResponse;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsUpdateRequest;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsUpdateResponse;

public interface IPnIndicizzazioneSafeStorage extends SettableApiKey {

    void getFileWithTagsByFileKey();

    void createFileWithTags();

    AdditionalFileTagsUpdateResponse updateSingleWithTags(String fileKey,
        AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest);

    void updateMassiveWithTags();

    AdditionalFileTagsGetResponse getTagsByFileKey(String fileKey);

    void searchFileKeyWithTags();
}
