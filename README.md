##Istruzioni per l'utilizzo
- creare il file 'api-keys.properties' nel path 'pn-b2b-client/config/'
- inserire nel file appena creato la stringa 'pn.external.api-keys.pagopa-dev=<api_key>' sostituendo ad <api_key> l'api key corretta 
- eseguire il comando
```
    ./mvnw clean install
```
- eseguire il run del main() nel file src/main/java/it/pagopa/pn/client/b2b/pa/NewNotification.java
per invio della notifica e verifica dell'accettazione della stessa da parte di Piattaforma Notifiche