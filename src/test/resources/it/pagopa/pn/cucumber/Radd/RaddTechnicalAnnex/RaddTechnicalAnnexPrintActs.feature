Feature: Adeguamento RADD alle modifiche dell’allegato tecnico - Stampa degli atti

  #capire come configurare/riprendere caso in cui MAX-Print request ha valore definito == 0
  @raddAlt @zip
  Scenario: [ADEG-RADD-PRINT_ACTS-1] PF - Stampa illimitata di documenti disponibili associati a QR code esistente con CF corretto
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber radd alternative  |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    And Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    When L'operatore scansiona il qrCode e stampa gli atti per 2 volte senza errori
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_RADD_RETRIEVED"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "DELIVERED"
    And lato destinatario la notifica può essere correttamente recuperata da "Mario Cucumber" e verifica presenza dell'evento di timeline NOTIFICATION_RADD_RETRIEVED
    And lato desinatario "Mario Cucumber" viene verificato che l'elemento di timeline NOTIFICATION_VIEWED non esista

  #capire come configurare/riprendere caso in cui MAX-Print request ha valore definito > & != 0
  @raddAlt @zip
  Scenario: [ADEG-RADD-PRINT_ACTS-2] PF - Stampa limitata di documenti disponibili associati a QR code esistente con CF corretto
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber radd alternative  |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    And Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    When L'operatore scansiona il qrCode e stampa gli atti per 2 volte senza errori
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_RADD_RETRIEVED"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "DELIVERED"
    And lato destinatario la notifica può essere correttamente recuperata da "Mario Cucumber" e verifica presenza dell'evento di timeline NOTIFICATION_RADD_RETRIEVED
    And lato desinatario "Mario Cucumber" viene verificato che l'elemento di timeline NOTIFICATION_VIEWED non esista

  #capire come configurare/riprendere caso in cui MAX-Print request ha valore definito > & != 0
  @raddAlt @zip
  Scenario: [ADEG-RADD-PRINT_ACTS-3] PF - Restituzione errore - Stampa limitata di documenti disponibili associati con raggiungimento limite raggiunto
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber radd alternative  |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    And Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    And L'operatore scansiona il qrCode e stampa gli atti per 2 volte senza errori
    And Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    When L'operatore scansione il qrCode per recuperare gli atti da radd alternative
    Then Viene restituito un messaggio di errore "Limite di * stampe superato" con codice di errore 3 su radd alternative
    And vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_RADD_RETRIEVED"




