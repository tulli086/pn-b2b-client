Feature: costo notifica con workflow analogico per multi destinatario 890

  Background:
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"

  @costoAnalogico
  Scenario Outline: [B2B_COSTO_ANALOG_890_MULTI_1] Invio notifica e verifica costo con FSU + @OK_890 + DELIVERY_MODE positivo
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy             | DELIVERY_MODE                   |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL           |
      | physicalAddress_address      | Via@ok_890     |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | SI           |
    And destinatario Cucumber Society
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_SUCCESS_WORKFLOW" per l'utente 1
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW" per l'utente 0
    And viene verificato il costo = "<COSTO>" della notifica per l'utente 0
    And viene verificato il costo = "100" della notifica per l'utente 1
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 05010 | 1105  | COLLELUNGO   | TR       |

  @costoAnalogico
  Scenario Outline: [B2B_COSTO_ANALOG_890_MULTI_2] Invio notifica e verifica costo con FSU + @OK_890 + FLAT_RATE positivo
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy             | FLAT_RATE                       |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL           |
      | physicalAddress_address      | Via@ok_890     |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | SI           |
    And destinatario Cucumber Society
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_SUCCESS_WORKFLOW" per l'utente 1
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW" per l'utente 0
    And viene verificato il costo = "<COSTO>" della notifica per l'utente 0
    And viene verificato il costo = "0" della notifica per l'utente 1
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 05010 | 0     | COLLELUNGO   | TR       |


  @costoAnalogico
  Scenario Outline: [B2B_COSTO_ANALOG_890_MULTI_3] Invio notifica e verifica costo con RECAPITISTA + @OK_890 + DELIVERY_MODE positivo
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy             | DELIVERY_MODE                   |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL           |
      | physicalAddress_address      | Via@ok_890     |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | SI           |
    And destinatario Cucumber Society
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_SUCCESS_WORKFLOW" per l'utente 1
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW" per l'utente 0
    And viene verificato il costo = "<COSTO>" della notifica per l'utente 0
    And viene verificato il costo = "100" della notifica per l'utente 1
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 70010 | 861   | VALENZANO    | BA       |
      | 00010 | 906   | CASAPE       | RM       |
      | 60010 | 979   | CASINE       | AN       |
      | 64010 | 954   | ANCARANO     | TE       |
      | 06031 | 957   | BEVAGNA      | PG       |
      | 10012 | 925   | BOLLENGO     | TO       |

  @costoAnalogico
  Scenario Outline: [B2B_COSTO_ANALOG_890_MULTI_4] Invio notifica e verifica costo con RECAPITISTA + @OK_890 + FLAT_RATE positivo
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy             | FLAT_RATE                       |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL           |
      | physicalAddress_address      | Via@ok_890     |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | SI           |
    And destinatario Cucumber Society
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "DIGITAL_SUCCESS_WORKFLOW" per l'utente 1
    And vengono letti gli eventi fino all'elemento di timeline della notifica "ANALOG_SUCCESS_WORKFLOW" per l'utente 0
    And viene verificato il costo = "<COSTO>" della notifica per l'utente 0
    And viene verificato il costo = "0" della notifica per l'utente 1
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 70010 | 0     | VALENZANO    | BA       |
      | 00010 | 0     | CASAPE       | RM       |
      | 60010 | 0     | CASINE       | AN       |
      | 64010 | 0     | ANCARANO     | TE       |
      | 06031 | 0     | BEVAGNA      | PG       |
      | 10012 | 0     | BOLLENGO     | TO       |