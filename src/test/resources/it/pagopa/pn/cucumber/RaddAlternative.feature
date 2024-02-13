Feature: Radd Alternative


  @raddAlt
  Scenario: [B2B_RADD_ACT-1] verifica recupero notifica inquiry qrCode corretto
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
  Scenario: [B2B_RADD_ACT-2] verifica errore inquiry qrCode di una notifica dopo i 120 giorni
    When Il cittadino "Mario Cucumber" mostra il QRCode "dopo 120gg"
    Then L'operatore scansione il qrCode per recuperare gli atti su radd alternative
    And Viene restituito un messaggio di errore "QRcode non valido" con codice di errore 1 su radd alternative


  @raddAlt
  Scenario: [B2B_RADD_ACT-3] verifica errore notifica inquiry qrCode inesistente
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
  Scenario: [B2B_RADD_ACT-4] verifica errore notifica inquiry qrCode CF Errato
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
  Scenario: [B2B_RADD_ACT-5] verifica scansione documenti
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED

  @raddAlt
  Scenario: [B2B_RADD_ACT-6] verifica stampa documenti assocciati a QRcode esistente
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    And Il cittadino "Mario Cucumber" mostra il QRCode "corretto" su radd alternative
    When L'operatore scansione il qrCode per recuperare gli atti su radd alternative
    Then l'operazione di download degli atti si conclude correttamente su radd alternative


  @raddAlt
  Scenario: [B2B_RADD_ACT-7] verifica e consegna documenti assocciati a QRcode esistente
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
  Scenario: [B2B_RADD_ACT-8] verifica e consegna documenti assocciati a QRcode esistente controllo presenza NOTIFICATION_RADD_RETRIEVED
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


  Scenario: [B2B_RADD_ACT-9] inquiry con lo stesso IUN della transazioni precendete
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