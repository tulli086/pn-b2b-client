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
    Then La response coincide con "<expectedOutput>"
    Examples:
      | dbData          | requestName                       | expectedOutput                   |
      | FileWithoutTags | UPDATE_SINGLE_ONLY_SET.json       | ResponseUpdateSingleOnlySet      |
      | FileWithTags    | UPDATE_SINGLE_ONLY_DELETE.json    | ResponseUpdateSingleOnlyDelete   |
      | FileWithTags    | UPDATE_SINGLE_SET_AND_DELETE.json | ResponseUpdateSingleSetAndDelete |




