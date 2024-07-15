Feature: Indicizzazione Safe Storage

  #Scenario Outline: FAILED AUTHORIZATION
  #  Given l'utente non è autorizzato ad accedere all'API
  #  When l'utente chiama l'endpoint "<endpoint>" con l'operazione "<operation>"
  #  Then la chiamata restituisce errore 403
  #  Examples:
  #    | endpoint                                   | operation |
  #    | /safe-storage/v1/files                     | POST      |
  #    | /safe-storage/v1/files/{fileKey}/tags      | POST      |
  #    | /safe-storage/v1/files/tags                | POST      |
  #    | /safe-storage/v1/files/{fileKey}?tags=true | GET       |
  #    | /safe-storage/v1/files/{fileKey}/tags      | GET       |
  #    | /safe-storage/v1/files/tags                | GET       |

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





