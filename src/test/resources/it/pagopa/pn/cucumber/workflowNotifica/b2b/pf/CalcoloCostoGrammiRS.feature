Feature: calcolo costo notifica in base hai grammi

  Background:
    Given viene rimossa se presente la pec di piattaforma di "Mario Gherkin"

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-20GR_1] Invio notifica e verifica calcolo del costo su raccomandata con peso <= 20gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
      | feePolicy          | DELIVERY_MODE                   |
      | document           | DOC_4_PG;                       |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 60010 | 410   | OSTRA        | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-21GR_2] Invio notifica e verifica calcolo del costo su raccomandata con peso = 21gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
      | feePolicy          | DELIVERY_MODE                   |
      | document           | DOC_5_PG;                       |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 60010 | 484   | OSTRA        | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-50GR_3] Invio notifica e verifica calcolo del costo su raccomandata con peso = 50gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
      | feePolicy          | DELIVERY_MODE                   |
      | document           | DOC_8_PG;DOC_8_PG;              |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 60010 | 502 | OSTRA | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-51GR_4] Invio notifica e verifica calcolo del costo su raccomandata con peso = 51gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
      | feePolicy          | DELIVERY_MODE                   |
      | document           | DOC_8_PG;DOC_8_PG;DOC_1_PG;     |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 60010 | 543 | OSTRA | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-100GR_5] Invio notifica e verifica calcolo del costo su raccomandata con peso = 100gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber               |
      | senderDenomination | Comune di palermo                             |
      | feePolicy          | DELIVERY_MODE                                 |
      | document           | DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_4_PG; |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 60010 | 567 | OSTRA | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-101GR_6] Invio notifica e verifica calcolo del costo su raccomandata con peso = 101gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber              |
      | senderDenomination | Comune di palermo                            |
      | feePolicy          | DELIVERY_MODE                                |
      | document           | DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_5_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 60010 | 611 | OSTRA | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-250GR_7] Invio notifica e verifica calcolo del costo su raccomandata con peso = 250gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                 |
      | senderDenomination | Comune di palermo                                               |
      | feePolicy          | DELIVERY_MODE                                                   |
      | document           | DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_6_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 60010 | 698 | OSTRA | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-251GR_8] Invio notifica e verifica calcolo del costo su raccomandata con peso = 251gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                 |
      | senderDenomination | Comune di palermo                                               |
      | feePolicy          | DELIVERY_MODE                                                   |
      | document           | DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_7_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 60010 | 735 | OSTRA | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-350GR_9] Invio notifica e verifica calcolo del costo su raccomandata con peso = 350gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                  |
      | senderDenomination | Comune di palermo                                                |
      | feePolicy          | DELIVERY_MODE                                                    |
      | document           | DOC_50_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_4_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 60010 | 792 | OSTRA | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-351GR_10] Invio notifica e verifica calcolo del costo su raccomandata con peso = 351gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                  |
      | senderDenomination | Comune di palermo                                                |
      | feePolicy          | DELIVERY_MODE                                                    |
      | document           | DOC_50_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_5_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO | MUNICIPALITY | PROVINCE |
      | 60010 | 868 | OSTRA | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-1000GR_11] Invio notifica e verifica calcolo del costo su raccomandata con peso = 1000gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                                                  |
      | senderDenomination | Comune di palermo                                                                                |
      | feePolicy          | DELIVERY_MODE                                                                                    |
      | document           | DOC_100_PG;DOC_100_PG;DOC_100_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_6_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO  | MUNICIPALITY | PROVINCE |
      | 60010 | 1255 | OSTRA | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-1001GR_12] Invio notifica e verifica calcolo del costo su raccomandata con peso = 1001gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                                                  |
      | senderDenomination | Comune di palermo                                                                                |
      | feePolicy          | DELIVERY_MODE                                                                                    |
      | document           | DOC_100_PG;DOC_100_PG;DOC_100_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_7_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO  | MUNICIPALITY | PROVINCE |
      | 60010 | 1346 | OSTRA | AN       |

  @CostoCartaceoComplete
  Scenario Outline: [CALCOLO-COSTO_RS-2000GR_13] Invio notifica e verifica calcolo del costo su raccomandata con peso = 2000gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                                                  |
      | senderDenomination | Comune di palermo                                                                                |
      | feePolicy          | DELIVERY_MODE                                                                                    |
      | document           | DOC_300_PG;DOC_300_PG;DOC_100_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_6_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it   |
      | physicalAddress_address      | Via@ok_RS      |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
      | payment_pagoPaForm           | NOALLEGATO     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "<COSTO>" della notifica
    Examples:
      | CAP   | COSTO  | MUNICIPALITY | PROVINCE |
      | 60010 | 1943 | OSTRA | AN       |

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-20GR_14] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso <= 20gr
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
    And viene verificato il costo = "748" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-21GR_15] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 21gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
      | feePolicy          | DELIVERY_MODE                   |
      | document           | DOC_5_PG;                       |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it            |              |
      | physicalAddress_State   | ALBANIA                 |              |
      | physicalAddress_zip     | ZONE_1                  |              |
      | physicalAddress_address | digitalDomicile_address | test@fail.it |
      | payment_pagoPaForm      | NOALLEGATO              |              |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "964" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-50GR_16] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 50gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
      | feePolicy          | DELIVERY_MODE                   |
      | document           | DOC_8_PG;DOC_8_PG;              |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "982" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-51GR_17] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 51gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
      | feePolicy          | DELIVERY_MODE                   |
      | document           | DOC_8_PG;DOC_8_PG;DOC_1_PG      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "1078" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-100GR_18] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 100gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber               |
      | senderDenomination | Comune di palermo                             |
      | feePolicy          | DELIVERY_MODE                                 |
      | document           | DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_4_PG; |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "1102" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-101GR_19] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 101gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber              |
      | senderDenomination | Comune di palermo                            |
      | feePolicy          | DELIVERY_MODE                                |
      | document           | DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_5_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "1296" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-250GR_20] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 250gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                 |
      | senderDenomination | Comune di palermo                                               |
      | feePolicy          | DELIVERY_MODE                                                   |
      | document           | DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_6_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "1383" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-251GR_21] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 251gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                 |
      | senderDenomination | Comune di palermo                                               |
      | feePolicy          | DELIVERY_MODE                                                   |
      | document           | DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_7_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "1524" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-350GR_22] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 350gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                  |
      | senderDenomination | Comune di palermo                                                |
      | feePolicy          | DELIVERY_MODE                                                    |
      | document           | DOC_50_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_4_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "1581" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-351GR_23] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 351gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                  |
      | senderDenomination | Comune di palermo                                                |
      | feePolicy          | DELIVERY_MODE                                                    |
      | document           | DOC_50_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_5_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "2037" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-1000GR_24] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 1000gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                                                  |
      | senderDenomination | Comune di palermo                                                                                |
      | feePolicy          | DELIVERY_MODE                                                                                    |
      | document           | DOC_100_PG;DOC_100_PG;DOC_100_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_6_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "2424" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-1001GR_25] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 1001gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                                                  |
      | senderDenomination | Comune di palermo                                                                                |
      | feePolicy          | DELIVERY_MODE                                                                                    |
      | document           | DOC_100_PG;DOC_100_PG;DOC_100_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_7_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "3236" della notifica

  @CostoCartaceoComplete
  Scenario: [CALCOLO-COSTO_RS-2000GR_26] Invio notifica ZONE_1 e verifica calcolo del costo su raccomandata con peso = 2000gr
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber                                                                  |
      | senderDenomination | Comune di palermo                                                                                |
      | feePolicy          | DELIVERY_MODE                                                                                    |
      | document           | DOC_300_PG;DOC_300_PG;DOC_100_PG;DOC_50_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_8_PG;DOC_6_PG |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | physicalAddress_State   | ALBANIA      |
      | physicalAddress_zip     | ZONE_1       |
      | physicalAddress_address | Via@ok_RIS   |
      | payment_pagoPaForm      | NOALLEGATO   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo = "3833" della notifica


