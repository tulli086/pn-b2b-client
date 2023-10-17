Feature: avanzamento notifiche asincrone b2b - controllo costi


  Scenario: [B2B_ASYNC_5] Notifica mono PF-Verifica amount GPD per notifica ASYNC e campo paFee non popolato - Refused
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | NULL                        |
    And destinatario
      | denomination | Cristoforo Colombo |
      | taxId | CLMCST42R12D969Z |
    When la notifica viene inviata tramite api b2b con sha256 differente dal "Comune_Multi" e si attende che lo stato diventi REFUSED
    Then viene verificato che l'elemento di timeline "REQUEST_REFUSED" esista
    And  lettura amount posizione debitoria
    And  viene effettuato il controllo del amount di GPD = 0
    Then viene cancellata la posizione debitoria


  Scenario: [B2B_ASYNC_7] Notifica mono PG-Verifica amount GPD per notifica non ASYNC validazione non prevista
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "GherkinSrl" con CF "12666810299"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | paFee              | 100                         |
    And destinatario Cucumber Society e:
      | payment_creditorTaxId | 77777777777 |
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


 #Si potrebbe aggiungere uno step che faccia il tentativo di lettura cosi possiamo prenderci il KO
 #Capire se per amount aggiornato a 0 intende la notifica non la posiozione debitoria
  Scenario: [B2B_ASYNC_11] Notifica mono PF-Verifica amount GPD per notifica ASYNC con posizione debitoria non presente
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
    And  l'operazione ha prodotto un errore con status code "404"
    And viene verificato il costo = "0" della notifica

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


    #Da vedere come gestire il multi se mettere 2 posizione debitorie
  #Vedere se aggiungere step che cancellano la posizione in base al nome del destinatario e si crea una lista di posizioni debitorie
  Scenario: [B2B_ASYNC_17] Notifica mono PF/PG-Verifica amount GPD per notifica ASYNC in stato “NOTIFICATION_CANCELLED“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    And viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Cucumber Society" con CF "20517490320"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario
      | denomination          | Cristoforo Colombo |
      | taxId                 | CLMCST42R12D969Z   |
      | payment_creditorTaxId | 77777777777        |
    And destinatario Cucumber Society e:
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And la notifica può essere annullata dal sistema tramite codice IUN dal comune "Comune_1"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED" per l'utente 0
    And  lettura amount posizione debitoria di "Cristoforo Colombo"
    And  viene effettuato il controllo del amount di GPD = 0 per "Cristoforo Colombo"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_CANCELLED" per l'utente 1
    And  lettura amount posizione debitoria di "Cucumber Society"
    And  viene effettuato il controllo del amount di GPD = 0 per "Cucumber Society"
    Then viene cancellata la posizione debitoria per "Cristoforo Colombo"
    And viene cancellata la posizione debitoria per "Cucumber Society"

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
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
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
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And  lettura amount posizione debitoria
    And  viene effettuato il confronto del amount del GPD con quello della notifica
    Then viene cancellata la posizione debitoria


  Scenario: [B2B_ASYNC_24] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato "VALIDATION" --> “SEND_SIMPLE_REGISTERED_LETTER“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_address | Via@ok_RS    |
      | payment_creditorTaxId   | 77777777777  |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then lettura amount posizione debitoria
    And  viene effettuato il confronto del amount del GPD con quello della notifica
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And  lettura amount posizione debitoria
    And  viene effettuato il confronto del amount del GPD con quello della notifica
    Then viene cancellata la posizione debitoria

  Scenario: [B2B_ASYNC_25] Notifica mono PG-Verifica amount GPD per notifica ASYNC fino a "SEND_ANALOG_DOMICILE" al secondo tentativo
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Cucumber Society" con CF "20517490320"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario Cucumber Society e:
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


  Scenario: [B2B_ASYNC_26] Notifica mono PF/PG-Verifica amount GPD per notifica ASYNC in stato “SEND_SIMPLE_REGISTERED_LETTER“
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Cucumber Society" con CF "20517490320"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
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
    And  viene effettuato il controllo del amount di GPD = 0 per "Cristoforo Colombo"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER" per l'utente 1
    And  lettura amount posizione debitoria di "Cucumber Society"
    And  viene effettuato il controllo del amount di GPD = 0 per "Cucumber Society"
    Then viene cancellata la posizione debitoria per "Cristoforo Colombo"
    And viene cancellata la posizione debitoria per "Cucumber Society"

  Scenario: [B2B_ASYNC_27] Notifica mono PF-Verifica amount GPD per notifica ASYNC cancellazione posizione debitoria dopo validazione della notifica
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | paFee              | 100                         |
    And destinatario
      | denomination          | Cristoforo Colombo |
      | taxId                 | CLMCST42R12D969Z   |
      | payment_creditorTaxId | 77777777777        |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then lettura amount posizione debitoria
    And  viene cancellata la posizione debitoria
    And  viene effettuato il confronto del amount del GPD con quello della notifica



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
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Cristoforo Colombo" con CF "CLMCST42R12D969Z"
    And  lettura amount posizione debitoria
    When viene cancellata la posizione debitoria