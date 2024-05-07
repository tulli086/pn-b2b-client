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


  Scenario: [B2B-PA-WI_2_SEND_PEC_2] PG - Verifica PEC contenente allegati (Più Atti, AAR) di una notifica mono destinatario digitale

  Scenario: [B2B-PA-WI_2_SEND_PEC_3] PF - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA) di una notifica mono destinatario digitale con solo avviso PagoPa

  Scenario: [B2B-PA-WI_2_SEND_PEC_4] PG - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA, no F24) di una notifica mono destinatario digitale con solo avviso PagoPa e senza modello F24

  Scenario: [B2B-PA-WI_2_SEND_PEC_5] PF/PG - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA, no F24) di una notifica multi destinatario digitale con più avvisi PagoPA e senza modelli F24


  Scenario: [B2B-PA-WI_2_SEND_PEC_6] Verifica presenza e correttezza SHA dei documenti allegati alla PEC in ricevuta consegna PEC

  Scenario: [B2B-PA-WI_2_SEND_PEC_7] Notifica mono destinatario digitale con un solo atto superiore a 30mb e controllare che nella lista degli allegati sia presente solo l’allegato AAR

  Scenario: [B2B-PA-WI_2_SEND_PEC_8] PF - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA,  F24) di una notifica mono destinatario digitale con solo avviso PagoPa e modello F24

  Scenario: [B2B-PA-WI_2_SEND_PEC_9] PF/PG - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA,  F24) di una notifica multi destinatario digitale con più avvisi PagoPA e modelli F24

  Scenario: [B2B-PA-WI_2_SEND_PEC_10] PF/PG - Verifica PEC contenente i propri allegati per ogni destinatario di una notifica multi destinatario digitale per il primo destinatario contente solamente più avvisi PagoPA e per il secondo destinatario contenente solamente più modelli F24

  Scenario: [B2B-PA-WI_2_SEND_PEC_11] PF - Verifica PEC contenente allegati (Atto, AAR, avviso PagoPa) di una notifica mono destinatario digitale con solo avviso PagoPa oltre i 30mb e modello F24

  Scenario: [B2B-PA-WI_2_SEND_PEC_12] PG - Verifica PEC contenente allegati (Atto, AAR, F24) di una notifica mono destinatario digitale con solo avviso PagoPa e modello F24 oltre i 30mb



