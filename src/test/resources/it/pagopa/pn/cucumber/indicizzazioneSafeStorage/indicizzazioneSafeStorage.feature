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
    Given Viene popolato il database
      | dbData | <dbData> |
    When Viene chiamato l'updateSingle
      | requestName | <requestName> |
      | fileKeyName | test          |
    Then I file del database coincidono con quelli attesi
      | expectedOutput | "<expectedOutput>" |
      | fileKeyName    | test               |
    Examples:
      | dbData                                | requestName                               | expectedOutput                             |
      | request/CREATE_FILE_WITHOUT_TAGS.json | request/UPDATE_SINGLE_ONLY_SET.json       | response/UPDATE_SINGLE_ONLY_SET.json       |
      | request/CREATE_FILE_WITH_TAGS.json    | request/UPDATE_SINGLE_ONLY_DELETE_1.json  | response/UPDATE_SINGLE_ONLY_DELETE_1.json  |
      | request/CREATE_FILE_WITH_TAGS.json    | request/UPDATE_SINGLE_ONLY_DELETE_2.json  | response/UPDATE_SINGLE_ONLY_DELETE_2.json  |
      | request/CREATE_FILE_WITH_TAGS.json    | request/UPDATE_SINGLE_ONLY_DELETE_3.json  | response/UPDATE_SINGLE_ONLY_DELETE_3.json  |
      | request/CREATE_FILE_WITH_TAGS.json    | request/UPDATE_SINGLE_SET_AND_DELETE.json | response/UPDATE_SINGLE_SET_AND_DELETE.json |

  Scenario: UpdateSingle ERROR - SET+DELETE Stesso tag
    Given Viene popolato il database
      | dbData | request/CREATE_FILE_WITH_TAGS.json |
    When Viene chiamato l'updateSingle
      | requestName | request/UPDATE_SINGLE_ERROR_SET_AND_DELETE.json |
      | fileKeyName | test |
    Then La response dell'updateSingle coincide con il response code previsto
      | expectedOutput | 400 |





