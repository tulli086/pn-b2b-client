package it.pagopa.pn.client.b2b.pa.service;

import it.pagopa.pn.client.b2b.pa.service.utils.SettableApiKey;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.ProgressResponseElement;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.StreamCreationRequest;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.StreamListElement;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.StreamMetadataResponse;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_2.ProgressResponseElementV22;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_2.StreamCreationRequestV22;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_2.StreamMetadataResponseV22;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_2.StreamRequestV22;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.UUID;

public interface IPnWebhookB2bClient extends SettableApiKey {

    StreamMetadataResponse createEventStream(StreamCreationRequest streamCreationRequest);

    void deleteEventStream(UUID streamId);

    StreamMetadataResponse getEventStream(UUID streamId);

    List<StreamListElement> listEventStreams();

    StreamMetadataResponse updateEventStream(UUID streamId, StreamCreationRequest streamCreationRequest);

    List<ProgressResponseElement> consumeEventStream(UUID streamId, String lastEventId);

    ResponseEntity<List<ProgressResponseElement>> consumeEventStreamHttp(UUID streamId, String lastEventId);

    //Versione 2_2

    StreamMetadataResponseV22 createEventStreamV22(StreamCreationRequestV22 streamCreationRequest);

    void deleteEventStreamV22(UUID streamId);

    StreamMetadataResponseV22 getEventStreamV22(UUID streamId);

    List<it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_2.StreamListElement> listEventStreamsV22();

    StreamMetadataResponseV22 updateEventStreamV22(UUID streamId, StreamRequestV22 streamRequest);

    StreamMetadataResponseV22 disableEventStreamV22(UUID streamId);

    List<ProgressResponseElementV22> consumeEventStreamV22(UUID streamId, String lastEventId);

    ResponseEntity<List<ProgressResponseElementV22>> consumeEventStreamHttpV22(UUID streamId, String lastEventId);
}
