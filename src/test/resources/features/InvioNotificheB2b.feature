Feature: invio notifiche b2b

  @B2Btest
  @SmokeTest
  Scenario: [B2B-PA-SEND_1] Invio notifica digitale mono destinatario e recupero tramite codice IUN (p.fisica)_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | senderTaxId | 01199250158 |
    And destinatario
      | denomination | Mario Cucumber |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN



  @B2Btest
  Scenario: [B2B-PA-SEND_2] Invio notifiche digitali mono destinatario (p.fisica)_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
      | idempotenceToken | AME2E3626070001.1  |
    And destinatario
      | denomination | Mario Cucumber |
    And la notifica viene inviata tramite api b2b e si attende che venga accettata
    And si verifica la corretta acquisizione della notifica
    And viene generata una nuova notifica con uguale paProtocolNumber e idempotenceToken "AME2E3626070001.2"
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica

  @B2Btest
  Scenario: [B2B-PA-SEND_3] invio notifiche digitali mono destinatario (p.fisica)_scenario negativo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
      | idempotenceToken | AME2E3626070001.1  |
    And destinatario
      | denomination | Mario Cucumber |
      | taxId | FRMTTR76M06B715E |
    And la notifica viene inviata tramite api b2b e si attende che venga accettata
    And si verifica la corretta acquisizione della notifica
    And viene generata una nuova notifica con uguale paProtocolNumber e idempotenceToken "AME2E3626070001.1"
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "409"

  @B2Btest
  Scenario: [B2B-PA-SEND_4] invio notifiche digitali mono destinatario (p.fisica)_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
    And destinatario
      | denomination | Mario Cucumber |
      | taxId | FRMTTR76M06B715E |
      | payment_creditorTaxId | 77777777777 |
    And la notifica viene inviata tramite api b2b e si attende che venga accettata
    And si verifica la corretta acquisizione della notifica
    And viene generata una nuova notifica con uguale codice fiscale del creditore e diverso codice avviso
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica

  @SmokeTest
  Scenario: [B2B-PA-SEND_5] invio notifiche digitali mono destinatario (p.fisica)_scenario negativo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
    And destinatario
      | denomination | Mario Cucumber |
      | taxId | FRMTTR76M06B715E |
      | payment_creditorTaxId | 77777777777 |
    And la notifica viene inviata tramite api b2b e si attende che venga accettata
    And si verifica la corretta acquisizione della notifica
    And viene generata una nuova notifica con uguale codice fiscale del creditore e uguale codice avviso
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "409"

  @B2Btest
  @SmokeTest
  Scenario: [B2B-PA-SEND_6] download documento notificato_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
      | document | SI |
    And destinatario
      | denomination | Mario Cucumber |
    And la notifica viene inviata tramite api b2b e si attende che venga accettata
    And si verifica la corretta acquisizione della notifica
    When viene richiesto il download del documento "NOTIFICA"
    Then il download si conclude correttamente

  @SmokeTest
  Scenario: [B2B-PA-SEND_7] download documento pagopa_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
    And destinatario
      | denomination | Mario Cucumber |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | SI |
      | payment_f24standard | NULL |
    And la notifica viene inviata tramite api b2b e si attende che venga accettata
    And si verifica la corretta acquisizione della notifica
    When viene richiesto il download del documento "PAGOPA"
    Then il download si conclude correttamente


  Scenario: [B2B-PA-SEND_8] download documento f24_standard_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
      | feePolicy | DELIVERY_MODE |
    And destinatario
      | denomination | Mario Cucumber |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | SI |
    And la notifica viene inviata tramite api b2b e si attende che venga accettata
    And si verifica la corretta acquisizione della notifica
    When viene richiesto il download del documento "PAGOPA"
    Then il download si conclude correttamente

  @SmokeTest
  Scenario: [B2B-PA-SEND_9] invio notifiche digitali mono destinatario senza physicalAddress (p.fisica)_scenario negativo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
    And destinatario
      | denomination | Mario Cucumber |
      | physicalAddress | NULL |
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "400"

  Scenario: [B2B-PA-SEND_10] Invio notifica digitale mono destinatario e recupero tramite codice IUN_scenario negativo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
    And destinatario
      | denomination | Mario Cucumber |
    And la notifica viene inviata tramite api b2b e si attende che venga accettata
    And si verifica la corretta acquisizione della notifica
    When si tenta il recupero della notifica dal sistema tramite codice IUN "IUNUGYD-XHEZ-KLRM-202208-X-0"
    Then l'operazione ha prodotto un errore con status code "404"


  Scenario: [B2B-PA-SEND_11] Invio notifica digitale mono destinatario Flat_rate_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
      | feePolicy | FLAT_RATE |
    And destinatario
      | denomination | Mario Cucumber |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica

  Scenario: [B2B-PA-SEND_12] Invio notifica digitale mono destinatario Delivery_mode_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
      | feePolicy | DELIVERY_MODE |
    And destinatario
      | denomination | Mario Cucumber |
      | payment_pagoPaForm | SI |
      | payment_f24flatRate | NULL |
      | payment_f24standard | NULL |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica


  Scenario Outline: [B2B-PA-SEND_13] Invio notifica digitale mono destinatario e recupero tramite codice IUN (p.fisica)_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | senderTaxId | 01199250158 |
    And destinatario
      | denomination | Mario Cucumber |
      | physicalAddress_municipality | <comune> |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN

    Examples:
      |  comune           |
      | san donà di piave |
      | Canneto sull'Oglio|
      | Erbè              |
      | Forlì             |
      | Nardò             |


  Scenario Outline: [B2B-PA-SEND_14] Invio notifica digitale mono destinatario e recupero tramite codice IUN (p.fisica)_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | senderTaxId | 01199250158 |
    And destinatario
      | denomination | Mario Cucumber |
      | physicalAddress_municipalityDetails | <localita> |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN

    Examples:
      |     localita       |
      | san donà di piave  |
      | Canneto sull'Oglio |
      | Erbè               |
      | Forlì              |
      | Nardò              |



  Scenario Outline: [B2B-PA-SEND_15] Invio notifica digitale mono destinatario e recupero tramite codice IUN (p.fisica)_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | senderTaxId | 01199250158 |
    And destinatario
      | denomination | Mario Cucumber |
      | physicalAddress_address | <indirizzo> |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN

    Examples:
      |   indirizzo   |
      | via dà        |
      | via dell'anno |
      | via è         |
      | via ì         |
      | via ò         |



  Scenario Outline: [B2B-PA-SEND_16] Invio notifica digitale mono destinatario e recupero tramite codice IUN (p.fisica)_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | senderTaxId | 01199250158 |
    And destinatario
      | denomination | Mario Cucumber |
      | physicalAddress_State | <stato> |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN

    Examples:
      |   stato             |
      | Città del Vaticano  |
      | Costa d'Avorio      |
      | Perù                |



  Scenario Outline: [B2B-PA-SEND_17] invio notifica con oggetto contenente caratteri speciali_scenario positivo
    Given viene generata una notifica
      | subject | <name> |
      | senderDenomination | comune di milano  |
    And destinatario
      | denomination | Mario Cucumber |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN
    Examples:
      |      name        |
      | irrinunciabilità |
      | trentatré        |
      | altresì          |
      | bistrò           |
      | più              |
      | dall'atto        |


  Scenario Outline: [B2B-PA-SEND_18] invio notifica a destinatario la cui denominazione contenente caratteri speciali_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano  |
    And destinatario
      | denomination | <denomination> |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN
    Examples:
      | denomination    |
      | Nicolò Rossi    |
      | Raffaella Carrà |
      | Ilaria D'Amico  |
      | Salvator Dalì   |
      | Bruno Nicolè    |
      | dudù            |



  Scenario Outline: [B2B-PA-SEND_19] invio notifiche digitali mono destinatario con parametri denomination errati_scenario negativo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
    And destinatario
      | denomination | <denomination> |
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "400"
    Examples:
      | denomination    |
      | 0_CHAR  |
      | 81_CHAR |

  Scenario Outline: [B2B-PA-SEND_20] invio notifiche digitali mono destinatario con parametri senderDenomination errati_scenario negativo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | <denomination> |
    And destinatario
      | denomination | Mario Cucumber |
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "400"
    Examples:
      | denomination    |
      | 0_CHAR  |
      | 81_CHAR |

  Scenario Outline: [B2B-PA-SEND_21] invio notifiche digitali mono destinatario con parametri tax_id errati_scenario negativo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
    And destinatario
      | taxId | <taxId> |
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "400"
    Examples:
      | taxId   |
      | 1000000000 |
      | 17000000000000000 |
      | FRMTTR76M06B715 |
      | FRMTTRZ6M06B715E |
      | FRMTTR76M0YB715E |
      | FRMTTR76M06B7W5E |
      #1) 10 numeri (min 11)
      #2) 17 numeri (max 16)
      #3) CF non valido (lettera finale mancante)
      #4) Lettera omocodia non contemplata (primi 2 numeri)
      #5) Lettera omocodia non contemplata (seconda serie di 2 numeri)
      #6) Lettera omocodia non contemplata (serie di 3 numeri finale)

  Scenario Outline: [B2B-PA-SEND_22] invio notifiche digitali mono destinatario con parametri tax_id corretti_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
    And destinatario
      | taxId | <taxId> |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN
    Examples:
      | taxId   |
      | FRMTTR76M06B715E |
      | FRMTTR76M0MB715E |
      | FRMTTR76M06B7P5E |
      #1) Lettera omocodia contemplata (primi 2 numeri)
      #2) Lettera omocodia contemplata (seconda serie di 2 numeri)
      #3) Lettera omocodia contemplata (serie di 3 numeri finale)


  Scenario Outline: [B2B-PA-SEND_23] invio notifiche digitali mono destinatario con parametri creditorTaxId errati_scenario negativo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
    And destinatario
      | payment_creditorTaxId | <creditorTaxId> |
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "400"
    Examples:
      | creditorTaxId   |
      | 1000000000 |
      | 120000000000 |
      | 11_CHAR |
      #1) 10 numeri (min 11)
      #2) 12 numeri (max 11)
      #3) 11 lettere (ammessi solo numeri)


  Scenario Outline: [B2B-PA-SEND_24] invio notifiche digitali mono destinatario con parametri senderTaxId errati_scenario negativo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
      | senderTaxId | <senderTaxId> |
    And destinatario
      | denomination | Mario Cucumber |
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "400"
    Examples:
      | senderTaxId   |
      | 1000000000 |
      | 120000000000 |
      | 11_CHAR |
      #1) 10 numeri (min 11)
      #2) 12 numeri (max 11)
      #3) 11 lettere (ammessi solo numeri)


  Scenario: [B2B-PA-SEND_25] verifica retention time dei documenti per la notifica inviata
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | senderTaxId | 01199250158 |
    And destinatario
      | denomination | Mario Cucumber |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And viene effettuato un controllo sulla durata della retention di "ATTO OPPONIBILE"

  Scenario: [B2B-PA-SEND_26] verifica retention time pagopaForm per la notifica inviata
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | senderTaxId | 01199250158 |
    And destinatario
      | denomination | Mario Cucumber |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And viene effettuato un controllo sulla durata della retention di "PAGOPA"

  Scenario: [B2B-PA-SEND_27] verifica retention time dei documenti pre-caricati
    Given viene effettuato il pre-caricamento di un documento
    Then viene effettuato un controllo sulla durata della retention di "ATTO OPPONIBILE" precaricato

  Scenario: [B2B-PA-SEND_28] verifica retention time  pagopaForm pre-caricato
    Given viene effettuato il pre-caricamento di un allegato
    Then viene effettuato un controllo sulla durata della retention di "PAGOPA" precaricato

  Scenario: [B2B-PA-SEND_29] Invio notifica digitale mono destinatario senza taxonomyCode (verifica Default)_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | senderTaxId | 01199250158 |
      | taxonomyCode |   NULL   |
    And destinatario
      | denomination | Mario Cucumber |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And viene controllato la presenza del taxonomyCode


  Scenario: [B2B-PA-SEND_30] Invio notifica digitale mono destinatario con taxonomyCode (verifica Default)_scenario positivo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | senderTaxId | 01199250158 |
      | taxonomyCode |   020202201P   |
    And destinatario
      | denomination | Mario Cucumber |
    When la notifica viene inviata tramite api b2b e si attende che venga accettata
    Then si verifica la corretta acquisizione della notifica
    And viene controllato la presenza del taxonomyCode


  Scenario Outline: [B2B-PA-SEND_24] invio notifiche digitali mono destinatario con parametri subject errati_scenario negativo
    Given viene generata una notifica
      | subject | <subject> |
      | senderDenomination | comune di milano |
    And destinatario
      | denomination | Mario Cucumber |
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "400"
    Examples:
      | subject   |
      | 513_CHAR |

  Scenario Outline: [B2B-PA-SEND_24] invio notifiche digitali mono destinatario con parametri abstract errati_scenario negativo
    Given viene generata una notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | comune di milano |
      | abstract | <abstract> |
    And destinatario
      | denomination | Mario Cucumber |
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "400"
    Examples:
      | abstract   |
      | 1025_CHAR |


     #Scenario in errore
 # Scenario: [B2B-PA-SEND_19] invio notifica digitale mono destinatario (p.fisica)_scenario negativo
  #  Given viene generata una notifica
   #   | subject | invio notifica con cucumber |
  #    | senderDenomination | comune di milano |
   #   | senderTaxId | 01199250158 |
   # And destinatario
   #   | denomination | Mario Cucumber |
   #   | taxId | aaa |
    #When la notifica viene inviata
   # Then l'operazione ha prodotto un errore con status code "409"

    #Scenario in errore
  #Scenario: [B2B-PA-SEND_20] Invio notifica digitale mono destinatario DeliveryMode-Senza-F24_Standard_scenario negativo
  #  Given viene generata una notifica
    #  | subject | invio notifica con cucumber |
   #   | senderDenomination | comune di milano |
    #  | senderTaxId | 01199250158 |
   #  | feePolicy | DELIVERY_MODE |
   # And destinatario
    #  | denomination | Mario Cucumber |
    #  | payment_pagoPaForm | SI |
    #  | payment_f24flatRate | SI |
    #  | payment_f24standard | NULL |
    #When la notifica viene inviata tramite api b2b e si attende che venga accettata
    #Then l'operazione ha prodotto un errore con status code "400"

    #Scenario in errore
  #Scenario: [B2B-PA-SEND_21] Invio notifica digitale mono destinatario FLAT_RATE-Senza-F24_FlatRate_scenario negativo
    #Given viene generata una notifica
     # | subject | invio notifica con cucumber |
    # | senderDenomination | comune di milano |
     # | senderTaxId | 01199250158 |
     # | feePolicy | FLAT_RATE |
   # And destinatario
     # | denomination | Mario Cucumber |
    #  | payment_pagoPaForm | SI |
    #  | payment_f24flatRate | NULL |
    #  | payment_f24standard | SI |
   # When la notifica viene inviata tramite api b2b e si attende che venga accettata
   # Then l'operazione ha prodotto un errore con status code "400"
