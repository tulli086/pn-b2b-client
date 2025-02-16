Feature: avanzamento notifiche asincrone b2b PF - controllo costi

  @Async
  Scenario: [B2B_ASYNC_1_PF] Notifica mono PF-Caso creazione Notifica di tipo non ASYNC, validazione non prevista
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | SYNC                        |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId | 77777777777 |
      | payment_pagoPaForm    | SI          |
      | payment_f24           | NULL        |
      | apply_cost_pagopa     | SI          |
      | payment_multy_number  | 1           |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED

  @Async
  Scenario: [B2B_ASYNC_2_PF] Notifica mono PF-Senza verifica amount GPD per notifica ASYNC e campo feePolicy a FLAT_RATE
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | FLAT_RATE                   |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId | 77777777777 |
      | payment_pagoPaForm    | SI          |
      | payment_f24           | NULL        |
      | apply_cost_pagopa     | NO          |
      | payment_multy_number  | 1           |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED

  @Async @ignore
  Scenario: [B2B_ASYNC_4_PF] Notifica mono PF-Rifiuto caso notifiche che riportano l’indicazione di modalità asincrona di integrazione al cui interno risultano avvisi con pagamento già effettuato
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId | 77777777777 |
      | payment_pagoPaForm    | SI          |
      | payment_f24           | NULL        |
      | apply_cost_pagopa     | SI          |
      | payment_multy_number  | 1           |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And viene aggiunto il costo della notifica totale
    And lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And si controlla che l'aggiornamento del costo del utente 0 sia corretto
    And l'avviso pagopa viene pagato correttamente
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "PAYMENT" e successivamente annullata
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED"
    Then viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId | 77777777777 |
      | payment_pagoPaForm    | SI          |
      | payment_f24           | NULL        |
      | apply_cost_pagopa     | SI          |
      | payment_multy_number  | 1           |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    Then la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED
    Then viene cancellata la posizione debitoria di "Mario Gherkin"

  @Async @refused
  Scenario: [B2B_ASYNC_6_PF] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “REQUEST_REFUSED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | physicalAddress_municipality | Palermo     |
      | physicalAddress_zip          | 20019       |
      | physicalAddress_province     | MI          |
      | digitalDomicile              | NULL        |
      | payment_creditorTaxId        | 77777777777 |
      | payment_pagoPaForm           | SI          |
      | payment_f24                  | NULL        |
      | apply_cost_pagopa            | SI          |
      | payment_multy_number         | 1           |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED
    And  lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And  viene effettuato il controllo del amount di GPD = "100"
    Then viene cancellata la posizione debitoria di "Mario Gherkin"

  @Async
  Scenario: [B2B_ASYNC_8_PF] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “NOTIFICATION_CANCELLED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | payment_creditorTaxId   | 77777777777  |
      | payment_pagoPaForm      | SI           |
      | payment_f24             | NULL         |
      | apply_cost_pagopa       | SI           |
      | payment_multy_number    | 1            |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And viene aggiunto il costo della notifica totale
    And lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And si controlla che l'aggiornamento del costo del utente 0 sia corretto
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    Then la notifica può essere annullata dal sistema tramite codice IUN
    When vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED"
    Then lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And  viene effettuato il controllo del amount di GPD = "100"
    Then viene cancellata la posizione debitoria di "Mario Gherkin"

  @Async @ignore
  Scenario: [B2B_ASYNC_9_PF] Notifica mono PF Multipagamento-Verifica amount GPD notifica async dopo pagamento di un solo pagamento poi annullata la notifica il secondo pagamento amount non azzerrato
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    And viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId   | 77777777777  |
      | digitalDomicile_address | test@fail.it |
      | payment_pagoPaForm      | SI           |
      | payment_f24             | NULL         |
      | apply_cost_pagopa       | SI           |
      | payment_multy_number    | 2            |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 1
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then l'avviso pagopa 0 viene pagato correttamente dall'utente 0
    And viene cancellata la posizione debitoria del pagamento 0
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE" e successivamente annullata
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED"
    And lettura amount posizione debitoria per pagamento 1
    And viene effettuato il controllo del amount di GPD = "100"
    Then viene cancellata la posizione debitoria del pagamento 1

  @Async @ignore
  Scenario: [B2B_ASYNC_10_PF] Notifica mono PF Multipagamento-Verifica amount GPD notifica async dopo pagamento tutti i pagamenti poi annullata la notifica il secondo pagamento amount non azzerrato
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    And viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId   | 77777777777  |
      | digitalDomicile_address | test@fail.it |
      | payment_pagoPaForm      | SI           |
      | payment_f24             | NULL         |
      | apply_cost_pagopa       | SI           |
      | payment_multy_number    | 2            |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 1
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then l'avviso pagopa 0 viene pagato correttamente dall'utente 0
    And l'avviso pagopa 1 viene pagato correttamente dall'utente 0
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE" e successivamente annullata
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED"
    And lettura amount posizione debitoria per pagamento 0
    And viene effettuato il controllo del amount di GPD = "100"
    And lettura amount posizione debitoria per pagamento 1
    And viene effettuato il controllo del amount di GPD = "100"
    Then vengono cancellate le posizioni debitorie


  @Async
  Scenario: [B2B_ASYNC_11_PF] Notifica mono PF-Verifica amount GPD per notifica ASYNC per Multipagamento
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId   | 77777777777          |
      | digitalDomicile_address | test@fail.it         |
      | payment_pagoPaForm      | SI                   |
      | payment_f24             | PAYMENT_F24_STANDARD |
      | apply_cost_f24          | SI                   |
      | apply_cost_pagopa       | SI                   |
      | payment_multy_number    | 1                    |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    And viene aggiunto il costo della notifica totale
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS"
    And lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    Then viene effettuato il controllo del cambiamento del amount nella timeline "SEND_SIMPLE_REGISTERED_LETTER" del pagamento 0
    Then si controlla che l'aggiornamento del costo del utente 0 sia corretto
    And viene cancellata la posizione debitoria del pagamento 0

  @Async
  Scenario: [B2B_ASYNC_12_PF] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “VALIDATION“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId   | 77777777777  |
      | digitalDomicile_address | test@fail.it |
      | payment_pagoPaForm      | SI           |
      | payment_f24             | NULL         |
      | apply_cost_pagopa       | SI           |
      | payment_multy_number    | 1            |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    And viene aggiunto il costo della notifica totale
    Then  lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And si controlla che l'aggiornamento del costo del utente 0 sia corretto
    Then viene cancellata la posizione debitoria di "Mario Gherkin"

  @Async
  Scenario: [B2B_ASYNC_13_PF] Notifica mono PF-Verifica amount GPD per notifica ASYNC fino a "SEND_ANALOG_DOMICILE" al primo tentativo
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL                 |
      | physicalAddress_address | Via@ok_890           |
      | payment_creditorTaxId   | 77777777777          |
      | payment_pagoPaForm      | SI                   |
      | payment_f24             | PAYMENT_F24_STANDARD |
      | apply_cost_pagopa       | SI                   |
      | apply_cost_f24          | SI                   |
      | payment_multy_number    | 1                    |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    And viene aggiunto il costo della notifica totale
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" al tentativo "ATTEMPT_0"
    Then lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And viene effettuato il controllo del cambiamento del amount nella timeline "SEND_ANALOG_DOMICILE" del utente 0 al tentativo:
      | details                 | NOT_NULL |
      | details_recIndex        | 0        |
      | details_sentAttemptMade | 0        |
    Then si controlla che l'aggiornamento del costo del utente 0 sia corretto
    Then viene cancellata la posizione debitoria di "Mario Gherkin"

  @Async
  Scenario: [B2B_ASYNC_14_PF] Notifica mono PF-Verifica amount GPD per notifica ASYNC fino a "SEND_ANALOG_DOMICILE" al secondo tentativo
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL                  |
      | physicalAddress_address | via@fail-Discovery_AR |
      | payment_creditorTaxId   | 77777777777           |
      | payment_pagoPaForm      | SI                    |
      | payment_f24             | NULL                  |
      | apply_cost_pagopa       | SI                    |
      | payment_multy_number    | 1                     |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    And viene aggiunto il costo della notifica totale
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" al tentativo "ATTEMPT_0"
    And viene effettuato il controllo del cambiamento del amount nella timeline "SEND_ANALOG_DOMICILE" del utente 0 al tentativo:
      | details                 | NOT_NULL |
      | details_recIndex        | 0        |
      | details_sentAttemptMade | 0        |
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" al tentativo "ATTEMPT_1"
    Then  lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And viene effettuato il controllo del cambiamento del amount nella timeline "SEND_ANALOG_DOMICILE" del utente 0 al tentativo:
      | details                 | NOT_NULL |
      | details_recIndex        | 0        |
      | details_sentAttemptMade | 1        |
    Then si controlla che l'aggiornamento del costo del utente 0 sia corretto
    And viene cancellata la posizione debitoria di "Mario Gherkin"

  @Async
  Scenario: [B2B_ASYNC_15_PF] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato "SEND_SIMPLE_REGISTERED_LETTER"
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | payment_creditorTaxId   | 77777777777  |
      | payment_pagoPaForm      | SI           |
      | payment_f24             | NULL         |
      | apply_cost_pagopa       | SI           |
      | payment_multy_number    | 1            |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" per la posizione debitoria 0 del pagamento 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    Then viene aggiunto il costo della notifica totale
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS"
    Then lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And viene effettuato il controllo del cambiamento del amount nella timeline "SEND_SIMPLE_REGISTERED_LETTER" del utente 0
    Then si controlla che l'aggiornamento del costo del utente 0 sia corretto
    Then viene cancellata la posizione debitoria di "Mario Gherkin"

  @Async
  Scenario: [B2B_ASYNC_16_PF] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato "VALIDATION" --> “SEND_SIMPLE_REGISTERED_LETTER“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | payment_creditorTaxId   | 77777777777  |
      | payment_pagoPaForm      | SI           |
      | payment_f24             | NULL         |
      | apply_cost_pagopa       | SI           |
      | payment_multy_number    | 1            |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    And viene aggiunto il costo della notifica totale
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS"
    And lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And viene effettuato il controllo del cambiamento del amount nella timeline "SEND_SIMPLE_REGISTERED_LETTER" del utente 0
    Then si controlla che l'aggiornamento del costo del utente 0 sia corretto
    Then viene cancellata la posizione debitoria di "Mario Gherkin"


  @Async
  Scenario: [B2B_ASYNC_17_PF] Notifica mono PF-Verifica amount GPD per notifica ASYNC cancellazione posizione debitoria dopo validazione della notifica
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId   | 77777777777  |
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@OK_RS    |
      | payment_pagoPaForm      | SI           |
      | payment_f24             | NULL         |
      | apply_cost_pagopa       | SI           |
      | payment_multy_number    | 1            |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    Then viene aggiunto il costo della notifica totale
    Then lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And si controlla che l'aggiornamento del costo del utente 0 sia corretto
    And  viene cancellata la posizione debitoria di "Mario Gherkin"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"

  @Async
  Scenario: [B2B_ASYNC_21_PF] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato "VALIDATION" --> “SEND_SIMPLE_REGISTERED_LETTER“
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | payment_creditorTaxId   | 77777777777  |
      | payment_pagoPaForm      | SI           |
      | payment_f24             | NULL         |
      | apply_cost_pagopa       | SI           |
      | payment_multy_number    | 1            |
    And viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS"
    #And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    Then viene verificato il costo finale della notifica amount_gpd + costo_base + pafee + analog_cost per ogni elemento di timeline
    And viene cancellata la posizione debitoria di "Mario Gherkin"

    #dopo accettato amount_gpd + 100 (costo base) + pafee
    #Ogni elemento di timeline analogico ha un analog cost per ogni elemento va verificato che aumenti di  + analog_cost.
    #se riufiutata amount_gpd

  @version @Async @ignore
  Scenario: [B2B_ASYNC_1_VERSIONAMENTO] Creazione notifica ASYNC con V1 - Errore
    Given viene generata una nuova notifica V1
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Cucumber V1
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED "V1"
    Then si verifica lo scarto dell' acquisizione della notifica V1

  @Async @refused
  Scenario: [B2B_ASYNC_2_MULTI] Notifica multi PF/PG-Verifica amount GPD in fase "REQUEST_REFUSED" costo aggiornato a 0
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Gherkin Analogic" con Piva "05722930657"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | physicalAddress_municipality | Palermo     |
      | physicalAddress_zip          | 20019       |
      | physicalAddress_province     | MI          |
      | digitalDomicile              | NULL        |
      | payment_creditorTaxId        | 77777777777 |
      | payment_pagoPaForm           | SI          |
      | payment_f24                  | NULL        |
      | apply_cost_pagopa            | SI          |
      | payment_multy_number         | 1           |
    And destinatario Gherkin Analogic e:
      | physicalAddress_municipality | Palermo     |
      | physicalAddress_zip          | 20019       |
      | physicalAddress_province     | MI          |
      | digitalDomicile              | NULL        |
      | payment_creditorTaxId        | 77777777777 |
      | payment_pagoPaForm           | SI          |
      | payment_f24                  | NULL        |
      | apply_cost_pagopa            | SI          |
      | payment_multy_number         | 1           |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" per la posizione debitoria 0 del pagamento 0
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Gherkin Analogic" per la posizione debitoria 1 del pagamento 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED
    And  lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And  viene effettuato il controllo del amount di GPD = "100"
    And  lettura amount posizione debitoria per la notifica corrente di "Gherkin Analogic"
    And  viene effettuato il controllo del amount di GPD = "100"
    Then viene cancellata la posizione debitoria di "Mario Gherkin"
    And viene cancellata la posizione debitoria di "Gherkin Analogic"

  @Async
  Scenario: [B2B_ASYNC_3_MULTI] Notifica multi PF/PG-Verifica amount GPD per notifica ASYNC in stato "NOTIFICATION_CANCELLED"
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Gherkin Analogic" con Piva "05722930657"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId   | 77777777777           |
      | digitalDomicile         | NULL                  |
      | physicalAddress_address | Via@FAIL-Discovery_AR |
      | payment_pagoPaForm      | SI                    |
      | payment_f24             | NULL                  |
      | apply_cost_pagopa       | SI                    |
      | payment_multy_number    | 1                     |
    And destinatario Gherkin Analogic e:
      | payment_creditorTaxId   | 77777777777           |
      | digitalDomicile         | NULL                  |
      | physicalAddress_address | Via@FAIL-Discovery_AR |
      | payment_pagoPaForm      | SI                    |
      | payment_f24             | NULL                  |
      | apply_cost_pagopa       | SI                    |
      | payment_multy_number    | 1                     |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" per la posizione debitoria 0 del pagamento 0
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Gherkin Analogic" per la posizione debitoria 1 del pagamento 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED e successivamente annullata
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED"
    And  lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And  viene effettuato il controllo del amount di GPD = "100"
    And  lettura amount posizione debitoria per la notifica corrente di "Gherkin Analogic"
    And  viene effettuato il controllo del amount di GPD = "100"
    Then vengono cancellate le posizioni debitorie


  @Async @ignore
  Scenario: [B2B_ASYNC_4_MULTI] Notifica multi PF/PG-Verifica amount GPD per notifica ASYNC per Multipagamento
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    And viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    And viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Gherkin Analogic" con Piva "05722930657"
    And viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Gherkin Analogic" con Piva "05722930657"
    And viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId   | 77777777777           |
      | digitalDomicile         | NULL                  |
      | physicalAddress_address | Via@FAIL-Discovery_AR |
      | payment_pagoPaForm      | SI                    |
      | payment_f24             | NULL                  |
      | apply_cost_pagopa       | SI                    |
      | payment_multy_number    | 2                     |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" per la posizione debitoria 0 del pagamento 0
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" per la posizione debitoria 1 del pagamento 1
    And destinatario Gherkin Analogic e:
      | payment_creditorTaxId   | 77777777777           |
      | digitalDomicile         | NULL                  |
      | physicalAddress_address | Via@FAIL-Discovery_AR |
      | payment_pagoPaForm      | SI                    |
      | payment_f24             | NULL                  |
      | apply_cost_pagopa       | SI                    |
      | payment_multy_number    | 2                     |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Gherkin Analogic" per la posizione debitoria 2 del pagamento 0
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Gherkin Analogic" per la posizione debitoria 3 del pagamento 1
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    And viene aggiunto il costo della notifica totale
    Then l'avviso pagopa 0 viene pagato correttamente dall'utente 0
    And la notifica può essere annullata dal sistema tramite codice IUN
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED"
    And  lettura amount posizione debitoria per pagamento 0
    And  viene effettuato il controllo del amount di GPD con amount notifica del pagamento 0
    And  lettura amount posizione debitoria per pagamento 1
    And  viene effettuato il controllo del amount di GPD = "100"
    And  lettura amount posizione debitoria per pagamento 2
    And  viene effettuato il controllo del amount di GPD = "100"
    And  lettura amount posizione debitoria per pagamento 3
    And  viene effettuato il controllo del amount di GPD = "100"
    Then vengono cancellate le posizioni debitorie

  @Async @mockNR
  Scenario: [B2B_ASYNC_5_MULTI] Notifica multi PF/PG-Verifica amount GPD per notifica ASYNC in stato "SEND_SIMPLE_REGISTERED_LETTER"
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    And viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Gherkin Analogic" con Piva "05722930657"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | payment_creditorTaxId   | 77777777777  |
      | payment_pagoPaForm      | SI           |
      | payment_f24             | NULL         |
      | apply_cost_pagopa       | SI           |
      | payment_multy_number    | 1            |
    And destinatario Gherkin Analogic e:
      | digitalDomicile_address | test@fail.it |
      | payment_creditorTaxId   | 77777777777  |
      | payment_pagoPaForm      | SI           |
      | payment_f24             | NULL         |
      | apply_cost_pagopa       | SI           |
      | payment_multy_number    | 1            |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" per la posizione debitoria 0 del pagamento 0
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Gherkin Analogic" per la posizione debitoria 1 del pagamento 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    Then viene aggiunto il costo della notifica totale
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS" per l'utente 0
    And  lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And viene effettuato il controllo del cambiamento del amount nella timeline "SEND_SIMPLE_REGISTERED_LETTER" del utente 0 :
      | details          | NOT_NULL |
      | details_recIndex | 0        |
    Then si controlla che l'aggiornamento del costo del utente 0 sia corretto
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS" per l'utente 1
    And  lettura amount posizione debitoria per la notifica corrente di "Gherkin Analogic"
    And viene effettuato il controllo del cambiamento del amount nella timeline "SEND_SIMPLE_REGISTERED_LETTER" del utente 1 :
      | details          | NOT_NULL |
      | details_recIndex | 1        |
    Then si controlla che l'aggiornamento del costo del utente 1 sia corretto
    Then vengono cancellate le posizioni debitorie






