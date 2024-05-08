Feature: Invio atto intero via PEC (fase 2 - estensione F24)

  @invioAttoInteroPec
  Scenario: [ALLEGATI-PEC_WI-2_1] PF - Verifica PEC contenente allegati (solo un atto, AAR) di una notifica mono destinatario digitale
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@pecOk.it |
      | payment                 | NULL          |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_SUCCESS_WORKFLOW"
    And si verifica il contenuto degli attacchment da inviare nella pec del destinatario 0 con 2 allegati
    And si verifica il contenuto della pec abbia 1 attachment di tipo "AAR"
    And si verifica il contenuto della pec abbia 1 attachment di tipo "NOTIFICATION_ATTACHMENTS"


  Scenario: [ALLEGATI-PEC_WI-2_2] PG - Verifica PEC contenente allegati (Più Atti, AAR) di una notifica mono destinatario digitale
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo           |
      | document           | DOC_1_PG; DOC_2_PG          |
    And destinatario
      | denomination | Azienda srl |
      | taxId | DVNLRD52D15M059P |
      | digitalDomicile_address | test@pecOk.it |
      | payment     | NULL              |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_SUCCESS_WORKFLOW"
    And si verifica il contenuto degli attacchment da inviare nella pec del destinatario 0 con 3 allegati
    And si verifica il contenuto della pec abbia 1 attachment di tipo "AAR"
    And si verifica il contenuto della pec abbia 2 attachment di tipo "NOTIFICATION_ATTACHMENTS"

  Scenario: [ALLEGATI-PEC_WI-2_3] PF - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA) di una notifica mono destinatario digitale con solo avviso PagoPa
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@pecOk.it |
      | payment_pagoPaForm      | NO            |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_SUCCESS_WORKFLOW"
    And si verifica il contenuto degli attacchment da inviare nella pec del destinatario 0 con 3 allegati
    And si verifica il contenuto della pec abbia 1 attachment di tipo "AAR"
    And si verifica il contenuto della pec abbia 2 attachment di tipo "NOTIFICATION_ATTACHMENTS"

  Scenario: [ALLEGATI-PEC_WI-2_4] PF/PG - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA, no F24) di una notifica multi destinatario digitale con più avvisi PagoPA e senza modelli F24
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo           |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@pecOk.it |
      | payment_pagoPaForm      | NO            |
    And destinatario
      | denomination | Azienda srl |
      | taxId | DVNLRD52D15M059P |
      | digitalDomicile_address | test@pecOk.it |
      | payment     | NULL              |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_SUCCESS_WORKFLOW"
    And si verifica il contenuto degli attacchment da inviare nella pec del destinatario 0 con 3 allegati
    And si verifica il contenuto della pec abbia 1 attachment di tipo "AAR"
    And si verifica il contenuto della pec abbia 2 attachment di tipo "NOTIFICATION_ATTACHMENTS"
    And si verifica il contenuto degli attacchment da inviare nella pec del destinatario 1 con 2 allegati
    And si verifica il contenuto della pec abbia 1 attachment di tipo "AAR"
    And si verifica il contenuto della pec abbia 1 attachment di tipo "NOTIFICATION_ATTACHMENTS"

  Scenario: [ALLEGATI-PEC_WI-2_5] Verifica presenza e correttezza SHA dei documenti allegati alla PEC in ricevuta consegna PEC

  Scenario: [ALLEGATI-PEC_WI-2_6] PF - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA,  F24) di una notifica mono destinatario digitale con solo avviso PagoPa e modello F24

  Scenario: [ALLEGATI-PEC_WI-2_7] PF/PG - Verifica PEC contenente allegati (Atto, AAR, Avviso PagoPA,  F24) di una notifica multi destinatario digitale con più avvisi PagoPA e modelli F24

  Scenario: [ALLEGATI-PEC_WI-2_8] PF/PG - Verifica PEC contenente i propri allegati per ogni destinatario di una notifica multi destinatario digitale per il primo destinatario contente solamente più avvisi PagoPA e per il secondo destinatario contenente solamente più modelli F24



