Feature: Workflow digitale multidestinatario

  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_ANALOG_MULTI_1_D0_OK-D1_OK] Invio a raccomandata semplice con successo e pec speciale con successo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
    #NB: sequence con un delay per cercare di allineare le tempistiche con l'analogico
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile_address | testpagopa2@sequence.60s-C000.5s-C001.5s-C005.5s-C003.it |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA@OK_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_sentAttemptMade | 0 |
      | details_analogCost | 177 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_digitalAddress | {"address": "testpagopa2@sequence.60s-C000.5s-C001.5s-C005.5s-C003.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    Then si verifica che lo stato della notifica sia "DELIVERED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 10    |
    # Recipient 0 - analogico
    Then viene verificato che l'elemento di timeline "ANALOG_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG001B |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "23L"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG001C |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    # Recipient 1 - digitale
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "testpagopa2@sequence.60s-C000.5s-C001.5s-C005.5s-C003.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "testpagopa2@sequence.60s-C000.5s-C001.5s-C005.5s-C003.it", "type": "PEC"} |
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
  Scenario: [E2E-PF-B2B_DIGITAL_ANALOG_MULTI_2_D0_OK-D1_KO] Invio a raccomandata semplice con successo e pec speciale fallimento
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
    #NB: sequence con un delay per cercare di allineare le tempistiche con il digitale
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | VIA@SEQUENCE.300S-CON080.5S-RECAG001A.5S-RECAG001B[DOC:23L].5S-RECAG001C |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile_address | destinatario_uno@fail.it |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    #NB: flusso cartaceo ritardato per cercare di sincronizzarsi con digitale
    Then viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA@SEQUENCE.300S-CON080.5S-RECAG001A.5S-RECAG001B[DOC:23L].5S-RECAG001C", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_sentAttemptMade | 0 |
      | details_analogCost | 177 |
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
    # Recipient 0 - analogico
    Then viene verificato che l'elemento di timeline "ANALOG_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@SEQUENCE.300S-CON080.5S-RECAG001A.5S-RECAG001B[DOC:23L].5S-RECAG001C", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG001B |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "23L"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG001C |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    # Recipient 1 - digitale
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


  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_ANALOG_MULTI_3_D0_KO-D1_OK] Invio a raccomandata semplice fallita e pec speciale con successo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | VIA@FAIL-Irreperibile_890 |
    #NB: sequence con un delay per cercare di allineare le tempistiche con l'analogico
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile_address | testpagopa2@sequence.120s-C000.5s-C001.5s-C005.5s-C003.it |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA@FAIL-IRREPERIBILE_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_sentAttemptMade | 0 |
      | details_analogCost | 177 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_digitalAddress | {"address": "testpagopa2@sequence.120s-C000.5s-C001.5s-C005.5s-C003.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    Then si verifica che lo stato della notifica sia "DELIVERED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 10    |
    # Recipient 0 - analogico
    Then viene verificato che l'elemento di timeline "ANALOG_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@FAIL-IRREPERIBILE_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG003E |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "Plico"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG003F |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    # Recipient 1 - digitale
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "testpagopa2@sequence.120s-C000.5s-C001.5s-C005.5s-C003.it", "type": "PEC"} |
      | details_recIndex | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "testpagopa2@sequence.120s-C000.5s-C001.5s-C005.5s-C003.it", "type": "PEC"} |
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
  Scenario: [E2E-PF-B2B_DIGITAL_ANALOG_MULTI_4_D0_KO-D1_KO] Invio a raccomandata semplice fallita e pec speciale con fallimento
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
    #NB: sequence con un delay per cercare di allineare le tempistiche con il digitale
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | VIA@sequence.360s-CON080.5s-RECAG003D[FAILCAUSE:M03].5s-RECAG003E[DOC:Plico].5s-RECAG003F |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile_address | destinatario_uno@fail.it |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime  | 30000 |
      | numCheck    | 5    |
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA@SEQUENCE.360S-CON080.5S-RECAG003D[FAILCAUSE:M03].5S-RECAG003E[DOC:PLICO].5S-RECAG003F", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_sentAttemptMade | 0 |
      | details_analogCost | 177 |
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
    # Recipient 0 - analogico
    Then viene verificato che l'elemento di timeline "ANALOG_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@SEQUENCE.360S-CON080.5S-RECAG003D[FAILCAUSE:M03].5S-RECAG003E[DOC:PLICO].5S-RECAG003F", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG003E |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "Plico"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG003F |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    # Recipient 1 - digitale
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
