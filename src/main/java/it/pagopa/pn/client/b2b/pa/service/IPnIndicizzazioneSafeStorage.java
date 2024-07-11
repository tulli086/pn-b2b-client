package it.pagopa.pn.client.b2b.pa.service;

import it.pagopa.pn.client.b2b.pa.service.utils.SettableApiKey;

public interface IPnIndicizzazioneSafeStorage extends SettableApiKey {

    String searchFileKeyWithTags();

    String updateMassiveWithTags();

    String updateSingleWithTags();

    String createFileWithTags();

    String getFileWithTags();
}
