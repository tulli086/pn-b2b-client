Feature: Radd Alternative Anagrafica Sportelli

  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_1] caricamento CSV con 2 sportelli
    When viene caricato il csv con dati:
      | address_radd_row         | address_radd_cap | address_radd_province | address_radd_city    | address_radd_country | radd_description | radd_phoneNumber | radd_geoLocation_latitudine | radd_geoLocation_longitudine | radd_openingTime | radd_start_validity | radd_end_validity | radd_capacity | radd_externalCode |
      | via ceggia               | 30022            | VE                    | CEGGIA               | ITALIA               | test sportelli   | 01/5410951       | 45,0000                     | 42,2412                      | lun=9.00-10.00   | now                 | +10g              | 10            | test radd         |
      | via CONCORDIA SAGITTARIA | 30023            | VE                    | CONCORDIA SAGITTARIA | ITALIA               | test sportelli   | 01/5245951       | 11,0000                     | 32,1245                      | lun=9.00-15.00   | now                 | +10g              | 22            | test radd         |
    Then viene controllato lo stato di caricamento del csv a "DONE"


  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_2] caricamento 2 volte stesso checksum del CSV
    When viene caricato il csv con dati:
      | address_radd_row | address_radd_cap | address_radd_province | address_radd_city | address_radd_country |
      | via posto        | 30020            | VE                    | PONTE CREPALDO    | ITALIA               |
      | via ceggia       | 30020            | VE                    | PORTEGRANDI       | ITALIA               |
    Then viene caricato il csv con stesso checksum
    And l'operazione ha prodotto un errore con status code "409"

  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_3] caricamento 2 CSV con il primo CSV con un record in stato PENDING
    When viene caricato il csv con dati:
      | address_radd_row | address_radd_cap | address_radd_province | address_radd_city | address_radd_country |
      | via posto        | 30020            | VE                    | PONTE CREPALDO    | ITALIA               |
      | via ceggia       | 30020            | VE                    | PORTEGRANDI       | ITALIA               |
    Then viene caricato il csv con restituzione errore con dati:
      | address_radd_row | address_radd_cap | address_radd_province | address_radd_city | address_radd_country |
      | via posto        | 30020            | VE                    | PONTE CREPALDO    | ITALIA               |
      | via ceggia       | 30020            | VE                    | PORTEGRANDI       | ITALIA               |
    And l'operazione ha prodotto un errore con status code "400"


  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_1] caricamento CSV verifica stato PENDING
    When viene caricato il csv con dati:
      | address_radd_row | address_radd_cap | address_radd_province | address_radd_city | address_radd_country |
      | via posto        | 30020            | VE                    | PONTE CREPALDO    | ITALIA               |
      | via ceggia       | 30020            | VE                    | PORTEGRANDI       | ITALIA               |
    Then viene controllato lo stato di caricamento del csv a "PENDING"

  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_2] caricamento CSV verifica stato DONE
    When viene caricato il csv con dati:
      | address_radd_row | address_radd_cap | address_radd_province | address_radd_city | address_radd_country |
      | via posto        | 30020            | VE                    | PONTE CREPALDO    | ITALIA               |
      | via ceggia       | 30020            | VE                    | PORTEGRANDI       | ITALIA               |
    Then viene controllato lo stato di caricamento del csv a "DONE"

  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_3] caricamento CSV con righa malformata verifica stato a REJECTED
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | via posto |
      | address_radd_cap             | ERRATO      | ERRATO    |
      | address_radd_province        | MI          | MI        |
      | address_radd_city            | MILANO      | MILANO    |
      | address_radd_country         | ITALY       | ITALY     |
      | radd_description             | descrizione |           |
      | radd_geoLocation_longitudine | %&/(        |           |
      | radd_openingTime             | %&/(        |           |
      | radd_start_validity          | now         | now       |
      | radd_end_validity            | +10g        | +10g      |
    Then viene controllato lo stato di caricamento del csv a REJECTED con messaggio di errore "csv malformato"


  @raddAnagrafica @raddCsv
  Scenario Outline: [RADD_ANAGRAFICA_CSV_STATO_4] caricamento CSV con campi a null dove c'è obbligatorietà verifica stato a REJECTED
    When viene caricato il csv con dati:
      | address_radd_row | address_radd_cap | address_radd_province | address_radd_city |
      | <via>            | <cap>            | <provincia>           | <citta>           |
      | via ceggia       | 30020            | VE                    | PORTEGRANDI       |
    Then viene controllato lo stato di caricamento del csv a REJECTED con messaggio di errore ""
    Examples:
      | via        | cap   | provincia | citta  |
      | via ceggia | 30022 | VE        | NULL   |
      | via ceggia | 30022 | NULL      | CEGGIA |
      | via ceggia | NULL  | VE        | CEGGIA |
      | NULL       | 30022 | VE        | CEGGIA |


  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_5] caricamento CSV con formato campi errato verifica stato a REJECTED e messaggio di errore
    When viene caricato il csv con dati:
      | address_radd_row             | ĄŁĽŚŠŞŤŹŽż  | łľśˇšşťź˝žż  |
      | address_radd_cap             | ĄŁĽŚŠŞŤŹŽż  | łľśˇšşťź˝žż  |
      | address_radd_province        | +ĄŁĽŚŠŞŤŹŽż | łľśˇšşťź˝žż  |
      | address_radd_city            | ĄŁĽŚŠŞŤŹŽż  | -łľśˇšşťź˝žż |
      | address_radd_country         | ĄŁĽŚŠŞŤŹŽż  | łľśˇšşťź˝žż  |
      | radd_description             | ĄŁĽŚŠŞŤŹŽż  | łľśˇšşťź˝žż  |
      | radd_geoLocation_longitudine | +ĄŁĽŚŠŞŤŹŽż | łľśˇšşťź˝žż  |
      | radd_geoLocation_latitudine  | +ĄŁĽŚŠŞŤŹŽż | łľśˇšşťź˝žż  |
      | radd_openingTime             | ĄŁĽŚŠŞŤŹŽż  | łľśˇšşťź˝žż  |
      | radd_start_validity          | ĄŁĽŚŠŞŤŹŽż  | łľśˇšşťź˝žż  |
      | radd_end_validity            | ĄŁĽŚŠŞŤŹŽż  | łľśˇšşťź˝žż  |
      | radd_externalCode            | ĄŁĽŚŠŞŤŹŽż  | -łľśˇšşťź˝žż |
    Then viene controllato lo stato di caricamento del csv a REJECTED con messaggio di errore "formato errato"

  @raddAnagrafica
  Scenario Outline: [RADD_ANAGRAFICA_CSV_STATO_6] caricamento CSV verifica stato con requestId non esistente
    When viene eseguita la richiesta per controllo dello stato di caricamento del csv con restituzione errore
      | radd_requestId | <requestId> |
    Then l'operazione ha prodotto un errore con status code "<errore>"
    Examples:
      | requestId  | errore |
      | non esiste | 404    |
      | NULL       | 400    |


  @raddAnagrafica @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_LISTA_1] caricamento CSV verifica il ricevimento della lista dei sportelli RADD
    When viene caricato il csv con dati:
      | address_radd_row      | via posto | via ceggia |
      | address_radd_cap      | NULL      | 30022      |
      | address_radd_province | MI        | VE         |
      | address_radd_city     | MILANO    | CEGGIA     |
      | address_radd_country  | ITALY     | ITALY      |
    Then viene richiesta la lista degli sportelli caricati dal csv:
      | radd_requestId    | corretto |
      | radd_filter_limit | 10       |


  @raddAnagrafica
  Scenario Outline: [RADD_ANAGRAFICA_CSV_LISTA_2] caricamento CSV verifica il ricevimento della lista dei sportelli RADD
    When viene richiesta la lista degli sportelli caricati dal csv con dati errati:
      | radd_requestId    | <requestId> |
      | radd_filter_limit | 10          |
    Then l'operazione ha prodotto un errore con status code "<errore>"
    Examples:
      | requestId   | errore |
      | saffasfasfa | 404    |
      | NULL        | 400    |


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_1] inserimento sportello RADD con dati corretti
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | via posto       |
      | address_radd_cap             | 20161           |
      | address_radd_province        | MI              |
      | address_radd_city            | MILANO          |
      | address_radd_country         | ITALY           |
      | radd_description             | descrizione     |
      | radd_phoneNumber             | 01/5245951      |
      | radd_geoLocation_latitudine  | 12,0000         |
      | radd_geoLocation_longitudine | 95,0001         |
      | radd_openingTime             | wen=10.00-11.00 |
      | radd_start_validity          | now             |
      | radd_end_validity            | +10g            |
    Then viene controllato lo stato di caricamento del csv a "ACCEPTED"

  @raddAnagrafica
  Scenario Outline: [RADD_ANAGRAFICA_CRUD_2] inserimento sportello RADD senza campi obbligatori
    When viene generato uno sportello Radd con restituzione errore con dati:
      | address_radd_row      | <via>       |
      | address_radd_cap      | <cap>       |
      | address_radd_province | <provincia> |
      | address_radd_city     | <citta>     |
    Then l'operazione ha prodotto un errore con status code "400"
    Examples:
      | via       | cap   | provincia | citta  |
      | NULL      | 20161 | MI        | MILANO |
      | via posto | NULL  | MI        | MILANO |
      | via posto | 20161 | NULL      | MILANO |
      | via posto | 20161 | MI        | NULL   |


  @raddAnagrafica
  Scenario Outline: [RADD_ANAGRAFICA_CRUD_3] inserimento sportello RADD con formato campi errato
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | <via>                |
      | address_radd_cap             | <cap>                |
      | address_radd_province        | <provincia>          |
      | address_radd_city            | <citta>              |
      | address_radd_country         | <stato>              |
      | radd_description             | <descrizione>        |
      | radd_phoneNumber             | <telefono>           |
      | radd_geoLocation_latitudine  | <latitudine>         |
      | radd_geoLocation_longitudine | <longitudine>        |
      | radd_openingTime             | <apperturaSportello> |
      | radd_start_validity          | <startValidity>      |
      | radd_end_validity            | <endValidity>        |
      | radd_capacity                | <capacity>           |
      | radd_externalCode            | <externalCode>       |
    Then viene controllato lo stato di caricamento del csv a REJECTED con messaggio di errore "formato errato"
    Examples:
      | via                     | cap     | provincia               | citta                   | stato          | descrizione    | telefono       | latitudine     | longitudine    | apperturaSportello | startValidity | endValidity    | capacity       | externalCode   |
      | ĄŁĽŚŠŞŤŹŽŻą˛łľśˇšşťź˝žż | 20161   | MI                      | MILANO                  | ITALIA         | NULL           | NULL           | NULL           | NULL           | NULL               | NULL          | NULL           | NULL           | NULL           |
      | via posto               | LETTERE | MI                      | MILANO                  | ITALIA         | NULL           | NULL           | NULL           | NULL           | NULL               | NULL          | NULL           | NULL           | NULL           |
      | via posto               | 20161   | ĄŁĽŚŠŞŤŹŽŻą˛łľśˇšşťź˝žż | MILANO                  | ITALIA         | NULL           | NULL           | NULL           | NULL           | NULL               | NULL          | NULL           | NULL           | NULL           |
      | via posto               | 20161   | MI                      | ĄŁĽŚŠŞŤŹŽŻą˛łľśˇšşťź˝žż | ITALIA         | NULL           | NULL           | NULL           | NULL           | NULL               | NULL          | NULL           | NULL           | NULL           |
      | via posto               | 20161   | MI                      | MILANO                  | ĄŁĽŚŠŞŤŹŽŻą˛łľ | NULL           | NULL           | NULL           | NULL           | NULL               | NULL          | NULL           | NULL           | NULL           |
      | via posto               | 20161   | MI                      | MILANO                  | ITALIA         | ĄŁĽŚŠŞŤŹŽŻą˛łľ | NULL           | NULL           | NULL           | NULL               | NULL          | NULL           | NULL           | NULL           |
      | via posto               | 20161   | MI                      | MILANO                  | ITALIA         | NULL           | ĄŁĽŚŠŞŤŹŽŻą˛łľ | NULL           | NULL           | NULL               | NULL          | NULL           | NULL           | NULL           |
      | via posto               | 20161   | MI                      | MILANO                  | ITALIA         | NULL           | NULL           | ĄŁĽŚŠŞŤŹŽŻą˛łľ | NULL           | NULL               | NULL          | NULL           | NULL           | NULL           |
      | via posto               | 20161   | MI                      | MILANO                  | ITALIA         | NULL           | NULL           | NULL           | ĄŁĽŚŠŞŤŹŽŻą˛łľ | NULL               | NULL          | NULL           | NULL           | NULL           |
      | via posto               | 20161   | MI                      | MILANO                  | ITALIA         | NULL           | NULL           | NULL           | NULL           | ĄŁĽŚŠŞŤŹŽŻą˛łľ     | NULL          | NULL           | NULL           | NULL           |
      | via posto validazione   | 20161   | MI                      | MILANO                  | ITALIA         | NULL           | NULL           | NULL           | NULL           | NULL               | now            | NULL           | NULL           | NULL           |
      | via posto               | 20161   | MI                      | MILANO                  | ITALIA         | NULL           | NULL           | NULL           | NULL           | NULL               | NULL          | ĄŁĽŚŠŞŤŹŽŻą˛łľ | NULL           | NULL           |
      | via posto               | 20161   | MI                      | MILANO                  | ITALIA         | NULL           | NULL           | NULL           | NULL           | NULL               | NULL          | NULL           | ĄŁĽŚŠŞŤŹŽŻą˛łľ | NULL           |
      | via posto               | 20161   | MI                      | MILANO                  | ITALIA         | NULL           | NULL           | NULL           | NULL           | NULL               | NULL          | NULL           | NULL           | ĄŁĽŚŠŞŤŹŽŻą˛łľ |


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_4] inserimento sportello RADD con endValidity minore della startValidity
    When viene generato uno sportello Radd con dati:
      | address_radd_row             | via posto   |
      | address_radd_cap             | 20161       |
      | address_radd_province        | MI          |
      | address_radd_city            | MILANO      |
      | address_radd_country         | ITALY       |
      | radd_description             | descrizione |
      | radd_geoLocation_latitudine  | 15,0000     |
      | radd_geoLocation_longitudine | 67,0000     |
      | radd_openingTime             | NULL        |
      | radd_start_validity          | now         |
      | radd_end_validity            | -20g        |
    Then l'operazione ha prodotto un errore con status code "400"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_5] inserimento sportello RADD con endValidity a null (controllo manuale che sportello sia utilizzabile )
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | via posto |
      | address_radd_cap      | 20144     |
      | address_radd_province | MI        |
      | address_radd_city     | MILANO    |
      | address_radd_country  | ITALY     |
      | radd_start_validity   | now       |
      | radd_end_validity     | NULL      |
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | MILANO     |
      | physicalAddress_zip          | 20144      |
      | physicalAddress_province     | MI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"
    And viene verificato il costo di 818 e il peso di 10 nei details del'elemento di timeline letto


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_6] inserimento sportello RADD con startValidity avanti di giorni (controllo manuale che il sportello non sia attivo)
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | via posto |
      | address_radd_cap      | 20142     |
      | address_radd_province | MI        |
      | address_radd_city     | MILANO    |
      | address_radd_country  | ITALY     |
      | radd_start_validity   | +10g      |
      | radd_end_validity     | NULL      |
    Given viene generata una nuova notifica
      | subject            | notifica analogica con cucumber |
      | senderDenomination | Comune di palermo               |
    And destinatario Mario Gherkin e:
      | digitalDomicile              | NULL       |
      | physicalAddress_address      | Via@ok_890 |
      | physicalAddress_municipality | MILANO     |
      | physicalAddress_zip          | 20142      |
      | physicalAddress_province     | MI         |
    When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi ACCEPTED
    Then vengono letti gli eventi fino all'elemento di timeline della notifica "SEND_ANALOG_DOMICILE"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_7] modifica sportello RADD con dati corretti controllo successo modifica
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | via posto      |
      | address_radd_cap      | 20161          |
      | address_radd_province | MI             |
      | address_radd_city     | MILANO         |
      | address_radd_country  | ITALY          |
      | radd_description      | descrizione    |
      | radd_phoneNumber      | +39 2445356789 |
      | radd_openingTime      | tue=1:00-2:00  |
    Then viene modificato uno sportello Radd con dati:
      | radd_description | descrizione modificata |
      | radd_openingTime | tue=10:00-20:00        |
      | radd_phoneNumber | +39 01234242556789     |


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_8] modifica sportello RADD con campi vuoto dove non obbligatorio controllo successo modifica
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | via posto      |
      | address_radd_cap      | 20161          |
      | address_radd_province | MI             |
      | address_radd_city     | MILANO         |
      | address_radd_country  | ITALY          |
      | radd_description      | descrizione    |
      | radd_phoneNumber      | +39 2445356789 |
      | radd_openingTime      | tue=1:00-2:00  |
    Then viene modificato uno sportello Radd con dati:
      | radd_description | NULL |
      | radd_openingTime | NULL |
      | radd_phoneNumber | NULL |


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_9] modifica sportello RADD con formato campi errato controllo restituzione errore
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | via posto      |
      | address_radd_cap      | 20161          |
      | address_radd_province | MI             |
      | address_radd_city     | MILANO         |
      | address_radd_country  | ITALY          |
      | radd_description      | descrizione    |
      | radd_phoneNumber      | +39 2445356789 |
      | radd_openingTime      | tue=1:00-2:00  |
    Then viene modificato uno sportello Radd con dati errati:
      | radd_description | !!"$%&/( |
      | radd_openingTime | !!"$%&/( |
      | radd_phoneNumber | !!"$%&/( |
    And l'operazione ha prodotto un errore con status code "400"

  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_10] modifica sportello RADD con registryId non presente controllo restituzione errore
    When viene modificato uno sportello Radd con dati errati:
      | radd_registryId | errato |
    Then l'operazione ha prodotto un errore con status code "404"

  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_11] modifica sportello RADD con registryId vuoto controllo restituzione errore
    When viene modificato uno sportello Radd con dati errati:
      | radd_registryId | NULL |
    Then l'operazione ha prodotto un errore con status code "400"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_12] modifica sportello RADD con uid non presente controllo restituzione errore
    Then viene modificato uno sportello Radd con dati errati:
      | radd_uid | AJFSAJFOSIJFO |
    And l'operazione ha prodotto un errore con status code "404"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_13] modifica sportello RADD con uid vuoto controllo restituzione errore
    Then viene modificato uno sportello Radd con dati errati:
      | radd_uid | NULL |
    And l'operazione ha prodotto un errore con status code "400"

  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_14] modifica sportello RADD con dati corretti ma modifica da diverso operatore RADD
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | via posto           |
      | address_radd_cap      | 20161               |
      | address_radd_province | MI                  |
      | address_radd_city     | MILANO              |
      | address_radd_country  | ITALY               |
      | radd_description      | descrizione         |
      | radd_phoneNumber      | +39 012643742556789 |
      | radd_openingTime      | mon=10:00-13:00     |
    And viene cambiato raddista con "issuer_2"
    Then viene modificato uno sportello Radd con dati errati:
      | radd_description | descrizione modificata |
      | radd_openingTime | tue=10:00-20:00        |
      | radd_phoneNumber | +39 01234242556789     |
    And l'operazione ha prodotto un errore con status code "404"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_15] cancellazione sportello RADD con dati corretti
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
    Then viene cancellato uno sportello Radd con dati corretti


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_16] cancellazione sportello RADD con endDate < endValidity dello sportello
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | NULL  |
      | address_radd_cap      | 02000 |
      | address_radd_province | NULL  |
      | address_radd_country  | NULL  |
      | radd_start_validity   | now   |
      | radd_end_validity     | +10g  |
    Then viene cancellato uno sportello Radd con dati errati:
      | radd_end_validity | -10g |
    And l'operazione ha prodotto un errore con status code "400"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_17] cancellazione sportello RADD con endDate > endValidity dello sportello controllo errore
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | via posto |
      | address_radd_cap      | 20161     |
      | address_radd_province | MI        |
      | address_radd_city     | MILANO    |
      | address_radd_country  | ITALY     |
      | radd_start_validity   | test radd |
      | radd_end_validity     | +10g      |
    Then viene cancellato uno sportello Radd con dati errati:
      | radd_end_validity | +10g |
    And l'operazione ha prodotto un errore con status code "400"


  @raddAnagrafica
  Scenario Outline: [RADD_ANAGRAFICA_CRUD_18] cancellazione sportello RADD con requestId non presente nella lista degli sportelli
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | via posto             |
      | address_radd_cap      | 20161                 |
      | address_radd_province | MI                    |
      | address_radd_city     | MILANO                |
      | address_radd_country  | ITALY                 |
      | radd_externalCode     | test cancellazione 19 |
    Then viene richiesta la lista degli sportelli con dati:
      | radd_externalCode | test cancellazione 19 |
    Then viene cancellato uno sportello Radd con dati errati:
      | radd_end_validity | <endValidity> |
      | radd_registryId   | <registryId>  |
      | radd_uid          | <uid>         |
    And l'operazione ha prodotto un errore con status code "400"
    Examples:
      | endValidity | registryId | uid      |
      | corretto    | corretto   | NULL     |
      | corretto    | NULL       | corretto |
      | NULL        | corretto   | corretto |


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_20] cancellazione sportello RADD con dati corretti da diverso operatore RADD
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | via posto |
      | address_radd_cap      | 20161     |
      | address_radd_province | MI        |
      | address_radd_city     | MILANO    |
      | address_radd_country  | ITALY     |
    Then viene cambiato raddista con "issuer_2"
    Then viene cancellato uno sportello Radd con dati corretti
    And l'operazione ha prodotto un errore con status code "404"


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_21] ricevimento lista sportelli del operatore con dati corretti
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | via posto |
      | address_radd_cap      | 20161     |
      | address_radd_province | MI        |
      | address_radd_city     | MILANO    |
      | address_radd_country  | ITALY     |
      | radd_externalCode     | test radd |
    Then viene richiesta la lista degli sportelli con dati:
      | radd_filter_limit     | 10        |
      | radd_filter_lastKey   | NULL      |
      | address_radd_cap      | 20161     |
      | address_radd_province | MI        |
      | address_radd_city     | MILANO    |
      | radd_externalCode     | test radd |
    And viene effettuato il controllo se la richiesta ha trovato dei sportelli


  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_22] ricevimento lista sportelli del operatore con limit a null controllo default
    When viene generato uno sportello Radd con dati:
      | address_radd_row      | via posto |
      | address_radd_cap      | 20161     |
      | address_radd_province | MI        |
      | address_radd_city     | MILANO    |
      | address_radd_country  | ITALY     |
      | radd_externalCode     | test radd |
    Then viene richiesta la lista degli sportelli con dati:
      | radd_filter_limit     | NULL      |
      | radd_filter_lastKey   | NULL      |
      | address_radd_cap      | NULL      |
      | address_radd_province | NULL      |
      | address_radd_city     | NULL      |
      | radd_externalCode     | test radd |
    And viene contrallato il numero di sportelli trovati sia uguale a 10

  @raddAnagrafica
  Scenario Outline: [RADD_ANAGRAFICA_CRUD_23] ricevimento lista sportelli del operatore tramite filtro
    Then viene richiesta la lista degli sportelli con dati:
      | radd_filter_limit     | 10             |
      | radd_filter_lastKey   | NULL           |
      | address_radd_cap      | <cap>          |
      | address_radd_province | <provincia>    |
      | address_radd_city     | <citta>        |
      | radd_externalCode     | <externalCode> |
    Then viene effettuato il controllo se la richiesta ha trovato dei sportelli
    Examples:
      | cap   | provincia | citta  | externalCode |
      | 20161 | NULL      | NULL   | NULL         |
      | NULL  | MI        | NULL   | NULL         |
      | NULL  | NULL      | MILANO | NULL         |
      | NULL  | NULL      | NULL   | test radd    |

  @raddAnagrafica
  Scenario: [RADD_ANAGRAFICA_CRUD_24] ricevimento lista vuota dei sportelli del operatore con filtro con valore non presente
    When viene richiesta la lista degli sportelli con dati:
      | radd_filter_limit     | 10                  |
      | radd_filter_lastKey   | NULL                |
      | address_radd_cap      | NULL                |
      | address_radd_province | NULL                |
      | address_radd_city     | NULL                |
      | radd_externalCode     | valore non presente |
    Then viene effettuato il controllo se la richiesta abbia dato lista vuota