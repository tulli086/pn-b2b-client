Feature: Adeguamento RADD alle modifiche dell’allegato tecnico - Stampa degli atti

  #PRINT ACT

#  #capire come configurare/riprendere caso in cui MAX-Print request ha valore definito == 0
#  scenario non coperto da AT
#
# @raddAlt @zip
#  Scenario: [ADEG-RADD-PRINT_ACTS-1] PF - Stampa illimitata di documenti disponibili associati a QR code esistente con CF corretto
#    Given viene generata una nuova notifica
#      | subject            | invio notifica con cucumber radd alternative  |
#      | senderDenomination | Comune di Palermo           |
#    And destinatario Mario Cucumber
#    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
#    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
#    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
#    And Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
#    When L'operatore scansiona il qrCode e stampa gli atti per 2 volte senza errori
#    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_RADD_RETRIEVED"
#    And vengono letti gli eventi fino all'elemento di timeline della notifica "DELIVERED"
#    And lato destinatario la notifica può essere correttamente recuperata da "Mario Cucumber" e verifica presenza dell'evento di timeline NOTIFICATION_RADD_RETRIEVED
#    And lato desinatario "Mario Cucumber" viene verificato che l'elemento di timeline NOTIFICATION_VIEWED non esista

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
    When L'operatore scansiona il qrCode e stampa gli atti per il numero di volte consentito
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
    When L'operatore scansiona il qrCode e stampa gli atti per il numero di volte consentito
    And Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    When L'operatore scansione il qrCode per recuperare gli atti da radd alternative
    Then Viene restituito un messaggio di errore "Limite di * stampe superato" con codice di errore 3 su radd alternative
    And vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_RADD_RETRIEVED"

#OPERATORE UPLOADER

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
    And la persona fisica "Signor casuale" chiede di verificare ad operatore radd "UPLOADER" la presenza di notifiche
    And La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente su radd alternative
    And vengono caricati i documento di identità del cittadino su radd alternative dall'operatore RADD "UPLOADER"
    Then Vengono recuperati gli aar delle notifiche in stato irreperibile della persona fisicagiuridica su radd alternative da operatore radd "UPLOADER"
    And il recupero degli aar in stato irreperibile si conclude correttamente su radd alternative

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
    And la persona fisica "Signor casuale" chiede di verificare ad operatore radd "UPLOADER" la presenza di notifiche
    And La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente su radd alternative
    And si inizia il processo di caricamento per radd "UPLOADER" dei documento di identità del cittadino ma non si porta a conclusione su radd alternative
    Then Vengono recuperati gli aar delle notifiche in stato irreperibile della persona fisicagiuridica su radd alternative da operatore radd "UPLOADER"
    And il recupero degli aar genera un errore "Campo fileKey obbligatorio mancante" con codice 5 su radd alternative
    #capire il codice errore se c'è

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_ACT-3] PF - Operatore RADD_UPLOADER - Start di una ACT transaction con fileKey presente - ricezione OK
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber radd alternative  |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    When Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    Then L'operatore "UPLOADER" scansione il qrCode per recuperare gli atti da radd alternative
    And la scansione si conclude correttamente su radd alternative
    And vengono caricati i documento di identità del cittadino su radd alternative dall'operatore RADD "UPLOADER"
    Then Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR da radd alternative per operatore "UPLOADER"
    And l'operazione di download degli atti si conclude correttamente su radd alternative

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_ACT-4] Operatore RADD_UPLOADER - Start di una ACT transaction senza fileKey presente - ricezione Errore
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber radd alternative  |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    When Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    Then L'operatore "UPLOADER" scansione il qrCode per recuperare gli atti da radd alternative
    And la scansione si conclude correttamente su radd alternative
    And si inizia il processo di caricamento per radd "UPLOADER" dei documento di identità del cittadino ma non si porta a conclusione su radd alternative
    Then Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR da radd alternative per operatore "UPLOADER"
    And il recupero degli aar genera un errore "Campo fileKey obbligatorio mancante" con codice 5 su radd alternative

  # OPERATORE STANDARD

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_AOR-5] Operatore RADD_STANDARD - Start di una AOR transaction senza fileKey presente - ricezione OK
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | AR_REGISTERED_LETTER            |
    And destinatario Signor casuale e:
      | digitalDomicile         | NULL                                         |
      | physicalAddress_address | Via NationalRegistries @fail-Irreperibile_AR |
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"
    And la persona fisica "Signor casuale" chiede di verificare ad operatore radd "STANDARD" la presenza di notifiche
    And La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente su radd alternative
    Then Vengono recuperati gli aar delle notifiche in stato irreperibile della persona fisicagiuridica su radd alternative da operatore radd "STANDARD"
    And il recupero degli aar in stato irreperibile si conclude correttamente su radd alternative

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_AOR-6] Operatore RADD_STANDARD - Start di una AOR transaction senza fileKey presente - ricezione Errore
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | AR_REGISTERED_LETTER            |
    And destinatario Signor casuale e:
      | digitalDomicile         | NULL                                         |
      | physicalAddress_address | Via NationalRegistries @fail-Irreperibile_AR |
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"
    And la persona fisica "Signor casuale" chiede di verificare ad operatore radd "STANDARD" la presenza di notifiche
    And La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente su radd alternative
    #devo rivedere il metodo sotto qui
    And vengono caricati i documento di identità del cittadino su radd alternative per errore
    Then Vengono recuperati gli aar delle notifiche in stato irreperibile della persona fisicagiuridica su radd alternative da operatore radd "STANDARD"
    And il recupero degli aar genera un errore "Campo fileKey inaspettato" con codice 5 su radd alternative
    #capire il codice errore se c'è

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_ACT-7] Operatore RADD_STANDARD - Start di una ACT transaction senza fileKey presente - ricezione OK
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber radd alternative  |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    When Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    Then L'operatore "STANDARD" scansione il qrCode per recuperare gli atti da radd alternative
    And la scansione si conclude correttamente su radd alternative
    Then Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR da radd alternative per operatore "STANDARD"
    And l'operazione di download degli atti si conclude correttamente su radd alternative

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_ACT-8] Operatore RADD_STANDARD - Start di una ACT transaction con fileKey presente - ricezione Errore
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber radd alternative  |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    When Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    Then L'operatore "STANDARD" scansione il qrCode per recuperare gli atti da radd alternative
    And la scansione si conclude correttamente su radd alternative
    And vengono caricati i documento di identità del cittadino su radd alternative per errore
    Then Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR da radd alternative per operatore "STANDARD"
    And il recupero degli aar genera un errore "Campo fileKey inaspettato" con codice 5 su radd alternative
    #capire il codice errore se c'è

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_ACT-8] Operatore RADD_STANDARD - Tentativo di eseguire documentUpload - ricezione Errore
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber radd alternative  |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    When Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    Then L'operatore "STANDARD" scansione il qrCode per recuperare gli atti da radd alternative
    And la scansione si conclude correttamente su radd alternative
    And l'operatore "STANDARD" tenta di caricare i documento di identità del cittadino su radd alternative senza successo

# OPERATORE NON CENSITO

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_AOR-5] Operatore non censito - Start di una AOR transaction senza fileKey presente - ricezione OK
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | AR_REGISTERED_LETTER            |
    And destinatario Signor casuale e:
      | digitalDomicile         | NULL                                         |
      | physicalAddress_address | Via NationalRegistries @fail-Irreperibile_AR |
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"
    And la persona fisica "Signor casuale" chiede di verificare ad operatore radd "WITHOUT_ROLE" la presenza di notifiche
    And La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente su radd alternative
    Then Vengono recuperati gli aar delle notifiche in stato irreperibile della persona fisicagiuridica su radd alternative da operatore radd "WITHOUT_ROLE"
    And il recupero degli aar in stato irreperibile si conclude correttamente su radd alternative

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_AOR-6] Operatore senza ruolo - Start di una AOR transaction senza fileKey presente - ricezione Errore
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | AR_REGISTERED_LETTER            |
    And destinatario Signor casuale e:
      | digitalDomicile         | NULL                                         |
      | physicalAddress_address | Via NationalRegistries @fail-Irreperibile_AR |
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"
    And la persona fisica "Signor casuale" chiede di verificare ad operatore radd "WITHOUT_ROLE" la presenza di notifiche
    And La verifica della presenza di notifiche in stato irreperibile per il cittadino si conclude correttamente su radd alternative
    And vengono caricati i documento di identità del cittadino su radd alternative per errore
    Then Vengono recuperati gli aar delle notifiche in stato irreperibile della persona fisicagiuridica su radd alternative da operatore radd "WITHOUT_ROLE"
    And il recupero degli aar genera un errore "Campo fileKey inaspettato" con codice 5 su radd alternative
    #capire il codice errore se c'è

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_ACT-7] Operatore senza ruolo - Start di una ACT transaction senza fileKey presente - ricezione OK
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber radd alternative  |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    When Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    Then L'operatore "WITHOUT_ROLE" scansione il qrCode per recuperare gli atti da radd alternative
    And la scansione si conclude correttamente su radd alternative
    Then Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR da radd alternative per operatore "WITHOUT_ROLE"
    And l'operazione di download degli atti si conclude correttamente su radd alternative

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_ACT-8] Operatore senza ruolo - Start di una ACT transaction con fileKey presente - ricezione Errore
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber radd alternative  |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    When Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    Then L'operatore "WITHOUT_ROLE" scansione il qrCode per recuperare gli atti da radd alternative
    And la scansione si conclude correttamente su radd alternative
    And vengono caricati i documento di identità del cittadino su radd alternative per errore
    Then Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR da radd alternative per operatore "WITHOUT_ROLE"
    And il recupero degli aar genera un errore "Campo fileKey inaspettato" con codice 5 su radd alternative
    #capire il codice errore se c'è

  #@raddAlt @zip
  Scenario: [ADEG-RADD-TRANS_ACT-8] Operatore senza ruolo - Tentativo di eseguire documentUpload - ricezione Errore
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber radd alternative  |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    When Il cittadino "Mario Cucumber" come destinatario 0 mostra il QRCode "corretto"
    Then L'operatore "WITHOUT_ROLE" scansione il qrCode per recuperare gli atti da radd alternative
    And la scansione si conclude correttamente su radd alternative
    And l'operatore "WITHOUT_ROLE" tenta di caricare i documento di identità del cittadino su radd alternative senza successo
