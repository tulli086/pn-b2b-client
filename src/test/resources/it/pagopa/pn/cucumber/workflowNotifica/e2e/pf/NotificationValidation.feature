Feature: Validazione notifica e2e

    @e2e
    Scenario: [E2E-PF_NOTIFICATION_VALIDATION_ATTACHMENT_1] validazione fallita allegati notifica - file non caricato su SafeStorage
        Given viene generata una nuova notifica
            | subject | invio notifica con cucumber |
        And destinatario "Mr. UtenteQualsiasi"
            | NULL | NULL |
        When la notifica viene inviata tramite api b2b senza preload allegato dal "Comune_Multi" e si attende che lo stato diventi REFUSED
        Then si verifica che la notifica non viene accettata causa "ALLEGATO"
        And viene inizializzata la sequence per il controllo sulla timeline
            | numCheck    | 2  |
        And si aggiunge alla sequence il controllo che "REQUEST_REFUSED" esista
            | details_refusalReasons | [{"errorCode": "FILE_NOTFOUND"}] |
        And viene verificata la sequence

    @e2e
    Scenario: [E2E-PF_NOTIFICATION_VALIDATION_ATTACHMENT_2] validazione fallita allegati notifica - Sha256 differenti
        Given viene generata una nuova notifica
            | subject | invio notifica con cucumber |
        And destinatario "Mr. UtenteQualsiasi"
            | NULL | NULL |
        When la notifica viene inviata tramite api b2b con sha256 differente dal "Comune_Multi" e si attende che lo stato diventi REFUSED
        Then si verifica che la notifica non viene accettata causa "SHA_256"
        And viene inizializzata la sequence per il controllo sulla timeline
            | numCheck    | 2  |
        And si aggiunge alla sequence il controllo che "REQUEST_REFUSED" esista
            | details_refusalReasons | [{"errorCode": "FILE_SHA_ERROR"}] |
        And viene verificata la sequence

    @e2e
    Scenario: [E2E-PF_NOTIFICATION_VALIDATION_ATTACHMENT_3] validazione fallita allegati notifica - estensione errata
        Given viene generata una nuova notifica
            | subject | invio notifica con cucumber |
        And destinatario "Mr. UtenteQualsiasi"
            | NULL | NULL |
        When la notifica viene inviata tramite api b2b con estensione errata dal "Comune_Multi" e si attende che lo stato diventi REFUSED
        Then si verifica che la notifica non viene accettata causa "EXTENSION"
        And viene inizializzata la sequence per il controllo sulla timeline
            | numCheck    | 2  |
        And si aggiunge alla sequence il controllo che "REQUEST_REFUSED" esista
            | details_refusalReasons | [{"errorCode": "FILE_PDF_INVALID_ERROR"}] |
        And viene verificata la sequence

    @e2e
    Scenario: [E2E-PF_NOTIFICATION_VALIDATION_ATTACHMENT_4] validazione fallita allegati notifica - file non caricato su SafeStorage
        Given viene generata una nuova notifica
            | subject | invio notifica con cucumber |
        And destinatario "Mr. UtenteQualsiasi"
            | NULL | NULL |
        When la notifica viene inviata tramite api b2b effettuando la preload ma senza caricare nessun allegato dal "Comune_Multi" e si attende che lo stato diventi REFUSED
        Then si verifica che la notifica non viene accettata causa "ALLEGATO"
        And viene inizializzata la sequence per il controllo sulla timeline
            | numCheck    | 2  |
        And si aggiunge alla sequence il controllo che "REQUEST_REFUSED" esista
            | details_refusalReasons | [{"errorCode": "FILE_NOTFOUND"}] |
        And viene verificata la sequence

    @e2e @ignore
    Scenario: [E2E-PF_NOTIFICATION_VALIDATION_TAXID] Invio notifica mono destinatario con taxId non valido scenario negativo
        Given viene generata una nuova notifica
            | subject | invio notifica con cucumber |
        And destinatario
            | taxId        | LNALNI80A01H501T |
        When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED
        Then si verifica che la notifica non viene accettata causa "TAX_ID"
        And viene inizializzata la sequence per il controllo sulla timeline
            | numCheck    | 2  |
        And si aggiunge alla sequence il controllo che "REQUEST_REFUSED" esista
            | details_refusalReasons | [{"errorCode": "TAXID_NOT_VALID"}] |
        And viene verificata la sequence

    @e2e @ignore
    Scenario: [E2E-PF_NOTIFICATION_VALIDATION_PHYSICAL_ADDRESS] Invio notifica mono destinatario con indirizzo fisico non valido scenario negativo
        Given viene generata una nuova notifica
            | subject | invio notifica con cucumber |
        And destinatario "Mr. UtenteQualsiasi"
            | physicalAddress_zip          | 00000 |
        When la notifica viene inviata tramite api b2b dal "Comune_Multi" e si attende che lo stato diventi REFUSED
        Then si verifica che la notifica non viene accettata causa "ADDRESS"
        And viene inizializzata la sequence per il controllo sulla timeline
            | numCheck    | 2  |
        And si aggiunge alla sequence il controllo che "REQUEST_REFUSED" esista
            | details_refusalReasons | [{"errorCode": "NOT_VALID_ADDRESS"}] |
        And viene verificata la sequence

    @e2e
    Scenario: [E2E-PF_NOTIFICATION_VALIDATION_ASINC_OK] Invio notifica digitale ed attesa elemento di timeline REQUEST_ACCEPTED e controllo che sia presente nel campo legalFactsIds l'atto opponibile a terzi con category SENDER_ACK positivo
        Given viene generata una nuova notifica
            | subject | invio notifica con cucumber |
            | senderDenomination | Comune di milano |
        And destinatario "Mr. UtenteQualsiasi"
            | NULL | NULL |
        When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
        Then viene inizializzata la sequence per il controllo sulla timeline
            | pollingTimeMultiplier | 1.5 |
            | numCheck    | 2  |
        And si aggiunge alla sequence il controllo che "REQUEST_ACCEPTED" esista
            | legalFactsIds | [{"category": "SENDER_ACK"}] |
        And viene verificata la sequence

    @e2e
    Scenario: [E2E-PF_NOTIFICATION_VALIDATION_AAR_GENERATION] Invio notifica digitale ed attesa elemento di timeline AAR_GENERATION sia presente il campo generatedAarUrl valorizzato positivo
        Given viene generata una nuova notifica
            | subject | invio notifica con cucumber |
            | senderDenomination | Comune di milano |
        And destinatario "Mr. UtenteQualsiasi"
            | NULL | NULL |
        When la notifica viene inviata tramite api b2b dal "Comune_1" e si attende che lo stato diventi ACCEPTED
        Then viene inizializzata la sequence per il controllo sulla timeline
            | pollingTimeMultiplier | 1.5 |
            | numCheck    | 2  |
        And si aggiunge alla sequence il controllo che "AAR_GENERATION" esista
            | details_recIndex | 0 |
            | details_generatedAarUrl | NOT_NULL |
        And viene verificata la sequence
        