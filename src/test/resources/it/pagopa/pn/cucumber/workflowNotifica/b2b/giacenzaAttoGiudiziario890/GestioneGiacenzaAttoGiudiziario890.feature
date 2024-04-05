Feature: avanzamento notifiche b2b con workflow cartaceo gestione giacenza atto giudiziario 890

  Background:
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"

  @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_1] Consegnata atto in Giacenza prima dei 10 giorni.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | OK-Giacenza-lte10_890 |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@OK-Giacenza-lte10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "CON080"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG011A"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG005B" e verifica tipo DOC "23L"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG005C"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.30s-RECAG012.5s-RECAG005A.5s-RECAG005B[DOC:ARCAD;DOC:23L].5s-RECAG005C"

  @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_2] Consegnato in Giacenza dopo i 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | OK-Giacenza-gt10_890 |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@OK-Giacenza-gt10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG005C"

    #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD;DOC:23L].60s-RECAG005A.5s-RECAG005C"

  @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_3] Consegnato in Giacenza dopo i 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | OK-Giacenza-gt10-23L_890 |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@OK-Giacenza-gt10-23L_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG005C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD].5s-RECAG005A.5s-RECAG005B[DOC:23L].5s-RECAG005C"

  @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_4] Consegnato a persona delegata in Giacenza prima dei 10 giorni.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | OK-GiacenzaDelegato-lte10_890 |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@OK-GiacenzaDelegato-lte10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG006C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.30s-RECAG012.5s-RECAG006A.5s-RECAG006B[DOC:ARCAD;DOC:23L].5s-RECAG006C"

  @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_5] Consegnato a persona delegata in Giacenza dopo dei 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | OK-GiacenzaDelegato-gt10_890 |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@OK-GiacenzaDelegato-gt10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG006C"

    #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD;DOC:23L].60s-RECAG006A.5s-RECAG006C"

  @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_6] Consegnato a persona delegata in Giacenza dopo dei 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | OK-GiacenzaDelegato-gt10-23L_890 |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@OK-GiacenzaDelegato-gt10-23L_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG006C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD].5s-RECAG006A.5s-RECAG006B[DOC:23L].5s-RECAG006C"


  @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_7] Mancata Consegna in Giacenza prima dei 10 giorni.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | FAIL-Giacenza-lte10_890 |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@FAIL-Giacenza-lte10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG007C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.30s-RECAG012.5s-RECAG007A.5s-RECAG007B[DOC:ARCAD;DOC:Plico].5s-RECAG007C"

  @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_8] Mancata Consegna in Giacenza dopo i 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | FAIL-Giacenza-gt10_890 |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@FAIL-Giacenza-gt10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG007C"

    #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD;DOC:23L].60s-RECAG007A.5s-RECAG007B[DOC:Plico].5s-RECAG007C"

  @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_9] Mancata Consegna in Giacenza dopo i 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno.
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | FAIL-Giacenza-gt10-23L_890 |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@FAIL-Giacenza-gt10-23L_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG007C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD].5s-RECAG007A.5s-RECAG007B[DOC:23L;DOC:Plico].5s-RECAG007C"


  @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_10] Compiuta Giacenza. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | OK-CompiutaGiacenza_890 |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@OK-CompiutaGiacenza_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG008C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD;DOC:23L].60s-RECAG008A.5s-RECAG008B[DOC:Plico].5s-RECAG008C"















  @giacenza890simplified
  Scenario: [B2B_GIACENZA_890_1] Invio notifica ed attesa elemento di timeline SEND_ANALOG_FEEDBACK con deliveryDetailCode PNAG012 positivo PN-5820
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | OK-Giacenza-gt10_890 |
      | taxId | CLMCST42R12D969Z |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@OK-Giacenza-gt10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "PNAG012"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG005C" e verifica data delay più 0
    #"sequence": "@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.5s-RECAG012[DELAY:+10d].5s-RECAG011B[DOC:ARCAD;DOC:23L].5s-RECAG005A[DELAY:+20d].5s-RECAG005C[DELAY:+20d]"


