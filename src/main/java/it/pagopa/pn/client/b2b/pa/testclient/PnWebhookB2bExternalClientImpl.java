package it.pagopa.pn.client.b2b.pa.testclient;

import it.pagopa.pn.client.b2b.pa.impl.PnPaB2bExternalClientImpl;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.ApiClient;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.api.EventsApi;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.api.StreamsApi;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Scope;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.UUID;

import static it.pagopa.pn.client.b2b.pa.testclient.InteropTokenSingleton.ENEBLED_INTEROP;

@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@Slf4j
@EnableAsync
public class PnWebhookB2bExternalClientImpl implements IPnWebhookB2bClient, InteropTokenRefresh {

    private final ApplicationContext ctx;
    private final RestTemplate restTemplate;
    private final EventsApi eventsApi;
    private final StreamsApi streamsApi;

    private final String apiKeyMvp1;
    private final String apiKeyMvp2;
    private final String apiKeyGa;
    private ApiKeyType apiKeySetted = ApiKeyType.MVP_1;
    private final String devBasePath;
    private String bearerTokenInterop;


    private final String enableInterop;

    private final InteropTokenSingleton interopTokenSingleton;

    public PnWebhookB2bExternalClientImpl(
            ApplicationContext ctx,
            RestTemplate restTemplate,
            InteropTokenSingleton interopTokenSingleton,
            @Value("${pn.external.base-url}") String devBasePath,
            @Value("${pn.external.api-key}") String apiKeyMvp1,
            @Value("${pn.external.api-key-2}") String apiKeyMvp2,
            @Value("${pn.external.api-key-GA}") String apiKeyGa,
            @Value("${pn.interop.enable}") String enableInterop
    ) {
        this.ctx = ctx;
        this.restTemplate = restTemplate;
        this.apiKeyMvp1 = apiKeyMvp1;
        this.apiKeyMvp2 = apiKeyMvp2;
        this.apiKeyGa = apiKeyGa;

        this.enableInterop = enableInterop;

        if (ENEBLED_INTEROP.equalsIgnoreCase(enableInterop)) {
            this.bearerTokenInterop = interopTokenSingleton.getTokenInterop();
        }
        this.interopTokenSingleton = interopTokenSingleton;

        this.devBasePath = devBasePath;

        this.eventsApi = new EventsApi( newApiClient( restTemplate, devBasePath, apiKeyMvp1, bearerTokenInterop,enableInterop) );
        this.streamsApi = new StreamsApi( newApiClient( restTemplate, devBasePath, apiKeyMvp1, bearerTokenInterop,enableInterop) );
    }


    @Async
    @Scheduled(cron = "* * * * * ?")
    public void refreshTokenInteropClient(){
        log.info("Attempt refresh interop token");
        if (ENEBLED_INTEROP.equalsIgnoreCase(enableInterop)) {
            String tokenInterop = interopTokenSingleton.getTokenInterop();
            if(!tokenInterop.equals(this.bearerTokenInterop)){
                log.info("refresh interop token");
                this.bearerTokenInterop = tokenInterop;
                this.eventsApi.getApiClient().addDefaultHeader("Authorization", "Bearer " + bearerTokenInterop);
                this.streamsApi.getApiClient().addDefaultHeader("Authorization", "Bearer " + bearerTokenInterop);
            }
        }
    }

    private static ApiClient newApiClient(RestTemplate restTemplate, String basePath, String apikey, String bearerToken, String enableInterop) {
        ApiClient newApiClient = new ApiClient( restTemplate );
        newApiClient.setBasePath( basePath );
        newApiClient.addDefaultHeader("x-api-key", apikey );
        if (ENEBLED_INTEROP.equalsIgnoreCase(enableInterop)) {
            newApiClient.addDefaultHeader("Authorization", "Bearer " + bearerToken);
        }
        return newApiClient;
    }


    public StreamMetadataResponse createEventStream(StreamCreationRequest streamCreationRequest){
        return this.streamsApi.createEventStream(streamCreationRequest);
    }

    public void deleteEventStream(UUID streamId){
        this.streamsApi.removeEventStream(streamId);
    }

    public StreamMetadataResponse getEventStream(UUID streamId){
        return this.streamsApi.retrieveEventStream(streamId);
    }

    public List<StreamListElement> listEventStreams(){
        return this.streamsApi.listEventStreams();
    }

    public StreamMetadataResponse updateEventStream(UUID streamId, StreamCreationRequest streamCreationRequest){
        return this.streamsApi.updateEventStream(streamId,streamCreationRequest);
    }

    public List<ProgressResponseElement> consumeEventStream(UUID streamId, String lastEventId){
        return this.eventsApi.consumeEventStream(streamId,lastEventId);
    }

    @Override
    public ResponseEntity<List<ProgressResponseElement>> consumeEventStreamHttp(UUID streamId, String lastEventId) {
        return this.eventsApi.consumeEventStreamWithHttpInfo(streamId,lastEventId);
    }


    @Override
    public boolean setApiKeys(ApiKeyType apiKey) {
        boolean beenSet = false;
        switch(apiKey){
            case MVP_1:
                if(this.apiKeySetted != ApiKeyType.MVP_1){
                    setApiKey(apiKeyMvp1);
                    this.apiKeySetted = ApiKeyType.MVP_1;
                }
                beenSet = true;
                break;
            case MVP_2:
                if(this.apiKeySetted != ApiKeyType.MVP_2) {
                    setApiKey(apiKeyMvp2);
                    this.apiKeySetted = ApiKeyType.MVP_2;
                }
                beenSet = true;
                break;
            case GA:
                if(this.apiKeySetted != ApiKeyType.GA) {
                    setApiKey(apiKeyGa);
                    this.apiKeySetted = ApiKeyType.GA;
                }
                beenSet = true;
                break;
        }
        return beenSet;
    }

    @Override
    public ApiKeyType getApiKeySetted() {
        return this.apiKeySetted;
    }

    public void setApiKey(String apiKey){
        this.eventsApi.setApiClient(newApiClient(restTemplate, devBasePath, apiKey, bearerTokenInterop,enableInterop));
        this.streamsApi.setApiClient(newApiClient(restTemplate, devBasePath, apiKey, bearerTokenInterop,enableInterop));
    }
}
