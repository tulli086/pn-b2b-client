Feature: avanzamento b2b notifica difgitale fallito

     @workflowDigitale
     Scenario: [B2B_TIMELINE_16] Invio notifica digitale ed attesa elemento di timeline PUBLIC_REGISTRY_CALL_scenario positivo
          Given viene generata una nuova notifica
               | subject | invio notifica con cucumber |
               | senderDenomination | Comune di milano |
          And destinatario Mario Cucumber e:
               | digitalDomicile_address | test@fail.it |
          When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
          Then vengono letti gli eventi fino all'elemento di timeline della notifica "PUBLIC_REGISTRY_CALL"

     @workflowDigitale
     Scenario: [B2B_TIMELINE_14] Invio notifica digitale ed attesa elemento di timeline SEND_DIGITAL_FEEDBACK_scenario positivo
          Given viene generata una nuova notifica
               | subject | invio notifica con cucumber |
               | senderDenomination | Comune di milano |
          And destinatario Mario Gherkin
          When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
          Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_FEEDBACK"

     @workflowDigitale
     Scenario: [B2B_TIMELINE_15] Invio notifica digitale ed attesa elemento di timeline SEND_DIGITAL_PROGRESS_scenario positivo
          Given viene generata una nuova notifica
               | subject | invio notifica con cucumber |
               | senderDenomination | Comune di milano |
          And destinatario Mario Gherkin
          When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
          Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_PROGRESS"

     @workflowDigitale
     Scenario: [B2B_TIMELINE_17] Invio notifica digitale ed attesa elemento di timeline PUBLIC_REGISTRY_RESPONSE_scenario positivo
          Given viene generata una nuova notifica
               | subject | invio notifica con cucumber |
               | senderDenomination | Comune di milano |
          And destinatario Mario Cucumber e:
               | digitalDomicile_address | test@fail.it |
          When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
          Then vengono letti gli eventi fino all'elemento di timeline della notifica "PUBLIC_REGISTRY_RESPONSE"

     @svil
     Scenario: [B2B_TIMELINE_19] Invio notifica digitale ed attesa elemento di timeline SEND_DIGITAL_FEEDBACK e controllo campi deliveryDetailCode e deliveryFailureCause positivo
          Given viene generata una nuova notifica
               | subject | invio notifica con cucumber |
               | senderDenomination | Comune di milano |
          And destinatario
               | taxId | DVNLRD52D15M059P |
               | digitalDomicile_address | test@gmail.it |
          When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
          Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_DIGITAL_FEEDBACK" con responseStatus "KO"
          And viene verificato che nell'elemento di timeline della notifica "SEND_DIGITAL_FEEDBACK" con responseStatus "KO" sia presente i campi deliveryDetailCode e deliveryFailureCause

     @workflowDigitale
     Scenario: [B2B_TIMELINE_26] Invio notifica digitale che va in DIGITAL_FAILURE con verifica uguaglianza tra scheduleDate di SCHEDULE_REFINEMENT e timestamp del REFINEMENT PN-9059
          Given viene generata una nuova notifica
               | subject            | invio notifica multi cucumber |
               | senderDenomination | Comune di milano              |
          And destinatario Mario Cucumber e:
               | digitalDomicile_address | test@fail.it |
          When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
          Then vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_FAILURE_WORKFLOW"
          Then vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
          And si verifica che scheduleDate del SCHEDULE_REFINEMENT sia uguale al timestamp di REFINEMENT per l'utente 0