Feature: avanzamento notifiche asincrone b2b - controllo costi


  Scenario: [B2B_ASYNC_5] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “REQUEST_REFUSED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | NULL                        |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
    When la notifica viene inviata tramite api b2b con sha256 differente dal "Comune_Multi" e si attende che lo stato diventi REFUSED
    Then viene verificato che l'elemento di timeline "REQUEST_REFUSED" esista
    And  lettura amount posizione debitoria
    And  viene effettuato il controllo del amount di GPD = 0
    Then viene cancellata la posizione debitoria


  Scenario: [B2B_ASYNC_9] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “REQUEST_REFUSED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
    When la notifica viene inviata tramite api b2b con sha256 differente dal "Comune_Multi" e si attende che lo stato diventi REFUSED
    Then viene verificato che l'elemento di timeline "REQUEST_REFUSED" esista
    And  lettura amount posizione debitoria
    And  viene effettuato il controllo del amount di GPD = 0
    Then viene cancellata la posizione debitoria


  Scenario: [B2B_ASYNC_12] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “NOTIFICATION_CANCELLED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    When la notifica può essere annullata dal sistema tramite codice IUN
    When vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED"
    And  lettura amount posizione debitoria
    And  viene effettuato il controllo del amount di GPD = 0
    Then viene cancellata la posizione debitoria


  Scenario: [B2B_ASYNC_15] Notifica mono PG-Verifica amount GPD per notifica ASYNC in stato “NOTIFICATION_CANCELLED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Cucumber Society" con CF "20517490320"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario Cucumber Society e:
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    When la notifica può essere annullata dal sistema tramite codice IUN
    When vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED"
    And  lettura amount posizione debitoria
    And  viene effettuato il controllo del amount di GPD = 0
    Then viene cancellata la posizione debitoria


  Scenario: [B2B_ASYNC_20] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “VALIDATION“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then lettura amount posizione debitoria
    And  viene effettuato il confronto del amount del GPD con quello della notifica
    Then viene cancellata la posizione debitoria


  Scenario: [B2B_ASYNC_21] Notifica mono PF-Verifica amount GPD per notifica ASYNC fino a "SEND_ANALOG_DOMICILE" al primo tentativo
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile | NULL |
      | physicalAddress_address | via@FAIL-Discovery_AR |
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then lettura amount posizione debitoria
    And  viene effettuato il confronto del amount del GPD con quello della notifica
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" al tentativo "ATTEMPT_0"
    And  lettura amount posizione debitoria
    And  viene effettuato il confronto del amount del GPD con quello della notifica
    Then viene cancellata la posizione debitoria


  Scenario: [B2B_ASYNC_22] Notifica mono PF-Verifica amount GPD per notifica ASYNC fino a "SEND_ANALOG_DOMICILE" al secondo tentativo
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile | NULL |
      | physicalAddress_address | via@FAIL-Discovery_AR |
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then lettura amount posizione debitoria
    And  viene effettuato il confronto del amount del GPD con quello della notifica
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" al tentativo "ATTEMPT_0"
    And  lettura amount posizione debitoria
    And  viene effettuato il confronto del amount del GPD con quello della notifica
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" al tentativo "ATTEMPT_1"
    And  lettura amount posizione debitoria
    And  viene effettuato il confronto del amount del GPD con quello della notifica
    Then viene cancellata la posizione debitoria


  Scenario: [B2B_ASYNC_23] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “SEND_SIMPLE_REGISTERED_LETTER“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Cucumber Society" con CF "20517490320"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario Cucumber Society e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS    |
      | payment_creditorTaxId   | 77777777777  |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    When la notifica può essere annullata dal sistema tramite codice IUN
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And  lettura amount posizione debitoria
    And  viene effettuato il confronto del amount del GPD con quello della notifica
    Then viene cancellata la posizione debitoria


  Scenario: [B2B_ASYNC_24] Notifica mono PF-Verifica notifica async senza posizione debitoria
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi REFUSED

  Scenario: [B2B_ASYNC_24] Notifica mono PF-Verifica notifica async senza posizione debitoria
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi REFUSED



  Scenario: [B2B_PROVA_INTEGRAZIONE_GPD] Viene creata una posizione debitoria, interrogata e cancellata
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    And  lettura amount posizione debitoria
    When viene cancellata la posizione debitoria