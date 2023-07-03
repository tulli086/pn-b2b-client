Feature: Analog send e2e

  @e2e
  Scenario: [E2E-PF_B2B_ANALOG_SEND_1] Invio ad indirizzo fisico successo al primo tentativo
    And viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | physicalCommunication | REGISTERED_LETTER_890           |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@OK-CompiutaGiacenza_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2.5 |
      | numCheck    | 10    |
    And si aggiunge alla sequence il controllo che "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | PNAG012 |
      | details_physicalAddress | {"address": "VIA@OK-COMPIUTAGIACENZA_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_responseStatus | OK |
    And si aggiunge alla sequence il controllo che "ANALOG_SUCCESS_WORKFLOW" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_physicalAddress | {"address": "VIA@OK-COMPIUTAGIACENZA_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
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
  Scenario: [E2E-PF_B2B_ANALOG_SEND_2] Invio ad indirizzo fisico fallimento al primo tentativo e successo al secondo tentativo
    And viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | physicalCommunication | REGISTERED_LETTER_890           |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | via@FAIL-Discovery_AR |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 2.5 |
      | numCheck    | 10    |
    And si aggiunge alla sequence il controllo che "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECRN002F |
      | details_physicalAddress | {"address": "VIA@FAIL-DISCOVERY_AR", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_responseStatus | KO |
    And si aggiunge alla sequence il controllo che "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 1 |
      | details_deliveryDetailCode | RECRN001C |
      | details_physicalAddress | {"address": "via@sequence.5s-CON080.5s-RECRN001A.5s-RECRN001B[DOC:AR].5s-RECRN001C", "municipality": "Milan", "province": "MI", "zip": "20121", "foreignState": "Italy"} |
      | details_responseStatus | OK |
    And si aggiunge alla sequence il controllo che "ANALOG_SUCCESS_WORKFLOW" esista
      | details_recIndex | 0 |
      | details_physicalAddress | {"address": "via@sequence.5s-CON080.5s-RECRN001A.5s-RECRN001B[DOC:AR].5s-RECRN001C", "municipality": "Milan", "province": "MI", "zip": "20121", "foreignState": "Italy"} |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_SUCCESS_WORKFLOW"
      | details_recIndex | 0 |
      | details_sentAttemptMade | 1 |
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
  Scenario: [E2E-PF_B2B_ANALOG_SEND_3] Invio ad indirizzo fisico fallimento al primo tentativo e al secondo tentativo
    And viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario "Mr. NoIndirizzi"
      | digitalDomicile | NULL |
      | physicalAddress_address | via@FAIL-DiscoveryIrreperibile_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene effettuato un controllo sulla durata della retention di "ATTACHMENTS" per l'elemento di timeline "REQUEST_ACCEPTED"
      | NULL | NULL |
    And viene inizializzata la sequence per il controllo sulla timeline
      | pollingTimeMultiplier | 4 |
      | numCheck    | 20    |
    And si aggiunge alla sequence il controllo che "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
      | details_deliveryDetailCode | RECAG003F |
      | details_physicalAddress | {"address": "VIA@FAIL-DISCOVERYIRREPERIBILE_890", "municipality": "MILANO", "municipalityDetails": "MILANO", "at": "Presso", "addressDetails": "SCALA B", "province": "MI", "zip": "87100", "foreignState": "ITALIA"} |
      | details_responseStatus | KO |
    And si aggiunge alla sequence il controllo che "SEND_ANALOG_FEEDBACK" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 1 |
      | details_deliveryDetailCode | RECAG003F |
      | details_physicalAddress | {"address": "via@sequence.5s-CON080.5s-RECAG003D[FAILCAUSE:M03].5s-RECAG003E[DOC:Plico].5s-RECAG003F", "municipality": "Milan", "province": "MI", "zip": "20121", "foreignState": "Italy"} |
      | details_responseStatus | KO |
    And si aggiunge alla sequence il controllo che "ANALOG_FAILURE_WORKFLOW" esista
      | details_recIndex | 0 |
      | details_sentAttemptMade | 0 |
    And si aggiunge alla sequence il controllo che "COMPLETELY_UNREACHABLE" esista
      | legalFactsIds | [{"category": "ANALOG_FAILURE_DELIVERY"}] |
      | details_recIndex | 0 |
    And si aggiunge alla sequence il controllo che "SCHEDULE_REFINEMENT" esista
      | details_recIndex | 0 |
    And viene verificata la sequence
    And viene schedulato il perfezionamento per decorrenza termini per il caso "ANALOG_FAILURE_WORKFLOW"
      | details_recIndex | 0 |
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