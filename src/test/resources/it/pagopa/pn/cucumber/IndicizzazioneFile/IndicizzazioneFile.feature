Feature: test preliminari indicizzazione File safeStorage

#  Scenario Outline: FAILED AUTHORIZATION
#    When L'utente effettua un'operazione <operation> senza essere autorizzato ad accedervi
#    Then La chiamata restituisce 403
#    Examples:
#      | operation     |
##      | GET_FILE |
##      | CREATE_FILE       |
#      | UPDATE_SINGLE |
##      | UPDATE_MASSIVE    |
#      | GET_TAGS      |
#      | SEARCH        |

  Scenario: UpdateSingle SUCCESS
    Given Viene caricato un nuovo documento pdf

  Scenario: UpdateSingle ERROR - Set+Delete sullo stesso tag
    Given Viene caricato un nuovo documento pdf
    When lo si prova a modificare passando una request che presenta elementi con operazioni SET e DELETE sullo stesso tag
    And viene invocato l'update passando il suddetto bodyRequest
    Then la chiamata genera un errore con status code 400

#  Scenario: UpdateSingle ERROR - MaxFileKeys
#    Given Vengono caricati 5 nuovi documenti pdf
#    And ad ognuno di essi è associato il tag "IUN"
#    When si modifica il documento caricato secondo le seguenti operazioni
#      | SET | [] |
#
#    And viene invocato l'update passando il suddetto bodyRequest
#    Then la chiamata genera un errore con status code 400
#
#  Scenario: UpdateSingle ERROR - MaxOperationsOnTagsPerRequest
#    Given Viene caricato un nuovo documento pdf
#    When lo si prova a modificare passando una request che contiene un numero di operazioni su uno stesso tag superiore al limite consentito
#    And viene invocato l'update passando il suddetto bodyRequest
#    Then la chiamata genera un errore con status code 400
#
#  Scenario: UpdateSingle ERROR - MaxValuesPerTagDocument
#    Given Viene caricato un nuovo documento pdf
#    When lo si prova a modificare passando una request che contiene uno o più tag con valori associati in numero superiore al limite consentito
#    And viene invocato l'update passando il suddetto bodyRequest
#    Then la chiamata genera un errore con status code 400

  Scenario: Esempio mappa
    Given prova mappa
      | SET | 10 TAG |
    And verifico i valori della mappa

