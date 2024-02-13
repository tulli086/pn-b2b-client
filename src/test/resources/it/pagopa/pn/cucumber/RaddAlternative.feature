Feature: Radd Alternative


  @raddAlt
  Scenario: [RADD-ALT_ACT-1] PF - Scansione QR code esistente associato al CF corretto
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    And Il cittadino "Mario Cucumber" mostra il QRCode "corretto" su radd alternative
    When L'operatore scansione il qrCode per recuperare gli atti della "PF"
    And la scansione si conclude correttamente su radd alternative


  @raddAlt
  Scenario: [RADD-ALT_ACT-2] PF - Scansione QR code esistente associato al CF corretto, ma relativo a una notifica con perfezionamento > 120 giorni
    When Il cittadino "Mario Cucumber" mostra il QRCode "dopo 120gg"
    Then L'operatore scansione il qrCode per recuperare gli atti su radd alternative
    And Viene restituito un messaggio di errore "QRcode non valido" con codice di errore 1 su radd alternative


  @raddAlt
  Scenario: [RADD-ALT_ACT-3] PF - Scansione QR code inesistente
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    And Il cittadino "Mario Cucumber" mostra il QRCode "inesistente" su radd alternative
    When L'operatore scansione il qrCode per recuperare gli atti su radd alternative
    Then Viene restituito un messaggio di errore "QRcode non valido" con codice di errore 1 su radd alternative


  @raddAlt
  Scenario: [RADD-ALT_ACT-4] PF - Scansione QR code esistente associato al CF sbagliato
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    And Il cittadino "Mario Cucumber" mostra il QRCode "appartenente a terzo" su radd alternative
    When L'operatore scansione il qrCode per recuperare gli atti su radd alternative
    Then Viene restituito un messaggio di errore "CF non valido" con codice di errore 1 su radd alternative


  @raddAlt
  Scenario: [RADD-ALT_ACT-5] PF - Scansione documenti e creazione file zip
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED

  @raddAlt
  Scenario: [RADD-ALT_ACT-6] PF - Stampa documenti disponibili associati a QR code esistente con CF corretto
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    When Il cittadino "Mario Cucumber" mostra il QRCode "corretto" su radd alternative
    Then L'operatore scansione il qrCode per recuperare gli atti su radd alternative
    And la scansione si conclude correttamente su radd alternative
    And vengono caricati i documento di identità del cittadino su radd alternative
    And Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR su radd alternative
    And l'operazione di download degli atti si conclude correttamente su radd alternative


  @raddAlt
  Scenario: [RADD-ALT_ACT-7] PF - Consegna documenti al cittadino successivi alla stampa
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    Then Il cittadino "Mario Cucumber" mostra il QRCode "corretto"
    And L'operatore scansione il qrCode per recuperare gli atti su radd alternative
    And la scansione si conclude correttamente su radd alternative
    And vengono caricati i documento di identità del cittadino su radd alternative
    And Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR su radd alternative
    And l'operazione di download degli atti si conclude correttamente su radd alternative
    And viene conclusa la visualizzati di atti ed attestazioni della notifica su radd alternative

  @raddAlt
  Scenario: [RADD-ALT_ACT-8] PF - Visualizzazione in timeline nuovo evento di avvenuta consegna documenti tramite RADD (NOTIFICATION_RADD_RETRIEVED)
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    When Il cittadino "Mario Cucumber" mostra il QRCode "corretto" su radd alternative
    Then L'operatore scansione il qrCode per recuperare gli atti su radd alternative
    When viene chiusa la transazione per il recupero degli aar su radd alternative
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_RADD_RETRIEVED"
    And viene verificato che l'elemento di timeline "NOTIFICATION_VIEWED" non esista


  Scenario: [RADD-ALT_ACT-9] PF - Restituzione errore - Documenti già stampati
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    When Il cittadino "Mario Cucumber" mostra il QRCode "corretto" su radd alternative
    And L'operatore scansione il qrCode per recuperare gli atti su radd alternative
    And la scansione si conclude correttamente su radd alternative
    And vengono caricati i documento di identità del cittadino su radd alternative
    And Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR su radd alternative
    And l'operazione di download degli atti si conclude correttamente su radd alternative
    And viene conclusa la visualizzati di atti ed attestazioni della notifica su radd alternative
    And Il cittadino "Mario Cucumber" mostra il QRCode "corretto"
    And L'operatore scansione il qrCode per recuperare gli atti
    And Viene restituito un messaggio di errore "Stampa già eseguita" con codice di errore 3