Feature: calcolo costo notifica in base hai grammi

  Background:
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    

  Scenario: [CALCOLO-COSTO_20GR_1] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy             | DELIVERY_MODE                   |
      | document              | DOC_2_PG;                       |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica


  Scenario: [CALCOLO-COSTO_21GR_2] Invio notifica e verifica calcolo del costo su raccomandata con peso = 21gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy             | DELIVERY_MODE                   |
      | document              | DOC_5_PG;                       |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica


  Scenario: [CALCOLO-COSTO_50GR_3] Invio notifica e verifica calcolo del costo su raccomandata con peso = 50gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy             | DELIVERY_MODE                   |
      | document              | DOC_8_PG;DOC_8_PG;              |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica


  Scenario: [CALCOLO-COSTO_51GR_4] Invio notifica e verifica calcolo del costo su raccomandata con peso = 51gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy             | DELIVERY_MODE                   |
      | document              | DOC_8_PG;DOC_8_PG;DOC_1_PG      |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica


  Scenario: [CALCOLO-COSTO_100GR_5] Invio notifica e verifica calcolo del costo su raccomandata con peso = 100gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber               |
      | senderDenomination    | Comune di palermo                             |
      | physicalCommunication | REGISTERED_LETTER_890                         |
      | feePolicy             | DELIVERY_MODE                                 |
      | document              | DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_4_PG; |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica


  Scenario: [CALCOLO-COSTO_101GR_6] Invio notifica e verifica calcolo del costo su raccomandata con peso = 101gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber              |
      | senderDenomination    | Comune di palermo                            |
      | physicalCommunication | REGISTERED_LETTER_890                        |
      | feePolicy             | DELIVERY_MODE                                |
      | document              | DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_7_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica


  Scenario: [CALCOLO-COSTO_250GR_7] Invio notifica e verifica calcolo del costo su raccomandata con peso = 250gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber                                 |
      | senderDenomination    | Comune di palermo                                               |
      | physicalCommunication | REGISTERED_LETTER_890                                           |
      | feePolicy             | DELIVERY_MODE                                                   |
      | document              | DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_6_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica

  Scenario: [CALCOLO-COSTO_251GR_8] Invio notifica e verifica calcolo del costo su raccomandata con peso = 251gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber                                 |
      | senderDenomination    | Comune di palermo                                               |
      | physicalCommunication | REGISTERED_LETTER_890                                           |
      | feePolicy             | DELIVERY_MODE                                                   |
      | document              | DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_7_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica

  Scenario: [CALCOLO-COSTO_350GR_9] Invio notifica e verifica calcolo del costo su raccomandata con peso = 350gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber                                  |
      | senderDenomination    | Comune di palermo                                                |
      | physicalCommunication | REGISTERED_LETTER_890                                            |
      | feePolicy             | DELIVERY_MODE                                                    |
      | document              | DOC_50_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_4_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica

  Scenario: [CALCOLO-COSTO_351GR_10] Invio notifica e verifica calcolo del costo su raccomandata con peso = 351gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber                                  |
      | senderDenomination    | Comune di palermo                                                |
      | physicalCommunication | REGISTERED_LETTER_890                                            |
      | feePolicy             | DELIVERY_MODE                                                    |
      | document              | DOC_50_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_5_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica

  Scenario: [CALCOLO-COSTO_1000GR_11] Invio notifica e verifica calcolo del costo su raccomandata con peso = 1000gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber                                                                  |
      | senderDenomination    | Comune di palermo                                                                                |
      | physicalCommunication | REGISTERED_LETTER_890                                                                            |
      | feePolicy             | DELIVERY_MODE                                                                                    |
      | document              | DOC_100_PG;DOC_100_PG;DOC_100_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_6_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica

  Scenario: [CALCOLO-COSTO_1001GR_12] Invio notifica e verifica calcolo del costo su raccomandata con peso = 1001gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber                                                                  |
      | senderDenomination    | Comune di palermo                                                                                |
      | physicalCommunication | REGISTERED_LETTER_890                                                                            |
      | feePolicy             | DELIVERY_MODE                                                                                    |
      | document              | DOC_100_PG;DOC_100_PG;DOC_100_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_7_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica

  Scenario: [CALCOLO-COSTO_2000GR_13] Invio notifica e verifica calcolo del costo su raccomandata con peso = 2000gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber                                                                  |
      | senderDenomination    | Comune di palermo                                                                                |
      | physicalCommunication | REGISTERED_LETTER_890                                                                            |
      | feePolicy             | DELIVERY_MODE                                                                                    |
      | document              | DOC_300_PG;DOC_300_PG;DOC_100_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_7_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica

  Scenario: [COSTO-GR_890_13] Invio notifica e verifica calcolo del costo su raccomandata con peso = 2001gr
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber                                                                  |
      | senderDenomination    | Comune di palermo                                                                                |
      | physicalCommunication | REGISTERED_LETTER_890                                                                            |
      | feePolicy             | DELIVERY_MODE                                                                                    |
      | document              | DOC_300_PG;DOC_300_PG;DOC_100_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_7_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | COLLELUNGO |
      | physicalAddress_province     | TR         |
      | physicalAddress_zip          | 05010      |
      | payment_pagoPaForm           | SI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW"
    And viene verificato il costo = "1105" della notifica