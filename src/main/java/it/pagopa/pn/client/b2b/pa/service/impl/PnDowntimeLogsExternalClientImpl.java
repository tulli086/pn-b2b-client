package it.pagopa.pn.client.b2b.pa.service.impl;

import it.pagopa.pn.client.b2b.pa.service.IPnDowntimeLogsClient;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.externalDowntimeLogs.ApiClient;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.externalDowntimeLogs.api.InteropProbingApi;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.externalDowntimeLogs.api.ReadApi;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.externalDowntimeLogs.api.WriteApi;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.externalDowntimeLogs.model.LegalFactDownloadMetadataResponse;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.externalDowntimeLogs.model.PnDowntimeHistoryResponse;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.externalDowntimeLogs.model.PnFunctionality;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.externalDowntimeLogs.model.PnStatusResponse;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.externalDowntimeLogs.model.PnStatusUpdateEvent;
import java.time.OffsetDateTime;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;


@Component
public class PnDowntimeLogsExternalClientImpl implements IPnDowntimeLogsClient {
    private final ReadApi readApi;
    private final WriteApi writeApi;
    private final InteropProbingApi interopProbingApi;


    public PnDowntimeLogsExternalClientImpl(RestTemplate restTemplate,
                                            @Value("${pn.webapi.external.base-url}") String basePath,
                                            @Value("${pn.external.bearer-token-pa-1}") String bearerToken,
                                            @Value("${pn.webapi.external.user-agent}")String userAgent) {
        this.readApi = new ReadApi( newApiClient( restTemplate, basePath, bearerToken,userAgent) );
        this.writeApi = new WriteApi( newApiClient( restTemplate, basePath, bearerToken,userAgent) );
        this.interopProbingApi = new InteropProbingApi(
            newApiClient(restTemplate, basePath, bearerToken, userAgent));
    }

    public ResponseEntity<Void> getEserviceStatus() throws RestClientException {
        return this.interopProbingApi.getEserviceStatusWithHttpInfo();
    }

    private static ApiClient newApiClient(RestTemplate restTemplate, String basePath, String bearerToken, String userAgent ) {
        ApiClient newApiClient = new ApiClient( restTemplate );
        newApiClient.setBasePath( basePath/*+"/downtime/v1"*/);
        newApiClient.addDefaultHeader("user-agent",userAgent);
        newApiClient.setBearerToken(bearerToken);
        newApiClient.addDefaultHeader("auth",bearerToken);
        return newApiClient;
    }

    public PnStatusResponse currentStatus() throws RestClientException {
        return this.readApi.currentStatus();
    }

    public LegalFactDownloadMetadataResponse getLegalFact(String legalFactId) throws RestClientException {
        return this.readApi.getLegalFact(legalFactId);
    }

    public PnStatusResponse status() throws RestClientException {
        return this.readApi.status();
    }

    public PnDowntimeHistoryResponse statusHistory(OffsetDateTime fromTime, OffsetDateTime toTime, List<PnFunctionality> functionality, String page, String size) throws RestClientException {
        return this.readApi.statusHistory(fromTime, toTime, functionality, page, size);
    }

    public void addStatusChangeEvent(String xPagopaPnUid, List<PnStatusUpdateEvent> pnStatusUpdateEvent) throws RestClientException {
        this.writeApi.addStatusChangeEventWithHttpInfo(xPagopaPnUid, pnStatusUpdateEvent);
    }
}