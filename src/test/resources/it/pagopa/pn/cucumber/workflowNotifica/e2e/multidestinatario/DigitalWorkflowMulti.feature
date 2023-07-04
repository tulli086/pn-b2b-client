Feature: Workflow digitale multidestinatario

  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_MULTI_1_D0_OK-D1_OK] Invio ad indirizzo speciale successo al primo tentativo per entrambi i destinatari
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | testpagopa1@pnpagopa.postecert.local |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile_address | testpagopa2@pnpagopa.postecert.local |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_digitalAddress | {"address": "testpagopa1@pnpagopa.postecert.local", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_digitalAddress | {"address": "testpagopa2@pnpagopa.postecert.local", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    Then si verifica che lo stato della notifica sia "DELIVERED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 10    |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "testpagopa1@pnpagopa.postecert.local", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "testpagopa1@pnpagopa.postecert.local", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "testpagopa2@pnpagopa.postecert.local", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "testpagopa2@pnpagopa.postecert.local", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 1 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 1 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 10    |
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 10    |
      | details_recIndex | 1 |



  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_MULTI_2_D0_KO-D1_OK] Invio ad indirizzo speciale fallito per destinatario 0, con successo per destinatario 1
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | destinatario_zero@fail.it |
    #NB: si usa una sequence con un ritardo maggiore, per dare il tempo al workflow del fallimento di fare i 2 tentativi
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile_address | testpagopa2@sequence.300s-C000.5s-C001.5s-C005.5s-C003.it |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_digitalAddress | {"address": "destinatario_zero@fail.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_digitalAddress | {"address": "testpagopa2@sequence.300s-C000.5s-C001.5s-C005.5s-C003.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    Then si verifica che lo stato della notifica sia "DELIVERED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "destinatario_zero@fail.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "destinatario_zero@fail.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "destinatario_zero@fail.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "destinatario_zero@fail.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "testpagopa2@sequence.300s-C000.5s-C001.5s-C005.5s-C003.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "testpagopa2@sequence.300s-C000.5s-C001.5s-C005.5s-C003.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 1 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 1 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 10    |
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 10    |
      | details_recIndex | 1 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | numCheck | 1 |
    And si aggiunge alla sequence il controllo che "PREPARE_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA SENZA NOME", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And si aggiunge alla sequence il controllo che "SEND_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA SENZA NOME", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 133 |


  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_MULTI_3_D0_KO-D1_KO] Invio ad indirizzo speciale fallito per destinatario e per destinatario 1
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | destinatario_zero@fail.it |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile_address | destinatario_uno@fail.it |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_digitalAddress | {"address": "destinatario_zero@fail.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_digitalAddress | {"address": "destinatario_uno@fail.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    Then si verifica che lo stato della notifica sia "DELIVERED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "destinatario_zero@fail.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "destinatario_zero@fail.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "destinatario_zero@fail.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "destinatario_zero@fail.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "destinatario_uno@fail.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "destinatario_uno@fail.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 1 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "destinatario_uno@fail.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "destinatario_uno@fail.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 1 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 10    |
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 10    |
      | details_recIndex | 1 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | numCheck | 1 |
    And si aggiunge alla sequence il controllo che "PREPARE_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA SENZA NOME", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And si aggiunge alla sequence il controllo che "SEND_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA SENZA NOME", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 133 |
    And si aggiunge alla sequence il controllo che "PREPARE_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 1 |
      | details_physicalAddress | {"address": "VIA SENZA NOME", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And si aggiunge alla sequence il controllo che "SEND_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 1 |
      | details_physicalAddress | {"address": "VIA SENZA NOME", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 133 |