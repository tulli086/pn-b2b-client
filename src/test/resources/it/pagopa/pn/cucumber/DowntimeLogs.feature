Feature: downtime logs test

  @downtimeLogs @authFleet
  Scenario: [DOWNTIME-LOGS_1] lettura downtime-logs
    Given vengono letti gli eventi di disservizio degli ultimi 30 giorni relativi alla "creazione notifiche"
    When viene individuato se presente l'evento più recente
    And viene scaricata la relativa attestazione opponibile
    Then l'attestazione opponibile è stata correttamente scaricata

  @downtimeLogs
  Scenario: [DOWNTIME-LOGS_2] lettura downtime-logs
    Given vengono letti gli eventi di disservizio degli ultimi 30 giorni relativi alla "visualizzazione notifiche"
    When viene individuato se presente l'evento più recente
    And viene scaricata la relativa attestazione opponibile
    Then l'attestazione opponibile è stata correttamente scaricata

  @downtimeLogs
  Scenario: [DOWNTIME-LOGS_3] lettura downtime-logs
    Given vengono letti gli eventi di disservizio degli ultimi 30 giorni relativi al "workflow notifiche"
    When viene individuato se presente l'evento più recente
    And viene scaricata la relativa attestazione opponibile
    Then l'attestazione opponibile è stata correttamente scaricata

  @downtimeLogs
  Scenario: [INTEROP-PROBING_1] interop probing SUCCESS
    When viene chiamato il servizio di probing
    Then la chiamata al servizio di probing restituisce 200

  @downtimeLogs
  Scenario: [INTEROP-PROBING_2] interop probing ERROR
    When viene chiamato il servizio di probing
    Then la chiamata al servizio di probing restituisce 500

