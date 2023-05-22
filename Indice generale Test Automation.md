# Questo elenco riporta i Test Automatici che sono attualmente implementati

## Invio Notifica

### Invio 

#### Persona fisica

##### Invio notifiche b2b

- [B2B-PA-SEND_1] Invio notifica digitale mono destinatario e recupero tramite codice IUN (p.fisica)_scenario positivo
- [B2B-PA-SEND_2] Invio notifiche digitali mono destinatario (p.fisica)_scenario positivo
- [B2B-PA-SEND_3] invio notifiche digitali mono destinatario (p.fisica)_scenario negativo
- [B2B-PA-SEND_4] invio notifiche digitali mono destinatario (p.fisica)_scenario positivo
- [B2B-PA-SEND_5] invio notifiche digitali mono destinatario (p.fisica)_scenario negativo
- [B2B-PA-SEND_9] invio notifiche digitali mono destinatario senza physicalAddress (p.fisica)_scenario negativo
- [B2B-PA-SEND_10] Invio notifica digitale mono destinatario e recupero tramite codice IUN_scenario negativo
- [B2B-PA-SEND_11] Invio notifica digitale mono destinatario Flat_rate_scenario positivo
- [B2B-PA-SEND_12] Invio notifica digitale mono destinatario Delivery_mode_scenario positivo
- [B2B-PA-SEND_17] Invio notifica digitale mono destinatario senza taxonomyCode (verifica Default)_scenario positivo
- [B2B-PA-SEND_18] Invio notifica digitale mono destinatario con taxonomyCode (verifica Default)_scenario positivo
- [B2B-PA-SEND_19] Invio notifica digitale mono destinatario con payment senza PagopaForm_scenario positivo
- [B2B-PA-SEND_20] Invio notifica digitale mono destinatario con pagamento
- [B2B-PA-SEND_21] Invio notifica digitale mono destinatario con noticeCode ripetuto prima notifica rifiutata
- [B2B-PA-SEND_21] Invio notifica digitale mono destinatario senza pagamento
- [B2B-PA-SEND_22] Invio notifica digitale mono destinatario senza pagamento
- [B2B-PA-SEND_24] Invio notifica digitale mono destinatario physicalCommunication-REGISTERED_LETTER_890_scenario positivo
- [B2B-PA-SEND_25] Invio notifica digitale mono destinatario physicalCommunication-AR_REGISTERED_LETTER_scenario positivo
- [B2B-PA-SEND_26] Invio notifica digitale mono destinatario e verifica stato_scenario positivo
- [B2B-PA-SEND_27] Invio notifica digitale mono destinatario e verifica stato_scenario positivo
- [B2B-PA-SEND_28] Invio notifica digitale mono destinatario e controllo paProtocolNumber con diverse pa_scenario positivo
- [B2B-PA-SEND_29] Invio notifica digitale mono destinatario e controllo paProtocolNumber con uguale pa_scenario negativo
- [B2B-PA-SEND_30] invio notifiche digitali e controllo paProtocolNumber e idempotenceToken con diversa pa_scenario positivo
- [B2B-PA-SEND-31] Invio notifica senza indirizzo fisico scenario negativo
- [B2B-PA-SEND-33] Invio notifica senza indirizzo fisico scenario negativo
- [B2B-PA-SEND_34] Invio notifica  mono destinatario con documenti pre-caricati non trovati su safestorage  scenario negativo
- [B2B-PA-SEND_35] Invio notifica mono destinatario con taxId non valido scenario negativo

##### Invio notifiche b2b con altre PA, multi-destinatario e senza pagamento

- [B2B-MULTI-PA-SEND_1] Invio notifica digitale_scenario negativo
- [B2B-MULTI-PA-SEND_2] Invio notifica digitale senza pagamento_scenario positivo
- [B2B-MULTI-PA-SEND_3] Invio notifica multi destinatario senza pagamento_scenario positivo
- [B2B-MULTI-PA-SEND_4] Invio notifica multi destinatario con pagamento_scenario positivo
- [B2B-MULTI-PA-SEND_5] Invio notifica multi destinatario PA non abilitata_scenario negativa
- [B2B-MULTI-PA-SEND_6] Invio notifica multi destinatario uguale codice avviso_scenario positivo
- [B2B-MULTI-PA-SEND_7] Invio notifica multi destinatario destinatario duplicato_scenario negativo

##### Invio notifiche e2e web PA

- [WEB_PA-SEND_1] Invio notifica digitale mono destinatario e recupero tramite codice IUN web PA_scenario positivo
- [WEB_PA-SEND_2] Invio notifica digitale senza pagamento e recupero tramite codice IUN web PA_scenario positivo
- [WEB_PA-SEND_3] Invio notifica digitale ed attesa stato ACCEPTED_scenario positivo
- [WEB_PA-SEND_4] Invio notifica digitale mono destinatario e recupero tramite ricerca API WEB_PA_scenario positivo
- [WEB_PA-SEND_5] Invio notifica digitale mono destinatario e recupero tramite ricerca API WEB_PA_scenario positivo
- [WEB_PA-SEND_6] Invio notifica digitale mono destinatario e recupero tramite ricerca API WEB_PA_scenario positivo
- [WEB_PA-SEND_7] Invio notifica digitale mono destinatario e recupero tramite ricerca API WEB_PA_scenario positivo

#### Persona giuridica

### Download

#### Persona fisica

##### Download da persona fisica

#### Persona giuridica

##### Download da persona giuridica

### Validation

#### Persona fisica

##### Validazione campi invio notifiche b2b

#### Persona giuridica

##### Validazione campi invio notifiche b2b con persona giuridica

## Visualizzazione notifica

### Deleghe

#### Persona fisica

##### Ricezione notifiche destinate al delegante

#### Persona giuridica

##### Ricezione notifiche destinate al delegante

#### Ricezione notifiche destinate al delegante

### Destinatario persona fisica

#### Recupero notifiche tramite api AppIO b2b

#### Ricezione notifiche api web con invio tramite api B2B

#### Ricezione notifiche api web con invio tramite api B2B multi destinatario

## Workflow notifica

### B2B

#### Persona fisica

##### Avanzamento notifiche b2b persona fisica

##### Avanzamento notifiche b2b multi destinatario

#### Persona giuridica

### Download

#### Persona fisica

#### Persona giuridica

### Webhook

#### Persona fisica

#### Persona giuridica

## Allegati

## Api Key Manager

## Downtime logs

## User Attributes





