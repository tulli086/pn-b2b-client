package it.pagopa.pn.client.b2b.pa.service;

import it.pagopa.pn.client.b2b.pa.service.utils.SettableApiKey;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsGetResponse;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsSearchResponse;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsUpdateRequest;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.AdditionalFileTagsUpdateResponse;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.FileCreationRequest;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.indicizzazione.model.FileCreationResponse;
import org.springframework.http.ResponseEntity;

public interface PnIndicizzazioneSafeStorageClient extends SettableApiKey {


    void getFileWithTagsByFileKey();

    void getFileWithTagsByFileKeyWithHttpInfo();

    void createFileWithTags();

    void createFileWithTagsWithHttpInfo();

    AdditionalFileTagsUpdateResponse updateSingleWithTags(String fileKey,
        AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest);

    ResponseEntity<AdditionalFileTagsUpdateResponse> updateSingleWithTagsWithHttpInfo(
        String fileKey, AdditionalFileTagsUpdateRequest additionalFileTagsUpdateRequest);

    void updateMassiveWithTags();

    void updateMassiveWithTagsWithHttpInfo();

    AdditionalFileTagsGetResponse getTagsByFileKey(String fileKey);

    ResponseEntity<AdditionalFileTagsGetResponse> getTagsByFileKeyWithHttpInfo(String fileKey);

    AdditionalFileTagsSearchResponse searchFileKeyWithTags(String id, String logic,
                                                           Boolean tags);

    ResponseEntity<AdditionalFileTagsSearchResponse> searchFileKeyWithTagsWithHttpInfo(
            String id, String logic, Boolean tags);

    FileCreationResponse createFile(String document);

    ResponseEntity<FileCreationResponse> createFileWithHttpInfo(FileCreationRequest fileCreationRequest);
}
