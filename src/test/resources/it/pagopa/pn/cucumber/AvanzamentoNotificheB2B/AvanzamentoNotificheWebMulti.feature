Feature: avanzamento notifiche b2b multi

  Scenario: [B2B_PA_MULTI_1] Invio notifica e download atto opponibile DIGITAL_DELIVERY_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica GA cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario Mario Gherkin
    And destinatario Mario Cucumber
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino allo stato della notifica "DELIVERED" dalla PA "Comune_Multi"

  @ignore
  Scenario: [B2B_PA_MULTI_2] Invio notifica multi destinatario con pagamento_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica GA cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario Mario Gherkin e:
      | digitalDomicile | NULL |
      | physicalAddress | NULL |
    And destinatario Mario Cucumber e:
      | digitalDomicile | NULL |
      | physicalAddress | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino allo stato della notifica "COMPLETELY_UNREACHABLE" dalla PA "Comune_Multi"

  @ignore
  Scenario: [B2B_PA_MULTI_3] Invio notifica multi destinatario con pagamento_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica GA cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario Mario Gherkin e:
      | digitalDomicile | NULL |
      | physicalAddress | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino allo stato della notifica "COMPLETELY_UNREACHABLE" dalla PA "Comune_Multi"

  Scenario: [B2B-TIMELINE_MULTI_4] Invio notifica multi destinatario_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica GA cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario Mario Gherkin
    And destinatario Mario Cucumber
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And "Mario Gherkin" legge la notifica ricevuta
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_VIEWED"

  Scenario: [B2B-TIMELINE_MULTI_5] Invio notifica multi destinatario_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica GA cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario Mario Gherkin
    And destinatario Mario Cucumber
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And "Mario Cucumber" legge la notifica ricevuta
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "NOTIFICATION_VIEWED"

  Scenario: [B2B_PA_MULTI_6] Invio notifica multi destinatario SCHEDULE_ANALOG_WORKFLOW_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica GA cucumber |
      | senderDenomination | Comune di palermo |
    And destinatario Mario Gherkin e:
      | digitalDomicile | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SCHEDULE_ANALOG_WORKFLOW"

  @clean @integrationTest
  Scenario: [B2B-TIMELINE_MULTI_7] Invio notifica digitale ed attesa elemento di timeline GET_ADDRESS_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Gherkin
    And destinatario Mario Cucumber
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE"
    And si crea il nuovo stream
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream fino all'elemento di timeline "GET_ADDRESS"

  @clean @dev
  Scenario: [B2B-TIMELINE_MULTI_8] Invio notifica digitale ed attesa elemento di timeline PUBLIC_REGISTRY_CALL_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
    And destinatario Mario Cucumber e:
      | digitalDomicile_address | test@fail.it |
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE"
    And si crea il nuovo stream
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream fino all'elemento di timeline "PUBLIC_REGISTRY_CALL"

  @clean @dev
  Scenario: [B2B-TIMELINE_MULTI_9] Invio notifica digitale ed attesa elemento di timeline PUBLIC_REGISTRY_RESPONSE_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
    And destinatario Mario Cucumber e:
      | digitalDomicile_address | test@fail.it |
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE"
    And si crea il nuovo stream
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream fino all'elemento di timeline "PUBLIC_REGISTRY_RESPONSE"

  @dev
  Scenario: [B2B-TIMELINE_MULTI_10] Invio notifica digitale ed attesa elemento di timeline DIGITAL_FAILURE_WORKFLOW_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
    And destinatario Mario Cucumber e:
      | digitalDomicile_address | test@fail.it |
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE"
    And si crea il nuovo stream
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream fino all'elemento di timeline "DIGITAL_FAILURE_WORKFLOW"

  @dev
  Scenario: [B2B-TIMELINE_MULTI_11] Invio notifica digitale ed attesa elemento di timeline SCHEDULE_ANALOG_WORKFLOW_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
    And destinatario Mario Cucumber e:
      | digitalDomicile_address | test@fail.it |
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE"
    And si crea il nuovo stream
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream fino all'elemento di timeline "SCHEDULE_ANALOG_WORKFLOW"

  Scenario: [B2B-TIMELINE_MULTI_12] Invio notifica digitale ed attesa elemento di timeline SEND_DIGITAL_PROGRESS_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Gherkin
    And destinatario Mario Cucumber
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE"
    And si crea il nuovo stream
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_PROGRESS"

  Scenario: [B2B-TIMELINE_MULTI_13] Invio notifica digitale ed attesa elemento di timeline SEND_DIGITAL_FEEDBACK_scenario positivo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario Mario Gherkin
    And destinatario Mario Cucumber
    And si predispone 1 nuovo stream denominato "stream-test" con eventType "TIMELINE"
    And si crea il nuovo stream
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi dello stream fino all'elemento di timeline "SEND_DIGITAL_FEEDBACK"



