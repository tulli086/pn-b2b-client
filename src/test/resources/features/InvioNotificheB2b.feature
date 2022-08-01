Feature: invio notifiche b2b
  Scenario: invio e recupero nuova notifica tramite api b2b
    Given viene predisposta una notifica con oggetto "prova invio" mittente "comune di milano" destinatario "Prova" con codice fiscale "FRMTTR76M06B715E"
    When la notifica viene inviata e si riceve una risposta
    Then la risposta di ricezione non presenta errori
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN

