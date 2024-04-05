Feature: Radd Alternative Atto Intero

  #TODO aggiungere integrazione per prendere i dati dal DynamoDb di aws per il controllo del campo del filtro

  #TODO aspettare cap da inserire per controllo filtro e controllare che non siano congruenti con quelli degli altri test sui costi

  Scenario: [RADD_FILTRO_ATTO-INTERO_1] invio notifica 890 coperto da RADD e controllo diminuzione costi filtro base
    Given viene generata una nuova notifica
      | subject               | notifica analogica filtro base |
      | senderDenomination    | Comune di palermo              |
      | physicalCommunication | REGISTERED_LETTER_890          |
      | feePolicy             | DELIVERY_MODE                  |
      | document              | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL                 |
      | physicalAddress_address      | Via@ok_890           |
      | physicalAddress_municipality | <MUNICIPALITY>       |
      | physicalAddress_province     | <PROVINCE>           |
      | physicalAddress_zip          | <CAP>                |
      | payment_f24                  | PAYMENT_F24_STANDARD |
      | title_payment                | F24_STANDARD_GHERKIN |
      | apply_cost_f24               | SI                   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo di 120 e il peso di 15 nei details del'elemento di timeline letto


  Scenario: [RADD_FILTRO_ATTO-INTERO_2] invio notifica AR coperto da RADD e controllo diminuzione costi filtro base
    Given viene generata una nuova notifica
      | subject               | notifica analogica filtro base |
      | senderDenomination    | Comune di palermo              |
      | physicalCommunication | AR_REGISTERED_LETTER           |
      | feePolicy             | DELIVERY_MODE                  |
      | document              | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL                 |
      | physicalAddress_address      | Via@ok_AR            |
      | physicalAddress_municipality | <MUNICIPALITY>       |
      | physicalAddress_province     | <PROVINCE>           |
      | physicalAddress_zip          | <CAP>                |
      | payment_f24                  | PAYMENT_F24_STANDARD |
      | title_payment                | F24_STANDARD_GHERKIN |
      | apply_cost_f24               | SI                   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo di 120 e il peso di 15 nei details del'elemento di timeline letto


  Scenario: [RADD_FILTRO_ATTO-INTERO_3] invio notifica RS coperto da RADD e controllo diminuzione costi filtro base
    Given viene generata una nuova notifica
      | subject            | notifica analogica filtro base |
      | senderDenomination | Comune di palermo              |
      | feePolicy          | DELIVERY_MODE                  |
      | document           | DOC_4_PG;                      |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it         |
      | physicalAddress_address      | Via@ok_RS            |
      | physicalAddress_municipality | <MUNICIPALITY>       |
      | physicalAddress_province     | <PROVINCE>           |
      | physicalAddress_zip          | <CAP>                |
      | payment_f24                  | PAYMENT_F24_STANDARD |
      | title_payment                | F24_STANDARD_GHERKIN |
      | apply_cost_f24               | SI                   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo di 120 e il peso di 15 nei details del'elemento di timeline letto


  Scenario Outline: [RADD_FILTRO_ATTO-INTERO_4] invio notifica 890 coperto da RADD e controllo diminuzione costi filtro con discardAttachment
    Given viene generata una nuova notifica
      | subject               | <SUBJECT>             |
      | senderDenomination    | Comune di palermo     |
      | physicalCommunication | REGISTERED_LETTER_890 |
      | feePolicy             | DELIVERY_MODE         |
      | document              | DOC_4_PG;             |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL                 |
      | physicalAddress_address      | Via@ok_890           |
      | physicalAddress_municipality | <MUNICIPALITY>       |
      | physicalAddress_province     | <PROVINCE>           |
      | physicalAddress_zip          | <CAP>                |
      | payment_f24                  | PAYMENT_F24_STANDARD |
      | title_payment                | F24_STANDARD_GHERKIN |
      | apply_cost_f24               | SI                   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo di <COSTO> e il peso di 15 nei details del'elemento di timeline letto
    Examples:
      | CAP   | COSTO | MUNICIPALITY   | PROVINCE | SUBJECT                                                     |
      | 05010 | 1103  | COLLELUNGO     | TR       | notifica filtro scarto ATTACHMENT_PAGOPA e LEGAL_FACT       |
      | 06031 | 957   | CANTALUPO      | PG       | notifica filtro scarto ATTACHMENT_F24 e LEGAL_FACT_EXTERNAL |
      | 64011 | 953   | ALBA ADRIATICA | TE       | notifica filtro scarto DOCUMENT e AAR                       |


  Scenario: [RADD_FILTRO_ATTO-INTERO_5] invio notifica RS coperto da RADD e controllo diminuzione costi filtro discardAttachment
    Given viene generata una nuova notifica
      | subject            | notifica analogica filtro AAR e DOCUMENT |
      | senderDenomination | Comune di palermo                        |
      | feePolicy          | DELIVERY_MODE                            |
      | document           | DOC_4_PG;                                |
    And destinatario Mario Gherkin e:
      | digitalDomicile_address      | test@fail.it         |
      | physicalAddress_address      | Via@ok_RS            |
      | physicalAddress_municipality | <MUNICIPALITY>       |
      | physicalAddress_province     | <PROVINCE>           |
      | physicalAddress_zip          | <CAP>                |
      | payment_f24                  | PAYMENT_F24_STANDARD |
      | title_payment                | F24_STANDARD_GHERKIN |
      | apply_cost_f24               | SI                   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_SIMPLE_REGISTERED_LETTER"
    And viene verificato il costo di 120 e il peso di 15 nei details del'elemento di timeline letto


  Scenario Outline: [RADD_FILTRO_ATTO-INTERO_6] invio notifica AR coperto da RADD e controllo diminuzione costi in base al filtro acceptAttachment
    Given viene generata una nuova notifica
      | subject               | <SUBJECT>             |
      | senderDenomination    | Comune di palermo     |
      | physicalCommunication | REGISTERED_LETTER_890 |
      | feePolicy             | DELIVERY_MODE         |
      | document              | DOC_4_PG;             |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL                 |
      | physicalAddress_address      | Via@ok_AR            |
      | physicalAddress_municipality | <MUNICIPALITY>       |
      | physicalAddress_province     | <PROVINCE>           |
      | physicalAddress_zip          | <CAP>                |
      | payment_f24                  | PAYMENT_F24_STANDARD |
      | title_payment                | F24_STANDARD_GHERKIN |
      | apply_cost_f24               | SI                   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo di <COSTO> e il peso di 15 nei details del'elemento di timeline letto
    Examples:
      | CAP   | COSTO | MUNICIPALITY   | PROVINCE | SUBJECT                                                          |
      | 05010 | 1103  | COLLELUNGO     | TR       | notifica filtro accetazione ATTACHMENT_PAGOPA e LEGAL_FACT       |
      | 06031 | 957   | CANTALUPO      | PG       | notifica filtro accetazione ATTACHMENT_F24 e LEGAL_FACT_EXTERNAL |
      | 64011 | 953   | ALBA ADRIATICA | TE       | notifica filtro accetazione DOCUMENT e AAR                       |


  Scenario: [RADD_FILTRO_ATTO-INTERO_7] invio notifica AR coperto da RADD e controllo diminuzione costi in base al filtro acceptAttachment e discardAttachment settato
    Given viene generata una nuova notifica
      | subject               | notifica analogica con filtro accetazione e scarto |
      | senderDenomination    | Comune di palermo                                  |
      | physicalCommunication | REGISTERED_LETTER_890                              |
      | feePolicy             | DELIVERY_MODE                                      |
      | document              | DOC_4_PG;                                          |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL                 |
      | physicalAddress_address      | Via@ok_AR            |
      | physicalAddress_municipality | <MUNICIPALITY>       |
      | physicalAddress_province     | <PROVINCE>           |
      | physicalAddress_zip          | <CAP>                |
      | payment_f24                  | PAYMENT_F24_STANDARD |
      | title_payment                | F24_STANDARD_GHERKIN |
      | apply_cost_f24               | SI                   |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo di 120 e il peso di 15 nei details del'elemento di timeline letto
