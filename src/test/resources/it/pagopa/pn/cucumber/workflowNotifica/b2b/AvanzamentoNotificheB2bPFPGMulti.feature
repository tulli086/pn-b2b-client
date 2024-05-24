Feature: avanzamento notifiche b2b multi destinatario con persona fisica e giuridica



  Scenario: [B2B_TIMELINE_MULTI_PF_PG_02] Invio notifica digitale ed attesa elemento di timeline GET_ADDRESS_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Gherkin spa
    And destinatario Mario Cucumber
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "GET_ADDRESS"

  Scenario: [B2B_TIMELINE_MULTI_PF_PG_03] Invio notifica digitale ed attesa stato DELIVERING_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Gherkin spa
    And destinatario Mario Cucumber
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino allo stato della notifica "DELIVERING"

  Scenario: [B2B_TIMELINE_MULTI_PF_PG_04] Invio notifica digitale ed attesa elemento di timeline SEND_DIGITAL_DOMICILE_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Gherkin spa
    And destinatario Mario Cucumber
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE"

  Scenario: [B2B_TIMELINE_MULTI_PF_PG_05] Invio notifica digitale ed attesa stato DELIVERED_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Gherkin spa
    And destinatario Mario Cucumber
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino allo stato della notifica "DELIVERED"





    @ignore
  Scenario: [B2B_TIMELINE_MULTI_PF_PF_09] Invio notifica multidestinatario da pagare destinatario 0 e destinatario 1 scenario  positivo
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination     | Cristoforo Colombo  |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_zip     | 16121       |
      | physicalAddress_address | Via@ok_AR |
    And destinatario
      | denomination     | Polo  |
      | taxId | PLOMRC01P30L736Y |
      | digitalDomicile | NULL |
      | physicalAddress_zip     | 16121       |
      | physicalAddress_address | Via@ok_AR |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato il costo = "100" della notifica per l'utente 0
    And viene verificato il costo = "100" della notifica per l'utente 1


  Scenario: [B2B_TIMELINE_MULTI_PF_PF_10] Invio notifica e verifica costo con RECAPITISTA + @OK_890 + DELIVERY_MODE positivo
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy             | DELIVERY_MODE                   |
    And destinatario
      | denomination     | Cristoforo Colombo  |
      | taxId | CLMCST42R12D969Z |
      | payment_pagoPaForm      | SI         |
      | digitalDomicile         | NULL       |
      | physicalAddress_zip     | 16121       |
      | physicalAddress_address | Via@ok_890 |
    And destinatario
      | denomination     | Polo  |
      | taxId | PLOMRC01P30L736Y |
      | payment_pagoPaForm      | SI         |
      | digitalDomicile         | NULL       |
      | physicalAddress_zip     | 16121       |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then viene verificato il costo = "100" della notifica per l'utente 0
    And viene verificato il costo = "100" della notifica per l'utente 1
    #And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW" per l'utente 1
    #And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW" per l'utente 0
    #And viene verificato il costo = "266" della notifica per l'utente 0
    #And viene verificato il costo = "266" della notifica per l'utente 1

