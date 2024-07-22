Feature: test preliminari indicizzazione File safeStorage

  Scenario Outline: FAILED AUTHORIZATION
    When L'utente tenta di effettuare l'operazione "<operation>" senza essere autorizzato ad accedervi
    Then La chiamata restituisce 403
    Examples:
      | operation     |
      | CREATE_FILE   |
      | GET_FILE      |
      | UPDATE_SINGLE |
#      | UPDATE_MASSIVE    |
#      | GET_TAGS      |
#      | SEARCH_FILE   |

  Scenario: UpdateSingle SUCCESS - solo operazioni SET
    Given Viene caricato un nuovo documento pdf
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test | SET |
    Then Il documento è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test |

  Scenario: UpdateSingle SUCCESS - solo operazioni DELETE 1
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test1 | DELETE |
    Then Il documento è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test2 |

  Scenario: UpdateSingle SUCCESS - solo operazioni DELETE 2
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test1 | DELETE |
    Then Il documento è stato correttamente modificato con la seguente lista di tag
    # E' necessario un tag come minimo?

  Scenario: UpdateSingle SUCCESS - solo operazioni DELETE 3
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test2 | DELETE |
    Then Il documento è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1 |

  Scenario: UpdateSingle SUCCESS - operazioni SET+DELETE
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test | SET |
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test  | DELETE |
      | global_singlevalue:test | SET    |
    Then Il documento è stato correttamente modificato con la seguente lista di tag
      | global_singlevalue:test |


  Scenario: UpdateSingle ERROR - Set+Delete sullo stesso tag
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test2 | SET    |
      | global_multivalue:test1 | DELETE |
    Then La chiamata genera un errore con status code 400

  #Scenario: UpdateSingle ERROR - MaxFileKeys
  #  Given Vengono caricati 6 nuovi documenti pdf
  #  And Ad ogni documento viene associato un tag
  #    | global_indexed_multivalue:test |
  #  When Si tenta di modificare uno dei documenti caricati
  #  Then La chiamata genera un errore con status code 400

  Scenario: UpdateSingle ERROR - MaxOperationsOnTagsPerRequest
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test1          | DELETE |
      | global_indexed_multivalue:test2  | SET    |
      | global_singlevalue:test3         | SET    |
      | global_indexed_singlevalue:test4 | SET    |
      | pn-test~local_multivalue:test5   | SET    |
    Then La chiamata genera un errore con status code 400

  Scenario: UpdateSingle ERROR - MaxValuesPerTagDocument
    Given Viene caricato un nuovo documento pdf
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
      | global_multivalue:test2 | SET |
      | global_multivalue:test3 | SET |
    And Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test4 | SET |
      | global_multivalue:test5 | SET |
      | global_multivalue:test6 | SET |
    Then La chiamata genera un errore con status code 400

  Scenario: UpdateSingle ERROR - MaxTagsPerDocument
    Given Viene caricato un nuovo documento pdf
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
      | global_indexed_multivalue:test2 | SET |
      | global_indexed_singlevalue:test4 | SET |
    Then La chiamata genera un errore con status code 400

  Scenario UpdateSingle ERROR - MaxValuesPerTagPerRequest
    Given Viene caricato un nuovo documento pdf
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_multivalue:test1,test2,test3,test4,test5,test6 | SET |
    Then La chiamata genera un errore con status code 400


