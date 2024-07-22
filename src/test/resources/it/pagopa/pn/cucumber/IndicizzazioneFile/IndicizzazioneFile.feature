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
      | global_indexed_multivalue:test | SET |
    Then Il documento è stato correttamente modificato con la seguente lista di tag
      | global_indexed_multivalue:test |

  Scenario: UpdateSingle SUCCESS - solo operazioni DELETE 1
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento creato secondo le seguenti operazioni
      | global_indexed_multivalue:test1,test2 | SET |
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_indexed_multivalue:test1 | DELETE |
    Then Il documento è stato correttamente modificato con la seguente lista di tag
      | global_indexed_multivalue:test2 |

  Scenario: UpdateSingle SUCCESS - solo operazioni DELETE 2
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento creato secondo le seguenti operazioni
      | global_indexed_multivalue:test1 | SET |
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_indexed_multivalue:test1 | DELETE |
    Then Il documento è stato correttamente modificato con la seguente lista di tag

  Scenario: UpdateSingle SUCCESS - solo operazioni DELETE 3
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento creato secondo le seguenti operazioni
      | global_indexed_multivalue:test1 | SET |
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_indexed_multivalue:test2 | DELETE |
    Then Il documento è stato correttamente modificato con la seguente lista di tag
      | global_indexed_multivalue:test1 |

  Scenario: UpdateSingle SUCCESS - operazioni SET+DELETE
    Given Viene caricato un nuovo documento pdf
    When Si modifica il documento creato secondo le seguenti operazioni
      | global_indexed_multivalue:test | SET |
    Then Il documento è stato correttamente modificato con la seguente lista di tag
      | global_indexed_multivalue:test  | DELETE |
      | global_indexed_singlevalue:test | DELETE |


  #Scenario: UpdateSingle ERROR - Set+Delete sullo stesso tag
  #  Given Viene caricato un nuovo documento pdf
  #  When lo si prova a modificare passando una request che presenta elementi con operazioni SET e DELETE sullo stesso tag
  #  And viene invocato l'update passando il suddetto bodyRequest
  #  Then la chiamata genera un errore con status code 400
#
  #Scenario: UpdateSingle ERROR - MaxFileKeys
  #  Given Vengono caricati 6 nuovi documenti pdf
  #  When si modificano i primi 5 documenti secondo le seguenti operazioni
  #    | SET | 1 TAG |
  #  Then viene modificato il documento 5 e la chiamata restituisce 400
#
  #Scenario: UpdateSingle ERROR - MaxOperationsOnTagsPerRequest
  #  Given Viene caricato un nuovo documento pdf
  #  When lo si prova a modificare passando una request che contiene un numero di operazioni su uno stesso tag superiore al limite consentito
  #  And viene invocato l'update passando il suddetto bodyRequest
  #  Then la chiamata genera un errore con status code 400
#
  #Scenario: UpdateSingle ERROR - MaxValuesPerTagDocument
  #  Given Viene caricato un nuovo documento pdf
  #  When lo si prova a modificare passando una request che contiene uno o più tag con valori associati in numero superiore al limite consentito
  #  And viene invocato l'update passando il suddetto bodyRequest
  #  Then la chiamata genera un errore con status code 400

