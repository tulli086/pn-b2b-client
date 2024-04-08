Feature: Radd Alternative Anagrafica Sportelli

  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_1] caricamento CSV con 2 sportelli
    Given viene caricato il csv con dati:
      | address_radd_row             | via posto   | minier |
      | address_radd_cap             | 000050      | casa   |
      | address_radd_province        | MI          | cose   |
      | address_radd_country         | ITALY       | ewrw   |
      | radd_description             | descrizione | ere    |
      | radd_phoneNumber             | minier      | erw    |
      | radd_geoLocation_latitudine  | non so      | rer    |
      | radd_geoLocation_longitudine | %&/(        | rer    |
      | radd_openingTime             | minier      | rer    |
      | radd_start_validity          | now         | now    |
      | radd_end_validity            | +10g        | +10g   |

  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_2] caricamento 2 volte stesso checksum del CSV
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | minier |
      | address_radd_cap             | 000050      | casa   |
      | address_radd_province        | MI          | cose   |
      | address_radd_country         | ITALY       | ewrw   |
      | radd_description             | descrizione | ere    |
      | radd_phoneNumber             | minier      | erw    |
      | radd_geoLocation_latitudine  | non so      | rer    |
      | radd_geoLocation_longitudine | %&/(        | rer    |
      | radd_openingTime             | minier      | rer    |
      | radd_start_validity          | now         | now    |
      | radd_end_validity            | +10g        | +10g   |
    Then viene caricato il csv con stesso checksum
    And l'operazione ha prodotto un errore con status code "409"

  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_3] caricamento 2 CSV con il primo CSV con un record in stato PENDING
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | minier |
      | address_radd_cap             | 000050      | casa   |
      | address_radd_province        | MI          | cose   |
      | address_radd_country         | ITALY       | ewrw   |
      | radd_description             | descrizione | ere    |
      | radd_phoneNumber             | minier      | erw    |
      | radd_geoLocation_latitudine  | non so      | rer    |
      | radd_geoLocation_longitudine | %&/(        | rer    |
      | radd_openingTime             | minier      | rer    |
      | radd_start_validity          | now         | now    |
      | radd_end_validity            | +10g        | +10g   |
    Then viene caricato il csv con restituzione errore con dati:
      | address_radd_row             | via posto   | minier |
      | address_radd_cap             | 000050      | casa   |
      | address_radd_province        | MI          | cose   |
      | address_radd_country         | ITALY       | ewrw   |
      | radd_description             | descrizione | ere    |
      | radd_phoneNumber             | minier      | erw    |
      | radd_geoLocation_latitudine  | non so      | rer    |
      | radd_geoLocation_longitudine | %&/(        | rer    |
      | radd_openingTime             | minier      | rer    |
      | radd_start_validity          | now         | now    |
      | radd_end_validity            | +10g        | +10g   |


  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_1] caricamento CSV verifica stato PENDING
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | minier |
      | address_radd_cap             | 000050      | casa   |
      | address_radd_province        | MI          | cose   |
      | address_radd_country         | ITALY       | ewrw   |
      | radd_description             | descrizione | ere    |
      | radd_phoneNumber             | minier      | erw    |
      | radd_geoLocation_latitudine  | non so      | rer    |
      | radd_geoLocation_longitudine | %&/(        | rer    |
      | radd_openingTime             | minier      | rer    |
      | radd_start_validity          | now         | now    |
      | radd_end_validity            | +10g        | +10g   |
    Then viene controllato lo stato di caricamento del csv a "PENDING"

  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_2] caricamento CSV verifica stato ACCEPTED
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | minier |
      | address_radd_cap             | 000050      | casa   |
      | address_radd_province        | MI          | cose   |
      | address_radd_country         | ITALY       | ewrw   |
      | radd_description             | descrizione | ere    |
      | radd_phoneNumber             | minier      | erw    |
      | radd_geoLocation_latitudine  | non so      | rer    |
      | radd_geoLocation_longitudine | %&/(        | rer    |
      | radd_openingTime             | minier      | rer    |
      | radd_start_validity          | now         | now    |
      | radd_end_validity            | +10g        | +10g   |
    Then viene controllato lo stato di caricamento del csv a "ACCEPTED"

  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_3] caricamento CSV con righa malformata verifica stato a REJECTED
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | address_radd |
      | address_radd_cap             | 000050      | NULL         |
      | address_radd_province        | MI          | 12342634     |
      | address_radd_country         | ITALY       |              |
      | radd_description             | descrizione |              |
      | radd_geoLocation_longitudine | %&/(        |              |
      | radd_openingTime             | minier      |              |
      | radd_start_validity          | now         | now          |
      | radd_end_validity            | +10g        | +10g         |
    Then viene controllato lo stato di caricamento del csv a REJECTED con messaggio di errore ""


  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_4] caricamento CSV con campi a null dove c'è obbligatorietà verifica stato a REJECTED
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | address_radd |
      | address_radd_cap             | 000050      | NULL         |
      | address_radd_province        | MI          | 12342634     |
      | address_radd_country         | ITALY       |              |
      | radd_description             | descrizione |              |
      | radd_geoLocation_longitudine | %&/(        |              |
      | radd_openingTime             | minier      |              |
      | radd_start_validity          | now         | now          |
      | radd_end_validity            | +10g        | +10g         |
    Then viene controllato lo stato di caricamento del csv a REJECTED con messaggio di errore ""

  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_5] caricamento CSV con formato campi errato verifica stato a REJECTED e messaggio di errore
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | address_radd |
      | address_radd_cap             | 000050      | NULL         |
      | address_radd_province        | MI          | 12342634     |
      | address_radd_country         | ITALY       |              |
      | radd_description             | descrizione |              |
      | radd_geoLocation_longitudine | %&/(        |              |
      | radd_openingTime             | minier      |              |
      | radd_start_validity          | now         | now          |
      | radd_end_validity            | +10g        | +10g         |
    Then viene controllato lo stato di caricamento del csv a REJECTED con messaggio di errore ""

  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_6] caricamento CSV con formato campi errato verifica stato a REJECTED e messaggio di errore
    When viene eseguita la richiesta per controllo dello stato di caricamento del csv con restituzione errore
    Then l'operazione ha prodotto un errore con status code "400"

  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_1] inserimento sportello RADD con dati corretti
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | via posto   |
      | address_radd_cap             | 000050      |
      | address_radd_province        | MI          |
      | address_radd_country         | ITALY       |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | +10g        |

  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_2] inserimento sportello RADD senza campi obbligatori
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | NULL        |
      | address_radd_cap             | NULL        |
      | address_radd_province        | NULL        |
      | address_radd_country         | NULL        |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | +10g        |
    Then l'operazione ha prodotto un errore con status code "400"

  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_3] inserimento sportello RADD con formato campi errato
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | NULL        |
      | address_radd_cap             | NULL        |
      | address_radd_province        | NULL        |
      | address_radd_country         | NULL        |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | +10g        |
    Then l'operazione ha prodotto un errore con status code "400"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_4] inserimento sportello RADD con endValidity minore della startValidity
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | NULL        |
      | address_radd_cap             | NULL        |
      | address_radd_province        | NULL        |
      | address_radd_country         | NULL        |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | -10g        |
    Then l'operazione ha prodotto un errore con status code "400"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_5] inserimento sportello RADD con endValidity a null (controllo manuale che sportello sia utilizzabile )
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | NULL        |
      | address_radd_cap             | 01000       |
      | address_radd_province        | NULL        |
      | address_radd_country         | NULL        |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | NULL        |
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL           |
      | physicalAddress_address      | Via@ok_890     |
      | physicalAddress_municipality | <municipality> |
      | physicalAddress_zip          | 01000          |
      | physicalAddress_province     | <province>     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_6] inserimento sportello RADD con startValidity avanti di giorni (controllo manuale che il sportello non sia attivo)
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | NULL        |
      | address_radd_cap             | 02000       |
      | address_radd_province        | NULL        |
      | address_radd_country         | NULL        |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | NULL        |
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL           |
      | physicalAddress_address      | Via@ok_890     |
      | physicalAddress_municipality | <municipality> |
      | physicalAddress_zip          | 02000          |
      | physicalAddress_province     | <province>     |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_7] modifica sportello RADD con dati corretti controllo successo modifica
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | NULL        |
      | address_radd_cap             | 02000       |
      | address_radd_province        | NULL        |
      | address_radd_country         | NULL        |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | NULL        |
    Then viene modificato uno sportello Radd con dati:
      | radd_description | descrizione |
      | radd_openingTime | minier      |
      | radd_phoneNumber | minier      |


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_8] modifica sportello RADD con campi vuoto dove non obbligatorio controllo successo modifica
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | NULL        |
      | address_radd_cap             | 02000       |
      | address_radd_province        | NULL        |
      | address_radd_country         | NULL        |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | NULL        |
    Then viene modificato uno sportello Radd con dati:
      | radd_description | NULL |
      | radd_openingTime | NULL |
      | radd_phoneNumber | NULL |


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_9] modifica sportello RADD con formato campi errato controllo restituzione errore
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | NULL        |
      | address_radd_cap             | 02000       |
      | address_radd_province        | NULL        |
      | address_radd_country         | NULL        |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | NULL        |
    Then viene modificato uno sportello Radd con dati:
      | radd_description | NULL |
      | radd_openingTime | NULL |
      | radd_phoneNumber | NULL |
    And l'operazione ha prodotto un errore con status code "400"

  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_10] modifica sportello RADD con registryId non presente controllo restituzione errore
   Then viene modificato uno sportello Radd con dati:
     | radd_requestId | errato |
    And l'operazione ha prodotto un errore con status code "404"

  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_11] modifica sportello RADD con registryId vuoto controllo restituzione errore
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | NULL        |
      | address_radd_cap             | 02000       |
      | address_radd_province        | NULL        |
      | address_radd_country         | NULL        |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | NULL        |
    Then viene modificato uno sportello Radd con dati:
      | radd_requestId | NULL |
    And l'operazione ha prodotto un errore con status code "400"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_12] modifica sportello RADD con uid non presente controllo restituzione errore
    Then viene modificato uno sportello Radd con dati:
      | radd_uid | AJFSAJFOSIJFO |
    And l'operazione ha prodotto un errore con status code "404"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_13] modifica sportello RADD con uid vuoto controllo restituzione errore
    Then viene modificato uno sportello Radd con dati:
      | radd_uid | NULL |
    And l'operazione ha prodotto un errore con status code "400"

  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_14] modifica sportello RADD con dati corretti ma modifica da diverso operatore RADD
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | NULL        |
      | address_radd_cap             | 02000       |
      | address_radd_province        | NULL        |
      | address_radd_country         | NULL        |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | NULL        |
    Then viene modificato uno sportello Radd con dati:
      | radd_description | descrizione |
      | radd_openingTime | minier      |
      | radd_phoneNumber | minier      |
    And viene cambiato raddista con "issuer_2"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_15] modifica sportello RADD con formato campi errato controllo restituzione errore
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | NULL        |
      | address_radd_cap             | 02000       |
      | address_radd_province        | NULL        |
      | address_radd_country         | NULL        |
      | radd_description             | descrizione |
      | radd_phoneNumber             | minier      |
      | radd_geoLocation_latitudine  | non so      |
      | radd_geoLocation_longitudine | %&/(        |
      | radd_openingTime             | minier      |
      | radd_start_validity          | now         |
      | radd_end_validity            | NULL        |
   And viene richiesta la lista degli sportelli con dati: