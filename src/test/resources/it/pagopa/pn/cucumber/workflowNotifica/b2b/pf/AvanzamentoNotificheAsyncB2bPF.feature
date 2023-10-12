Feature: avanzamento notifiche asincrone b2b - controllo costi

  @testLite @workflowDigitale
  Scenario: [B2B_ASYNC_20] Notifica mono PF-Verifica amount GPD per notifica ASYNC in stato “VALIDATION“

   # Given viene creata una nuova richieste per istanziare una nuova posizione debitoria per l'ente creditore "77777777"

    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | feePolicy | DELIVERY_MODE |
      | pagoPaIntMode | ASYNC |
    And destinatario Mario Gherkin e:
      | payment_creditorTaxId | 77777777777 |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino allo stato della notifica "ACCEPTED"

