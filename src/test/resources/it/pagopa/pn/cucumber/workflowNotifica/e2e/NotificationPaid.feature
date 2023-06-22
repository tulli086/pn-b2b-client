Feature: Notifica pagata

  @e2e
  Scenario: [E2E-WF-INHIBITION-PAID-3] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  Viene effettuato il pagamento subito dopo la generazione dell'evento di timeline SCHEDULE_REFINEMENT.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo |
      | feePolicy | DELIVERY_MODE |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 2000 |
      | numCheck    | 40     |
      | details | NOT_NULL |
      | details_recIndex | 0 |
    And l'avviso pagopa viene pagato correttamente
    And si attende il corretto pagamento della notifica
    Then viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-WF-INHIBITION-PAID-4] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  Viene effettuato il pagamento subito dopo che la notifica è stata accettata. Il pagamento non deve generare un evento di timeline SEND_ANALOG_DOMICILE.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo |
      | feePolicy | DELIVERY_MODE |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_AR |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then l'avviso pagopa viene pagato correttamente
    And si attende il corretto pagamento della notifica
    Then viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" non esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |

  @e2e
  Scenario: [E2E-WF-INHIBITION-PAID-5] Casistica in cui il pagamento di una notifica inibisce parte del workflow di notifica.
  Viene effettuato il pagamento subito dopo la generazione del secondo evento di timeline SEND_DIGITAL_DOMICILE. Il pagamento non deve generare
  un evento di timeline PREPARE_SIMPLE_REGISTERED_LETTER e SEND_SIMPLE_REGISTERED_LETTER.
  Viene verificata la presenza degli elementi SCHEDULE_REFINEMENT e REFINEMENT.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo |
      | feePolicy | DELIVERY_MODE |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_DIGITAL_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 1 |
      | details_isFirstSendRetry | false |
      | details_digitalAddressSource | SPECIAL |
      | details_digitalAddress | {"address": "test@fail.it", "type": "PEC"} |
    And l'avviso pagopa viene pagato correttamente
    And si attende il corretto pagamento della notifica
    Then viene verificato che l'elemento di timeline "PREPARE_SIMPLE_REGISTERED_LETTER" non esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
    Then viene verificato che l'elemento di timeline "SEND_SIMPLE_REGISTERED_LETTER" non esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
    Then viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-WF-INHIBITION-PAID-6] Casistica in cui il pagamento di una notifica inibisce parte del workflow di notifica.
  Viene effettuato il pagamento subito dopo la generazione dell'evento di timeline SEND_SIMPLE_REGISTERED_LETTER.
  Viene verificata la presenza degli elementi SCHEDULE_REFINEMENT e REFINEMENT.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo |
      | feePolicy | DELIVERY_MODE |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_SIMPLE_REGISTERED_LETTER" esista
      | loadTimeline | true |
      | pollingTime | 20000 |
      | numCheck    | 30     |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_RS", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 133 |
    And l'avviso pagopa viene pagato correttamente
    And si attende il corretto pagamento della notifica
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
    Then viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-WF-INHIBITION-PAID-7] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  Viene effettuato il pagamento dopo il primo SEND_ANALOG_DOMICILE e viene verificata la presenza degli elementi SCHEDULE_REFINEMENT e REFINEMENT.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy | DELIVERY_MODE |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime | 20000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    Then l'avviso pagopa viene pagato correttamente
    And si attende il corretto pagamento della notifica
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
    Then viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-WF-INHIBITION-PAID-8a] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  Viene effettuato il pagamento dopo il primo SEND_ANALOG_DOMICILE
  Viene inoltre verificata l'assenza del record in tabella pn-paper-notification-failed.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy | DELIVERY_MODE |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-Irreperibile_890 |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime | 20000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    Then l'avviso pagopa viene pagato correttamente
    And si attende il corretto pagamento della notifica
    And viene verificato che il destinatario "CLMCST42R12D969Z" di tipo "PF" non sia nella tabella pn-paper-notification-failed

  @e2e
  Scenario: [E2E-WF-INHIBITION-PAID-8b] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  Viene effettuato il pagamento dopo il primo SEND_ANALOG_DOMICILE.
  Viene inoltre verificata l'assenza del record in tabella pn-paper-notification-failed e del secondo SEND_ANALOG_DOMICILE
  e la presenza del REFINEMENT.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy | DELIVERY_MODE |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-Discovery_890 |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime | 20000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    Then l'avviso pagopa viene pagato correttamente
    And si attende il corretto pagamento della notifica
    Then viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" non esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 1 |
    Then viene verificato che l'elemento di timeline "REFINEMENT" non esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
    And viene verificato che il destinatario "CLMCST42R12D969Z" di tipo "PF" non sia nella tabella pn-paper-notification-failed


  @e2e
  Scenario: [E2E-WF-INHIBITION-PAID-9] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  Viene effettuato il pagamento dopo il secondo SEND_ANALOG_DOMICILE e viene verificata la presenza degli elementi SCHEDULE_REFINEMENT e REFINEMENT
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy | DELIVERY_MODE |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | VIA@FAIL-Discovery_890 |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 1 |
    Then l'avviso pagopa viene pagato correttamente
    And si attende il corretto pagamento della notifica
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
    Then viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-WF-INHIBITION-PAID-10] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  Viene effettuato il pagamento dopo il secondo SEND_ANALOG_DOMICILE e viene verificata la presenza degli elementi COMPLETELY_UNREACHABLE, SCHEDULE_REFINEMENT e REFINEMENT.
  Viene inoltre verificata la presenza del record in tabella pn-paper-notification-failed.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy | DELIVERY_MODE |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-DiscoveryIrreperibile_890 |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 1 |
    Then l'avviso pagopa viene pagato correttamente
    And si attende il corretto pagamento della notifica
    Then viene verificato che l'elemento di timeline "COMPLETELY_UNREACHABLE" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | legalFactsIds | [{"category": "ANALOG_FAILURE_DELIVERY"}] |
      | details | NOT_NULL |
      | details_recIndex | 0 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
    Then viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20    |
      | details | NOT_NULL |
      | details_recIndex | 0 |
    And viene verificato che il destinatario "CLMCST42R12D969Z" di tipo "PF" sia nella tabella pn-paper-notification-failed

