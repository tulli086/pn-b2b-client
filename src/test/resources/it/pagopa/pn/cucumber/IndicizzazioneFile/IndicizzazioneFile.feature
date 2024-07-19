Feature: test preliminari indicizzazione File safeStorage

  Scenario Outline: FAILED AUTHORIZATION
    When L'utente chiama l'endpoint senza essere autorizzato ad accedervi
    Then La chiamata restituisce 403
      | endpoint | <endpoint> |
    Examples:
      | endpoint              |
#      | getFileWithTagsByFileKey |
#      | createFileWithTags       |
      | updateSingleWithTags  |
#      | updateMassiveWithTags    |
      | getTagsByFileKey      |
      | searchFileKeyWithTags |

  Scenario Outline: UpdateSingle SUCCESS
    Given Viene caricato un nuovo documento pdf
    When gli si vogliono modificare i tag aggiungendo operazioni di tipo "<requestType>"
    Examples:
      | requestType               |
      | ONLY_SET_OPERATIONS       |
      | ONLY_DELETE_OPERATIONS    |
      | SET_AND_DELETE_OPERATIONS |
