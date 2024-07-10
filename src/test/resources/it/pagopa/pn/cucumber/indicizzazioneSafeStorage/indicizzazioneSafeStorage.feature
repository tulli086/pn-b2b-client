Feature: Indicizzazione Safe Storage

  Scenario Outline: FAILED AUTHORIZATION
    Given l'utente non è autorizzato ad accedere all'API
    When l'utente chiama l'endpoint "<endpoint>" con l'operazione "<operation>"
    Then la chiamata restituisce errore 403
    Examples:
      | endpoint                                   | operation |
      | /safe-storage/v1/files                     | POST      |
      | /safe-storage/v1/files/{fileKey}/tags      | POST      |
      | /safe-storage/v1/files/tags                | POST      |
      | /safe-storage/v1/files/{fileKey}?tags=true | GET       |
      | /safe-storage/v1/files/{fileKey}/tags      | GET       |
      | /safe-storage/v1/files/tags                | GET       |

  Scenario: ERROR UpdateSingle - MaxOperationsOnTagsPerRequest
    Given è stato configurato un numero massimo X di operazioni eseguibili simultaneamente su uno stesso tag
    And E' stato configurato un numero massimo Y di file key che si possono modificare nella stessa request
    And la request contiene un numero di operazioni su uno stesso tag maggiore di X
    When l'utente chiama l'endpoint per l'update singolo
    Then la chiamata restituisce errore 400

  Scenario: ERROR UpdateMassive - MaxOperationsOnTagsPerRequest
    Given è stato configurato un numero massimo X di operazioni eseguibili simultaneamente su uno stesso tag
    And E' stato configurato un numero massimo Y di file key che si possono modificare nella stessa request
    And la request contiene un numero di operazioni su uno stesso tag maggiore di X
    When l'utente chiama l'endpoint per l'update massivo
    Then la chiamata restituisce 200
    And la chiamata contiene la lista degli errori relativi ai tag con numero di operazioni maggiore di X