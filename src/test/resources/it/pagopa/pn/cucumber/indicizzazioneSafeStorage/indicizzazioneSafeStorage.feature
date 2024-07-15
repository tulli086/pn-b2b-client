Feature: Indicizzazione Safe Storage

  Scenario Outline: FAILED AUTHORIZATION
    When L'utente non è autorizzato ad accedere all'API
    Then L'utente chiama l'endpoint e la chiamata restituisce 403
      | endpoint | <endpoint> |
    Examples:
      | endpoint             |
#      | getFileWithTagsByFileKey |
#      | createFileWithTags       |
      | updateSingleWithTags |
#      | updateMassiveWithTags    |
      | getTagsByFileKey     |
#      | searchFileKeyWithTags    |

  Scenario Outline: UpdateSingle SUCCESS
    Given Viene popolato il database
      | dbData | <dbData> |
    When Viene chiamato l'updateSingle
      | requestName | <requestName> |
      | fileKeyName | test          |
    Then La response coincide con l'output previsto
      | expectedOutput | "<expectedOutput>" |
      | fileKeyName    | test               |
    Examples:
      | dbData                             | requestName                               | expectedOutput                             |
      | request/CREATE_FILE_NO_TAGS.json   | request/UPDATE_SINGLE_ONLY_SET.json       | response/UPDATE_SINGLE_ONLY_SET.json       |
      | request/CREATE_FILE_WITH_TAGS.json | request/UPDATE_SINGLE_ONLY_DELETE_1.json  | response/UPDATE_SINGLE_ONLY_DELETE_1.json  |
      | request/CREATE_FILE_WITH_TAGS.json | request/UPDATE_SINGLE_ONLY_DELETE_2.json  | response/UPDATE_SINGLE_ONLY_DELETE_2.json  |
      | request/CREATE_FILE_WITH_TAGS.json | request/UPDATE_SINGLE_ONLY_DELETE_3.json  | response/UPDATE_SINGLE_ONLY_DELETE_3.json  |
      | request/CREATE_FILE_WITH_TAGS.json | request/UPDATE_SINGLE_SET_AND_DELETE.json | response/UPDATE_SINGLE_SET_AND_DELETE.json |





