Feature: Adeguamento RADD alle modifiche dell’allegato tecnico - Stampa degli atti

  #capire come configurare/riprendere caso in cui MAX-Print request ha valore definito == 0
  #@raddAlt @zip
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
  #@raddAlt @zip
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
  #@raddAlt @zip
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

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_AOR-1] Operatore RADD_UPLOADER - Start di una AOR transaction con fileKey presente - ricezione OK
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | AR_REGISTERED_LETTER            |
    And destinatario Signor casuale e:
      | digitalDomicile         | NULL                                         |
      | physicalAddress_address | Via NationalRegistries @fail-Irreperibile_AR |
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"
    And la persona fisica "Signor casuale" chiede di verificare la presenza di notifiche
    And La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente su radd alternative
    And si inizia il processo di caricamento dei documento di identità del cittadino ma non si porta a conclusione su radd alternative
    When Vengono recuperati gli aar delle notifiche in stato irreperibile della persona fisica 2 volte su radd alternative
    Then il recupero degli aar in stato irreperibile si conclude correttamente su radd alternative

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_AOR-2] Operatore RADD_UPLOADER - Start di una AOR transaction senza fileKey presente - ricezione Errore
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | AR_REGISTERED_LETTER            |
    And destinatario Signor casuale e:
      | digitalDomicile         | NULL                                         |
      | physicalAddress_address | Via NationalRegistries @fail-Irreperibile_AR |
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"
    And la persona fisica "Signor casuale" chiede di verificare la presenza di notifiche
    And La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente su radd alternative
    # And vengono caricati i documento di identità del cittadino su radd alternative
    When Vengono recuperati gli aar delle notifiche in stato irreperibile della persona fisica 2 volte su radd alternative
    Then il recupero degli aar in stato irreperibile si conclude correttamente su radd alternative

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_AOR-3] PF - Operatore RADD_STANDARD - Start di una AOR transaction con fileKey presente - ricezione OK
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | AR_REGISTERED_LETTER            |
    And destinatario Signor casuale e:
      | digitalDomicile         | NULL                                         |
      | physicalAddress_address | Via NationalRegistries @fail-Irreperibile_AR |
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"
    And la persona fisica "Signor casuale" chiede di verificare la presenza di notifiche
    Then La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente su radd alternative
    And vengono caricati i documento di identità del cittadino su radd alternative
    When Vengono recuperati gli aar delle notifiche in stato irreperibile della persona fisica 2 volte su radd alternative
    And il recupero degli aar in stato irreperibile si conclude correttamente su radd alternative


