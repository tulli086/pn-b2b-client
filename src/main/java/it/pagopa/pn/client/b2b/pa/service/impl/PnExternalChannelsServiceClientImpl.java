package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.generated.openapi.clients.externalchannels.api.mock.ApiClient;
import it.pagopa.pn.client.b2b.generated.openapi.clients.externalchannels.api.mock.pec.MockReceivedMessagesApi;
import it.pagopa.pn.client.b2b.generated.openapi.clients.externalchannels.model.mock.pec.ReceivedMessage;
import it.pagopa.pn.client.b2b.pa.service.IPnExternalChannelsServiceClient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import java.util.*;


@Slf4j
@Component
public class PnExternalChannelsServiceClientImpl implements IPnExternalChannelsServiceClient {

    private final RestTemplate restTemplate;
    private final String extChannelsBasePath;
    private final MockReceivedMessagesApi mockReceivedMessagesApi;

    public PnExternalChannelsServiceClientImpl(
            RestTemplate restTemplate,
            @Value("${pn.externalChannels.base-url}") String extChannelsBasePath
    )
    {
        this.restTemplate = restTemplate;
        this.extChannelsBasePath = extChannelsBasePath;
        this.mockReceivedMessagesApi = new MockReceivedMessagesApi( newApiClient( restTemplate, extChannelsBasePath) );
    }

    private static ApiClient newApiClient(RestTemplate restTemplate, String basePath ) {
        ApiClient newApiClient = new ApiClient(restTemplate);
        newApiClient.setBasePath( basePath );
        return newApiClient;
    }

    public ReceivedMessage getReceivedMessage(String requestId) throws RestClientException {
        return this.mockReceivedMessagesApi.getReceivedMessage(requestId);
    }

    public List<ReceivedMessage> getReceivedMessages(String iun, Integer recipientIndex) throws RestClientException {
        return this.mockReceivedMessagesApi.getReceivedMessages(iun, recipientIndex);
    }


}
