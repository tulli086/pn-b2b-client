Feature: Digital send e2e

  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_1] Invio ad indirizzo di piattaforma successo al primo tentativo
    Given si predispone addressbook per l'utente "Mr. IndirizzoPiattaforma"
    And viene inserito un recapito legale "example@pecSuccess.it"
    And viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario "Mr. IndirizzoPiattaforma"
      | digitalDomicile | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 10    |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "DIGITAL_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "example@pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | numCheck    | 1    |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_2] Invio ad indirizzo di piattaforma fallimento al primo tentativo, successo al ritentativo e fallimento al secondo tentativo
    Given si predispone addressbook per l'utente "Mr. IndirizzoPiattaforma"
    And viene inserito un recapito legale "example@OK-pecFirstFailSecondSuccess.it"
    And viene generata una nuova notifica
      | subject | invio notifica con cucumber |
    And destinatario "Mr. IndirizzoPiattaforma"
      | digitalDomicile | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2.5 |
      | numCheck    | 8    |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And viene verificata la sequence
    And viene inserito un recapito legale "example@FAIL-pecFirstKO.it"
    # si ritenta l'invio
    And si attende che si ritenti l'invio dopo l'evento "SEND_DIGITAL_DOMICILE"
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck | 8 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    # secondo invio
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "DIGITAL_SUCCESS_WORKFLOW" esista
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | numCheck | 1 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_3] Invio ad indirizzo di piattaforma fallimento al primo tentativo, successo al ritentativo e al secondo tentativo
    Given si predispone addressbook per l'utente "Mr. IndirizzoPiattaforma"
    And viene inserito un recapito legale "example@OK-pecFirstFailSecondSuccess.it"
    And viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario "Mr. IndirizzoPiattaforma"
      | digitalDomicile | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2.5 |
      | numCheck    | 8    |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And viene verificata la sequence
    And viene inserito un recapito legale "example@OK-pecSuccess.it"
    # si ritenta l'invio
    And si attende che si ritenti l'invio dopo l'evento "SEND_DIGITAL_DOMICILE"
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck | 8 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    # secondo invio
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "DIGITAL_SUCCESS_WORKFLOW" esista
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | numCheck | 1 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_4] Invio ad indirizzo di piattaforma fallimento al primo tentativo e al ritentativo, successo al secondo tentativo
    Given si predispone addressbook per l'utente "Mr. IndirizzoPiattaforma"
    And viene inserito un recapito legale "example@FAIL-pecFirstKOSecondKO.it"
    And viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario "Mr. IndirizzoPiattaforma"
      | digitalDomicile | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2.5 |
      | numCheck    | 8    |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And viene verificata la sequence
    And viene inserito un recapito legale "example@OK-pecSuccess.it"
    # si ritenta l'invio
    And si attende che si ritenti l'invio dopo l'evento "SEND_DIGITAL_DOMICILE"
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck | 8 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    # secondo invio
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "DIGITAL_SUCCESS_WORKFLOW" esista
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | numCheck | 1 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_5] Invio ad indirizzo di piattaforma fallimento al primo tentativo, al ritentativo e al secondo tentativo
    Given si predispone addressbook per l'utente "Mr. IndirizzoPiattaforma"
    And viene inserito un recapito legale "example@FAIL-pecFirstKOSecondKO.it"
    And viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890 |
    And destinatario "Mr. IndirizzoPiattaforma"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2.5 |
      | numCheck | 8 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And viene verificata la sequence
    And viene inserito un recapito legale "example@FAIL-pecFirstKO.it"
    # si ritenta l'invio
    And si attende che si ritenti l'invio dopo l'evento "SEND_DIGITAL_DOMICILE"
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2.5 |
      | numCheck | 10 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    # secondo invio
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "DIGITAL_FAILURE_WORKFLOW" esista
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_FAILURE_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | numCheck | 1 |
    And si aggiunge alla sequence il controllo che "PREPARE_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA@OK_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And si aggiunge alla sequence il controllo che "SEND_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA@OK_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 133 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_6] Invio ad indirizzo speciale successo al primo tentativo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | testpagopa1@pnpagopa.postecert.local |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck | 4 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "testpagopa1@pnpagopa.postecert.local", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "testpagopa1@pnpagopa.postecert.local", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "DIGITAL_SUCCESS_WORKFLOW" esista
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "testpagopa1@pnpagopa.postecert.local", "type": "PEC"} |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | numCheck | 1 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e @ignore @OnlyEnvTest
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_7] Invio ad indirizzo speciale fallimento al primo tentativo e successo al secondo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | test@OK-pecFirstFailSecondSuccess.it |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 3 |
      | numCheck | 14 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "test@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_retryNumber | 0 |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "test@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "DIGITAL_SUCCESS_WORKFLOW" esista
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "test@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
    # secondo tentativo
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "test@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "test@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | numCheck | 1 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e @ignore @OnlyEnvTest
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_8] Invio ad indirizzo speciale fallimento al primo tentativo e fallimento al secondo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | test@FAIL-pecFirstKOSecondKO.it |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 3 |
      | numCheck | 14 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "test@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "test@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_retryNumber | 0 |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    #secondo tentativo
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "test@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "test@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "DIGITAL_FAILURE_WORKFLOW" esista
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_FAILURE_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | numCheck | 1 |
    And si aggiunge alla sequence il controllo che "PREPARE_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA SENZA NOME", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And si aggiunge alla sequence il controllo che "SEND_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA SENZA NOME", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 133 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e @ignore @OnlyEnvTest
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_9] Invio ad indirizzo generale successo al primo tentativo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario "Mr. IndirizzoGenerale"
      | digitalDomicile | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And si aggiunge alla sequence il controllo che "DIGITAL_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 0 |
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e @ignore @OnlyEnvTest
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_10] Invio ad indirizzo generale fallimento al primo tentativo, successo al ritentativo e fallimento al secondo tentativo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario "Mr. GeneraleRitentativo"
      | digitalDomicile | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | loadTimeline | true |
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    # si ritenta l'invio
    And si attende che si ritenti l'invio dopo l'evento "SEND_DIGITAL_DOMICILE"
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "DIGITAL_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    # secondo invio
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 0 |
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e @ignore @OnlyEnvTest
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_11] Invio ad indirizzo generale fallimento al primo tentativo, successo al ritentativo e al secondo tentativo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario "Mr. GeneraleRitentativoSecondo"
      | digitalDomicile | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | loadTimeline | true |
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    # si ritenta l'invio
    And si attende che si ritenti l'invio dopo l'evento "SEND_DIGITAL_DOMICILE"
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "DIGITAL_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecFirstFailSecondSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    # secondo invio
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 0 |
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e @ignore @OnlyEnvTest
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_12] Invio ad indirizzo generale fallimento al primo tentativo e al ritentativo, successo al secondo tentativo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario "Mr. GeneraleSecondo"
      | digitalDomicile | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | loadTimeline | true |
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    # si ritenta l'invio
    And si attende che si ritenti l'invio dopo l'evento "SEND_DIGITAL_DOMICILE"
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "DIGITAL_SUCCESS_WORKFLOW" esista
      | loadTimeline | true |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    # secondo invio
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | OK |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@OK-pecSuccess.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 0 |
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |

  @e2e @ignore @OnlyEnvTest
  Scenario: [E2E-PF-B2B_DIGITAL_SEND_13] Invio ad indirizzo generale fallimento al primo tentativo, al ritentativo e al secondo tentativo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890 |
    And destinatario "Mr. GeneraleFallimento"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | loadTimeline | true |
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    # si ritenta l'invio
    And si attende che si ritenti l'invio dopo l'evento "SEND_DIGITAL_DOMICILE"
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "DIGITAL_FAILURE_WORKFLOW" esista
      | loadTimeline | true |
      | legalFactsIds | [{"category": "DIGITAL_DELIVERY"}] |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKOSecondKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | isFirstSendRetry | true |
    # secondo invio
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_FEEDBACK" esista
      | details_responseStatus | KO |
      | details_sendingReceipts | [{"id": null, "system": null}] |
      | details_digitalAddress | {"address": "example@FAIL-pecFirstKO.it", "type": "PEC"} |
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 0 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | PLATFORM |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | false |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "GET_ADDRESS" esista
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
      | details_isAvailable | true |
      | isFirstSendRetry | true |
    And si aggiunge alla sequence il controllo che "SEND_SIMPLE_REGISTERED_LETTER" esista
      | loadTimeline | true |
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA@OK_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 133 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_FAILURE_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | GENERAL |
      | details_sentAttemptMade | 1 |
    And si aggiunge alla sequence il controllo che "PREPARE_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "VIA@OK_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" esista
      | loadTimeline | true |
      | details_recIndex | 0 |
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REFINEMENT"
      | details_recIndex | 0 |




