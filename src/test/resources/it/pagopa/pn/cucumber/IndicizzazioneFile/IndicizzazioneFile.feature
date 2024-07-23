Feature: test preliminari indicizzazione File safeStorage

  Scenario Outline: FAILED AUTHORIZATION
    When L'utente tenta di effettuare l'operazione "<operation>" senza essere autorizzato ad accedervi
    Then La chiamata genera un errore con status code 403
    Examples:
      | operation      |
      | CREATE_FILE    |
      | GET_FILE       |
      | UPDATE_SINGLE  |
      | UPDATE_MASSIVE |
      | GET_TAGS       |
      | SEARCH_FILE    |

  @aggiuntaTag
  Scenario: UpdateSingle SUCCESS - solo operazioni SET
    Given Viene caricato un nuovo documento pdf
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test | SET |
    Then Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test |

  @aggiuntaTag
  Scenario: UpdateSingle SUCCESS - solo operazioni DELETE 1
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1 | DELETE |
    Then Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test2 |

  @aggiuntaTag
  Scenario: UpdateSingle SUCCESS - solo operazioni DELETE 2
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
      | global_singlevalue:test1 | SET |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | DELETE |
    Then Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_singlevalue:test1 |

  @aggiuntaTag
  Scenario: UpdateSingle SUCCESS - solo operazioni DELETE 3
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test2 | DELETE |
    Then Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1 |

  @aggiuntaTag
  Scenario: UpdateSingle SUCCESS - operazioni SET+DELETE
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test | SET |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test  | DELETE |
      | global_singlevalue:test | SET    |
    Then Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_singlevalue:test |

  @aggiuntaTag
  Scenario: UpdateSingle ERROR - Set+Delete sullo stesso tag
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test2 | SET    |
      | global_multivalue:test1 | DELETE |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "SET and DELETE cannot contain the same tags: [global_multivalue]"

  @aggiuntaTag
  Scenario: UpdateSingle ERROR - MaxFileKeys
    Given Vengono caricati 6 nuovi documenti pdf
    And I primi 5 documenti vengono modificati secondo le seguenti operazioni
      | global_indexed_multivalue:test | SET |
    When Si modifica il documento 6 secondo le seguenti operazioni
      | global_indexed_multivalue:test | SET |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Limit 'MaxFileKeys' reached. Current value: 6. Max value: 5"

  @aggiuntaTag
  Scenario: UpdateSingle ERROR - MaxOperationsOnTagsPerRequest
    Given Viene caricato un nuovo documento pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1          | DELETE |
      | global_indexed_multivalue:test2  | SET    |
      | global_singlevalue:test3         | SET    |
      | global_indexed_singlevalue:test4 | SET    |
      | pn-test~local_multivalue:test5   | SET    |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Number of tags to update exceeds maxOperationsOnTags limit"

  @aggiuntaTag
  Scenario: UpdateSingle ERROR - MaxValuesPerTagDocument
    Given Viene caricato un nuovo documento pdf
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2,test3 | SET |
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test4,test5,test6 | SET |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Limit 'MaxValuesPerTagDocument' reached. Current value: 6. Max value: 5"

  @aggiuntaTag
  Scenario: UpdateSingle ERROR - MaxTagsPerDocument
    Given Viene caricato un nuovo documento pdf
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1        | SET |
      | global_singlevalue:test1       | SET |
      | pn-test~local_multivalue:test1 | SET |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Limit 'MaxTagsPerDocument' reached. Current value: 3. Max value: 2"

  @aggiuntaTag
  Scenario: UpdateSingle ERROR - MaxValuesPerTagPerRequest
    Given Viene caricato un nuovo documento pdf
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2,test3,test4,test5,test6 | SET |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Number of values for tag global_multivalue exceeds maxValues limit"

#  Scenario: Search ERROR - MaxMapValuesForSearch
#    Given Viene caricato un nuovo documento pdf
#    And Si modifica il documento 1 secondo le seguenti operazioni
#      | global_multivalue:test1,test2,test3,test4,test5 | SET |
#    When Si effettua una ricerca passando 6 filtri di ricerca
#    Then La chiamata genera un errore con status code 400
#    And Il messaggio di errore riporta la dicitura "TODO"

  @aggiuntaTag
  Scenario: GetTags SUCCESS
    Given Viene caricato un nuovo documento pdf
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2,test3 | SET |
      | global_singlevalue:test1            | SET |
    Then Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1,test2,test3 |
      | global_singlevalue:test1            |
    
  Scenario: GetTags SUCCESS Empty Result
    Given Viene caricato un nuovo documento pdf
    Then Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | null |

  @aggiuntaTag
  Scenario: Update Massive SUCCESS - solo operazioni SET
    Given Vengono caricati 2 nuovi documenti pdf
    When Si modificano i documenti secondo le seguenti operazioni
      | tag                      | documentIndex | operation |
      | global_multivalue:test1  | 1             | SET       |
      | global_singlevalue:test1 | 1             | SET       |
      | global_multivalue:test2  | 2             | SET       |
    Then La chiamata va in successo con stato 200
    And Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1  |
      | global_singlevalue:test1 |
    And Il documento 2 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test2 |

  @aggiuntaTag
  Scenario: Update Massive SUCCESS - solo operazioni DELETE 1
    Given Vengono caricati 2 nuovi documenti pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
    And Si modifica il documento 2 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
    When Si modificano i documenti secondo le seguenti operazioni
      | tag                     | documentIndex | operation |
      | global_multivalue:test1 | 1             | DELETE    |
      | global_multivalue:test2 | 2             | DELETE    |
    Then La chiamata va in successo con stato 200
    And Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test2 |
    And Il documento 2 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1 |
    And Il documento 1 non contiene la seguente lista di tag
      | global_multivalue:test1 |
    And Il documento 2 non contiene la seguente lista di tag
      | global_multivalue:test2 |

  @aggiuntaTag
  Scenario: Update Massive SUCCESS - solo operazioni DELETE 2
    Given Vengono caricati 2 nuovi documenti pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
      | global_singlevalue:test1      | SET |
    And Si modifica il documento 2 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
      | global_singlevalue:test1      | SET |
    When Si modificano i documenti secondo le seguenti operazioni
      | tag                           | documentIndex | operation |
      | global_multivalue:test1,test2 | 1             | DELETE    |
      | global_multivalue:test1,test2 | 2             | DELETE    |
    Then La chiamata va in successo con stato 200
    And Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_singlevalue:test1 |
    And Il documento 2 è stato correttamente modificato con la seguente lista di tag
      | global_singlevalue:test1 |
    And Il documento 1 non contiene la seguente lista di tag
      | global_multivalue:test1,test2 |
    And Il documento 2 non contiene la seguente lista di tag
      | global_multivalue:test1,test2 |

  @aggiuntaTag
  Scenario: Update Massive SUCCESS - solo operazioni DELETE 3
    Given Vengono caricati 2 nuovi documenti pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
    And Si modifica il documento 2 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
    When Si modificano i documenti secondo le seguenti operazioni
      | tag                     | documentIndex | operation |
      | global_multivalue:test3 | 1             | DELETE    |
      | global_multivalue:test3 | 2             | DELETE    |
    Then La chiamata va in successo con stato 200
    And Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1,test2 |
    And Il documento 2 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1,test2 |

  @aggiuntaTag
  Scenario: Update Massive SUCCESS - operazioni SET+DELETE
    Given Vengono caricati 2 nuovi documenti pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
      | global_singlevalue:test1      | SET |
    And Si modifica il documento 2 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
      | global_singlevalue:test1      | SET |
    When Si modificano i documenti secondo le seguenti operazioni
      | operation | tag                     | documentIndex |
      | DELETE    | global_multivalue:test2 | 1             |
      | DELETE    | global_multivalue:test2 | 2             |
    Then La chiamata va in successo con stato 200
    And Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1  |
      | global_singlevalue:test1 |
    And Il documento 2 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1  |
      | global_singlevalue:test1 |

  @aggiuntaTag
  Scenario: Update Massive ERROR - File key ripetuta
    Given Vengono caricati 2 nuovi documenti pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
      | global_singlevalue:test1      | SET |
    And Si modifica il documento 2 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
      | global_singlevalue:test1      | SET |
    When La request presenta una ripetizione della stessa fileKey
      | operation | tag                      | documentIndex |
      | SET       | global_multivalue:test3  | 1             |
      | DELETE    | global_singlevalue:test1 | 1             |
      | DELETE    | global_multivalue:test2  | 2             |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Duplicate fileKey found: " 1

  @aggiuntaTag
  Scenario: Update Massive ERROR - Set+Delete sullo stesso tag
    Given Vengono caricati 2 nuovi documenti pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
      | global_singlevalue:test1      | SET |
    And Si modifica il documento 2 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | SET |
      | global_singlevalue:test1      | SET |
    When Si modificano i documenti secondo le seguenti operazioni
      | operation | tag                     | documentIndex |
      | SET       | global_multivalue:test3 | 1             |
      | DELETE    | global_multivalue:test2 | 1             |
      | DELETE    | global_multivalue:test2 | 2             |
    Then La chiamata va in successo con stato 200
    And La response contiene uno o più errori riportanti la dicitura "SET and DELETE cannot contain the same tags: [global_multivalue]" riguardanti il documento 1
    And Il documento 2 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1  |
      | global_singlevalue:test1 |

  @aggiuntaTag
  Scenario: Update Massive ERROR - MaxFileKeysUpdateMassivePerRequest
    Given Vengono caricati 6 nuovi documenti pdf
    When Si modificano i documenti secondo le seguenti operazioni
      | operation | tag                     | documentIndex |
      | SET       | global_multivalue:test1 | 1             |
      | SET       | global_multivalue:test1 | 2             |
      | SET       | global_multivalue:test1 | 3             |
      | SET       | global_multivalue:test1 | 4             |
      | SET       | global_multivalue:test1 | 5             |
      | SET       | global_multivalue:test1 | 6             |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Number of documents to update exceeds MaxFileKeysUpdateMassivePerRequest limit."

  Scenario: Update Massive ERROR - MaxOperationsOnTagsPerRequest
    Given Vengono caricati 2 nuovi documenti pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
    And Si modifica il documento 2 secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
    When Si modificano i documenti secondo le seguenti operazioni
      | operation | tag                              | documentIndex |
      | DELETE    | global_multivalue:test1          | 1             |
      | SET       | global_indexed_multivalue:test2  | 1             |
      | SET       | global_singlevalue:test3         | 1             |
      | SET       | global_indexed_singlevalue:test4 | 1             |
      | SET       | pn-test~local_multivalue:test5   | 1             |
      | SET       | global_singlevalue:test6         | 2             |
    Then La chiamata va in successo con stato 200
    And La response contiene uno o più errori riportanti la dicitura "Number of tags to update exceeds maxOperationsOnTags limit" riguardanti il documento 1
    And Il documento 2 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1  |
      | global_singlevalue:test6 |


#  @aggiuntaTag
#  Scenario: Update Massive ERROR - MaxFileKeys
#    Given Vengono caricati 6 nuovi documenti pdf
#    And Si modifica il documento 1 secondo le seguenti operazioni
#      | global_multivalue:test1,test2 | SET |
#      | global_singlevalue:test1      | SET |
#    And Si modifica il documento 2 secondo le seguenti operazioni
#      | global_multivalue:test1,test2 | SET |
#      | global_singlevalue:test1      | SET |
#    When Si modificano i documenti secondo le seguenti operazioni
#      | operation | tag                     | documentIndex |
#      | SET       | global_multivalue:test3 | 1             |
#      | DELETE    | global_multivalue:test2 | 1             |
#      | DELETE    | global_multivalue:test2 | 2             |
#    Then La chiamata va in successo con stato 200
#    And La response contiene uno o più errori riportanti la dicitura "SET and DELETE cannot contain the same tags: [global_multivalue]" riguardanti il documento 1
#    And Il documento 2 è stato correttamente modificato con la seguente lista di tag
#      | global_multivalue:test1  |
#      | global_singlevalue:test1 |
#
#
#  @aggiuntaTag
#  Scenario: UpdateSingle ERROR - MaxFileKeys
#    Given Vengono caricati 6 nuovi documenti pdf
#    And I primi 5 documenti vengono modificati secondo le seguenti operazioni
#      | global_indexed_multivalue:test | SET |
#    When Si modifica il documento 6 secondo le seguenti operazioni
#      | global_indexed_multivalue:test | SET |
#    Then La chiamata genera un errore con status code 400
#    And Il messaggio di errore riporta la dicitura "Limit 'MaxFileKeys' reached. Current value: 6. Max value: 5"

#  TODO Matteo non va
  Scenario: Update Massive ERROR - MaxTagsPerDocument
    Given Vengono caricati 2 nuovi documenti pdf
    And Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1 | SET |
    And Si modifica il documento 2 secondo le seguenti operazioni
      | global_multivalue:test2 | SET |
    When Si modificano i documenti secondo le seguenti operazioni
      | operation | tag                            | documentIndex |
      | SET       | global_singlevalue:test1       | 1             |
      | SET       | pn-test~local_multivalue:test1 | 1             |
      | SET       | global_singlevalue:test2       | 2             |
    Then La chiamata va in successo con stato 200
    And La response contiene uno o più errori riportanti la dicitura "Number of tags to update exceeds maxOperationsOnTags limit" riguardanti il documento 1
    And Il documento 2 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test2  |
      | global_singlevalue:test2 |