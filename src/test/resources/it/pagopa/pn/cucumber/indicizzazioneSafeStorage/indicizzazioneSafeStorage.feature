Feature: Indicizzazione Safe Storage

  Scenario Outline: FAILED AUTHORIZATION
    When L'utente chiama l'endpoint senza essere autorizzato ad accedervi
    Then La chiamata restituisce 403
      | endpoint | <endpoint>    |
    Examples:
      | endpoint                 |
#      | getFileWithTagsByFileKey |
#      | createFileWithTags       |
      | updateSingleWithTags     |
#      | updateMassiveWithTags    |
      | getTagsByFileKey         |
      | searchFileKeyWithTags    |

  Scenario Outline: UpdateSingle SUCCESS
    Given Viene caricato un nuovo documento
    When Viene chiamato l'updateSingle
      | requestName | <requestName> |
    Then I file del database coincidono con quelli attesi
      | expectedOutput | "<expectedOutput>" |
    Examples:
      | requestName                         | expectedOutput                       |
      | request/UPDATE_SINGLE_ONLY_SET.json | response/UPDATE_SINGLE_ONLY_SET.json |
#      | request/UPDATE_SINGLE_ONLY_DELETE_1.json  | response/UPDATE_SINGLE_ONLY_DELETE_1.json  |
#      | request/UPDATE_SINGLE_ONLY_DELETE_2.json  | response/UPDATE_SINGLE_ONLY_DELETE_2.json  |
#      | request/UPDATE_SINGLE_ONLY_DELETE_3.json  | response/UPDATE_SINGLE_ONLY_DELETE_3.json  |
#      | request/UPDATE_SINGLE_SET_AND_DELETE.json | response/UPDATE_SINGLE_SET_AND_DELETE.json |

  Scenario: UpdateSingle ERROR - SET+DELETE Stesso tag
    Given Viene caricato un nuovo documento
    When Viene chiamato l'updateSingle
      | requestName | request/UPDATE_SINGLE_ERROR_SET_AND_DELETE.json |
    Then La response dell'updateSingle coincide con il response code previsto
      | expectedOutput | 400 |

  Scenario Outline: UpdateSingle ERROR
    Given Viene caricato un nuovo documento
    When Viene chiamato l'updateSingle
      | requestName | <requestName> |
    Then La richiesta va in errore "400" con il messaggio
      | errorMessage | <errorMessage> |
    Examples:
      | errorMessage                  | requestName                                                        |
      | MaxFileKeys                   | request/UPDATE_SINGLE_ONLY_SET.json                                |
      | MaxOperationsOnTagsPerRequest | request/TODO_N_OPERATIONS_SET+DELETE_SULLA_FILE_KEY>MAX_OPERATIONS |
      | MaxValuesPerTagDocument       | request/TODO_N_VALUES4TAG_WHERE_N>MAX_TAGS_ALLOWED                 |
      | MaxTagsPerDocument            | request/TODO_N_TAG_WHERE_N>MaxTagsPerDocument                      |
      | MaxValuesPerTagPerRequest     | request/TODO_TAG_WITH_N_VALUES_WHERE_N>MaxValuesPerTagPerRequest   |






