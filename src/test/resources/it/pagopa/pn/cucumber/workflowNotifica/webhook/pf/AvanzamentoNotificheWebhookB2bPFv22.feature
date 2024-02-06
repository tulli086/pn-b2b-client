Feature: avanzamento notifiche webhook b2b V22

  Background:
    Given vengono cancellati tutti gli stream presenti del "Comune_1" con versione "V22"

  #--------------CREAZIONE DI UNO STREAM--------------------
  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_1] Creazione per una PA di 10 nuovi stream notifica con eventType TIMELINE e senza gruppo.
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
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
    And si creano i nuovi stream per il "Comune_1" con versione "V22"
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
    When si creano i nuovi stream per il "Comune_1" con versione "V22"
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
    And si creano i nuovi stream per il "Comune_1" con versione "V22"
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
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
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
    And si creano i nuovi stream per il "Comune_1" con versione "V22"
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
    When si creano i nuovi stream per il "Comune_1" con versione "V22"
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
    And si creano i nuovi stream per il "Comune_1" con versione "V22"
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
    When si crea il nuovo stream per il "Comune_1" con versione "V22" con un gruppo disponibile "FIRST"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_11] Creazione di uno stream notifica con gruppo non appartenente alla PA dell'apiKey, con eventType "STATUS"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22" con un gruppo disponibile "ALTRA_PA"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_12] Creazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22" con un gruppo disponibile "LAST"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_13] Creazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V22"
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
    When si crea il nuovo stream per il "Comune_1" con versione "V22" con un gruppo disponibile "FIRST"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_16] Creazione di uno stream notifica con gruppo non appartenente alla PA dell'apiKey, con eventType "TIMELINE"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22" con un gruppo disponibile "ALTRA_PA"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_17] Creazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22" con un gruppo disponibile "LAST"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_18] Creazione di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si creano i nuovi stream per il "Comune_1" con versione "V22"
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
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
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
    When si crea il nuovo stream per il "Comune_1" con versione "V22" con un gruppo disponibile "NO_GROUPS"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_22] Creazione di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
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
    When si crea il nuovo stream per il "Comune_1" con versione "V22" con un gruppo disponibile "NO_GROUPS"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_25] Creazione di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22" con un gruppo disponibile "FIRST"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  #--------------LETTURA METADATI DI UNO STREAM------------
  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_27] Lettura di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso..
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When lo stream viene recuperato dal sistema tramite stream id con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_28] Lettura di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso..
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When lo stream viene recuperato dal sistema tramite stream id con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_29] Lettura di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
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
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    When viene impostata l'apikey appena generata
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_32] Lettura di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo non appartenente alla PA.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When lo stream viene recuperato dal sistema tramite stream id con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_33] Lettura di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When lo stream viene recuperato dal sistema tramite stream id con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_34] Lettura di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
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
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
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
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When lo stream viene recuperato dal sistema tramite stream id con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_38] Lettura di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
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
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When lo stream viene recuperato dal sistema tramite stream id con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata












  @testLite @webhook1
  Scenario: [B2B-STREAM_ES1.1_1] Creazione stream notifica V22 senza gruppo con eventType "STATUS"
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.1_1_1] Creazione stream notifica V22 senza gruppo con eventType "TIMELINE"
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.1_2] Creazione 10 stream notifica V22 senza gruppo con eventType "TIMELINE"
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.1_3] Creazione 11 stream notifica V22 senza gruppo con eventType "TIMELINE"
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V22"
    When si predispone 1 nuovo stream denominato "stream-test-11" con eventType "STATUS" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.1_4] Creazione stream notifica V22 con gruppo con eventType "STATUS"
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.1_4_1] Creazione stream notifica V22 con gruppo con eventType "TIMELINE"
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.1_5] Creazione 10 stream notifica V22 con gruppo con eventType "STATUS"
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.1_6] Creazione 11 stream notifica V22 con gruppo con eventType "STATUS"
    Given si predispone 10 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si creano i nuovi stream per il "Comune_1" con versione "V22"
    When si predispone 1 nuovo stream denominato "stream-test-11" con eventType "STATUS" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata







  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.1_9] Disabilitazione per una PA di uno stream notifica senza gruppo con eventType "TIMELINE"  utilizzando un apikey senza gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    Then si disabilita lo stream creato con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.9_1] Disabilitazione per una PA di uno stream notifica senza gruppo con eventType "STATUS" utilizzando un apikey con gruppo
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.1_10] Disabilitazione per una PA di uno stream notifica con gruppo con eventType "STATUS"  utilizzando un apikey con lo stesso gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    Then si disabilita lo stream creato con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.10_1] Disabilitazione per una PA di uno stream notifica con gruppo con eventType "STATUS" utilizzando un apikey senza gruppo
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    Then si disabilita lo stream creato con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.10_2] Disabilitazione per una PA di uno stream notifica con gruppo con eventType "STATUS" utilizzando un apikey con gruppo diverso
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con gruppo differente del invio notifica
    And viene impostata l'apikey appena generata
    When si disabilita lo stream creato con versione "V22"
    Then l'operazione ha prodotto un errore con status code "403"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata


  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.12] Cancellazione stream notifica V22 con gruppo con eventType "STATUS" utilizzando un apikey appartentente allo stesso gruppo
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.12_1] Cancellazione stream notifica V22 con gruppo con eventType "STATUS" utilizzando un apikey senza gruppo
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    Then si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.13] Cancellazione stream notifica V22 senza gruppo con eventType "STATUS" utilizzando un apikey senza gruppo
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata

  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_STATUS_ES1.13_1] Cancellazione stream notifica V22 senza gruppo con eventType "STATUS" utilizzando un apikey con gruppo
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V22"
    And Viene creata una nuova apiKey per il comune "Comune_1" senza gruppo
    And viene impostata l'apikey appena generata
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    Then si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata



  @testLite @webhook1
  Scenario Outline: [B2B-STREAM_V22_STATUS_ES2.1 Impostare nuova tipologia di Audit Log
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


  @testLite @webhook1
  Scenario: [B2B-STREAM_V22_TIMELINE_1] Creazione stream notifica V22
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    When si crea il nuovo stream per il "Comune_1" con versione "V22"
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V22"
    And si cancella lo stream creato con versione "V22"
    And viene verificata la corretta cancellazione con versione "V22"

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_2] Invio notifica digitale ed attesa stato ACCEPTED_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino allo stato "ACCEPTED"

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_3] Invio notifica digitale ed attesa elemento di timeline REQUEST_ACCEPTED_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED"

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_4] Invio notifica digitale ed attesa elemento di timeline AAR_GENERATION positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "AAR_GENERATION"

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_6] Invio notifica digitale ed attesa elemento di timeline GET_ADDRESS_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "GET_ADDRESS"

  @clean @testLite @webhook1
  Scenario: [B2B-STREAM_TIMELINE_7] Invio notifica digitale ed attesa stato DELIVERING_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino allo stato "DELIVERING"

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_8] Invio notifica digitale ed attesa elemento di timeline SEND_DIGITAL_DOMICILE_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "SEND_DIGITAL_DOMICILE"

  @clean @testLite @webhook1
  Scenario: [B2B-STREAM_TIMELINE_9] Invio notifica digitale ed attesa stato DELIVERING-VIEWED_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi dello stream del "Comune_1" fino allo stato "DELIVERING"
    And "Mario Gherkin" legge la notifica
    Then si verifica nello stream del "Comune_1" che la notifica abbia lo stato VIEWED

  @clean @testLite @webhook1
  Scenario: [B2B-STREAM_TIMELINE_10] Invio notifica digitale ed attesa elemento di timeline DELIVERING-NOTIFICATION_VIEWED_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi dello stream del "Comune_1" fino allo stato "DELIVERING"
    And "Mario Gherkin" legge la notifica
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "NOTIFICATION_VIEWED"

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_11] Invio notifica digitale ed attesa stato DELIVERED_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino allo stato "DELIVERED"

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_12] Invio notifica digitale ed attesa stato DELIVERED-VIEWED_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino allo stato "DELIVERED"
    And "Mario Gherkin" legge la notifica
    Then si verifica nello stream del "Comune_1" che la notifica abbia lo stato VIEWED

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_13] Invio notifica digitale ed attesa elemento di timeline DELIVERED-NOTIFICATION_VIEWED_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino allo stato "DELIVERED"
    And "Mario Gherkin" legge la notifica
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "NOTIFICATION_VIEWED"

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_14] Creazione multi stream notifica
    Given si predispongono 6 nuovi stream denominati "stream-test" con eventType "STATUS" con versione "V22"
    When si creano i nuovi stream per il "Comune_1" con versione "V22"
    Then l'ultima creazione ha prodotto un errore con status code "409"

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_15] Creazione multi stream notifica
    Given si predispongono 6 nuovi stream denominati "stream-test" con eventType "TIMELINE" con versione "V22"
    When si creano i nuovi stream per il "Comune_1" con versione "V22"
    Then l'ultima creazione ha prodotto un errore con status code "409"

  @clean @dev @webhook1
  Scenario: [B2B-STREAM_TIMELINE_16] Invio notifica digitale ed attesa elemento di timeline DIGITAL_FAILURE_WORKFLOW_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Cucumber Analogic e:
      | digitalDomicile_address | test@fail.it |
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "DIGITAL_FAILURE_WORKFLOW"

  @clean @dev @ignore @webhook1
  Scenario: [B2B-STREAM_TIMELINE_17] Invio notifica digitale ed attesa elemento di timeline NOT_HANDLED_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Cucumber e:
      | digitalDomicile_address | test@fail.it |
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "NOT_HANDLED"

  @clean @dev @webhook1
  Scenario: [B2B-STREAM_TIMELINE_19] Invio notifica digitale ed attesa elemento di timeline SEND_DIGITAL_FEEDBACK_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "SEND_DIGITAL_FEEDBACK"

  @clean @dev @webhook1
  Scenario: [B2B-STREAM_TIMELINE_20] Invio notifica digitale ed attesa elemento di timeline SEND_DIGITAL_PROGRESS_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "SEND_DIGITAL_PROGRESS"

  @clean @dev @webhook1
  Scenario: [B2B-STREAM_TIMELINE_21] Invio notifica digitale ed attesa elemento di timeline PUBLIC_REGISTRY_CALL_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Cucumber e:
      | digitalDomicile_address | test@fail.it |
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "PUBLIC_REGISTRY_CALL"

  @clean @dev @webhook1
  Scenario: [B2B-STREAM_TIMELINE_22] Invio notifica digitale ed attesa elemento di timeline PUBLIC_REGISTRY_RESPONSE_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Cucumber e:
      | digitalDomicile_address | test@fail.it |
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "PUBLIC_REGISTRY_RESPONSE"

  @clean @dev @webhook1
  Scenario: [B2B-STREAM_TIMELINE_23] Invio notifica  mono destinatario con documenti pre-caricati non trovati su safestorage scenario negativo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b senza preload allegato dal "Comune_1" e si attende che lo stato diventi REFUSED
    And si verifica che la notifica non viene accettata causa "ALLEGATO"
    Then vengono letti gli eventi dello stream del "Comune_1" con la verifica di Allegato non trovato

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_24_7878] Invio notifiche digitali e controllo che vengano letti 50 eventi nel webhook
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    When viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Cucumber e:
      | digitalDomicile_address | test@fail.it |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_FAILURE_WORKFLOW"
    And vengono letti gli eventi dello stream che contenga 50 eventi


  @clean @dev @webhook1
  Scenario: [B2B-STREAM_TIMELINE_25] Invio notifica digitale ed attesa elemento di timeline PAYMENT
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
    And destinatario Mario Gherkin e:
      | payment_pagoPaForm | SI   |
      | payment_f24        | NULL |
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And l'avviso pagopa viene pagato correttamente
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "PAYMENT"

  @clean @webhook1
  Scenario: [B2B-STREAM_TIMELINE_26] Invio notifica digitale ed attesa elemento di timeline REFINEMENT e verifica corretteza data PN-9059
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V22"
    And si crea il nuovo stream per il "Comune_1" con versione "V22"
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And l'avviso pagopa viene pagato correttamente
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REFINEMENT"
    And Si verifica che l'elemento di timeline REFINEMENT abbia il timestamp uguale a quella presente nel webhook
