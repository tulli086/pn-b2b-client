Feature: avanzamento notifiche asincrone b2b - controllo costi

  Scenario: [B2B_ASYNC_1] Notifica mono PF-Caso creazione Notifica di tipo non ASYNC, validazione non prevista
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | SYNC                        |
      | paFee              | NULL                        |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED


  Scenario: [B2B_ASYNC_2] Notifica mono PF-Senza verifica amount GPD per notifica ASYNC e campo feePolicy a FLAT_RATE
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | FLAT_RATE                   |
      | pagoPaIntMode      | ASYNC                       |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED


  Scenario: [B2B_ASYNC_3] Notifica mono PF-Rifiuto in caso di notifiche che riportano l’indicazione di modalità asincrona di integrazione al cui interno risultano avvisi non abilitati alla modalità asincrona
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId        | CLMCST42R12D969Z   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED


  Scenario: [B2B_ASYNC_4] Notifica mono PF-Rifiuto caso notifiche che riportano l’indicazione di modalità asincrona di integrazione al cui interno risultano avvisi con pagamento già effettuato
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario
      | denomination          | Cristoforo Colombo |
      | taxId                 | CLMCST42R12D969Z   |
      | payment_creditorTaxId | 77777777777        |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And l'avviso pagopa viene pagato correttamente
    Then viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario
      | denomination          | Cristoforo Colombo |
      | taxId                 | CLMCST42R12D969Z   |
      | payment_creditorTaxId | 77777777777        |
    Then la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED
    Then viene cancellata la posizione debitoria


  Scenario: [B2B_ASYNC_5] Notifica mono PF-Senza verifica amount GPD per notifica ASYNC e campo paFee non popolato - Refused
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | NULL                        |
    And destinatario
      | denomination          | Cristoforo Colombo |
      | taxId                 | CLMCST42R12D969Z   |
      | payment_creditorTaxId | 77777777777        |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED


  Scenario: [B2B_ASYNC_6] Notifica multi PF/PG-Rifiuto di notifiche con modalità asincrona di integrazione al cui interno risultano avvisi non abilitati alla modalità asincrona
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo           |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario
      | denomination          | Cristoforo Colombo |
      | taxId                 | CLMCST42R12D969Z   |
      | payment_creditorTaxId | 77777777777        |
    And destinatario Cucumber Society e:
      | payment_creditorTaxId | 77777777777      |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED


  Scenario: [B2B_ASYNC_7] Notifica mono PG-Caso creazione Notifica di tipo non ASYNC, validazione non prevista
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | SYNC                        |
      | paFee              | NULL                        |
    And destinatario Cucumber Society e:
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b con sha256 differente dal "Comune_Multi" e si attende che lo stato diventi REFUSED


  Scenario: [B2B_ASYNC_8] Notifica mono PG-Rifiuto caso notifiche che riportano l’indicazione di modalità asincrona di integrazione al cui interno risultano avvisi con pagamento già effettuato
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cucumber Society" con Piva "20517490320"
    And viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario Cucumber Society e:
      | payment_creditorTaxId | 77777777777      |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And l'avviso pagopa viene pagato correttamente
    Then viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario Cucumber Society e:
      | payment_creditorTaxId | 77777777777      |
    Then la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_REFUSED"
    Then viene cancellata la posizione debitoria di "Cucumber Society"


  Scenario: [B2B_ASYNC_9] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “REQUEST_REFUSED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                           |
    And destinatario
      | denomination            | Cristoforo Colombo |
      | taxId                   | CLMCST42R12D969Z   |
      | payment_creditorTaxId   | 77777777777        |
      | physicalAddress_address | 0000               |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_REFUSED"
    And  lettura amount posizione debitoria di "Cristoforo Colombo"
    And  viene effettuato il controllo del amount di GPD = "100"
    Then viene cancellata la posizione debitoria di "Cristoforo Colombo"


  Scenario: [B2B_ASYNC_10] Notifica multi PF/PG-Verifica amount GPD in fase "REQUEST_REFUSED" costo aggiornato a 0
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    And viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cucumber Society" con Piva "20517490320"
    Then viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario
      | denomination            | Cristoforo Colombo |
      | taxId                   | CLMCST42R12D969Z   |
      | payment_creditorTaxId   | 77777777777        |
      | physicalAddress_address | 0000               |
    And destinatario
      | denomination            | Cucumber Society |
      | taxId                   | 20517490320      |
      | payment_creditorTaxId   | 77777777777      |
      | physicalAddress_address | 0000             |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi REFUSED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_REFUSED" per l'utente 0
    And  lettura amount posizione debitoria di "Cristoforo Colombo"
    And  viene effettuato il controllo del amount di GPD = "110"
    And  viene verificato il costo = "110" della notifica per l'utente 0
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_REFUSED" per l'utente 1
    And  lettura amount posizione debitoria di "Cucumber Society"
    And  viene effettuato il controllo del amount di GPD = "110"
    And  viene verificato il costo = "110" della notifica per l'utente 1
    Then viene cancellata la posizione debitoria di "Cristoforo Colombo"
    And viene cancellata la posizione debitoria di "Cucumber Society"



  Scenario: [B2B_ASYNC_11] Notifica mono PF-Aggiornamento costi KO per posizione debitoria non presente
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario
      | denomination          | Cristoforo Colombo |
      | taxId                 | CLMCST42R12D969Z   |
      | payment_creditorTaxId | 77777777777        |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED
    Then viene verificato che l'elemento di timeline "REQUEST_REFUSED" esista
    And viene verificato il costo = "100" della notifica


  Scenario: [B2B_ASYNC_12] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “NOTIFICATION_CANCELLED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario
      | denomination          | Cristoforo Colombo |
      | taxId                 | CLMCST42R12D969Z   |
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then la notifica può essere annullata dal sistema tramite codice IUN
    When vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED"
    Then lettura amount posizione debitoria di "Mario Gherkin"
    And  viene effettuato il controllo del amount di GPD = "0"
    And viene verificato il costo = "0" della notifica
    Then viene cancellata la posizione debitoria di "Mario Gherkin"


    #da vedere come fare il multipagamento
  Scenario: [B2B_ASYNC_13] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “NOTIFICATION_CANCELLED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario
      | denomination          | Cristoforo Colombo |
      | taxId                 | CLMCST42R12D969Z   |
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    When la notifica può essere annullata dal sistema tramite codice IUN
    When vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED"
    Then lettura amount posizione debitoria di "Mario Gherkin"
    And  viene effettuato il controllo del amount di GPD = "0"
    And viene verificato il costo = "0" della notifica
    Then viene cancellata la posizione debitoria di "Mario Gherkin"


  Scenario: [B2B_ASYNC_15] Notifica mono PG-Verifica amount GPD per notifica ASYNC in stato “NOTIFICATION_CANCELLED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cucumber Society" con Piva "20517490320"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario Cucumber Society e:
      | digitalDomicile       | NULL        |
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then la notifica può essere annullata dal sistema tramite codice IUN
    When vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED"
    Then lettura amount posizione debitoria di "Cucumber Society"
    And  viene effettuato il controllo del amount di GPD = "0"
    And viene verificato il costo = "0" della notifica
    Then viene cancellata la posizione debitoria di "Cucumber Society"


  Scenario: [B2B_ASYNC_17] Notifica multi PF/PG-Verifica amount GPD per notifica ASYNC in stato “NOTIFICATION_CANCELLED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    And viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cucumber Society" con Piva "20517490320"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario
      | denomination          | Cristoforo Colombo |
      | taxId                 | CLMCST42R12D969Z   |
      | payment_creditorTaxId | 77777777777        |
      | digitalDomicile       | NULL               |
    And destinatario Cucumber Society e:
      | digitalDomicile       | NULL        |
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And la notifica può essere annullata dal sistema tramite codice IUN
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED" per l'utente 0
    And  lettura amount posizione debitoria di "Cristoforo Colombo"
    And  viene effettuato il controllo del amount di GPD = "0"
    And  viene verificato il costo = "0" della notifica per l'utente 0
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED" per l'utente 1
    And  lettura amount posizione debitoria di "Cucumber Society"
    And  viene effettuato il controllo del amount di GPD = "0"
    And  viene verificato il costo = "0" della notifica per l'utente 1
    Then viene cancellata la posizione debitoria di "Cristoforo Colombo"
    And viene cancellata la posizione debitoria di "Cucumber Society"

  Scenario: [B2B_ASYNC_20] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “VALIDATION“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                           |
    And destinatario
      | denomination            | Cristoforo Colombo |
      | taxId                   | CLMCST42R12D969Z   |
      | payment_creditorTaxId   | 77777777777        |
      | physicalAddress_address | 0000               |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then  lettura amount posizione debitoria di "Cristoforo Colombo"
    And viene effettuato il controllo del amount di GPD = "210"
    And viene verificato il costo = "210" della notifica
    Then viene cancellata la posizione debitoria di "Cristoforo Colombo"


  Scenario: [B2B_ASYNC_21] Notifica mono PF-Verifica amount GPD per notifica ASYNC fino a "SEND_ANALOG_DOMICILE" al primo tentativo
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario
      | denomination            | Cristoforo Colombo    |
      | taxId                   | CLMCST42R12D969Z      |
      | digitalDomicile         | NULL                  |
      | physicalAddress_address | via@FAIL-Discovery_AR |
      | payment_creditorTaxId   | 77777777777           |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then lettura amount posizione debitoria di "Mario Gherkin"
    #And  viene effettuato il confronto del amount del GPD con quello della notifica
    And viene effettuato il controllo del amount di GPD = "210"
    And viene verificato il costo = "210" della notifica
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" al tentativo "ATTEMPT_0"
    And  lettura amount posizione debitoria di "Mario Gherkin"
    And viene effettuato il controllo del amount di GPD = "310"
    And viene verificato il costo = "310" della notifica
    Then viene cancellata la posizione debitoria di "Mario Gherkin"


  Scenario: [B2B_ASYNC_22] Notifica mono PF-Verifica amount GPD per notifica ASYNC fino a "SEND_ANALOG_DOMICILE" al secondo tentativo
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                         |
    And destinatario
      | denomination            | Cristoforo Colombo |
      | taxId                   | CLMCST42R12D969Z   |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@FAIL-Discovery_AR |
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then lettura amount posizione debitoria di "Mario Gherkin"
    And viene effettuato il controllo del amount di GPD = "210"
    And viene verificato il costo = "210" della notifica
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" al tentativo "ATTEMPT_0"
    And  lettura amount posizione debitoria di "Mario Gherkin"
    And viene effettuato il controllo del amount di GPD = "310"
    And viene verificato il costo = "310" della notifica
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" al tentativo "ATTEMPT_1"
    And  lettura amount posizione debitoria di "Mario Gherkin"
    And viene effettuato il controllo del amount di GPD = "410"
    And viene verificato il costo = "410" della notifica
    Then viene cancellata la posizione debitoria di "Mario Gherkin"


  Scenario: [B2B_ASYNC_23] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “SEND_SIMPLE_REGISTERED_LETTER“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario
      | denomination            | Cristoforo Colombo |
      | taxId                   | CLMCST42R12D969Z   |
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS    |
      | payment_creditorTaxId   | 77777777777  |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    Then  lettura amount posizione debitoria di "Mario Gherkin"
    And viene effettuato il controllo del amount di GPD = "210"
    And viene verificato il costo = "210" della notifica
    Then viene cancellata la posizione debitoria di "Mario Gherkin"


  Scenario: [B2B_ASYNC_24] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato "VALIDATION" --> “SEND_SIMPLE_REGISTERED_LETTER“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario
      | denomination            | Cristoforo Colombo |
      | taxId                   | CLMCST42R12D969Z   |
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS    |
      | payment_creditorTaxId   | 77777777777  |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And la notifica viene inviata tramite api b2b
    Then lettura amount posizione debitoria di "Mario Gherkin"
    And viene effettuato il controllo del amount di GPD = "210"
    And viene verificato il costo = "210" della notifica
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And  lettura amount posizione debitoria di "Mario Gherkin"
    And viene effettuato il controllo del amount di GPD = "310"
    And viene verificato il costo = "310" della notifica
    Then viene cancellata la posizione debitoria di "Mario Gherkin"

  Scenario: [B2B_ASYNC_25] Notifica mono PG-Verifica amount GPD per notifica ASYNC fino a "SEND_ANALOG_DOMICILE" al secondo tentativo
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cucumber Society" con Piva "20517490320"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario Cucumber Society e:
      | digitalDomicile | NULL |
      | physicalAddress_address | via@FAIL-Discovery_AR |
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then lettura amount posizione debitoria di "Cucumber Society"
    And viene effettuato il controllo del amount di GPD = "210"
    And viene verificato il costo = "210" della notifica
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" al tentativo "ATTEMPT_0"
    And  lettura amount posizione debitoria di "Cucumber Society"
    And viene effettuato il controllo del amount di GPD = "310"
    And viene verificato il costo = "310" della notifica
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" al tentativo "ATTEMPT_1"
    And  lettura amount posizione debitoria di "Cucumber Society"
    And viene effettuato il controllo del amount di GPD = "410"
    And viene verificato il costo = "410" della notifica
    Then viene cancellata la posizione debitoria di "Cucumber Society"


  Scenario: [B2B_ASYNC_26] Notifica multi PF/PG-Verifica amount GPD per notifica ASYNC in stato “SEND_SIMPLE_REGISTERED_LETTER“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cucumber Society" con Piva "20517490320"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario
      | denomination            | Cristoforo Colombo |
      | taxId                   | CLMCST42R12D969Z   |
      | digitalDomicile_address | test@fail.it       |
      | physicalAddress_address | Via@ok_RS          |
      | payment_creditorTaxId   | 77777777777        |
    And destinatario Cucumber Society e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS    |
      | payment_creditorTaxId   | 77777777777  |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER" per l'utente 0
    And  lettura amount posizione debitoria di "Cristoforo Colombo"
    And viene effettuato il controllo del amount di GPD = "210"
    And viene verificato il costo = "210" della notifica per l'utente 0
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER" per l'utente 1
    And  lettura amount posizione debitoria di "Cucumber Society"
    And  viene effettuato il controllo del amount di GPD = "210"
    And viene verificato il costo = "210" della notifica per l'utente 1
    Then viene cancellata la posizione debitoria di "Cristoforo Colombo"
    And viene cancellata la posizione debitoria di "Cucumber Society"


  Scenario: [B2B_ASYNC_27] Notifica mono PF-Verifica amount GPD per notifica ASYNC cancellazione posizione debitoria dopo validazione della notifica
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 10                          |
    And destinatario
      | denomination            | Cristoforo Colombo |
      | taxId                   | CLMCST42R12D969Z   |
      | payment_creditorTaxId   | 77777777777        |
      | digitalDomicile_address | test@fail.it       |
      | physicalAddress_address | Via@ok_RS          |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then lettura amount posizione debitoria di "Cristoforo Colombo"
    And  viene effettuato il controllo del amount di GPD = "210"
    And viene verificato il costo = "210" della notifica
    And  viene cancellata la posizione debitoria di "Cristoforo Colombo"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "210" della notifica



  Scenario: [B2B_ASYNC_40] Notifica mono PF-Verifica notifica async senza posizione debitoria
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi REFUSED


  Scenario: [B2B_ASYNC_41] Notifica mono PF-Verifica notifica async senza posizione debitoria
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi REFUSED


  Scenario: [B2B_PROVA_INTEGRAZIONE_GPD] Viene creata una posizione debitoria, interrogata e cancellata
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cucumber Society" con Piva "20517490320"
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Then lettura amount posizione debitoria di "Cristoforo Colombo"
    And lettura amount posizione debitoria di "Cucumber Society"
    Then viene cancellata la posizione debitoria di "Cristoforo Colombo"
    And viene cancellata la posizione debitoria di "Cucumber Society"