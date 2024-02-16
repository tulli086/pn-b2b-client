Feature: avanzamento notifiche webhook b2b V23

  #Background:
   # Given vengono cancellati tutti gli stream presenti del "Comune_1" con versione "V23"

    #--------------LETTURA EVENTO DI TIMELINE DI UNO STREAM------------

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_112] Creazione con replaceID di uno stream notifica senza gruppo uguale al precedente stream con eventType "TIMELINE" utilizzando un apikey master. (replacedStreamId settato) con controllo EventId incrementale e senza duplicati.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi dello stream del "Comune_Multi" fino all'elemento di timeline "SEND_DIGITAL_DOMICILE"
    And viene verificato che il ProgressResponseElement del webhook abbia un EventId incrementale e senza duplicati V23
    And si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    When viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di palermo           |
    And destinatario Cucumber Analogic e:
      | digitalDomicile_address | test@fail.it |
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi dello stream del "Comune_Multi" fino all'elemento di timeline "DIGITAL_FAILURE_WORKFLOW"
    Then viene verificato che il ProgressResponseElement del webhook abbia un EventId incrementale e senza duplicati V23
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.3_127] Consumo di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con stesso gruppo.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino allo stato "ACCEPTED" con versione V23 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.3_128] Consumo di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey master.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    When Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V23 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.3_131] Consumo di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con stesso gruppo.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V23 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.3_132] Consumo di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey master.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino allo stato "ACCEPTED" con versione V23 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.3_50] Consumo di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey master e verifica corrispondenza tra i detail del webhook e quelli della timeline.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    When vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V23 e apiKey aggiornata con position 0
    And verifica corrispondenza tra i detail del webhook e quelli della timeline
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.3_134] Consumo di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey master.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V23 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @webhookV23 @clean @webhook1 @deleghe1
  Scenario: [B2B-STREAM_ES3.1_144] Lettura e verifica de-anonimizzazione con un apikey master degli eventi di timeline di una notifica inviata con un apikey master e salvati in uno stream dell'ente senza gruppo
    Given "Mario Gherkin" rifiuta se presente la delega ricevuta "Mario Cucumber"
    And "Mario Gherkin" viene delegato da "Mario Cucumber"
    And "Mario Gherkin" accetta la delega "Mario Cucumber"
    And viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Cucumber
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    When vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V23 e apiKey aggiornata con position 0
    Then verifica deanonimizzazione degli eventi di timeline
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @webhookV23 @clean @webhook1 @deleghe1
  Scenario: [B2B-STREAM_ES3.1_146] Lettura e verifica de-anonimizzazione con un apiKey con gruppo degli eventi di timeline di una notifica inviata con un apikey con gruppo e salvati in uno stream dell'ente con gruppo (Stesso gruppo)
    Given "Mario Gherkin" rifiuta se presente la delega ricevuta "Mario Cucumber"
    And "Mario Gherkin" viene delegato da "Mario Cucumber"
    And "Mario Gherkin" accetta la delega "Mario Cucumber"
    And viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Cucumber
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    When vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V23 e apiKey aggiornata con position 0
    Then verifica deanonimizzazione degli eventi di timeline
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_158] Consumo di uno stream notifica con gruppi appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    When vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V23 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



 #--------------LETTURA NUOVO EVENTO DI TIMELINE DI UNO STREAM------------

  #SERVE INTEGRAZIONE CON RADD
  @webhookV23 @clean @webhook1 @ignore
  Scenario: [B2B-STREAM_ES1.4_136] Lettura degli eventi di timeline  dello stream senza gruppo con visualizzazione del nuovo evento di timeline utilzzando un apikey abilitata.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_RADD_RETRIEVED"
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "NOTIFICATION_RADD_RETRIEVED" con versione V23 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

 #SERVE INTEGRAZIONE CON RADD
  @webhookV23 @clean @webhook1 @ignore
  Scenario: [B2B-STREAM_ES1.4_137] Lettura degli eventi di timeline  dello stream con gruppo con visualizzazione  del nuovo evento di timeline utilzzando un apikey abilitata.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_RADD_RETRIEVED"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    When Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "NOTIFICATION_RADD_RETRIEVED" con versione V23 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

 #SERVE INTEGRAZIONE CON RADD
  @webhookV23 @clean @webhook1 @ignore
  Scenario: [B2B-STREAM_ES3.1_145] Creazione di uno stream senza gruppo con la V10 e  lettura di nuovi eventi di timeline con un apikey abilitata.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V10"
    And si crea il nuovo stream per il "Comune_1" con versione "V10" e filtro di timeline "NOTIFICATION_RADD_RETRIEVED"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V10"
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_RADD_RETRIEVED"
    Then verifica non presenza di eventi nello stream del "Comune_1"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.2_123] Creazione di stream con apiKey con gruppi differenti e verifica corretta scrittura degli eventi di notifiche create con le stesse apiKey.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And si predispone 1 nuovo stream denominato "stream-test1" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    And vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V23 e apiKey aggiornata con position 1
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And viene generata una nuova notifica
      | subject            | invio notifica con cucumber 2 |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V23 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.2_124] Verifica corretta scrittura degli eventi di una notifica creata con un apikey master, dove l’evento stesso deve essere salvato solo negli stream senza gruppi.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And si predispone 1 nuovo stream denominato "stream-test1" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    And vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V23 e apiKey aggiornata con position 1
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And viene generata una nuova notifica
      | subject            | invio notifica con cucumber 2 |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V23 e apiKey aggiornata con position 1
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
