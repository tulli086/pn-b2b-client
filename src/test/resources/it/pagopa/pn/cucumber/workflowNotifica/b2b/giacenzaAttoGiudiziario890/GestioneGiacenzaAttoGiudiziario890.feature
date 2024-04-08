Feature: avanzamento notifiche b2b con workflow cartaceo gestione giacenza atto giudiziario 890

  Background:
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"

  @workflowAnalogico @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_1] Consegnata atto in Giacenza prima dei 10 giorni.
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | OK-Giacenza-lte10_890     |
      | taxId                   | CLMCST42R12D969Z          |
      | digitalDomicile         | NULL                      |
      | physicalAddress_address | via@OK-Giacenza-lte10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "CON080"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG011A"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG005B" e verifica tipo DOC "23L"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG005C"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.30s-RECAG012.5s-RECAG005A.5s-RECAG005B[DOC:ARCAD;DOC:23L].5s-RECAG005C"

    #SEND_ANALOG_PROGRESS
  #CON080 - Stampato ed Imbustato.

  #SEND_ANALOG_PROGRESS nn sono OK e ne KO
  #inesito RECAG010 - Atto Giudiziario (890)
  #RECRS010 - Raccomandata Semplice (RS)
  #RECRN010 - Raccomandata con ricevuta di ritorno (AR)
  #RECAG012 - ""

  #SEND_ANALOG_FEEDBACK
  #PNAG012 - Perfezionamento giudiziario della notifica - Il destinatario non ha ritirato la raccomandata 890 numero {{numero raccomandata}} presso il punto di giacenza entro 10 giorni. SEND_ANALOG_FEEDBACK

    #SEND_ANALOG_PROGRESS
  #RECAG005A - Consegnato presso Punti di Giacenza - pre-esito
  #RECAG006A - Consegna a persona abilitata presso Punti di Giacenza - pre-esito
  #RECAG007A - Mancata consegna presso Punti di Giacenza - pre-esito
  #RECAG008A - Compiuta giacenza - pre-esito

  #SEND_ANALOG_PROGRESS
  #RECAG005B - Consegnato presso Punti di Giacenza In Dematerializzazione - 23L**
  #RECAG006B - Consegna a persona delegata presso Punti di Giacenza In Dematerializzazione - 23L**
  #RECAG007B - Mancata consegna presso Punti di Giacenza In Dematerializzazione - C'è un nuovo documento allegato 23L o plico
  #RECAG008B - Compiuta giacenza In Dematerializzazione -  Plico -C'è un nuovo documento allegato  plico
  #RECAG011B - Dematerializzazione 23L

  #SEND_ANALOG_FEEDBACK | SEND_ANALOG_PROGRESS
  #RECAG005C -- Consegnato presso Punti di Giacenza -La raccomandata 890 numero {{numero raccomandata}} è stata ritirata presso il punto di giacenza.
  #RECAG006C -- Consegna a persona delegata presso Punti di Giacenza -La raccomandata 890 numero {{numero raccomandata}} è stata ritirata da una persona delegata presso il punto di giacenza
  #RECAG007C -- Mancata consegna presso Punti di Giacenza -Il destinatario ha rifiutato il ritiro della raccomandata 890 numero {{numero raccomandata}} presso il punto di giacenza.
  #RECAG008C -- Compiuta giacenza. Il destinatario non ha ritirato la raccomandata 890 numero {{numero raccomandata}} presso il punto di giacenza entro 6 mesi.


  @workflowAnalogico @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_2] Consegnato in Giacenza dopo i 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno.
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | OK-Giacenza-gt10_890     |
      | taxId                   | CLMCST42R12D969Z         |
      | digitalDomicile         | NULL                     |
      | physicalAddress_address | via@OK-Giacenza-gt10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG005C"

    #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD;DOC:23L].60s-RECAG005A.5s-RECAG005C"


  @workflowAnalogico @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_3] Consegnato in Giacenza dopo i 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | OK-Giacenza-gt10-23L_890     |
      | taxId                   | CLMCST42R12D969Z             |
      | digitalDomicile         | NULL                         |
      | physicalAddress_address | via@OK-Giacenza-gt10-23L_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG005C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD].5s-RECAG005A.5s-RECAG005B[DOC:23L].5s-RECAG005C"

  @workflowAnalogico @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_4] Consegnato a persona delegata in Giacenza prima dei 10 giorni.
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | OK-GiacenzaDelegato-lte10_890     |
      | taxId                   | CLMCST42R12D969Z                  |
      | digitalDomicile         | NULL                              |
      | physicalAddress_address | via@OK-GiacenzaDelegato-lte10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG006C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.30s-RECAG012.5s-RECAG006A.5s-RECAG006B[DOC:ARCAD;DOC:23L].5s-RECAG006C"


  @workflowAnalogico @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_5] Consegnato a persona delegata in Giacenza dopo dei 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | OK-GiacenzaDelegato-gt10_890     |
      | taxId                   | CLMCST42R12D969Z                 |
      | digitalDomicile         | NULL                             |
      | physicalAddress_address | via@OK-GiacenzaDelegato-gt10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG006C"

    #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD;DOC:23L].60s-RECAG006A.5s-RECAG006C"


  @workflowAnalogico @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_6] Consegnato a persona delegata in Giacenza dopo dei 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | OK-GiacenzaDelegato-gt10-23L_890     |
      | taxId                   | CLMCST42R12D969Z                     |
      | digitalDomicile         | NULL                                 |
      | physicalAddress_address | via@OK-GiacenzaDelegato-gt10-23L_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG006C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD].5s-RECAG006A.5s-RECAG006B[DOC:23L].5s-RECAG006C"


  @workflowAnalogico @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_7] Mancata Consegna in Giacenza prima dei 10 giorni.
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | FAIL-Giacenza-lte10_890     |
      | taxId                   | CLMCST42R12D969Z            |
      | digitalDomicile         | NULL                        |
      | physicalAddress_address | via@FAIL-Giacenza-lte10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG007C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.30s-RECAG012.5s-RECAG007A.5s-RECAG007B[DOC:ARCAD;DOC:Plico].5s-RECAG007C"

  @workflowAnalogico @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_8] Mancata Consegna in Giacenza dopo i 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno.
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | FAIL-Giacenza-gt10_890     |
      | taxId                   | CLMCST42R12D969Z           |
      | digitalDomicile         | NULL                       |
      | physicalAddress_address | via@FAIL-Giacenza-gt10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG007C"

    #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD;DOC:23L].60s-RECAG007A.5s-RECAG007B[DOC:Plico].5s-RECAG007C"

  @workflowAnalogico @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_9] Mancata Consegna in Giacenza dopo i 10 giorni. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno.
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | FAIL-Giacenza-gt10-23L_890     |
      | taxId                   | CLMCST42R12D969Z               |
      | digitalDomicile         | NULL                           |
      | physicalAddress_address | via@FAIL-Giacenza-gt10-23L_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG007C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD].5s-RECAG007A.5s-RECAG007B[DOC:23L;DOC:Plico].5s-RECAG007C"


  @workflowAnalogico @giacenza890Simplified
  Scenario: [B2B_GIACENZA_890_10] Compiuta Giacenza. In questo scenario viene simulato il perfezionamento dell’atto al 10° giorno
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | OK-CompiutaGiacenza_890     |
      | taxId                   | CLMCST42R12D969Z            |
      | digitalDomicile         | NULL                        |
      | physicalAddress_address | via@OK-CompiutaGiacenza_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG008C"

  #"@sequence.5s-CON080.5s-RECAG010.5s-RECAG011A.60s-RECAG012.5s-RECAG011B[DOC:ARCAD;DOC:23L].60s-RECAG008A.5s-RECAG008B[DOC:Plico].5s-RECAG008C"


  @workflowAnalogico @giacenza890simplified
  Scenario: [B2B_GIACENZA_890_11] Invio notifica con sequence @OK-Giacenza-lte10_890 ed attesa elemento di timeline SEND_ANALOG_PROGRESS con deliveryDetailCode RECAG010
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | OK-Giacenza-gt10_890      |
      | taxId                   | CLMCST42R12D969Z          |
      | digitalDomicile         | NULL                      |
      | physicalAddress_address | via@OK-Giacenza-lte10_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG010"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"

  @workflowAnalogico @giacenza890simplified
  Scenario: [B2B_GIACENZA_890_12] Invio notifica con sequence @OK-Giacenza_RS ed attesa elemento di timeline SEND_ANALOG_PROGRESS con deliveryDetailCode RECRS010
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | OK-Giacenza_RS     |
      | taxId                   | CLMCST42R12D969Z   |
      | digitalDomicile         | NULL               |
      | physicalAddress_address | via@OK-Giacenza_RS |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECRS010"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"


  @workflowAnalogico @giacenza890simplified
  Scenario: [B2B_GIACENZA_890_13] Invio notifica con sequence @OK-WO-Giacenza_AR ed attesa elemento di timeline SEND_ANALOG_PROGRESS con deliveryDetailCode RECRS010
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | OK-WO-Giacenza_AR     |
      | taxId                   | CLMCST42R12D969Z      |
      | digitalDomicile         | NULL                  |
      | physicalAddress_address | via@OK-WO-Giacenza_AR |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECRS010"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"

  @workflowAnalogico @giacenza890simplified
  Scenario: [B2B_GIACENZA_890_14] Invio notifica con sequence @OK-WO-Giacenza_AR ed attesa elemento di timeline SEND_ANALOG_PROGRESS con deliveryDetailCode RECRS010
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | FAIL-Giacenza-Missing_11A_890     |
      | taxId                   | CLMCST42R12D969Z      |
      | digitalDomicile         | NULL                  |
      | physicalAddress_address | via@FAIL-Giacenza-Missing_11A_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECRS011"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG012"


