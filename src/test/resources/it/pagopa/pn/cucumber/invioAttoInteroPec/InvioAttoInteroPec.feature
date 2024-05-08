Feature: Invio atto intero via PEC (fase 2 - estensione F24)

  @invioAttoInteroPec
  Scenario: [B2B-PA-WI_2_SEND_PEC_1] PF - Verifica PEC contenente allegati (solo un atto, AAR) di una notifica mono destinatario digitale
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
    And destinatario Mario Gherkin e:
      | payment_pagoPaForm | SI |
      | apply_cost_pagopa  | SI |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_SUCCESS_WORKFLOW"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    And si verifica il contenuto degli attacchment da inviare nella pec del destinatario 0


  Scenario: [B2B-PA-WI_2_SEND_PEC_2] PG - Verifica PEC contenente allegati (Più Atti, AAR) di una notifica mono destinatario digitale

  Scenario: [B2B-PA-WI_2_SEND_PEC_3] PF - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA) di una notifica mono destinatario digitale con solo avviso PagoPa

  Scenario: [B2B-PA-WI_2_SEND_PEC_5] PF/PG - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA, no F24) di una notifica multi destinatario digitale con più avvisi PagoPA e senza modelli F24

  Scenario: [B2B-PA-WI_2_SEND_PEC_6] Verifica presenza e correttezza SHA dei documenti allegati alla PEC in ricevuta consegna PEC

  Scenario: [B2B-PA-WI_2_SEND_PEC_8] PF - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA,  F24) di una notifica mono destinatario digitale con solo avviso PagoPa e modello F24

  Scenario: [B2B-PA-WI_2_SEND_PEC_9] PF/PG - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA,  F24) di una notifica multi destinatario digitale con più avvisi PagoPA e modelli F24

  Scenario: [B2B-PA-WI_2_SEND_PEC_10] PF/PG - Verifica PEC contenente i propri allegati per ogni destinatario di una notifica multi destinatario digitale per il primo destinatario contente solamente più avvisi PagoPA e per il secondo destinatario contenente solamente più modelli F24



