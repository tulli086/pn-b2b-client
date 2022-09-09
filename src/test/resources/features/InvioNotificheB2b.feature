Feature: invio notifiche b2b

  Scenario: B2B_1 : invio e recupero nuova notifica tramite api b2b
    Given viene predisposta una notifica con oggetto "invio notifica con cucumber" mittente "comune di milano" destinatario "Mario Cucumber" con codice fiscale "FRMTTR76M06B715E"
    When la notifica viene inviata e si riceve una risposta
    Then la risposta di ricezione non presenta errori
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN

  Scenario: B2B_2 : invio notifiche con uguale paProtocolNumber e diverso idempotenceToken
    Given viene predisposta una notifica con oggetto "invio notifica con cucumber" mittente "comune di milano" destinatario "Mario Cucumber" con codice fiscale "FRMTTR76M06B715E" e idempotenceToken "AME2E3626070001.1"
    And la notifica viene inviata e si riceve una risposta
    And la risposta di ricezione non presenta errori
    And viene predisposta e inviata una nuova notifica con uguale paProtocolNumber e idempotenceToken "AME2E3626070001.2"
    When la notifica viene inviata e si riceve una risposta
    Then la risposta di ricezione non presenta errori

  Scenario: B2B_3 : invio notifiche con uguale paProtocolNumber e uguale idempotenceToken
    Given viene predisposta una notifica con oggetto "invio notifica con cucumber" mittente "comune di milano" destinatario "Mario Cucumber" con codice fiscale "FRMTTR76M06B715E" e idempotenceToken "AME2E3626070001.1"
    And la notifica viene inviata e si riceve una risposta
    And la risposta di ricezione non presenta errori
    And viene predisposta e inviata una nuova notifica con uguale paProtocolNumber e idempotenceToken "AME2E3626070001.1"
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "409"

  Scenario: B2B_4 : invio notifiche con uguale codice fiscale del creditore e diverso codice avviso
    Given viene predisposta una notifica con oggetto "invio notifica con cucumber" mittente "comune di milano" destinatario "Mario Cucumber" con codice fiscale "FRMTTR76M06B715E" e creditorTaxId "77777777777"
    And la notifica viene inviata e si riceve una risposta
    And la risposta di ricezione non presenta errori
    And viene predisposta e inviata una nuova notifica con uguale codice fiscale del creditore e diverso codice avviso
    When la notifica viene inviata e si riceve una risposta
    Then la risposta di ricezione non presenta errori

  Scenario: B2B_5 : invio notifiche con uguale codice fiscale del creditore e uguale codice avviso
    Given viene predisposta una notifica con oggetto "invio notifica con cucumber" mittente "comune di milano" destinatario "Mario Cucumber" con codice fiscale "FRMTTR76M06B715E" e creditorTaxId "77777777777"
    And la notifica viene inviata e si riceve una risposta
    And la risposta di ricezione non presenta errori
    And viene predisposta e inviata una nuova notifica con uguale codice fiscale del creditore e uguale codice avviso
    When la notifica viene inviata
    Then l'operazione ha prodotto un errore con status code "409"

  Scenario: B2B_6 : download documento notificato
    Given viene predisposta una notifica con oggetto "invio notifica con cucumber" mittente "comune di milano" destinatario "Mario Cucumber" con codice fiscale "FRMTTR76M06B715E"
    And la notifica viene inviata e si riceve una risposta
    And la risposta di ricezione non presenta errori
    When viene richiesto il download del documento notificato
    Then il download si conclude correttamente

  #Scenari in errore
#  Scenario: B2B_7 : download errato documento notificato
#    Given viene predisposta una notifica con oggetto "invio notifica con cucumber" mittente "comune di milano" destinatario "Mario Cucumber" con codice fiscale "FRMTTR76M06B715E"
#    And la notifica viene inviata e si riceve una risposta
#    And la risposta di ricezione non presenta errori
#    When viene richiesto il download di un documento inesistente
#    Then l'operazione ha prodotto un errore con status code "400"
#
#  Scenario: B2B_8 : invio e recupero nuova notifica tramite api b2b con codice fiscale errato
#    Given viene predisposta una notifica con oggetto "invio notifica con cucumber" mittente "comune di milano" destinatario "Prova" con codice fiscale "a"
#    When la notifica viene inviata
#    Then l'operazione ha prodotto un errore con status code "400"