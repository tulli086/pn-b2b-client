# Esempio di lancio:

1. Recarsi alla root del progetto e buildare il progetto con il comando:
   - `./mvnw clean package` (ambiente Unix)
   - `mvnw.cmd clean package` (ambiente Windows)
2. Eseguire il JAR con le options opportune:

    java -jar create-client-assertion-1.0-SNAPSHOT-jar-with-dependencies.jar --kid=$kid \
    --alg=RS256 \
    --typ=JWT \
    --issuer=$iss \
    --subject=$iss \
    --audience=$audience \
    --purposeId=$purposeId \
    --keyPath=keys/client-pn-${ENV}.rsa.priv

In alternative è possibile da IDE avviare direttamente la classe `it.pagopa.pdnd.CreateClientAssertionApp` (sempre con le options opportune)