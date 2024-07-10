package it.pagopa.pn.client.b2b.pa.service;

import it.pagopa.pn.client.b2b.pa.service.utils.SettableApiKey;

public interface IPnIndicizzazioneSafeStorage extends SettableApiKey {

    //TODO MATTEO
    String searchFileKey();

    String updateMassive();

    String updateSingle();

    String createFile();

    String getFile();
}
