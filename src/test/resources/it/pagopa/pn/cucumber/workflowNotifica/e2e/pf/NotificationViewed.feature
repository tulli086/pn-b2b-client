Feature: Notifica visualizzata

  @e2e
  Scenario: [E2E-PF-NOTIFICATION-VIEWED-1] Visualizzazione da parte del destinatario della notifica
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
    And destinatario "Mr. UtenteQualsiasi2"
      | NULL | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene inizializzata la sequence per il controllo sulla timeline
      | numCheck    | 1    |
    And si aggiunge alla sequence il controllo che "REQUEST_ACCEPTED" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And la notifica può essere correttamente recuperata da "Mr. UtenteQualsiasi2"
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 4    |
    And si aggiunge alla sequence il controllo che "NOTIFICATION_VIEWED" esista
      | details_recIndex | 0 |
      | legalFactsIds | [{"category": "RECIPIENT_ACCESS"}] |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "NOTIFICATION_VIEWED"
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-PF-NOTIFICATION-VIEWED-2] Visualizzazione da parte del delegato della notifica
    Given "Mr. UtenteQualsiasi" viene delegato da "Mr. UtenteQualsiasi2"
    And "Mr. UtenteQualsiasi" accetta la delega "Mr. UtenteQualsiasi2"
    And viene generata una nuova notifica
      | subject | invio notifica con cucumber |
    And destinatario "Mr. UtenteQualsiasi2"
      | NULL | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene inizializzata la sequence per il controllo sulla timeline
      | numCheck    | 1    |
    And si aggiunge alla sequence il controllo che "REQUEST_ACCEPTED" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And la notifica può essere correttamente letta da "Mr. UtenteQualsiasi" con delega
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 4    |
    And si aggiunge alla sequence il controllo che "NOTIFICATION_VIEWED" esista
      | details_recIndex | 0 |
      | legalFactsIds | [{"category": "RECIPIENT_ACCESS"}] |
      | details_delegateInfo | {"denomination": "Mr. UtenteQualsiasi", "delegateType": "PF"} |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "NOTIFICATION_VIEWED"
      | details_recIndex | 0 |

  @e2e @ignore
  Scenario: [E2E-PF-NOTIFICATION-VIEWED-4] A valle della visualizzazione della notifica non deve essere generato un nuovo elemento di timeline NOTIFICATION VIEWED
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
    And destinatario "Mr. UtenteQualsiasi2"
      | NULL | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene inizializzata la sequence per il controllo sulla timeline
      | numCheck    | 1    |
    And si aggiunge alla sequence il controllo che "REQUEST_ACCEPTED" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And la notifica può essere correttamente recuperata da "Mr. UtenteQualsiasi2"
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 4    |
    And si aggiunge alla sequence il controllo che "NOTIFICATION_VIEWED" esista
      | details_recIndex | 0 |
      | legalFactsIds | [{"category": "RECIPIENT_ACCESS"}] |
    And viene verificata la sequence
    # seconda lettura
    And la notifica può essere correttamente recuperata da "Mr. UtenteQualsiasi2"
    And verifico che l'atto opponibile a terzi di "NOTIFICATION_VIEWED" sia lo stesso
      | details_recIndex | 0 |
      | legalFactsIds | [{"category": "RECIPIENT_ACCESS"}] |
    And viene verificato che il numero di elementi di timeline "NOTIFICATION_VIEWED" sia di 1
      | details_recIndex | 0 |
    And viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "NOTIFICATION_VIEWED"
      | details_recIndex | 0 |

  @e2e
  Scenario: [E2E-PF-NOTIFICATION-VIEWED-5] A valle della visualizzazione della notifica, il destinatario non deve essere nella tabella pn-paper-notification-failed
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | @FAIL-DiscoveryIrreperibile_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 4 |
      | numCheck    | 20    |
    And si aggiunge alla sequence il controllo che "COMPLETELY_UNREACHABLE" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene verificato che il destinatario "Mr. NoIndirizzi" di tipo "PF" sia nella tabella pn-paper-notification-failed
    And la notifica può essere correttamente recuperata da "Mr. NoIndirizzi"
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 4    |
    And si aggiunge alla sequence il controllo che "NOTIFICATION_VIEWED" esista
      | details_recIndex | 0 |
      | legalFactsIds | [{"category": "RECIPIENT_ACCESS"}] |
    And viene verificata la sequence
    And viene verificato che il destinatario "Mr. NoIndirizzi" di tipo "PF" non sia nella tabella pn-paper-notification-failed

  @e2e
  Scenario: [E2E-PF-WF-INHIBITION-2] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | testpagopa1@pnpagopa.postecert.local |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 4   |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_digitalAddress | {"address": "testpagopa1@pnpagopa.postecert.local", "type": "PEC"} |
    And viene verificata la sequence
    And la notifica può essere correttamente recuperata da "Mr. NoIndirizzi"
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 6    |
    And si aggiunge alla sequence il controllo che "NOTIFICATION_VIEWED" esista
      | details_recIndex | 0 |
      | legalFactsIds | [{"category": "RECIPIENT_ACCESS"}] |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" non esista
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" non esista
      | details_recIndex | 0 |
    And viene verificata la sequence

  @e2e
  Scenario: [E2E-PF-WF-INHIBITION-3] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  La notifica viene letta subito dopo la generazione dell'evento di timeline SCHEDULE_REFINEMENT. Questa lettura non deve generare
  un evento di timeline REFINEMENT.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | testpagopa1@pnpagopa.postecert.local |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 8    |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And la notifica può essere correttamente recuperata da "Mr. NoIndirizzi"
    And viene schedulato il perfezionamento per decorrenza termini per il caso "DIGITAL_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_digitalAddressSource | SPECIAL |
      | details_sentAttemptMade | 0 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 2    |
    And si aggiunge alla sequence il controllo che "REFINEMENT" non esista
      | details_recIndex | 0 |
    And viene verificata la sequence

  @e2e
  Scenario: [E2E-PF-WF-INHIBITION-4] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  Viene visualizzata la notifica dopo la generazione del secondo evento di timeline SEND_DIGITAL_DOMICILE. Il pagamento non deve generare
  un evento di timeline PREPARE_SIMPLE_REGISTERED_LETTER e SEND_SIMPLE_REGISTERED_LETTER.
  Viene verificata l'assenza degli elementi SCHEDULE_REFINEMENT e REFINEMENT.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di Palermo |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2.5 |
      | numCheck    | 15   |
    And si aggiunge alla sequence il controllo che "SEND_DIGITAL_DOMICILE" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 1 |
      | details_digitalAddressSource | SPECIAL |
      | details_digitalAddress | {"address": "test@fail.it", "type": "PEC"} |
    And viene verificata la sequence
    And la notifica può essere correttamente recuperata da "Mr. NoIndirizzi"
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 6    |
    And si aggiunge alla sequence il controllo che "PREPARE_SIMPLE_REGISTERED_LETTER" non esista
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SEND_SIMPLE_REGISTERED_LETTER" non esista
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" non esista
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "REFINEMENT" non esista
      | details_recIndex | 0 |
    And viene verificata la sequence

  @e2e
  Scenario: [E2E-PF-WF-INHIBITION-5] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  La notifica viene letta subito dopo essere stata accettata. Questa lettura non deve generare un evento di timeline SEND_ANALOG_DOMICILE.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di Palermo |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_AR |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then la notifica può essere correttamente recuperata da "Mr. NoIndirizzi"
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 6    |
    And si aggiunge alla sequence il controllo che "SEND_ANALOG_DOMICILE" non esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And viene verificata la sequence

  @e2e
  Scenario: [E2E-PF-WF-INHIBITION-6] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  La notifica viene letta subito dopo la generazione dell'evento di timeline ANALOG_FAILURE_WORKFLOW. Questa lettura non deve generare
  un evento di timeline REFINEMENT.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | @FAIL-DiscoveryIrreperibile_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 15   |
    And si aggiunge alla sequence il controllo che "ANALOG_FAILURE_WORKFLOW" esista
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And la notifica può essere correttamente recuperata da "Mr. NoIndirizzi"
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_FAILURE_WORKFLOW"
      | details_recIndex | 0 |
      | details_sentAttemptMade | 1 |
    And si attende che sia presente il perfezionamento per decorrenza termini
      | details_recIndex | 0 |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 2    |
    And si aggiunge alla sequence il controllo che "REFINEMENT" non esista
      | details_recIndex | 0 |
    And viene verificata la sequence

  @e2e
  Scenario: [E2E-PF-WF-INHIBITION-7] Invio notifica con percorso analogico. Notifica visualizzata tra un tentativo e l'altro
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di Palermo |
      | physicalCommunication | REGISTERED_LETTER_890           |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-Discovery_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 15   |
    And si aggiunge alla sequence il controllo che "SEND_ANALOG_DOMICILE" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And viene verificata la sequence
    And la notifica può essere correttamente recuperata da "Mr. NoIndirizzi"
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2.5 |
      | numCheck    | 15   |
    And si aggiunge alla sequence il controllo che "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "SEND_ANALOG_DOMICILE" non esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 1 |
    And viene verificata la sequence
    And viene verificato che il numero di elementi di timeline "SEND_ANALOG_DOMICILE" sia di 1
      | NULL | NULL |

  @e2e
  Scenario: [E2E-PF-WF-INHIBITION-8] Casistica in cui la visualizzazione di una notifica inibisce parte del workflow di notifica.
  Viene visualizzata la notifica subito dopo la generazione dell'evento di timeline SEND_SIMPLE_REGISTERED_LETTER.
  Viene verificata l'assenza dell'elemento REFINEMENT.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo |
      | feePolicy | DELIVERY_MODE |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2.5 |
      | numCheck    | 20   |
    And si aggiunge alla sequence il controllo che "SEND_SIMPLE_REGISTERED_LETTER" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK_RS", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_analogCost | 181 |
    And viene verificata la sequence
    And la notifica può essere correttamente recuperata da "Mr. NoIndirizzi"
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 4   |
    And si aggiunge alla sequence il controllo che "REFINEMENT" non esista
      | details_recIndex | 0 |
    And viene verificata la sequence

  @e2e
  Scenario: [E2E-PF-WF-INHIBITION-9] Destinatario completamente irreperibile. Casistiche in cui la visualizzazione di una notifica inibisce parte del workflow di notifica - step 1
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication | REGISTERED_LETTER_890 |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-DiscoveryIrreperibile_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 3 |
      | numCheck    | 5   |
    And si aggiunge alla sequence il controllo che "SEND_ANALOG_DOMICILE" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 1 |
    And viene verificata la sequence
    And la notifica può essere correttamente recuperata da "Mr. NoIndirizzi"
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2 |
      | numCheck    | 4   |
    And si aggiunge alla sequence il controllo che "NOTIFICATION_VIEWED" esista
      | details_recIndex | 0 |
      | legalFactsIds | [{"category": "RECIPIENT_ACCESS"}] |
    And si aggiunge alla sequence il controllo che "COMPLETELY_UNREACHABLE" non esista
      | details_recIndex | 0 |
    And viene verificata la sequence