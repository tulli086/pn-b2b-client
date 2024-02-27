Feature: Radd Alternative jwt verification


  Scenario: [RADD_ALT-JWKS-1] PF -  Recupero notifica con codice IUN esistente associato con JWKS corretto
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo           |
      | feePolicy          | DELIVERY_MODE               |
      | paFee              | 0                           |
    And destinatario Mario Cucumber e:
      | payment_pagoPaForm   | SI   |
      | payment_f24          | NULL |
      | apply_cost_pagopa    | SI   |
      | apply_cost_f24       | NO   |
      | payment_multy_number | 1    |
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    Then L'operatore usa lo IUN "corretto" per recuperare gli atti di "Mario Cucumber" da issuer "issuer_1"
    And la lettura si conclude correttamente su radd alternative
    And vengono caricati i documento di identità del cittadino su radd alternative
    Then Vengono visualizzati sia gli atti sia le attestazioni opponibili riferiti alla notifica associata all'AAR da radd alternative
    And l'operazione di download degli atti si conclude correttamente su radd alternative
    And l'operazione di download restituisce 5 documenti
    And viene conclusa la visualizzati di atti ed attestazioni della notifica su radd alternative
    And la chiusura delle transazione per il recupero degli aar non genera errori su radd alternative
