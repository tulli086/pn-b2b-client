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
      | details_analogCost | 181 |


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
      | details_analogCost | 181 |
    And si aggiunge alla sequence il controllo che "PREPARE_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 1 |
      | details_physicalAddress | {"address": "VIA SENZA NOME", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And si aggiunge alla sequence il controllo che "SEND_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 1 |
      | details_physicalAddress | {"address": "VIA SENZA NOME", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 181 |


  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_MULTI_4_D0_KO-D1_OK] Invio notifica multi destinatario con percorso digitale.
  Fallimento pec + Successo pec, inibizione per visualizzazione.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS |
    And destinatario "Mr. EmailCortesia"
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_COURTESY_MESSAGE" esista
      | loadTimeline | true |
      | pollingTime | 20000 |
      | numCheck    | 20    |
      | details_recIndex | 1 |
      | details_digitalAddress | {"address": "testEmail@email.it", "type": "EMAIL"} |
    And la notifica può essere correttamente recuperata da "Mr. EmailCortesia"
    Then si verifica che lo stato della notifica sia "VIEWED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
    Then viene verificato che l'elemento di timeline "DIGITAL_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
    Then viene verificato che l'elemento di timeline "SEND_SIMPLE_REGISTERED_LETTER" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30     |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_RS", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 181 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_FAILURE_WORKFLOW"
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    Then si verifica che lo stato della notifica non sia "EFFECTIVE_DATE"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |

  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_MULTI_5_D0_KO-D1_KO] Invio notifica multi destinatario con percorso digitale.
  Fallimento pec + Fallimento pec, inibizione per visualizzazione.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_COURTESY_MESSAGE" esista
      | loadTimeline | true |
      | pollingTime | 20000 |
      | numCheck    | 20    |
      | details_recIndex | 1 |
      | details_digitalAddress | {"address": "testEmail@email.it", "type": "EMAIL"} |
    And la notifica può essere correttamente recuperata da "Mr. EmailCortesia"
    Then si verifica che lo stato della notifica sia "VIEWED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
    Then viene verificato che l'elemento di timeline "SEND_SIMPLE_REGISTERED_LETTER" non esista
      | loadTimeline | true |
      | pollingTime | 40000 |
      | numCheck    | 30     |
      | details | NOT_NULL |
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_RS", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 181 |
    Then viene verificato che l'elemento di timeline "DIGITAL_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
    Then viene verificato che l'elemento di timeline "SEND_SIMPLE_REGISTERED_LETTER" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30     |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_RS", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 181 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_FAILURE_WORKFLOW"
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    Then si verifica che lo stato della notifica non sia "EFFECTIVE_DATE"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |

  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_MULTI_6_D0_KO-D1_OK] Invio notifica multi destinatario con percorso digitale.
  Fallimento pec + Successo pec, inibizione per visualizzazione.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy | DELIVERY_MODE |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS |
    And destinatario "Mr. EmailCortesia"
      | physicalAddress_address | Via@ok_890 |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_COURTESY_MESSAGE" esista
      | loadTimeline | true |
      | pollingTime | 20000 |
      | numCheck    | 20    |
      | details_recIndex | 1 |
      | details_digitalAddress | {"address": "testEmail@email.it", "type": "EMAIL"} |
    Then l'avviso pagopa viene pagato correttamente per il destinatario con recIndex 1
    And si attende il corretto pagamento della notifica
    Then viene verificato che l'elemento di timeline "DIGITAL_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
    Then viene verificato che l'elemento di timeline "SEND_SIMPLE_REGISTERED_LETTER" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30     |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_RS", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 181 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_FAILURE_WORKFLOW"
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    Then si verifica che lo stato della notifica sia "EFFECTIVE_DATE"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |

  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_MULTI_7_D0_KO-D1_KO] Invio notifica multi destinatario con percorso digitale.
  Fallimento pec + Fallimento pec, inibizione per pagamento.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
      | feePolicy | DELIVERY_MODE |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_COURTESY_MESSAGE" esista
      | loadTimeline | true |
      | pollingTime | 20000 |
      | numCheck    | 20    |
      | details_recIndex | 1 |
      | details_digitalAddress | {"address": "testEmail@email.it", "type": "EMAIL"} |
    Then l'avviso pagopa viene pagato correttamente per il destinatario con recIndex 1
    And si attende il corretto pagamento della notifica
    Then viene verificato che l'elemento di timeline "SEND_SIMPLE_REGISTERED_LETTER" non esista
      | loadTimeline | true |
      | pollingTime | 40000 |
      | numCheck    | 30     |
      | details | NOT_NULL |
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_RS", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 181 |
    Then viene verificato che l'elemento di timeline "DIGITAL_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
    Then viene verificato che l'elemento di timeline "SEND_SIMPLE_REGISTERED_LETTER" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30     |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_RS", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 181 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_FAILURE_WORKFLOW"
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    Then si verifica che lo stato della notifica sia "EFFECTIVE_DATE"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |