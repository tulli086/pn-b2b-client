Feature: National Registries e2e

  @e2e @ignore
  Scenario: [B2B_NATIONAL_REGISTRIES_1] Utenza senza recapiti settati, non settare recapito digitale nella notifica.
  IPA risponde in OK e non viene fatta chiamata a INIPEC.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario
      | taxId        | da definire |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene verificato che l'elemento di timeline "DIGITAL_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "da recuperare da mock", "type": "PEC"} |
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "da recuperare da mock", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "da recuperare da mock", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 0 |
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e @ignore
  Scenario: [B2B_NATIONAL_REGISTRIES_2] Utenza senza recapiti settati, non settare recapito digitale nella notifica.
  IPA risponde in KO e viene fatta chiamata a INIPEC.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario
      | taxId        | da definire |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene verificato che l'elemento di timeline "DIGITAL_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "da recuperare da mock", "type": "PEC"} |
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "da recuperare da mock", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "da recuperare da mock", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 0 |
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

