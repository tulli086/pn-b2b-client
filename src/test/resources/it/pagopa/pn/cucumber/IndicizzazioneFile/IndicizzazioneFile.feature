Feature: test preliminari indicizzazione File safeStorage

  Scenario Outline: [INDEX_SS_FAIL_AUTH] FAILED AUTHORIZATION
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

  ########################################################### GET FILE ###################################################################

  @aggiuntaTag
  Scenario: [INDEX_SS_GET_FILE_1] GetFile - SUCCESS
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2 |
      | global_singlevalue:test1      |
    Then Il documento 1 è correttamente formato con la seguente lista di tag
      | global_multivalue:test1,test2 |
      | global_singlevalue:test1      |

  ########################################################### GET TAGS ###################################################################

  @aggiuntaTag
  Scenario: [INDEX_SS_GET_TAGS_1] GetTags SUCCESS
    Given Viene caricato un nuovo documento
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2,test3 | SET |
      | global_singlevalue:test1            | SET |
    Then Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1,test2,test3 |
      | global_singlevalue:test1            |

  Scenario: [INDEX_SS_GET_TAGS_2] GetTags SUCCESS Empty Result
    Given Viene caricato un nuovo documento
    Then Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | null |

  ########################################################### CREATE FILE ###################################################################

  @aggiuntaTag
  Scenario: [INDEX_SS_CREATE_1] Create - SUCCESS
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2 |
      | global_singlevalue:test1      |
    Then Il documento 1 è associato alla seguente lista di tag
      | global_multivalue:test1,test2 |
      | global_singlevalue:test1      |

  @aggiuntaTag
  Scenario: Create - ERROR Trasformazione
    When Viene caricato un nuovo documento di tipo "PN_LEGAL_FACTS_ST" con tag associati
  Scenario: [INDEX_SS_CREATE_2] Create - ERROR Trasformazione
    Given Viene caricato un nuovo documento di tipo "PN_LEGAL_FACTS_ST" con tag associati
      | global_multivalue:test1 |
    Then Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test1 |
    And Il documento 1 è correttamente formato con la seguente lista di tag
      | global_multivalue:test1 |
    And La chiamata genera un errore con status code 404
    And Il messaggio di errore riporta la dicitura "Document is missing from bucket"

  @aggiuntaTag
  Scenario: [INDEX_SS_CREATE_3] Create ERROR - MaxTagsPerRequest
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2           |
      | global_indexed_multivalue:test1,test2   |
      | global_singlevalue:test1                |
      | global_indexed_singlevalue:test1        |
      | pn-test~local_multivalue:test1,test2    |
      | pn-test~local_singlevalue:test1         |
      | pn-test~local_indexed_singlevalue:test1 |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Limit 'MaxTagsPerRequest' reached"

  @aggiuntaTag
  Scenario: [INDEX_SS_CREATE_4] Create ERROR - MaxFileKeys
    Given Vengono caricati 5 nuovi documenti
    And I primi 5 documenti vengono modificati secondo le seguenti operazioni
      | global_indexed_multivalue:test | SET |
    When Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_indexed_multivalue:test |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Limit 'MaxFileKeys' reached. Current value: 6. Max value: 5"

  @aggiuntaTag
  Scenario: [INDEX_SS_CREATE_5] Create ERROR - MaxValuesPerTagDocument
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2,test3,test4,test5,test6 |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Limit 'MaxValuesPerTagDocument' reached."

  @aggiuntaTag
  Scenario: [INDEX_SS_CREATE_6] Create ERROR - MaxTagsPerDocument
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2         |
      | global_indexed_multivalue:test1,test2 |
      | global_singlevalue:test1              |
      | global_indexed_singlevalue:test1      |
      | pn-test~local_multivalue:test1,test2  |
      | pn-test~local_singlevalue:test1       |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Limit 'MaxTagsPerDocument' reached"

  @aggiuntaTag
  Scenario: [INDEX_SS_CREATE_7] Create ERROR - MaxValuesPerTagPerRequest
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2,test3,test4,test5,test6, test7 |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Limit 'MaxValuesPerTagPerRequest' reached"

  ########################################################### UPDATE SINGLE ###################################################################

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_SINGLE_1] UpdateSingle SUCCESS - solo operazioni SET
    Given Viene caricato un nuovo documento
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test | SET |
    Then Il documento 1 è stato correttamente modificato con la seguente lista di tag
      | global_multivalue:test |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_SINGLE_2] UpdateSingle SUCCESS - solo operazioni DELETE (PARZIALE)
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2 |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test2 | DELETE |
    Then Il documento 1 è associato alla seguente lista di tag
      | global_multivalue:test1 |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_SINGLE_3] UpdateSingle SUCCESS - solo operazioni DELETE (TOTALE)
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2 |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2 | DELETE |
    Then Il documento 1 è associato alla seguente lista di tag
      | null |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_SINGLE_4] UpdateSingle SUCCESS - solo operazioni DELETE (ININFLUENTE)
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1 |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test2 | DELETE |
    Then Il documento 1 è associato alla seguente lista di tag
      | global_multivalue:test1 |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_SINGLE_5] UpdateSingle SUCCESS - operazioni SET+DELETE
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test  | DELETE |
      | global_singlevalue:test | SET    |
    Then Il documento 1 è associato alla seguente lista di tag
      | global_singlevalue:test |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_SINGLE_6] UpdateSingle ERROR - Set+Delete sullo stesso tag
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1 |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test2 | SET    |
      | global_multivalue:test1 | DELETE |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "SET and DELETE cannot contain the same tags: [global_multivalue]"

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_SINGLE_7] UpdateSingle ERROR - MaxFileKeys
    Given Vengono caricati 6 nuovi documenti
    And I primi 5 documenti vengono modificati secondo le seguenti operazioni
      | global_indexed_multivalue:test | SET |
    When Si modifica il documento 6 secondo le seguenti operazioni
      | global_indexed_multivalue:test | SET |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Limit 'MaxFileKeys' reached. Current value: 6. Max value: 5"

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_SINGLE_8] UpdateSingle ERROR - MaxOperationsOnTagsPerRequest
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1 |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1          | DELETE |
      | global_indexed_multivalue:test2  | SET    |
      | global_singlevalue:test3         | SET    |
      | global_indexed_singlevalue:test4 | SET    |
      | pn-test~local_multivalue:test5   | SET    |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Number of tags to update exceeds maxOperationsOnTags limit"

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_SINGLE_9] UpdateSingle ERROR - MaxValuesPerTagDocument
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2,test3 |
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test4,test5,test6 | SET |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Limit 'MaxValuesPerTagDocument' reached. Current value: 6. Max value: 5"

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_SINGLE_10] UpdateSingle ERROR - MaxTagsPerDocument
    Given Viene caricato un nuovo documento
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1        | SET |
      | global_singlevalue:test1       | SET |
      | pn-test~local_multivalue:test1 | SET |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Limit 'MaxTagsPerDocument' reached. Current value: 3. Max value: 2"

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_SINGLE_11] UpdateSingle ERROR - MaxValuesPerTagPerRequest
    Given Viene caricato un nuovo documento
    When Si modifica il documento 1 secondo le seguenti operazioni
      | global_multivalue:test1,test2,test3,test4,test5,test6, test7 | SET |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Number of values for tag global_multivalue exceeds maxValues limit"

  ########################################################### UPDATE MASSIVE ###################################################################

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_MASSIVE_1] Update Massive SUCCESS - solo operazioni SET
    Given Vengono caricati 2 nuovi documenti
    When Si modificano i documenti secondo le seguenti operazioni
      | tag                      | documentIndex | operation |
      | global_multivalue:test1  | 1             | SET       |
      | global_singlevalue:test1 | 1             | SET       |
      | global_multivalue:test2  | 2             | SET       |
    Then L'update massivo va in successo con stato 200
    And Il documento 1 è associato alla seguente lista di tag
      | global_multivalue:test1  |
      | global_singlevalue:test1 |
    And Il documento 2 è associato alla seguente lista di tag
      | global_multivalue:test2 |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_MASSIVE_2] Update Massive SUCCESS - solo operazioni DELETE (PARZIALE)
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2 |
    When Si modificano i documenti secondo le seguenti operazioni
      | tag                     | documentIndex | operation |
      | global_multivalue:test1 | 1             | DELETE    |
      | global_multivalue:test2 | 2             | DELETE    |
    Then L'update massivo va in successo con stato 200
    And Il documento 1 è associato alla seguente lista di tag
      | global_multivalue:test2 |
    And Il documento 2 è associato alla seguente lista di tag
      | global_multivalue:test1 |
    And Il documento 1 non contiene la seguente lista di tag
      | global_multivalue:test1 |
    And Il documento 2 non contiene la seguente lista di tag
      | global_multivalue:test2 |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_MASSIVE_3] Update Massive SUCCESS - solo operazioni DELETE (TOTALE)
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2 |
      | global_singlevalue:test1      |
    When Si modificano i documenti secondo le seguenti operazioni
      | tag                           | documentIndex | operation |
      | global_multivalue:test1,test2 | 1             | DELETE    |
      | global_multivalue:test1,test2 | 2             | DELETE    |
    Then L'update massivo va in successo con stato 200
    And Il documento 1 è associato alla seguente lista di tag
      | global_singlevalue:test1 |
    And Il documento 2 è associato alla seguente lista di tag
      | global_singlevalue:test1 |
    And Il documento 1 non contiene la seguente lista di tag
      | global_multivalue:test1,test2 |
    And Il documento 2 non contiene la seguente lista di tag
      | global_multivalue:test1,test2 |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_MASSIVE_4] Update Massive SUCCESS - solo operazioni DELETE (ININFLUENTE)
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2 |
    When Si modificano i documenti secondo le seguenti operazioni
      | tag                     | documentIndex | operation |
      | global_multivalue:test3 | 1             | DELETE    |
      | global_multivalue:test3 | 2             | DELETE    |
    Then L'update massivo va in successo con stato 200
    And Il documento 1 è associato alla seguente lista di tag
      | global_multivalue:test1,test2 |
    And Il documento 2 è associato alla seguente lista di tag
      | global_multivalue:test1,test2 |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_MASSIVE_5] Update Massive SUCCESS - operazioni SET+DELETE
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2 |
      | global_singlevalue:test1      |
    When Si modificano i documenti secondo le seguenti operazioni
      | operation | tag                     | documentIndex |
      | DELETE    | global_multivalue:test2 | 1             |
      | DELETE    | global_multivalue:test2 | 2             |
    Then L'update massivo va in successo con stato 200
    And Il documento 1 è associato alla seguente lista di tag
      | global_multivalue:test1  |
      | global_singlevalue:test1 |
    And Il documento 2 è associato alla seguente lista di tag
      | global_multivalue:test1  |
      | global_singlevalue:test1 |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_MASSIVE_6] Update Massive ERROR - File key ripetuta
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2 |
      | global_singlevalue:test1      |
    When La request presenta una ripetizione della stessa fileKey
      | operation | tag                      | documentIndex |
      | SET       | global_multivalue:test3  | 1             |
      | DELETE    | global_singlevalue:test1 | 1             |
      | DELETE    | global_multivalue:test2  | 2             |
    Then La chiamata genera un errore con status code 400
    And Il messaggio di errore riporta la dicitura "Duplicate fileKey found:"

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_MASSIVE_7] Update Massive ERROR - Set+Delete sullo stesso tag
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1,test2 |
      | global_singlevalue:test1      |
    When Si modificano i documenti secondo le seguenti operazioni
      | operation | tag                     | documentIndex |
      | SET       | global_multivalue:test3 | 1             |
      | DELETE    | global_multivalue:test2 | 1             |
      | DELETE    | global_multivalue:test2 | 2             |
    Then L'update massivo va in successo con stato 200
    And La response contiene uno o più errori riportanti la dicitura "SET and DELETE cannot contain the same tags: [global_multivalue]" riguardanti il documento 1
    And Il documento 2 è associato alla seguente lista di tag
      | global_multivalue:test1  |
      | global_singlevalue:test1 |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_MASSIVE_8] Update Massive ERROR - MaxFileKeysUpdateMassivePerRequest
    Given Vengono caricati 6 nuovi documenti
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

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_MASSIVE_9] Update Massive ERROR - MaxOperationsOnTagsPerRequest
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1 |
    When Si modificano i documenti secondo le seguenti operazioni
      | operation | tag                              | documentIndex |
      | DELETE    | global_multivalue:test1          | 1             |
      | SET       | global_indexed_multivalue:test2  | 1             |
      | SET       | global_singlevalue:test3         | 1             |
      | SET       | global_indexed_singlevalue:test4 | 1             |
      | SET       | pn-test~local_multivalue:test5   | 1             |
      | SET       | global_singlevalue:test6         | 2             |
    Then L'update massivo va in successo con stato 200
    And La response contiene uno o più errori riportanti la dicitura "Number of tags to update exceeds maxOperationsOnTags limit" riguardanti il documento 1
    And Il documento 2 è associato alla seguente lista di tag
      | global_multivalue:test1  |
      | global_singlevalue:test6 |

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_MASSIVE_10] Update Massive ERROR - MaxFileKeys
    Given Vengono caricati 5 nuovi documenti
    And I primi 5 documenti vengono modificati secondo le seguenti operazioni
      | global_indexed_multivalue:test | SET |
    And Viene caricato un nuovo documento
    When Si modificano i documenti secondo le seguenti operazioni
      | operation | tag                            | documentIndex |
      | SET       | global_indexed_multivalue:test | 6             |
      | SET       | global_multivalue:test1        | 1             |
    Then L'update massivo va in successo con stato 200
    And La response contiene uno o più errori riportanti la dicitura "Limit 'MaxFileKeys' reached. Current value: 6. Max value: 5" riguardanti il documento 6
    And Il documento 1 è associato alla seguente lista di tag
      | global_indexed_multivalue:test |
      | global_multivalue:test1        |

    #TODO aggiungere MaxValuesPerTagDocument

  @aggiuntaTag
  Scenario: [INDEX_SS_UPDATE_MASSIVE_12] Update Massive ERROR - MaxTagsPerDocument
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_multivalue:test1 |
    When Si modificano i documenti secondo le seguenti operazioni
      | operation | tag                            | documentIndex |
      | SET       | global_singlevalue:test1       | 1             |
      | SET       | pn-test~local_multivalue:test1 | 1             |
      | SET       | global_singlevalue:test1       | 2             |
    Then L'update massivo va in successo con stato 200
    And La response contiene uno o più errori riportanti la dicitura "Limit 'MaxTagsPerDocument' reached. Current value: 3. Max value: 2" riguardanti il documento 1
    And Il documento 2 è associato alla seguente lista di tag
      | global_multivalue:test1  |
      | global_singlevalue:test1 |

  @aggiuntaTag
  Scenario: Update Massive ERROR - MaxValuesPerTagPerRequest
    Given Vengono caricati 2 nuovi documenti
    When Si modificano i documenti secondo le seguenti operazioni
      | operation | tag                                                         | documentIndex |
      | SET       | global_multivalue:test1,test2,test3,test4,test5,test6,test7 | 1             |
      | SET       | global_multivalue:test1                                     | 2             |
    Then L'update massivo va in successo con stato 200
    And La response contiene uno o più errori riportanti la dicitura "Number of values for tag global_multivalue exceeds maxValues limit" riguardanti il documento 1
    And Il documento 2 è associato alla seguente lista di tag
      | global_multivalue:test1 |

  ########################################################### SEARCH FILE-KEY ###################################################################

  #TODO aggiungere MaxMapValuesForSearch

  @aggiuntaTag
  Scenario Outline: [INDEX_SS_SEARCH_2] SEARCH SUCCESS: Empty Result
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_indexed_multivalue:test1,test2 |
      | global_indexed_singlevalue:test1      |
    When Vengono ricercate con logica "<logic>" le fileKey aventi i seguenti tag
      | global_indexed_multivalue:testEmpty  |
      | global_indexed_singlevalue:testEmpty |
    Then Il risultato della search contiene le fileKey relative ai seguenti documenti
      | null |
    Examples:
      | logic |
      | and   |
      | or    |
      |       |

  @aggiuntaTag
  Scenario Outline: [INDEX_SS_SEARCH_3] SEARCH ERROR: 0 parametri tag
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_indexed_multivalue:test1,test2 |
      | global_indexed_singlevalue:test1      |
    When Vengono ricercate con logica "<logic>" le fileKey aventi i seguenti tag
      | null |
    Then La chiamata genera un errore con status code 400
#    And Il messaggio di errore riporta la dicitura "Limit 'MaxTagsPerRequest' reached"
    Examples:
      | logic |
      | and   |
      | or    |
      |       |

  @aggiuntaTag
  Scenario Outline: [INDEX_SS_SEARCH_4] SEARCH SUCCESS: 1 parametro tag
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_indexed_multivalue:test1param,test2param |
      | global_indexed_singlevalue:test1param           |
    When Vengono ricercate con logica "<logic>" le fileKey aventi i seguenti tag
      | global_indexed_multivalue:test1param |
    Then Il risultato della search contiene le fileKey relative ai seguenti documenti
      | 1 |
      | 2 |
    Examples:
      | logic |
      | and   |
      | or    |
      |       |

  @aggiuntaTag
  Scenario Outline: [INDEX_SS_SEARCH_5] SEARCH SUCCESS: multipli parametri tag (logic and o null)
    Given Vengono caricati 2 nuovi documenti di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_indexed_multivalue:test1param,test2param |
      | global_indexed_singlevalue:test1param           |
    When Vengono ricercate con logica "<logic>" le fileKey aventi i seguenti tag
      | global_indexed_multivalue:test1param  |
      | global_indexed_singlevalue:test1param |
    Then Il risultato della search contiene le fileKey relative ai seguenti documenti
      | 1 |
      | 2 |
    Examples:
      | logic |
      | and   |
      |       |

  @aggiuntaTag
  Scenario: [INDEX_SS_SEARCH_6] SEARCH SUCCESS: multipli parametri tag (logic or)
    Given Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_indexed_multivalue:test1paramOR,test2paramOR |
    And Viene caricato un nuovo documento di tipo "PN_NOTIFICATION_ATTACHMENTS" con tag associati
      | global_indexed_singlevalue:test1paramOR |
    When Vengono ricercate con logica "or" le fileKey aventi i seguenti tag
      | global_indexed_multivalue:test1paramOR  |
      | global_indexed_singlevalue:test1paramOR |
    Then Il risultato della search contiene le fileKey relative ai seguenti documenti
      | 1 |
      | 2 |