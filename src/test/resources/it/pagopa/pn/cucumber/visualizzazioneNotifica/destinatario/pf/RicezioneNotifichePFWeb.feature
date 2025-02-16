Feature: Ricezione notifiche api web con invio tramite api B2B

  @SmokeTest @letturaDestinatario @authFleet
  Scenario: [WEB-PF-RECIPIENT_1] Invio notifica digitale mono destinatario e recupero tramite codice IUN API WEB_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Gherkin
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then la notifica può essere correttamente recuperata da "Mario Gherkin"

  @SmokeTest @letturaDestinatario
  Scenario: [WEB-PF-RECIPIENT_2] Invio notifica digitale mono destinatario e recupero documento notificato_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Gherkin
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then il documento notificato può essere correttamente recuperato da "Mario Gherkin"

  @SmokeTest @letturaDestinatario
  Scenario: [WEB-PF-RECIPIENT_3] Invio notifica digitale mono destinatario e recupero allegato pagopa_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Gherkin e:
      | payment_pagoPaForm | SI               |
      | payment_f24        | PAYMENT_F24_FLAT |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then l'allegato "PAGOPA" può essere correttamente recuperato da "Mario Gherkin"

  @ignore
  Scenario: [WEB-PF-RECIPIENT_4] Invio notifica digitale mono destinatario e recupero allegato F24_FLAT_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
      | feePolicy          | FLAT_RATE                   |
    And destinatario Mario Gherkin e:
      | payment_pagoPaForm | SI               |
      | payment_f24        | PAYMENT_F24_FLAT |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then l'allegato "F24" può essere correttamente recuperato da "Mario Gherkin"

  @ignore
  Scenario: [WEB-PF-RECIPIENT_5] Invio notifica digitale mono destinatario e recupero allegato F24_STANDARD_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
    And destinatario Mario Gherkin e:
      | payment_pagoPaForm | SI                   |
      | payment_f24        | PAYMENT_F24_STANDARD |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then l'allegato "F24" può essere correttamente recuperato da "Mario Gherkin"

  @ignore
  Scenario: [WEB-PF-RECIPIENT_6] Invio notifica digitale mono destinatario e recupero allegato F24_STANDARD_scenario negativo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
    And destinatario Mario Gherkin e:
      | payment_pagoPaForm | SI   |
      | payment_f24        | NULL |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And "Mario Gherkin" tenta il recupero dell'allegato "F24"
    Then il download ha prodotto un errore con status code "404"


  Scenario: [WEB-PF-RECIPIENT_7] Invio notifica digitale altro destinatario e recupero tramite codice IUN API WEB_scenario negativo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Cucumber
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And "Mario Gherkin" tenta il recupero della notifica
    Then il recupero ha prodotto un errore con status code "404"

  @ignore
  Scenario: [WEB-PF-RECIPIENT_8] Invio notifica digitale altro destinatario e recupero allegato F24_STANDARD_scenario negativo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
    And destinatario Mario Cucumber e:
      | payment_pagoPaForm | SI               |
      | payment_f24        | PAYMENT_F24_FLAT |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And "Mario Gherkin" tenta il recupero dell'allegato "F24"
    Then il download ha prodotto un errore con status code "404"

  @ignore
  Scenario: [WEB-PF-RECIPIENT_9] Invio notifica digitale altro destinatario e recupero allegato F24_FLAT_scenario negativo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
      | feePolicy          | FLAT_RATE                   |
    And destinatario Mario Cucumber e:
      | payment_pagoPaForm | SI               |
      | payment_f24        | PAYMENT_F24_FLAT |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And "Mario Gherkin" tenta il recupero dell'allegato "F24"
    Then il download ha prodotto un errore con status code "404"

  @ignore
  Scenario: [WEB-PF-RECIPIENT_10] Invio notifica digitale altro destinatario e recupero allegato pagopa_scenario negativo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Cucumber e:
      | payment_pagoPaForm | SI               |
      | payment_f24        | PAYMENT_F24_FLAT |
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And "Mario Gherkin" tenta il recupero dell'allegato "PAGOPA"
    Then il download ha prodotto un errore con status code "404"

  Scenario: [WEB-PF-RECIPIENT_11] Invio notifica digitale mono destinatario e recupero tramite ricerca API WEB_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Gherkin
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then la notifica può essere correttamente recuperata con una ricerca da "Mario Gherkin"
      |  |  |

  Scenario: [WEB-PF-RECIPIENT_12] Invio notifica digitale mono destinatario e recupero tramite ricerca API WEB_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Gherkin
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then la notifica può essere correttamente recuperata con una ricerca da "Mario Gherkin"
      | subjectRegExp | cucumber |

  Scenario: [WEB-PF-RECIPIENT_13] Invio notifica digitale mono destinatario e recupero tramite ricerca API WEB_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Gherkin
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then la notifica può essere correttamente recuperata con una ricerca da "Mario Gherkin"
      | startDate     | 01/01/2022 |
      | subjectRegExp | cucumber   |

  @SmokeTest @letturaDestinatario
  Scenario: [WEB-PF-RECIPIENT_14] Invio notifica digitale mono destinatario e recupero tramite ricerca API WEB_scenario positivo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Gherkin
    When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then la notifica può essere correttamente recuperata con una ricerca da "Mario Gherkin"
      | startDate     | 01/01/2022 |
      | endDate       | 01/10/2030 |
      | iunMatch      | ACTUAL     |
      | subjectRegExp | cucumber   |
