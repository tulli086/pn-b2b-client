Feature: verifica creazione stream

  #--------------CREAZIONE DI UNO STREAM--------------------
  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_1] Creazione per una PA di 10 nuovi stream notifica con eventType TIMELINE e senza gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And si cancella lo stream creato con versione "V23"
    And viene verificata la corretta cancellazione con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_2] Creazione per una PA di 11 nuovi stream notifica con eventType TIMELINE e senza gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    When si predispone 1 nuovo stream denominato "stream-test-11" con eventType "TIMELINE" con versione "V23"
    And si crea il nuovo stream per il "Comune_1" con versione "V23"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_3] Creazione per una PA di 10 nuovi stream notifica con eventType TIMELINE con gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And si cancella lo stream creato con versione "V23"
    And viene verificata la corretta cancellazione con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_4] Creazione per una PA di 11 nuovi stream notifica con eventType TIMELINE con gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    When si predispone 1 nuovo stream denominato "stream-test-11" con eventType "TIMELINE" con versione "V23"
    And si crea il nuovo stream per il "Comune_1" con versione "V23"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_5] Creazione per una PA di 10 nuovi stream notifica con eventType STATUS e senza gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And si cancella lo stream creato con versione "V23"
    And viene verificata la corretta cancellazione con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_6] Creazione per una PA di 11 nuovi stream notifica con eventType STATUS e senza gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    When si predispone 1 nuovo stream denominato "stream-test-11" con eventType "STATUS" con versione "V23"
    And si crea il nuovo stream per il "Comune_1" con versione "V23"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_7] Creazione per una PA di 10 nuovi stream notifica con eventType TIMELINE con gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And si cancella lo stream creato con versione "V23"
    And viene verificata la corretta cancellazione con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_8] Creazione per una PA di 11 nuovi stream notifica con eventType STATUS con gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    When si predispone 1 nuovo stream denominato "stream-test-11" con eventType "STATUS" con versione "V23"
    And si crea il nuovo stream per il "Comune_1" con versione "V23"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_9] Creazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey master.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    Then si cancella lo stream creato con versione "V23"
    And viene verificata la corretta cancellazione con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_11] Creazione di uno stream notifica con gruppo non appartenente alla PA dell'apiKey, con eventType "STATUS"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "ALTRA_PA" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_12] Creazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_13] Creazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And si cancella lo stream creato con versione "V23"
    And viene verificata la corretta cancellazione con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_14] Creazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey master.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_16] Creazione di uno stream notifica con gruppo non appartenente alla PA dell'apiKey, con eventType "TIMELINE"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "ALTRA_PA" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_17] Creazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_18] Creazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And si cancella lo stream creato con versione "V23"
    And viene verificata la corretta cancellazione con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_19] Creazione di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey master.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And si cancella lo stream creato con versione "V23"
    And viene verificata la corretta cancellazione con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_21] Creazione di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_22] Creazione di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey master.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V23" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And si cancella lo stream creato con versione "V23"
    And viene verificata la corretta cancellazione con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_24] Creazione di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_25] Creazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey master.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    Then si cancella lo stream creato con versione "V23"
    And viene verificata la corretta cancellazione con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_148] Creazione di uno stream notifica con gruppi appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And si cancella lo stream creato con versione "V23"
    And viene verificata la corretta cancellazione con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_149] Creazione di uno stream notifica con gruppi non appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "ALL" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @webhookV23 @clean @webhook1
  Scenario: [B2B-STREAM_ES1.1_120] Consumo per una PA di uno stream che non esiste per la stessa PA
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si consuma lo stream che non esiste e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "404"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata