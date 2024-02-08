Feature: avanzamento notifiche webhook b2b V22

  Background:
    Given vengono cancellati tutti gli stream presenti del "Comune_1" con versione "V22"

  #--------------CREAZIONE DI UNO STREAM--------------------
  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_1] Creazione per una PA di 10 nuovi stream notifica con eventType TIMELINE e senza gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_2] Creazione per una PA di 11 nuovi stream notifica con eventType TIMELINE e senza gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    When si predispone 1 nuovo stream denominato "stream-test-11" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_3] Creazione per una PA di 10 nuovi stream notifica con eventType TIMELINE con gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_4] Creazione per una PA di 11 nuovi stream notifica con eventType TIMELINE con gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    When si predispone 1 nuovo stream denominato "stream-test-11" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_5] Creazione per una PA di 10 nuovi stream notifica con eventType STATUS e senza gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_6] Creazione per una PA di 11 nuovi stream notifica con eventType STATUS e senza gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    When si predispone 1 nuovo stream denominato "stream-test-11" con eventType "STATUS" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_7] Creazione per una PA di 10 nuovi stream notifica con eventType TIMELINE con gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "STATUSSTATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_8] Creazione per una PA di 11 nuovi stream notifica con eventType STATUS con gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    When si predispone 1 nuovo stream denominato "stream-test-11" con eventType "STATUS" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_9] Creazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey master.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    Then si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_11] Creazione di uno stream notifica con gruppo non appartenente alla PA dell'apiKey, con eventType "STATUS"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "ALTRA_PA" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_12] Creazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_13] Creazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_14] Creazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_16] Creazione di uno stream notifica con gruppo non appartenente alla PA dell'apiKey, con eventType "TIMELINE"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "ALTRA_PA" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_17] Creazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_18] Creazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_19] Creazione di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_21] Creazione di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_22] Creazione di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_24] Creazione di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_25] Creazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    Then si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_148] Creazione di uno stream notifica con gruppi appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_149] Creazione di uno stream notifica con gruppi non appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "ALL" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



  #--------------CREAZIONE CON REPLACED_STREAM_ID DI UNO STREAM--------------------
  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_101] Creazione con replaceID di uno stream notifica con gruppo uguale al precedente stream con eventType "STATUS" utilizzando un apikey senza gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_103]  Creazione con replaceID di uno stream notifica con gruppo  non appartenente alla PA, con eventType "STATUS" utilizzando un apikey senza gruppo.(replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "ALTRA_PA" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_104]  Creazione con replaceID di uno stream notifica con gruppo diverso al precedente stream con eventType "STATUS" utilizzando un apikey senza gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_105]  Creazione con replaceID di uno stream notifica con gruppo uguale al precedente stream con eventType "STATUS" utilizzando un apikey con gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_106] Creazione con replaceID di uno stream notifica con gruppo uguale al precedente stream con eventType "TIMELINE" utilizzando un apikey senza gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_108] Creazione con replaceID di uno stream notifica con gruppo  non appartenente alla PA, con eventType "TIMELINE" utilizzando un apikey senza gruppo.(replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "ALTRA_PA" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  Scenario: [B2B-STREAM_ES1.1_109]  Creazione con replaceID di uno stream notifica con gruppo diverso al precedente stream con eventType "TIMELINE" utilizzando un apikey senza gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_110]  Creazione con replaceID di uno stream notifica con gruppo uguale al precedente stream con eventType "TIMELINE" utilizzando un apikey con gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_111]  Creazione con replaceID di uno stream notifica senza gruppo uguale al precedente stream con eventType "STATUS" utilizzando un apikey senza gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_113]  Creazione con replaceID di uno stream notifica senza gruppo uguale al precedente stream con eventType "STATUS" utilizzando un apikey con gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    When lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_114]  Creazione con replaceID di uno stream notifica senza gruppo uguale al precedente stream con eventType "TIMELINE" utilizzando un apikey senza gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_115]  Creazione con replaceID di uno stream notifica con gruppo diverso al precedente stream con eventType "STATUS" utilizzando un apikey senza gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_116]  Creazione con replaceID di uno stream notifica senza gruppo uguale al precedente stream con eventType "TIMELINE" utilizzando un apikey con gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "FIRST" e apiKey aggiornata
    When lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata




  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_117]  Creazione per una PA di 10 nuovi stream notifica con eventType TIMELINE e senza gruppo, disabilitazione di uno stream e creazione di un nuovo stream.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si disabilita lo stream creato con versione "V22" e apiKey aggiornata
    And l'operazione non ha prodotto errori
    And si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    When si creano i nuovi stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And l'operazione non ha prodotto errori
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_102]  Creazione con replaceID di uno stream notifica senza gruppo uguale al precedente stream disabilitato con eventType "TIMELINE" utilizzando un apikey senza gruppo. (replacedStreamId settato).
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si disabilita lo stream creato con versione "V22"
    And l'operazione non ha prodotto errori
    When si crea il nuovo stream per il "Comune_1" con replaceId "SET" con un gruppo disponibile "NO_GROUPS" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  #--------------LETTURA METADATI DI UNO STREAM------------
  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_27] Lettura di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    When viene impostata l'apikey appena generata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22" e apiKey aggiornata
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_28] Lettura di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso..
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When viene impostata l'apikey appena generata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22" e apiKey aggiornata
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_29] Lettura di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_30] Lettura di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    When viene impostata l'apikey appena generata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22" e apiKey aggiornata
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1 @ignore
  Scenario: [B2B-STREAM_ES1.1_32] Lettura di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo non appartenente alla PA.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When viene impostata l'apikey appena generata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22" e apiKey aggiornata
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_33] Lettura di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    When viene impostata l'apikey appena generata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22" e apiKey aggiornata
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_34] Lettura di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_35] Lettura di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_37] Lettura di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    When viene impostata l'apikey appena generata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22" e apiKey aggiornata
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_38] Lettura di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_40] Lettura di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    When viene impostata l'apikey appena generata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22" e apiKey aggiornata
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_122] Lettura per una PA di uno stream che non esiste per la stessa PA
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si legge lo stream che non esiste e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "404"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_156] Lettura di uno stream notifica con gruppi appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_157] Lettura di uno stream notifica con gruppi non appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "UGUALI" e apiKey aggiornata
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When lo stream viene recuperato dal sistema tramite stream id con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  #--------------DISABILITAZIONE DI UNO STREAM------------

  @testLite @webhook1 @ignore
  Scenario: [B2B-STREAM_ES1.1_57] Disabilitazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo non appartenente alla PA.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si disabilita lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_58] Disabilitazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When si disabilita lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_59] Disabilitazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione non ha prodotto errori
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_60] Disabilitazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si disabilita lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione non ha prodotto errori
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1 @ignore
  Scenario: [B2B-STREAM_ES1.1_62] Disabilitazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo non appartenente alla PA.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_63] Disabilitazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When si disabilita lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_64] Disabilitazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione non ha prodotto errori
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_65] Disabilitazione di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione non ha prodotto errori
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_67] Disabilitazione di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si disabilita lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_68] Disabilitazione di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione non ha prodotto errori
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_70] Disabilitazione di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si disabilita lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_150] Disabilitazione di uno stream notifica con gruppi appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si disabilita lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione non ha prodotto errori
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_151] Disabilitazione di uno stream notifica con gruppi non appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "UGUALI" e apiKey aggiornata
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si disabilita lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_118] Disabilitazione per una PA di uno stream che non esiste per la stessa PA
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si disabilita lo stream che non esiste e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "404"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_61] Disabilitazione di uno stream notifica senza gruppo già disabilitato, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione non ha prodotto errori
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione ha prodotto un errore con status code "404"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_77] Cancellazione di uno stream notifica senza gruppo già disabilitato, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione non ha prodotto errori
    When si cancella lo stream creato con versione "V22"
    Then l'operazione ha prodotto un errore con status code "404"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_98] Aggiornamento di uno stream notifica senza gruppo già disabilitato, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione non ha prodotto errori
    When si aggiorna lo stream creato con versione "V22"
    Then l'operazione ha prodotto un errore con status code "404"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_32] Lettura di uno stream notifica senza gruppo già disabilitato, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione non ha prodotto errori
    When lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    Then l'operazione ha prodotto un errore con status code "404"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

     #--------------CANCELLAZIONE DI UNO STREAM------------

  @testLite @webhook1 @ignore
  Scenario: [B2B-STREAM_ES1.1_72] Cancellazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo non appartenente alla PA.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si cancella lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_73] Cancellazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When si cancella lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_74] Cancellazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si cancella lo stream creato con versione "V22"
    Then viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_75] Cancellazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si cancella lo stream creato con versione "V22" e apiKey aggiornata
    Then viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



  @testLite @webhook1 @ignore
  Scenario: [B2B-STREAM_ES1.1_77] Cancellazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo non appartenente alla PA.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si cancella lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_78] Cancellazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When si cancella lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_79] Cancellazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si cancella lo stream creato con versione "V22"
    Then viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_80] Cancellazione di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si cancella lo stream creato con versione "V22"
    Then viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_82] Cancellazione di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si cancella lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_83] Cancellazione di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si cancella lo stream creato con versione "V22"
    Then viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_85] Cancellazione di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si cancella lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_152] Cancellazione di uno stream notifica con gruppi appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si cancella lo stream creato con versione "V22"
    Then viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_153] Cancellazione di uno stream notifica con gruppi non appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "UGUALI" e apiKey aggiornata
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si cancella lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_119] Cancellazione per una PA di uno stream che non esiste per la stessa PA
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si cancella lo stream che non esiste e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "404"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

#--------------AGGIORNAMENTO DI UNO STREAM------------

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_87] Aggiornamento di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo non appartenente alla PA.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si aggiorna lo stream creato con versione "V22" con un gruppo che non appartiene al comune "Comune_1"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_88] Aggiornamento di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When si aggiorna lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_89] Aggiornamento di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si aggiorna lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione non ha prodotto errori
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_42] Aggiornamento di uno stream notifica da due gruppi ad un gruppo, con eventType "STATUS".
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "UGUALI" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si "rimuove" un gruppo allo stream creato con versione "V22" per il comune "Comune_1" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_43] Aggiornamento di uno stream notifica da un gruppo a più gruppi, con eventType "STATUS".
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "UGUALI" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si "aggiunge" un gruppo allo stream creato con versione "V22" per il comune "Comune_1" e apiKey aggiornata
    Then l'operazione non ha prodotto errori
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata





  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_91] Aggiornamento di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si aggiorna lo stream creato con versione "V22" e apiKey aggiornata
    Then viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_92] Aggiornamento di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo non appartenente alla PA.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si aggiorna lo stream creato con versione "V22" con un gruppo che non appartiene al comune "Comune_1"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_93] Aggiornamento di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When si aggiorna lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_94] Aggiornamento di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si aggiorna lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione non ha prodotto errori
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_95] Aggiornamento di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si aggiorna lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione non ha prodotto errori
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_97] Aggiornamento di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si aggiorna lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_98] Aggiornamento di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si aggiorna lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione non ha prodotto errori
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_100] Aggiornamento di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si aggiorna lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_154] Aggiornamento di uno stream notifica con gruppi appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si aggiorna lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione non ha prodotto errori
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_155] Aggiornamento di uno stream notifica con gruppi appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "UGUALI" e apiKey aggiornata
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si aggiorna lo stream creato con versione "V22" e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_121] Aggiornamento per una PA di uno stream che non esiste per la stessa PA
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    When si aggiorna lo stream che non esiste e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "404"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


 #--------------CONSUMO DI EVENTI DI UNO STREAM------------
  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.3_126] Consumo di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin

    And si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When vengono letti gli eventi dello stream del "Comune_1" fino allo stato "ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.3_127] Consumo di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con stesso gruppo.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino allo stato "ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.3_128] Consumo di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    When Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.3_130] Consumo di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo diverso.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.3_131] Consumo di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con stesso gruppo.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.3_132] Consumo di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino allo stato "ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.3_125] Consumo di uno stream notifica disabilitato senza gruppo, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And si disabilita lo stream creato con versione "V22"
    And l'operazione non ha prodotto errori
    When vengono letti gli eventi dello stream del "Comune_1" fino allo stato "ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.3_133] Consumo di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When vengono letti gli eventi dello stream del "Comune_1" fino allo stato "ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.3_134] Consumo di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.3_135] Consumo di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_120] Consumo per una PA di uno stream che non esiste per la stessa PA
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si consuma lo stream che non esiste e apiKey aggiornata
    Then l'operazione ha prodotto un errore con status code "404"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_158] Consumo di uno stream notifica con gruppi appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin

    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "LAST" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    When vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_159] Consumo di uno stream notifica con gruppi non appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin

    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con due gruppi
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con replaceId "NO_SET" con un gruppo disponibile "UGUALI" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


 #--------------LETTURA NUOVO EVENTO DI TIMELINE DI UNO STREAM------------
  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.4_136] Lettura degli eventi di timeline  dello stream senza gruppo con visualizzazione del nuovo evento di timeline utilzzando un apikey abilitata.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_RADD_RETRIEVED"
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "NOTIFICATION_RADD_RETRIEVED" con versione V22 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.4_137] Lettura degli eventi di timeline  dello stream con gruppo con visualizzazione  del nuovo evento di timeline utilzzando un apikey abilitata.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_RADD_RETRIEVED"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "NOTIFICATION_RADD_RETRIEVED" con versione V22 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.2_123] Creazione di stream con apiKey con gruppi differenti e verifica corretta scrittura degli eventi di notifiche create con le stesse apiKey.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

    And si predispone 1 nuovo stream denominato "stream-test1" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"

    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    And vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V22 e apiKey aggiornata con position 1
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
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V22 e apiKey aggiornata con position 0
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata







  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.2_124] Verifica corretta scrittura degli eventi di una notifica creata con un apiKey senza gruppo, dove l’evento stesso deve essere salvato solo negli stream senza gruppi.
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

    And si predispone 1 nuovo stream denominato "stream-test1" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22" e apiKey aggiornata
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"

    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REQUEST_ACCEPTED"
    And vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V22 e apiKey aggiornata con position 1
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
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED" con versione V22 e apiKey aggiornata con position 1
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



#--------------AUDIT LOG DI UNO STREAM------------
  @testLite @webhook1
  Scenario Outline: [B2B-STREAM_ES2.1] Impostare nuova tipologia di Audit Log
    Then viene verificato che esiste un audit log "<audit-log>" in "10y"
    Examples:
      | audit-log      |
      | AUD_WH_CREATE  |
      | AUD_WH_READ    |
      | AUD_WH_UPDATE  |
      | AUD_WH_DELETE  |
      | AUD_WH_DISABLE |
      | AUD_WH_CONSUME |

 # AUD_WH_CREATE(PnAuditLogMarker.AUDIT10Y),
 # AUD_WH_READ(PnAuditLogMarker.AUDIT10Y),
 # AUD_WH_UPDATE(PnAuditLogMarker.AUDIT10Y),
 # AUD_WH_DELETE(PnAuditLogMarker.AUDIT10Y),
 # AUD_WH_DISABLE(PnAuditLogMarker.AUDIT10Y),
 # AUD_WH_CONSUME(PnAuditLogMarker.AUDIT10Y),
