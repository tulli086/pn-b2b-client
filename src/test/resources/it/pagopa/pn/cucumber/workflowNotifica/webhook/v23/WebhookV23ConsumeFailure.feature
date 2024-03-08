Feature: tentativo consumo stream

   #--------------CONSUMO DI EVENTI DI UNO STREAM------------

  @webhookV23 @cleanWebhook @webhook2
  Scenario: [B2B-STREAM_ES1.3_126] Consumo di uno stream notifica con gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And viene aggiornata la apiKey utilizzata per gli stream
    And si crea il nuovo stream V23 per il "Comune_Multi" con un gruppo disponibile "FIRST"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When vengono letti gli eventi dello stream versione V23
    Then l'operazione ha prodotto un errore con status code "403"


  @webhookV23 @cleanWebhook @webhook2
  Scenario: [B2B-STREAM_ES1.3_130] Consumo di uno stream notifica con gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo diverso.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And viene aggiornata la apiKey utilizzata per gli stream
    And si crea il nuovo stream V23 per il "Comune_Multi" con un gruppo disponibile "FIRST"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con gruppo differente dallo stream
    And viene impostata l'apikey appena generata
    When vengono letti gli eventi dello stream versione V23
    Then l'operazione ha prodotto un errore con status code "403"


  @webhookV23 @cleanWebhook @webhook2
  Scenario: [B2B-STREAM_ES1.3_125] Consumo di uno stream notifica disabilitato senza gruppo, con eventType "STATUS"  utilizzando un apikey master.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_Multi" senza gruppo
    And viene impostata l'apikey appena generata
    And viene aggiornata la apiKey utilizzata per gli stream
    And si crea il nuovo stream per il "Comune_Multi" con versione "V23"
    And si disabilita lo stream V23 creato per il comune "Comune_Multi"
    And l'operazione non ha prodotto errori
    When vengono letti gli eventi dello stream versione V23
    Then l'operazione non ha prodotto errori


  @webhookV23 @cleanWebhook @webhook2
  Scenario: [B2B-STREAM_ES1.3_133] Consumo di uno stream notifica senza gruppo, con eventType "STATUS"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "STATUS" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_Multi" senza gruppo
    And viene impostata l'apikey appena generata
    And viene aggiornata la apiKey utilizzata per gli stream
    And si crea il nuovo stream per il "Comune_Multi" con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When vengono letti gli eventi dello stream versione V23
    Then l'operazione ha prodotto un errore con status code "403"

    #Verificare se corretto che restituisce un 400 invece di un 403
  @webhookV23 @cleanWebhook @webhook2
  Scenario: [B2B-STREAM_ES1.5_139] Creazione di uno stream senza gruppo con la V23 e lettura Eventi di timeline o di cambio di stato con la versione V10  utilzzando un apikey abilitata
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_Multi" senza gruppo
    And viene impostata l'apikey appena generata
    And viene aggiornata la apiKey utilizzata per gli stream
    And si crea il nuovo stream per il "Comune_Multi" con versione "V23"
    When vengono letti gli eventi di timeline dello stream con versione "V10" -Cross Versioning
    Then l'operazione ha prodotto un errore con status code "400"


  @webhookV23 @cleanWebhook @webhook2
  Scenario: [B2B-STREAM_ES1.5_141] Creazione di uno stream senza gruppo con la V10 e  lettura Eventi di timeline o di cambio di stato con la versione V23 utilzzando un apikey abilitata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V10"
    And si crea il nuovo stream per il "Comune_Multi" con versione "V10"
    And Viene creata una nuova apiKey per il comune "Comune_Multi" senza gruppo
    And viene impostata l'apikey appena generata
    When vengono letti gli eventi di timeline dello stream con versione "V23" -Cross Versioning
    Then l'operazione ha prodotto un errore con status code "403"



  @webhookV23 @cleanWebhook @webhook2
  Scenario: [B2B-STREAM_ES1.3_135] Consumo di uno stream notifica senza gruppo, con eventType "TIMELINE"  utilizzando un apikey con gruppo.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_Multi" senza gruppo
    And viene impostata l'apikey appena generata
    And viene aggiornata la apiKey utilizzata per gli stream
    And si crea il nuovo stream per il "Comune_Multi" con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When vengono letti gli eventi dello stream versione V23
    Then l'operazione ha prodotto un errore con status code "403"



  @webhookV23 @cleanWebhook @webhook2
  Scenario: [B2B-STREAM_ES1.1_159] Consumo di uno stream notifica con gruppi non appartenenti ad un sottinsieme dei gruppi dell'apikey utilizzata.
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V23"
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con due gruppi
    And viene impostata l'apikey appena generata
    And viene aggiornata la apiKey utilizzata per gli stream
    And si crea il nuovo stream V23 per il "Comune_Multi" con un gruppo disponibile "UGUALI"
    And lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V23"
    And viene modificato lo stato dell'apiKey in "BLOCK"
    And l'apiKey viene cancellata
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    When vengono letti gli eventi dello stream versione V23
    Then l'operazione ha prodotto un errore con status code "403"

#-----------------------------------------------------------------------------------------------------------------
#TODO RipoRtare i TEST NEL FILE FEATURE CORRETTO
  #DELETE
  @webhookV23 @cleanWebhook @webhook2
  Scenario: [B2B-STREAM_ES1.1_160] Creazione di uno stream senza gruppo con la V10 e  cancellazione dello stesso utilizzando un apikey con gruppi.-PN-10218
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V10"
    And si crea il nuovo stream per il "Comune_Multi" con versione "V10"
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And viene aggiornata la apiKey utilizzata per gli stream
    And si cancella lo stream creato per il "Comune_Multi" con versione "V10"
    Then l'operazione non ha prodotto errori

  #UPDATE
  @webhookV23 @cleanWebhook @webhook2
  Scenario: [B2B-STREAM_ES1.5.161] Creazione di uno stream senza gruppo con la V10 e  aggiornamento dello stesso utilizzando un apikey con gruppi.-PN-10218
    Given si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V10"
    And si crea il nuovo stream per il "Comune_Multi" con versione "V10"
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And viene aggiornata la apiKey utilizzata per gli stream
    And si aggiorna lo stream creato con versione "V10"
    Then l'operazione non ha prodotto errori

  #CONSUME
  @webhookV23 @cleanWebhook @webhook1
  Scenario: [B2B-STREAM_ES1.3_162] Creazione di uno stream senza gruppo con la V10 e  lettura Eventi di timeline o di cambio di stato con la versione V10 utilizzando un apikey con gruppi. -PN-10218.
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Gherkin
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V10"
    And si crea il nuovo stream per il "Comune_1" con versione "V10"
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And Viene creata una nuova apiKey per il comune "Comune_1" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And viene aggiornata la apiKey utilizzata per gli stream
    Then vengono letti gli eventi dello stream del "Comune_1" fino all'elemento di timeline "REQUEST_ACCEPTED"

  #SEARCH
  @webhookV23 @cleanWebhook @webhook2
  Scenario: [B2B-STREAM_ES1.1_163] Creazione di uno stream senza gruppo con la V10 e recupero metadati utilizzando un apikey con gruppi. -PN-10218.
    Given vengono cancellati tutti gli stream presenti del "Comune_Multi" con versione "V10"
    And si predispongono 1 nuovo stream denominato "stream-test" con eventType "TIMELINE" con versione "V10"
    And si crea il nuovo stream per il "Comune_Multi" con versione "V10"
    And Viene creata una nuova apiKey per il comune "Comune_Multi" con il primo gruppo disponibile
    And viene impostata l'apikey appena generata
    And viene aggiornata la apiKey utilizzata per gli stream
    Then lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione "V10"






