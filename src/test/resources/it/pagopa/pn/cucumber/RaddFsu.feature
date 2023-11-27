Feature: Radd fsu

  @radd
  Scenario: [B2B_RADD_ACT-1] verifica errore inquiry qrCode malformato
    Given Il cittadino "MNDLCU98T68C933T" mostra il QRCode "malformato"
    When L'operatore scansione il qrCode per recuperare gli atti
    Then Viene restituito un messaggio di errore "QRcode non valido" con codice di errore 1

  @radd
  Scenario: [B2B_RADD_ACT-2] verifica errore inquiry qrCode inesistente
    Given Il cittadino "MNDLCU98T68C933T" mostra il QRCode "inesistente"
    When L'operatore scansione il qrCode per recuperare gli atti
    Then Viene restituito un messaggio di errore "QRcode non valido" con codice di errore 1

  @radd
  Scenario: [B2B_RADD_ACT-3] inquiry su QRcode esistente ma associato al CF sbagliato
    Given Il cittadino "CLMCST42R12D969Z" mostra il QRCode "appartenente a terzo"
    When L'operatore scansione il qrCode per recuperare gli atti
    Then Viene restituito un messaggio di errore "CF non valido" con codice di errore 1


  @radd
  Scenario: [B2B_RADD_ACT-5] inquiry su QRcode esistente associato al corretto codice fiscale
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    And Il cittadino "Mario Cucumber" mostra il QRCode "corretto"
    When L'operatore scansione il qrCode per recuperare gli atti
    And la scansione si conclude correttamente
    And vengono caricati i documento di identità del cittadino
    Then Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR
    And l'operazione di download degli atti si conclude correttamente
    #And viene conclusa la visualizzati di atti ed attestazioni della notifica

  @radd
  Scenario: [B2B_RADD_ACT-6] inquiry su QRcode esistente associato al CF giusto senza effettuare upload documenti
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    And Il cittadino "Mario Cucumber" mostra il QRCode "corretto"
    When L'operatore scansione il qrCode per recuperare gli atti
    And la scansione si conclude correttamente
    And si inizia il processo di caricamento dei documento di identità del cittadino ma non si porta a conclusione
    Then Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR
    And l'operazione di download degli atti genera un errore "documenti non disponibili" con codice 99


  @radd
  Scenario: [B2B_RADD_ACT-7] start transaction utilizzando l'operation id di una transazione precedente
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    And Il cittadino "Mario Cucumber" mostra il QRCode "corretto"
    And L'operatore scansione il qrCode per recuperare gli atti
    And la scansione si conclude correttamente
    And vengono caricati i documento di identità del cittadino
    And Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR
    And l'operazione di download degli atti si conclude correttamente
    And viene conclusa la visualizzati di atti ed attestazioni della notifica
    And viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    And Il cittadino "Mario Cucumber" mostra il QRCode "corretto"
    And L'operatore scansione il qrCode per recuperare gli atti
    And la scansione si conclude correttamente
    And vengono caricati i documento di identità del cittadino
    When Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR utilizzando il precedente operationId
    Then l'operazione di download degli atti si conclude correttamente

  @radd #TODO: Questo caso dovrebbe andare in errore
  Scenario: [B2B_RADD_ACT-8] start transaction utilizzando i documenti associati alla transazione di altro cittadino
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Gherkin
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    And Il cittadino "Mario Gherkin" mostra il QRCode "corretto"
    And L'operatore scansione il qrCode per recuperare gli atti
    And la scansione si conclude correttamente
    And vengono caricati i documento di identità del cittadino
    And Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR
    And l'operazione di download degli atti si conclude correttamente
    And viene conclusa la visualizzati di atti ed attestazioni della notifica
    And viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    And Il cittadino "Mario Cucumber" mostra il QRCode "corretto"
    And L'operatore scansione il qrCode per recuperare gli atti
    And la scansione si conclude correttamente
    When Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR
    Then l'operazione di download degli atti si conclude correttamente

  @radd @bugNoto
  Scenario: [B2B_RADD_AOR-1] inquiry per cittadino con molte notifiche in stato irreperibile
    Given Il cittadino "DVNLRD52D15M059P" chiede di verificare la presenza di notifiche
    When La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente

  @radd
  Scenario: [B2B_RADD_AOR-2] inquiry per cittadino con notifiche in stato irreperibile
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication |  AR_REGISTERED_LETTER |
    And destinatario Signor casuale e:
      | digitalDomicile | NULL |
      | physicalAddress_address | Via NationalRegistries @fail-Irreperibile_AR|
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"
    When Il cittadino Signor casuale chiede di verificare la presenza di notifiche
    Then La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente

  @radd
  Scenario: [B2B_RADD_AOR-3] recupero atti per cittadino con notifiche in stato irreperibile
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
      | physicalCommunication |  AR_REGISTERED_LETTER |
    And destinatario Signor casuale e:
      | digitalDomicile | NULL |
      | physicalAddress_address | Via NationalRegistries @fail-Irreperibile_AR|
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"
    When Il cittadino Signor casuale chiede di verificare la presenza di notifiche
    And La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente
    And vengono caricati i documento di identità del cittadino
    Then Vengono recuperati gli atti delle notifiche in stato irreperibile
    And il recupero degli atti in stato irreperibile si conclude correttamente
