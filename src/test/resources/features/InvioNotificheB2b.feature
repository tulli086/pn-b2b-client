Feature: invio notifiche b2b

  Scenario: invio e recupero nuova notifica tramite api b2b
    Given viene predisposta una notifica con oggetto "prova invio" mittente "comune di milano" destinatario "Prova" con codice fiscale "FRMTTR76M06B715E"
    When la notifica viene inviata e si riceve una risposta
    Then la risposta di ricezione non presenta errori
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN

  Scenario: invio notifiche con uguale paProtocolNumber e diverso idempotenceToken
    Given viene predisposta una notifica con oggetto "prova invio" mittente "comune di milano" destinatario "Prova" con codice fiscale "FRMTTR76M06B715E" e idempotenceToken "AME2E3626070001.1"
    And la notifica viene inviata e si riceve una risposta
    And la risposta di ricezione non presenta errori
    And viene predisposta e inviata una nuova notifica con uguale paProtocolNumber e idempotenceToken "AME2E3626070001.2"
    When la notifica viene inviata e si riceve una risposta
    Then la risposta di ricezione non presenta errori

  Scenario: invio notifiche con uguale paProtocolNumber e uguale idempotenceToken
    Given viene predisposta una notifica con oggetto "prova invio" mittente "comune di milano" destinatario "Prova" con codice fiscale "FRMTTR76M06B715E" e idempotenceToken "AME2E3626070001.1"
    And la notifica viene inviata e si riceve una risposta
    And la risposta di ricezione non presenta errori
    And viene predisposta e inviata una nuova notifica con uguale paProtocolNumber e idempotenceToken "AME2E3626070001.1"
    When la notifica viene inviata
    Then l'invio della notifica ha prodotto un errore con status code "400"

