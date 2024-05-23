Feature: avanzamento notifiche b2b con workflow cartaceo 890

  Background:
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"


  @dev @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_2] Invio notifica ed attesa elemento di timeline ANALOG_SUCCESS_WORKFLOW_scenario positivo
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL       |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"


  @dev @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_5] Attesa elemento di timeline SEND_ANALOG_FEEDBACK_fail_890_scenario negativo
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL         |
      | physicalAddress_address | Via@fail_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con responseStatus "OK"


  @dev @ignore @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_7] Attesa elemento di timeline ANALOG_SUCCESS_WORKFLOW_fail_890_NR_scenario positivo
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario Mario Cucumber e:
      | digitalDomicile         | NULL         |
      | physicalAddress_address | Via@fail_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"


  @dev @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_10] Attesa elemento di timeline ANALOG_SUCCESS_WORKFLOW_FAIL-Discovery_890_scenario positivo
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL                   |
      | physicalAddress_address | Via@fail-Discovery_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"


  @dev @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_12] Invio notifica ed attesa elemento di timeline ANALOG_SUCCESS_WORKFLOW_scenario positivo
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | Test 890 ok      |
      | taxId                   | DVNLRD52D15M059P |
      | digitalDomicile         | NULL             |
      | physicalAddress_address | Via@ok_890       |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"


  @dev @ignore @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_14] Invio notifica ed attesa elemento di timeline SEND_ANALOG_FEEDBACK_scenario negativo
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario
      | denomination            | Test 890 Fail    |
      | taxId                   | PRVMNL80A01F205M |
      | digitalDomicile         | NULL             |
      | physicalAddress_address | Via@fail_890     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con responseStatus "KO"
     #PRVMNL80A01F205M ha un indirizzo PEC


  @dev @ignore @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_15] Invio notifica ed attesa elemento di timeline ANALOG_SUCCESS_WORKFLOW_scenario positivo
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL       |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"


  @dev @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_16] Attesa elemento di timeline SEND_ANALOG_FEEDBACK e verifica campo SEND_ANALOG_FEEDBACK positivo
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario Mario Cucumber e:
      | digitalDomicile         | NULL         |
      | physicalAddress_address | Via@fail_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK"
    And viene verificato il campo sendRequestId dell' evento di timeline "SEND_ANALOG_FEEDBACK"


  @dev @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_18] Invio notifica digitale ed attesa elemento di timeline SEND_ANALOG_DOMICILE e controllo campi municipalityDetails e foreignState positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Cucumber Analogic e:
      | digitalDomicile         | NULL         |
      | physicalAddress_address | Via@fail_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato che nell'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" siano configurati i campi municipalityDetails e foreignState


  Scenario: [B2B_TIMELINE_ANALOG_20] Invio notifica digitale ed attesa elemento di timeline SEND_ANALOG_DOMICILE e controllo campo serviceLevel positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL       |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il campo serviceLevel dell' evento di timeline "SEND_ANALOG_DOMICILE" sia valorizzato con "REGISTERED_LETTER_890"


  @dev @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_22] Invio notifica digitale ed attesa elemento di timeline PREPARE_ANALOG_DOMICILE e controllo campo serviceLevel positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL       |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "PREPARE_ANALOG_DOMICILE"
    And viene verificato il campo serviceLevel dell' evento di timeline "PREPARE_ANALOG_DOMICILE" sia valorizzato con "REGISTERED_LETTER_890"

  @dev @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_24] Invio notifica digitale ed attesa elemento di timeline SEND_ANALOG_FEEDBACK e controllo campo serviceLevel positivo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Gherkin e:
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK"
    And viene verificato il campo serviceLevel dell' evento di timeline "SEND_ANALOG_FEEDBACK" sia valorizzato con "REGISTERED_LETTER_890"



  @dev @ignore @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_26] Invio notifica ed attesa elemento di timeline COMPLETELY_UNREACHABLE_fail_890 negativo
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | Test 890 Fail |
      | taxId | PRVMNL80A01F205M |
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@fail_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"
    #PRVMNL80A01F205M ha un indirizzo PEC



  @dev @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_28] Attesa elemento di timeline COMPLETELY_UNREACHABLE_fail_890_scenario negativo
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination | Test AR Fail 2 |
      | taxId | DVNLRD52D15M059P |
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-Irreperibile_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"

  @dev @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_31] Invio notifica ed attesa elemento di timeline COMPLETELY_UNREACHABLE_fail_890_NR negativo
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario
      | denomination            | Test 890 Fail 2                              |
      | taxId                   | DVNLRD52D15M059P                             |
      | digitalDomicile         | NULL                                         |
      | physicalAddress_address | Via NationalRegistries@FAIL-Irreperibile_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"


  @dev @ignore @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_32] Invio notifica digitale senza allegato ed attesa elemento di timeline SEND_ANALOG_DOMICILE e controllo numero pagine AAR
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
      | document | NO |
    And destinatario Mario Gherkin e:
      | digitalDomicile | NULL |
      | physicalAddress_address | Via minzoni |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" verifica numero pagine AAR 1


  @dev @ignore @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_47] Invio notifica ed attesa elemento di timeline SEND_ANALOG_FEEDBACK con deliveryDetailCode RECRN015 890 momentaneamente non rendicontabile positivo PN-6079
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario Mario Gherkin e:
      | denomination | OK-CausaForzaMaggiore_890 |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@OK-CausaForzaMaggiore_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "CON080"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG015"
   # And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG001A"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG001B" e verifica tipo DOC "23L"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECRN001C"
    #"@sequence.5s-CON080.5s-RECAG015.5s-RECAG001A.5s-RECAG001B[DOC:23L].5s-RECAG001C"

  @dev @ignore @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_48] Invio notifica ed attesa elemento di timeline SEND_ANALOG_FEEDBACK con deliveryDetailCode RECRN013 890 momentaneamente non rendicontabile positivo PN-6079
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario Mario Gherkin e:
      | denomination | OK-NonRendicontabile_890 |
      | digitalDomicile | NULL |
      | physicalAddress_address | via@OK-NonRendicontabile_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "CON080"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG013"
    #And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG001A"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG001B" e verifica tipo DOC "23L"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECRN001C"
    #"@sequence.5s-CON080.5s-RECAG013@retry.5s-CON080.5s-RECAG001A.5s-RECAG001B[DOC:23L].5s-RECAG001C"



  @dev @workflowAnalogico @bugSecondoTentativo_PN-8719
  Scenario: [B2B_TIMELINE_ANALOG_58] Attesa elemento di timeline ANALOG_SUCCESS_WORKFLOW_FAIL-DiscoveryIrreperibile_890_scenario positivo
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario Mario Gherkin e:
      | digitalDomicile | NULL |
      | physicalAddress_address | Via@FAIL-DiscoveryIrreperibile_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "CON080" tentativo "ATTEMPT_0"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG003E" e verifica tipo DOC "Plico" tentativo "ATTEMPT_0"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG003E" e verifica tipo DOC "Indagine" tentativo "ATTEMPT_0"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG003F" e deliveryFailureCause "M03" tentativo "ATTEMPT_0"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "CON080" tentativo "ATTEMPT_1"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG003E" e verifica tipo DOC "Plico" tentativo "ATTEMPT_1"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" con deliveryDetailCode "RECAG003F" e deliveryFailureCause "M03" tentativo "ATTEMPT_1"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "COMPLETELY_UNREACHABLE"
    #"@sequence.5s-CON080.5s-RECAG003D[DISCOVERY;FAILCAUSE:M03].5s-RECAG003E[DOC:Plico;DOC:Indagine].5s-RECAG003F@discovered.5s-CON080.5s-RECAG003D[FAILCAUSE:M03].5s-RECAG003E[DOC:Plico].5s-RECAG003F"




  @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_65] Attesa elemento di timeline REFINEMENT con physicalAddress OK-WO-011B
    Given viene generata una nuova notifica
      | subject | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL           |
      | physicalAddress_address | via@OK-WO-011B |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"



  @workflowAnalogico
  Scenario: [B2B_TIMELINE_ANALOG_74] Attesa elemento di timeline REFINEMENT con physicalAddress OK-REC008_890 - PN-9929
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL              |
      | physicalAddress_address | Via@OK-REC008_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG011A"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG008B" e verifica tipo DOC "23L"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" con deliveryDetailCode "RECAG008C"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"