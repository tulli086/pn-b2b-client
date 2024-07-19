Feature: calcolo costo notifica in base hai grammi con notifiche RS

 # Background:
  #  Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_1] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    And viene generata una nuova notifica
      | subject            | notifica analogica FSU         |
      | senderDenomination | Comune di palermo              |
      | feePolicy          | DELIVERY_MODE                  |
      | document           | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | OSTRA          |
      | physicalAddress_province     | AN             |
      | physicalAddress_zip          | 60010          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "402" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_2] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    And viene generata una nuova notifica
      | subject            | notifica analogica RECAPITISTA |
      | senderDenomination | Comune di palermo              |
      | feePolicy          | DELIVERY_MODE                  |
      | document           | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | LE FERRIERE    |
      | physicalAddress_province     | LT             |
      | physicalAddress_zip          | 04100          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "340" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_3] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica RECAPITISTA |
      | senderDenomination | Comune di palermo              |
      | feePolicy          | DELIVERY_MODE                  |
      | document           | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | ROMA           |
      | physicalAddress_province     | RM             |
      | physicalAddress_zip          | 00123          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "313" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_4] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    And viene generata una nuova notifica
      | subject            | notifica analogica RECAPITISTA |
      | senderDenomination | Comune di palermo              |
      | feePolicy          | DELIVERY_MODE                  |
      | document           | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | CRETONE        |
      | physicalAddress_province     | RM             |
      | physicalAddress_zip          | 00018          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "402" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_5] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica RECAPITISTA |
      | senderDenomination | Comune di palermo              |
      | feePolicy          | DELIVERY_MODE                  |
      | document           | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | BARI           |
      | physicalAddress_province     | BA             |
      | physicalAddress_zip          | 70124          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "274" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_6] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    And viene generata una nuova notifica
      | subject            | notifica analogica RECAPITISTA |
      | senderDenomination | Comune di palermo              |
      | feePolicy          | DELIVERY_MODE                  |
      | document           | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | MONTERADO      |
      | physicalAddress_province     | AN             |
      | physicalAddress_zip          | 60012          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "344" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_7] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    And viene generata una nuova notifica
      | subject            | notifica analogica RECAPITISTA |
      | senderDenomination | Comune di palermo              |
      | feePolicy          | DELIVERY_MODE                  |
      | document           | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | ANCONA         |
      | physicalAddress_province     | AN             |
      | physicalAddress_zip          | 60126          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "294" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_8] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    And viene generata una nuova notifica
      | subject            | notifica analogica RECAPITISTA |
      | senderDenomination | Comune di palermo              |
      | feePolicy          | DELIVERY_MODE                  |
      | document           | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | ARZANO         |
      | physicalAddress_province     | NA             |
      | physicalAddress_zip          | 80022          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "344" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_9] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    And viene generata una nuova notifica
      | subject            | notifica analogica RECAPITISTA |
      | senderDenomination | Comune di palermo              |
      | feePolicy          | DELIVERY_MODE                  |
      | document           | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | SALERNO        |
      | physicalAddress_province     | SA             |
      | physicalAddress_zip          | 84124          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "294" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_10] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    And viene generata una nuova notifica
      | subject            | notifica analogica RECAPITISTA |
      | senderDenomination | Comune di palermo              |
      | feePolicy          | DELIVERY_MODE                  |
      | document           | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | NAPOLI         |
      | physicalAddress_province     | NA             |
      | physicalAddress_zip          | 80129          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "274" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_11] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
      | feePolicy          | DELIVERY_MODE                   |
      | document           | DOC_4_PG;                       |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "737" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_12] Invio notifica ZONE_2 e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
      | feePolicy          | DELIVERY_MODE                   |
      | document           | DOC_4_PG;                       |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | MESSICO      |
      | physicalAddress_zip     | ZONE_2       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "852" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_13] Invio notifica ZONE_3 e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
      | feePolicy          | DELIVERY_MODE                   |
      | document           | DOC_4_PG;                       |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | AUSTRALIA    |
      | physicalAddress_zip     | ZONE_3       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "909" della notifica




