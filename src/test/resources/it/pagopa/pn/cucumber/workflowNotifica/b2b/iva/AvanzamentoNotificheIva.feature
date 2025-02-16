Feature: controllo costo notifiche con IVA

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_1] Invio notifica 890 SYNC con iva inclusa controllo costo
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | DELIVERY_MODE               |
      | physicalCommunication | REGISTERED_LETTER_890       |
      | vat                   | 10                          |
      | paFee                 | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL       |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo "parziale" di una notifica "890" del utente "0"
    And viene verificato il costo "totale" di una notifica "890" del utente "0"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_2] Invio notifica AR SYNC con iva inclusa controllo costo
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | DELIVERY_MODE               |
      | physicalCommunication | AR_REGISTERED_LETTER        |
      | vat                   | 10                          |
      | paFee                 | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL      |
      | physicalAddress_address | Via@ok_AR |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo "parziale" di una notifica "AR" del utente "0"
    And viene verificato il costo "totale" di una notifica "AR" del utente "0"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_3] Invio notifica RIR SYNC con iva inclusa controllo costo
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | DELIVERY_MODE               |
      | physicalCommunication | AR_REGISTERED_LETTER        |
      | vat                   | 10                          |
      | paFee                 | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_State        | FRANCIA    |
      | physicalAddress_municipality | Parigi     |
      | physicalAddress_zip          | ZONE_1     |
      | physicalAddress_province     | Paris      |
      | physicalAddress_address      | Via@ok_RIR |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo "parziale" di una notifica "RIR" del utente "0"
    And viene verificato il costo "totale" di una notifica "RIR" del utente "0"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_4] Invio notifica RS SYNC con iva inclusa controllo costo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | vat                | 10                          |
      | paFee              | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo "totale" di una notifica "RS" del utente "0"


  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_5] Invio notifica RIS SYNC con iva inclusa controllo costo
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | vat                | 10                          |
      | paFee              | 100                         |
    And destinatario Mario Gherkin e:
      | physicalAddress_State        | FRANCIA      |
      | physicalAddress_municipality | Parigi       |
      | physicalAddress_zip          | ZONE_1       |
      | physicalAddress_province     | Paris        |
      | digitalDomicile_address      | test@fail.it |
      | physicalAddress_address      | Via@ok_RIS   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo "totale" di una notifica "RIS" del utente "0"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_6] Invio notifica 890 ASYNC con iva inclusa controllo costo
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | DELIVERY_MODE               |
      | physicalCommunication | REGISTERED_LETTER_890       |
      | pagoPaIntMode         | ASYNC                       |
      | vat                   | 10                          |
      | paFee                 | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL        |
      | physicalAddress_address | via@ok_890  |
      | payment_creditorTaxId   | 77777777777 |
      | payment_pagoPaForm      | SI          |
      | payment_f24             | NULL        |
      | apply_cost_pagopa       | SI          |
      | payment_multy_number    | 1           |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    Then  lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And viene effettuato il controllo del amount di GPD con il costo "totale" della notifica con iva inclusa
    Then viene cancellata la posizione debitoria di "Mario Gherkin"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_7] Invio notifica RS ASYNC con iva inclusa controllo costo
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | vat                | 10                          |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address | test@fail.it |
      | payment_creditorTaxId   | 77777777777  |
      | payment_pagoPaForm      | SI           |
      | payment_f24             | NULL         |
      | apply_cost_pagopa       | SI           |
      | payment_multy_number    | 1            |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS"
    Then  lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And viene effettuato il controllo del amount di GPD con il costo "totale" della notifica con iva inclusa
    Then viene cancellata la posizione debitoria di "Mario Gherkin"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_8] Invio notifica 890 SYNC con 1 F24 iva inclusa controllo costo
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | DELIVERY_MODE               |
      | physicalCommunication | REGISTERED_LETTER_890       |
      | vat                   | 10                          |
      | paFee                 | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL                          |
      | physicalAddress_address | Via@ok_890                    |
      | payment_f24             | PAYMENT_F24_STANDARD_0        |
      | title_payment           | F24_STANDARD_CLMCST42R12D969Z |
      | apply_cost_f24          | SI                            |
      | payment_multy_number    | 1                             |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo "totale" di una notifica "890" del utente "0"


  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_9] Invio notifica 890 SYNC FLAT_RATE con campo vat conmpilato controllo costo a 0
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | FLAT_RATE                   |
      | physicalCommunication | REGISTERED_LETTER_890       |
      | vat                   | 10                          |
      | paFee                 | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL       |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo "totale" di una notifica "890" del utente "0"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_10] Invio notifica 890 ASYNC FLAT_RATE con campo vat conmpilato controllo costo a 0
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | FLAT_RATE                   |
      | pagoPaIntMode      | ASYNC                       |
      | vat                | 10                          |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL        |
      | physicalAddress_address | via@ok_890  |
      | payment_creditorTaxId   | 77777777777 |
      | payment_pagoPaForm      | SI          |
      | payment_f24             | NULL        |
      | payment_multy_number    | 1           |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS"
    Then  lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And viene effettuato il controllo del amount di GPD con il costo "totale" della notifica con iva inclusa
    Then viene cancellata la posizione debitoria di "Mario Gherkin"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_11] Invio notifica 890 SYNC FLAT_RATE con 1 F24 con campo vat conmpilato controllo costo a 0
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | FLAT_RATE                   |
      | physicalCommunication | REGISTERED_LETTER_890       |
      | vat                   | 10                          |
      | paFee                 | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL             |
      | physicalAddress_address | Via@ok_890       |
      | payment_f24             | PAYMENT_F24_FLAT |
      | apply_cost_pagopa       | NO               |
      | payment_multy_number    | 1                |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_12] Invio notifica 890 SYNC FLAT_RATE con campo vat non compilato controllo resituzione default
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | FLAT_RATE                   |
      | physicalCommunication | REGISTERED_LETTER_890       |
      | vat                   | NULL                        |
      | paFee                 | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL       |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And viene verificato che il campo "vat" sia valorizzato a 22
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo "totale" di una notifica "890" del utente "0"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_13] Invio notifica 890 SYNC FLAT_RATE con campo paFee non compilato controllo resituzione default
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | FLAT_RATE                   |
      | physicalCommunication | REGISTERED_LETTER_890       |
      | vat                   | 20                          |
      | paFee                 | NULL                        |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL       |
      | physicalAddress_address | Via@ok_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And viene verificato che il campo "paFee" sia valorizzato a 100
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo "totale" di una notifica "890" del utente "0"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_14] Invio notifica 890 SYNC con due tentativi con iva inclusa controllo costo
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | DELIVERY_MODE               |
      | physicalCommunication | REGISTERED_LETTER_890       |
      | vat                   | 10                          |
      | paFee                 | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL                   |
      | physicalAddress_address | Via@FAIL-Discovery_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" al tentativo "ATTEMPT_0"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" al tentativo "ATTEMPT_1"
    Then viene verificato il costo "parziale" di una notifica "890" del utente "0"
    And viene verificato il costo "totale" di una notifica "890" del utente "0"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_15] Invio notifica 890 ASYNC con due tentativi con iva inclusa controllo costo
    Given viene creata una nuova richiesta per istanziare una nuova posizione debitoria per l'ente creditore "77777777777" e amount "100" per "Mario Gherkin" con CF "CLMCST42R12D969Z"
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di milano            |
      | feePolicy          | DELIVERY_MODE               |
      | pagoPaIntMode      | ASYNC                       |
      | vat                | 10                          |
      | paFee              | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL                   |
      | physicalAddress_address | Via@FAIL-Discovery_890 |
      | payment_creditorTaxId   | 77777777777            |
      | payment_pagoPaForm      | SI                     |
      | payment_f24             | NULL                   |
      | apply_cost_pagopa       | SI                     |
      | payment_multy_number    | 1                      |
    And al destinatario viene associato lo iuv creato mediante partita debitoria per "Mario Gherkin" alla posizione 0
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED per controllo GPD
    When vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" al tentativo "ATTEMPT_0"
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" al tentativo "ATTEMPT_1"
    Then  lettura amount posizione debitoria per la notifica corrente di "Mario Gherkin"
    And viene effettuato il controllo del amount di GPD con il costo "totale" della notifica con iva inclusa
    Then viene cancellata la posizione debitoria di "Mario Gherkin"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_16] Invio notifica 890 SYNC con 1 F24 con due tentativi con iva inclusa controllo costo
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | DELIVERY_MODE               |
      | physicalCommunication | REGISTERED_LETTER_890       |
      | vat                   | 10                          |
      | paFee                 | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL                          |
      | physicalAddress_address | Via@FAIL-Discovery_890        |
      | payment_f24             | PAYMENT_F24_STANDARD_0        |
      | title_payment           | F24_STANDARD_CLMCST42R12D969Z |
      | apply_cost_f24          | SI                            |
      | payment_multy_number    | 1                             |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" al tentativo "ATTEMPT_0"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_PROGRESS" al tentativo "ATTEMPT_1"
    Then viene verificato il costo "parziale" di una notifica "890" del utente "0"
    And viene verificato il costo "totale" di una notifica "890" del utente "0"

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_17] Invio notifica 890 SYNC e lettura dopo REFINEMENT controllo presenza di ogni campo valorizzato della response
    Given viene generata una nuova notifica
      | subject               | invio notifica con cucumber |
      | senderDenomination    | Comune di milano            |
      | feePolicy             | DELIVERY_MODE               |
      | physicalCommunication | REGISTERED_LETTER_890       |
      | vat                   | 10                          |
      | paFee                 | 10                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL                   |
      | physicalAddress_address | Via@FAIL-Discovery_890 |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK"
    And vengono letti gli eventi fino all'elemento di timeline della notifica "REFINEMENT"
    Then "Mario Gherkin" legge la notifica ricevuta
    Then viene verificato il costo "parziale" di una notifica "890" del utente "0"
    And viene verificato che tutti i campi per il calcolo del iva per il destinatario 0 siano valorizzati

  @calcoloIva
  Scenario Outline: [CALCOLO-IVA_CONTROLLO-COSTO_18] Invio notifica 890 SYNC e controllo arrotondamento
    Given viene generata una nuova notifica
      | subject               | notifica analogica con cucumber |
      | senderDenomination    | Comune di palermo               |
      | physicalCommunication | REGISTERED_LETTER_890           |
      | feePolicy             | DELIVERY_MODE                   |
      | vat                   | 10                              |
      | paFee                 | 100                             |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL           |
      | physicalAddress_address      | Via@ok_890     |
      | physicalAddress_municipality | <MUNICIPALITY> |
      | physicalAddress_province     | <PROVINCE>     |
      | physicalAddress_zip          | <CAP>          |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    And vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    Then viene verificato il costo "parziale" di una notifica "890" del utente "0"
    And viene verificato il costo "totale" di una notifica "890" del utente "0"
    Examples:
      | CAP   | MUNICIPALITY | PROVINCE |
      | 00010 | CASAPE       | RM       |
      | 10010 | ANDRATE      | TO       |

  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_19] Invio notifica 890 SYNC con due pagamenti pagoPa controllo costi con iva
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo           |
      | feePolicy          | DELIVERY_MODE               |
      | vat                | 10                          |
      | paFee              | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL       |
      | physicalAddress_address | Via@ok_890 |
      | payment_pagoPaForm      | SI         |
      | apply_cost_pagopa       | SI         |
      | payment_multy_number    | 2          |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    Then viene verificato il costo "parziale" di una notifica "890" del utente "0"
    And viene verificato il costo "totale" di una notifica "890" del utente "0"


  @calcoloIva
  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_20] Invio notifica 890 SYNC multidestinatario e controllo costi con iva destinatari
    Given viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | Comune di Palermo           |
      | feePolicy          | DELIVERY_MODE               |
      | vat                | 10                          |
      | paFee              | 100                         |
    And destinatario Mario Gherkin e:
      | digitalDomicile         | NULL       |
      | physicalAddress_address | Via@ok_890 |
      | payment_pagoPaForm      | SI         |
      | apply_cost_pagopa       | SI         |
    And destinatario Mario Cucumber e:
      | digitalDomicile         | NULL                   |
      | physicalAddress_address | Via@FAIL-Discovery_890 |
      | payment_pagoPaForm      | SI                     |
      | apply_cost_pagopa       | SI                     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE" per l'utente 0
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_FEEDBACK" per l'utente 1
    Then viene verificato il costo "parziale" di una notifica "890" del utente "0"
    And viene verificato il costo "totale" di una notifica "890" del utente "0"
    Then viene verificato il costo "parziale" di una notifica "890" del utente "1"
    And viene verificato il costo "totale" di una notifica "890" del utente "1"


  Scenario: [CALCOLO-IVA_CONTROLLO-COSTO_21] ricerca notifica vecchia prima del introduzione del Iva con pagamento controllo valori di default - PN-10874
    Given recupero notifica del "2023-12-21" lato web dalla PA "Comune_Multi" e verifica presenza pagamento per notifica che è arrivato fino al elemento "ANALOG_SUCCESS_WORKFLOW" con feePolicy "DELIVERY_MODE"
    And viene verificato che per il calcolo del iva il campo vat sia di 22 e il campo paFee sia di 100 per il destinatario 0
    And viene verificato il costo "totale" di una notifica "890" del utente "0"



