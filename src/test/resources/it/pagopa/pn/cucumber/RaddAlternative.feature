Feature: Radd Alternative


  @radd
  Scenario: [B2B_RADD_ACT-1] verifica errore inquiry qrCode malformato
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "AAR_GENERATION"
    When L'operatore usa lo IUN per recuperare gli atti della "PF"
