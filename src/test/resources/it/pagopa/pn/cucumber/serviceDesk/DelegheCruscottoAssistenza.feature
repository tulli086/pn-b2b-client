Feature: Deleghe Cruscotto Assitenza

  #CE02.9 Come operatore devo accedere alla lista delle Notifiche per le quali l’utente risulta destinatario come “delegato” di una persona fisica o di una persona giuridica.

  @deleghe1  @cruscottoAssistenza
  Scenario Outline: [API-SERVICE-CA_CE02.9_64] Invocazione del servizio e verifica risposta
    Given "Mario Gherkin" rifiuta se presente la delega ricevuta "Mario Cucumber"
    And "Mario Gherkin" viene delegato da "Mario Cucumber"
    And "Mario Gherkin" accetta la delega "Mario Cucumber"
    When viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And la notifica può essere correttamente letta da "Mario Gherkin" con delega
    And come operatore devo accedere ai dati del profilo di un utente (PF e PG) di Piattaforma Notifiche con taxId "<TAXIID>" e recipientType  "<RECIPIENT_TYPE>"
    And Il servizio risponde correttamente
    Then come operatore devo accedere alla lista delle Notifiche per le quali l’utente risulta destinatario come "delegato" di una persona fisica o di una persona giuridica con taxId "<TAXIID_DELEGATOR>" recipientType  "<RECIPIENT_TYPE>" e con searchPageSize "<SEARCH_PAGE_SIZE>" searchNextPagesKey "<SEARCH_NEXT_PAGE_KEY>" startDate "<START_DATE>" endDate "<END_DATE>" searchMandateId "<MANDATE_ID>" searchInternalId "<INTERNAL_ID>"
    And Il servizio risponde correttamente

    Examples:
      | TAXIID        | TAXIID_DELEGATOR | RECIPIENT_TYPE | SEARCH_PAGE_SIZE | SEARCH_NEXT_PAGE_KEY | START_DATE | END_DATE | MANDATE_ID | INTERNAL_ID |
      | Mario Gherkin | Mario Cucumber   | PF             | 1                | NULL                 | NULL       | NULL     | NO_SET     | NO_SET      |
    #Mario Gherkin - DELEGATO - CLMCST42R12D969Z
    #Mario Cucumber -DELEGANTE - FRMTTR76M06B715E


  @deleghe2  @cruscottoAssistenza
  Scenario Outline: [API-SERVICE-PG-CA_CE02.9_64] Invocazione del servizio e verifica risposta
    Given "CucumberSpa" rifiuta se presente la delega ricevuta "GherkinSrl"
    And "CucumberSpa" viene delegato da "GherkinSrl"
    And "CucumberSpa" accetta la delega "GherkinSrl"
    When viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario GherkinSrl
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    Then la notifica può essere correttamente letta da "CucumberSpa" con delega
    And come operatore devo accedere ai dati del profilo di un utente (PF e PG) di Piattaforma Notifiche con taxId "<TAXIID>" e recipientType  "<RECIPIENT_TYPE>"
    And Il servizio risponde correttamente
    Then come operatore devo accedere alla lista delle Notifiche per le quali l’utente risulta destinatario come "delegato" di una persona fisica o di una persona giuridica con taxId "<TAXIID_DELEGATOR>" recipientType  "<RECIPIENT_TYPE>" e con searchPageSize "<SEARCH_PAGE_SIZE>" searchNextPagesKey "<SEARCH_NEXT_PAGE_KEY>" startDate "<START_DATE>" endDate "<END_DATE>" searchMandateId "<MANDATE_ID>" searchInternalId "<INTERNAL_ID>"
    And Il servizio risponde correttamente

    Examples:
      | TAXIID      | TAXIID_DELEGATOR | RECIPIENT_TYPE | SEARCH_PAGE_SIZE | SEARCH_NEXT_PAGE_KEY | START_DATE | END_DATE | MANDATE_ID | INTERNAL_ID |
      | CucumberSpa | GherkinSrl       | PG             | 1                | NULL                 | NULL       | NULL     | NO_SET     | NO_SET      |


  @deleghe1  @cruscottoAssistenza
  Scenario Outline: [API-SERVICE-CA_CE02.9_65] Invocazione del servizio con IUN esistente, recipientType corretto, recipientTaxId corrispondente al destinatario della notifica ma senza searchMandateId
    Given "Mario Gherkin" rifiuta se presente la delega ricevuta "Mario Cucumber"
    And "Mario Gherkin" viene delegato da "Mario Cucumber"
    And "Mario Gherkin" accetta la delega "Mario Cucumber"
    When viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And la notifica può essere correttamente letta da "Mario Gherkin" con delega
    And come operatore devo accedere ai dati del profilo di un utente (PF e PG) di Piattaforma Notifiche con taxId "<TAXIID>" e recipientType  "<RECIPIENT_TYPE>"
    And Il servizio risponde correttamente
    Then come operatore devo accedere alla lista delle Notifiche per le quali l’utente risulta destinatario come "delegato" di una persona fisica o di una persona giuridica con taxId "<TAXIID_DELEGATOR>" recipientType  "<RECIPIENT_TYPE>" e con searchPageSize "<SEARCH_PAGE_SIZE>" searchNextPagesKey "<SEARCH_NEXT_PAGE_KEY>" startDate "<START_DATE>" endDate "<END_DATE>" searchMandateId "<MANDATE_ID>" searchInternalId "<INTERNAL_ID>"
    And il servizio risponde con errore "400"

    Examples:
      | TAXIID        | TAXIID_DELEGATOR | RECIPIENT_TYPE | SEARCH_PAGE_SIZE | SEARCH_NEXT_PAGE_KEY | START_DATE | END_DATE | MANDATE_ID | INTERNAL_ID |
      | Mario Gherkin | Mario Cucumber   | PF             | 1                | NULL                 | NULL       | NULL     | NULL       | NO_SET      |
    #Errore: 400 BAD_REQUEST 400 Missing the required parameter 'mandateId' when calling searchNotificationsAsDelegateFromInternalId null

  @deleghe1  @cruscottoAssistenza
  Scenario Outline: [API-SERVICE-CA_CE02.9_66] Invocazione del servizio con IUN esistente, recipientType corretto, recipientTaxId corrispondente al destinatario della notifica, con searchMandateId ma senza searchDelegateInternalId
    Given "Mario Gherkin" rifiuta se presente la delega ricevuta "Mario Cucumber"
    And "Mario Gherkin" viene delegato da "Mario Cucumber"
    And "Mario Gherkin" accetta la delega "Mario Cucumber"
    When viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And la notifica può essere correttamente letta da "Mario Gherkin" con delega
    And come operatore devo accedere ai dati del profilo di un utente (PF e PG) di Piattaforma Notifiche con taxId "<TAXIID>" e recipientType  "<RECIPIENT_TYPE>"
    And Il servizio risponde correttamente
    Then come operatore devo accedere alla lista delle Notifiche per le quali l’utente risulta destinatario come "delegato" di una persona fisica o di una persona giuridica con taxId "<TAXIID_DELEGATOR>" recipientType  "<RECIPIENT_TYPE>" e con searchPageSize "<SEARCH_PAGE_SIZE>" searchNextPagesKey "<SEARCH_NEXT_PAGE_KEY>" startDate "<START_DATE>" endDate "<END_DATE>" searchMandateId "<MANDATE_ID>" searchInternalId "<INTERNAL_ID>"
    And il servizio risponde con errore "400"

    Examples:
      | TAXIID        | TAXIID_DELEGATOR | RECIPIENT_TYPE | SEARCH_PAGE_SIZE | SEARCH_NEXT_PAGE_KEY | START_DATE | END_DATE | MANDATE_ID | INTERNAL_ID |
      | Mario Gherkin | Mario Cucumber   | PF             | 1                | NULL                 | NULL       | NULL     | NO_SET     | NULL        |
    # Errore: 400 BAD_REQUEST 400 Missing the required parameter 'delegateInternalId' when calling searchNotificationsAsDelegateFromInternalId null

   #TODO Verificare il comportamento corretto...
  @deleghe1  @cruscottoAssistenza
  Scenario Outline: [API-SERVICE-CA_CE02.9_67] Invocazione del servizio con IUN esistente, recipientType corretto, recipientTaxId corrispondente al destinatario della notifica, ma con searchMandateId non coerente con il searchDelegateInternalId
    Given "Mario Gherkin" rifiuta se presente la delega ricevuta "Mario Cucumber"
    And "Mario Gherkin" viene delegato da "Mario Cucumber"
    And "Mario Gherkin" accetta la delega "Mario Cucumber"
    When viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And la notifica può essere correttamente letta da "Mario Gherkin" con delega
    And come operatore devo accedere ai dati del profilo di un utente (PF e PG) di Piattaforma Notifiche con taxId "<TAXIID>" e recipientType  "<RECIPIENT_TYPE>"
    And Il servizio risponde correttamente
    Then come operatore devo accedere alla lista delle Notifiche per le quali l’utente risulta destinatario come "delegante" di una persona fisica o di una persona giuridica con taxId "<TAXIID_DELEGATE>" recipientType  "<RECIPIENT_TYPE>" e con searchPageSize "<SEARCH_PAGE_SIZE>" searchNextPagesKey "<SEARCH_NEXT_PAGE_KEY>" startDate "<START_DATE>" endDate "<END_DATE>" searchMandateId "<MANDATE_ID>" searchInternalId "<INTERNAL_ID>"
    And il servizio risponde con errore "400"

    Examples:
      | TAXIID         | TAXIID_DELEGATE | RECIPIENT_TYPE | SEARCH_PAGE_SIZE | SEARCH_NEXT_PAGE_KEY | START_DATE | END_DATE | MANDATE_ID               | INTERNAL_ID |
      | Mario Cucumber | Mario Gherkin   | PF             | 10               | NULL                 | NULL       | NULL     | z7942f2e-1037-4ed9-8ca6- | NO_SET      |

    # Response 400 INTERNAL_SERVER_ERROR

#CE02.10 Come operatore devo accedere alla lista delle Notifiche per le quali l’utente risulta destinatario ma sono state “trattate” da altro utente da lui “delegato”

  @deleghe1  @cruscottoAssistenza
  Scenario Outline: [API-SERVICE-CA_CE02.10_74] Invocazione del servizio e verifica risposta
    Given "Mario Gherkin" rifiuta se presente la delega ricevuta "Mario Cucumber"
    And "Mario Gherkin" viene delegato da "Mario Cucumber"
    And "Mario Gherkin" accetta la delega "Mario Cucumber"
    When viene generata una nuova notifica
      | subject            | invio notifica con cucumber |
      | senderDenomination | comune di milano            |
    And destinatario Mario Cucumber
    And la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
    And la notifica può essere correttamente letta da "Mario Gherkin" con delega
    And come operatore devo accedere ai dati del profilo di un utente (PF e PG) di Piattaforma Notifiche con taxId "<TAXIID>" e recipientType  "<RECIPIENT_TYPE>"
    And Il servizio risponde correttamente
    Then come operatore devo accedere alla lista delle Notifiche per le quali l’utente risulta destinatario come "delegante" di una persona fisica o di una persona giuridica con taxId "<TAXIID_DELEGATE>" recipientType  "<RECIPIENT_TYPE>" e con searchPageSize "<SEARCH_PAGE_SIZE>" searchNextPagesKey "<SEARCH_NEXT_PAGE_KEY>" startDate "<START_DATE>" endDate "<END_DATE>" searchMandateId "<MANDATE_ID>" searchInternalId "<INTERNAL_ID>"
    And Il servizio risponde correttamente

    Examples:
      | TAXIID         | TAXIID_DELEGATE | RECIPIENT_TYPE | SEARCH_PAGE_SIZE | SEARCH_NEXT_PAGE_KEY | START_DATE | END_DATE | MANDATE_ID | INTERNAL_ID |
      | Mario Cucumber | Mario Gherkin   | PF             | 1                | NULL                 | NULL       | NULL     | NO_SET     | NO_SET      |

