Feature: Workflow analogico

  @e2e @ignore
  Scenario: [E2E-PF_WF-ANALOG-MULTI-1] Invio notifica multi destinatario con percorso analogico.
  Successo raccomandata semplice + Successo raccomandata semplice.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "ANALOG_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    Then viene verificato che l'elemento di timeline "ANALOG_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    Then si verifica che lo stato della notifica sia "DELIVERED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG001B |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "23L"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG001B |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "23L"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG001C |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG001C |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 1 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_SUCCESS_WORKFLOW"
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 1 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 1 |


  @e2e @ignore
  Scenario: [E2E-PF_WF-ANALOG-MULTI-2] Invio notifica multi destinatario con percorso analogico.
  Successo raccomandata semplice + Fallimento raccomandata semplice.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-Irreperibile_AR |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "ANALOG_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    Then viene verificato che l'elemento di timeline "ANALOG_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
    Then si verifica che lo stato della notifica sia "DELIVERED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG001B |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "23L"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002E |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "Plico"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG001C |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002F |
      | details_deliveryFailureCause | M04 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 1 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_FAILURE_WORKFLOW"
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 1 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 1 |

  @e2e @ignore
  Scenario: [E2E-PF_WF-ANALOG-MULTI-3] Invio notifica multi destinatario con percorso analogico.
  Fallimento raccomandata semplice + Fallimento raccomandata semplice.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-Irreperibile_AR |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-Irreperibile_AR |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "ANALOG_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    Then viene verificato che l'elemento di timeline "ANALOG_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
    Then si verifica che lo stato della notifica sia "DELIVERED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002E |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "Plico"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002E |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "Plico"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002F |
      | details_deliveryFailureCause | M04 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002F |
      | details_deliveryFailureCause | M04 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 1 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_FAILURE_WORKFLOW"
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_FAILURE_WORKFLOW"
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 1 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 1 |

  @e2e
  Scenario: [E2E-PF_WF-ANALOG-MULTI-5] Invio notifica multi destinatario con percorso analogico.
  Fallimento raccomandata semplice + Successo raccomandata semplice, inibizione per visualizzazione.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-Irreperibile_AR |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SCHEDULE_ANALOG_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 10000 |
      | numCheck    | 30    |
      | details_recIndex | 1 |
    And la notifica può essere correttamente recuperata da "Mr. EmailCortesia"
    Then si verifica che lo stato della notifica sia "VIEWED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" non esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 15     |
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
    Then viene verificato che l'elemento di timeline "ANALOG_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002E |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "Plico"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002F |
      | details_deliveryFailureCause | M04 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_FAILURE_WORKFLOW"
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
  Scenario: [E2E-PF_WF-ANALOG-MULTI-6] Invio notifica multi destinatario con percorso analogico.
  Successo raccomandata semplice + Successo raccomandata semplice, inibizione per pagamento.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890 |
      | feePolicy | DELIVERY_MODE |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SCHEDULE_ANALOG_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 10000 |
      | numCheck    | 30    |
      | details_recIndex | 1 |
    Then l'avviso pagopa viene pagato correttamente per il destinatario con recIndex 1
    And si attende il corretto pagamento della notifica
    And viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" non esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 20     |
      | details | NOT_NULL |
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
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
      | details_deliveryDetailCode | RECAG001B |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "23L"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG001C |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene verificato che l'elemento di timeline "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 0 |

  @dev
  Scenario: [E2E-PF_WF-ANALOG-MULTI-7] Invio notifica ed attesa elemento di timeline SEND_ANALOG_FEEDBACK_scenario positivo
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario "Mr. UtenteQualsiasi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@OK_AR |
    And destinatario "Mr. UtenteQualsiasi2"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@OK_AR |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "ANALOG_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    Then viene verificato che l'elemento di timeline "ANALOG_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
    Then si verifica che lo stato della notifica sia "DELIVERED"
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002E |

  @e2e
  Scenario: [E2E-PF_WF-ANALOG-MULTI-8] Invio notifica multi destinatario con percorso analogico.
  Fallimento raccomandata semplice + Successo raccomandata semplice, inibizione per pagamento.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy | DELIVERY_MODE |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-Irreperibile_AR |
    And destinatario "Mr. EmailCortesia"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato che l'elemento di timeline "SCHEDULE_ANALOG_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 10000 |
      | numCheck    | 30    |
      | details_recIndex | 1 |
    Then l'avviso pagopa viene pagato correttamente per il destinatario con recIndex 1
    And si attende il corretto pagamento della notifica
    And viene verificato che l'elemento di timeline "SEND_ANALOG_DOMICILE" non esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 15     |
      | details_recIndex | 1 |
      | details_sentAttemptMade | 0 |
    Then viene verificato che l'elemento di timeline "ANALOG_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | CON080 |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_PROGRESS" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002E |
      | legalFactsIds | [{"category": "ANALOG_DELIVERY"}] |
      | details_attachments | [{"documentType": "Plico"}] |
    And viene verificato che l'elemento di timeline "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002F |
      | details_deliveryFailureCause | M04 |
    Then viene verificato che l'elemento di timeline "SCHEDULE_REFINEMENT" esista
      | loadTimeline | true |
      | pollingTime | 30000 |
      | numCheck    | 30    |
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_FAILURE_WORKFLOW"
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






    