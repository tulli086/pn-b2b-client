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

  Scenario: UpdateSingle SUCCESS - solo operazioni SET
    Given Viene popolato il database con un insieme di "FileNoTag"
    When Viene chiamata l'updateSingle passando come body "UpdateSingleConSet"
    Then Vengono controllati i file "UpdateSingleConSet" modificati



