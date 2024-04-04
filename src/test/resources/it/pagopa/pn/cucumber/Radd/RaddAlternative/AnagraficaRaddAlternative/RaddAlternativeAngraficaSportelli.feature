Feature: Radd Alternative Anagrafica Sportelli

@raddCsv
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
      | radd_start_validity          | +10g        | re     |
      | radd_end_validity            | -10g        | er     |

  @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_2] caricamento 2 volte stesso checksum del CSV
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | address_radd |
      | address_radd_cap             | 000050      | casa         |
      | address_radd_province        | MI          | 12342634     |
      | address_radd_country         | ITALY       |              |
      | radd_description             | descrizione |              |
      | radd_phoneNumber             | minier      |              |
      | radd_geoLocation_latitudine  | non so      |              |
      | radd_geoLocation_longitudine | %&/(        |              |
      | radd_openingTime             | minier      |              |
      | radd_start_validity          | +10g        |              |
      | radd_end_validity            | -10g        |              |
    Then viene caricato il csv con stesso checksum
    And l'operazione ha prodotto un errore con status code "409"

  @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_3] caricamento 2 CSV con il primo CSV con un record in stato PENDING
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | address_radd |
      | address_radd_cap             | 000050      | casa         |
      | address_radd_province        | MI          | 12342634     |
      | address_radd_country         | ITALY       |              |
      | radd_description             | descrizione |              |
      | radd_phoneNumber             | minier      |              |
      | radd_geoLocation_latitudine  | non so      |              |
      | radd_geoLocation_longitudine | %&/(        |              |
      | radd_openingTime             | minier      |              |
      | radd_start_validity          | +10g        |              |
      | radd_end_validity            | -10g        |              |
    Then viene caricato il csv con restituzione errore con dati:
      | address_radd_row             | via posto   | address_radd |
      | address_radd_cap             | 000050      | casa         |
      | address_radd_province        | MI          | 12342634     |
      | address_radd_country         | ITALY       |              |
      | radd_description             | descrizione |              |
      | radd_phoneNumber             | minier      |              |
      | radd_geoLocation_latitudine  | non so      |              |
      | radd_geoLocation_longitudine | %&/(        |              |
      | radd_openingTime             | minier      |              |
      | radd_start_validity          | +10g        |              |
      | radd_end_validity            | -10g        |              |


  @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_1] caricamento CSV verifica stato PENDING
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | address_radd |
      | address_radd_cap             | 000050      | casa         |
      | address_radd_province        | MI          | 12342634     |
      | address_radd_country         | ITALY       |              |
      | radd_description             | descrizione |              |
      | radd_phoneNumber             | minier      |              |
      | radd_geoLocation_latitudine  | non so      |              |
      | radd_geoLocation_longitudine | %&/(        |              |
      | radd_openingTime             | minier      |              |
      | radd_start_validity          | +10g        |              |
      | radd_end_validity            | -10g        |              |
    Then viene controllato lo stato di caricamento del csv a "PENDING"

  @raddCsv
  Scenario: [RADD_ANAGRAFICA_CSV_STATO_2] caricamento CSV verifica stato ACCEPTED
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | address_radd |
      | address_radd_cap             | 000050      | casa         |
      | address_radd_province        | MI          | 12342634     |
      | address_radd_country         | ITALY       |              |
      | radd_description             | descrizione |              |
      | radd_phoneNumber             | minier      |              |
      | radd_geoLocation_latitudine  | non so      |              |
      | radd_geoLocation_longitudine | %&/(        |              |
      | radd_openingTime             | minier      |              |
      | radd_start_validity          | +10g        |              |
      | radd_end_validity            | -10g        |              |
    Then viene controllato lo stato di caricamento del csv a "ACCEPTED"


  Scenario: [RADD_ANAGRAFICA_CSV_STATO_3] caricamento CSV con righa malformata verifica stato a REJECTED
    When viene caricato il csv con dati:
      | address_radd_row             | via posto   | address_radd |
      | address_radd_cap             | 000050      | NULL         |
      | address_radd_province        | MI          | 12342634     |
      | address_radd_country         | ITALY       |              |
      | radd_description             | descrizione |              |
      | radd_geoLocation_longitudine | %&/(        |              |
      | radd_openingTime             | minier      |              |
      | radd_start_validity          | +10g        |              |
      | radd_end_validity            | -10g        |              |
    Then viene controllato lo stato di caricamento del csv a REJECTED con messaggio di errore ""



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
      | radd_start_validity          | +10g        |
      | radd_end_validity            | -10g        |


  Scenario: [RADD_ANAGRAFICA_CRUD_2] inserimento sportello RADD con dati corretti
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