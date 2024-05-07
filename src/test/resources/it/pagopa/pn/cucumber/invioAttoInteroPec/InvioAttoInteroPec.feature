Feature: Invio atto intero via PEC (fase 2 - estensione F24)

  @invioAttoInteroPec
  Scenario: [B2B-PA-WI_2_SEND_PEC_1] PF - Verifica PEC contenente allegati (solo un atto, AAR) di una notifica mono destinatario digitale
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Cucumber e:
      | payment_pagoPaForm | SI |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then si verifica la corretta acquisizione della notifica
    And la notifica può essere correttamente recuperata dal sistema tramite codice IUN




