Feature: avanzamento b2b notifica difgitale con indirizzo piattaforma

  @workflowDigitale @mockPec
  Scenario: [B2B_TIMELINE_20] Invio notifica digitale ed attesa elemento di timeline SEND_DIGITAL_FEEDBACK e controllo campi deliveryDetailCode e deliveryFailureCause positivo
    Given viene generata una nuova notifica
      | subject | invio notifica con cucumber |
      | senderDenomination | Comune di milano |
    And destinatario
      | taxId | GLLGLL64B15G702I |
      | digitalDomicile_address | DSRDNI00A01A225I@pec.pagopa.it |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_SUCCESS_WORKFLOW"
    And viene verificato che nell'elemento di timeline della notifica "SEND_DIGITAL_DOMICILE" e' presente il campo Digital Address di piattaforma
    #Serve un CF con indirizzo digitale in piattaforma