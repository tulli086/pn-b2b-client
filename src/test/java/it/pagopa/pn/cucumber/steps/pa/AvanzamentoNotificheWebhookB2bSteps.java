package it.pagopa.pn.cucumber.steps.pa;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.google.common.collect.ComparisonChain;
import io.cucumber.java.After;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.*;
import it.pagopa.pn.client.b2b.pa.service.IPnPaB2bClient;
import it.pagopa.pn.client.b2b.pa.service.IPnWebRecipientClient;
import it.pagopa.pn.client.b2b.pa.service.IPnWebhookB2bClient;
import it.pagopa.pn.client.b2b.pa.service.utils.SettableApiKey;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.NotificationStatus;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.ProgressResponseElement;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.StreamCreationRequest;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.StreamListElement;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.StreamMetadataResponse;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.ProgressResponseElementV23;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.StreamCreationRequestV23;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.StreamMetadataResponseV23;
import it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.StreamRequestV23;
import it.pagopa.pn.cucumber.steps.SharedSteps;
import it.pagopa.pn.cucumber.utils.GroupPosition;
import org.junit.jupiter.api.Assertions;
import org.opentest4j.AssertionFailedError;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.HttpStatusCodeException;

import java.time.OffsetDateTime;
import java.util.*;
import java.util.stream.Collectors;


public class AvanzamentoNotificheWebhookB2bSteps {


    private final IPnWebhookB2bClient webhookB2bClient;
    private final IPnPaB2bClient b2bClient;
    private final IPnWebRecipientClient webRecipientClient;
    private final SharedSteps sharedSteps;

    private LinkedList<ProgressResponseElement> progressResponseElementList = new LinkedList<>();
    private List<StreamCreationRequest> streamCreationRequestList;
    private List<StreamMetadataResponse> eventStreamList;

    private LinkedList<ProgressResponseElementV23> progressResponseElementListV23 = new LinkedList<>();
    private List<StreamCreationRequestV23> streamCreationRequestListV23;
    private List<StreamMetadataResponseV23> eventStreamListV23;
    private StreamRequestV23 streamRequestV23;



    private  List<String> filterValues;

    private Integer requestNumber;
    private HttpStatusCodeException notificationError;
    private StreamRequestV23 streamRequest;
    private static final Logger logger = LoggerFactory.getLogger(AvanzamentoNotificheWebhookB2bSteps.class);

    @Autowired
    public AvanzamentoNotificheWebhookB2bSteps(IPnWebhookB2bClient webhookB2bClient, SharedSteps sharedSteps) {
        this.sharedSteps = sharedSteps;
        this.webhookB2bClient = webhookB2bClient;
        this.webRecipientClient = sharedSteps.getWebRecipientClient();
        this.b2bClient = sharedSteps.getB2bClient();
    }



    @Given("si predispo(ngono)(ne) {int} nuov(i)(o) stream denominat(i)(o) {string} con eventType {string} con versione {string}")
    public void setUpStreamsWithEventType(int number, String title, String eventType, String versione) {

        this.requestNumber = number;
        switch (versione) {
            case "V10":
                this.streamCreationRequestList = new LinkedList<>();
                for(int i = 0; i<number; i++){
                    StreamCreationRequest streamRequest = new StreamCreationRequest();
                    streamRequest.setTitle(title+"_"+i);
                    //STATUS, TIMELINE
                    streamRequest.setEventType(eventType.equalsIgnoreCase("STATUS") ?
                            StreamCreationRequest.EventTypeEnum.STATUS : StreamCreationRequest.EventTypeEnum.TIMELINE);
                    streamCreationRequestList.add(streamRequest);
                    streamRequest.setFilterValues(new LinkedList<>());
                }
                break;
            case "V23":
                this.streamCreationRequestListV23 = new LinkedList<>();
                for(int i = 0; i<number; i++){
                    StreamCreationRequestV23 streamRequest = new StreamCreationRequestV23();
                    streamRequest.setTitle(title+"_"+i);
                    //STATUS, TIMELINE
                    streamRequest.setEventType(eventType.equalsIgnoreCase("STATUS") ?
                            StreamCreationRequestV23.EventTypeEnum.STATUS : StreamCreationRequestV23.EventTypeEnum.TIMELINE);
                    streamCreationRequestListV23.add(streamRequest);
                    streamRequest.setFilterValues(new LinkedList<>());
                }
                break;
            default:
                throw new IllegalArgumentException();
        }





    }

    @Given("si predispo(ngono)(ne) {int} nuov(i)(o) stream V2 denominat(i)(o) {string} con eventType {string}")
    public void setUpStreamsWithEventTypeV2(int number, String title, String eventType) {
        this.streamCreationRequestList = new LinkedList<>();
        this.requestNumber = number;
        for(int i = 0; i<number; i++){
            StreamCreationRequest streamRequest = new StreamCreationRequest();
            streamRequest.setTitle(title+"_"+i);
            //STATUS, TIMELINE

            if(eventType.equalsIgnoreCase("STATUS")){
                streamRequest.setEventType(StreamCreationRequest.EventTypeEnum.STATUS);

                List<String> filteredValues = Arrays.stream(NotificationStatus.values())
                        .map(Enum::toString)
                        .collect(Collectors.toList());
                streamRequest.setFilterValues(filteredValues);
            }else{
                streamRequest.setEventType(StreamCreationRequest.EventTypeEnum.TIMELINE);

                List<String> filteredValues = Arrays.stream(TimelineElementCategoryV23.values())
                        .map(Enum::toString)
                        .collect(Collectors.toList());
                streamRequest.setFilterValues(filteredValues);
            }

            streamCreationRequestList.add(streamRequest);
        }
    }

    @Given("si predispo(ngono)(ne) {int} nuov(i)(o) stream V23 denominat(i)(o) {string} con eventType {string}")
    public void setUpStreamsWithEventTypeV23(int number, String title, String eventType) {
        this.streamCreationRequestListV23 = new LinkedList<>();
        this.requestNumber = number;
        for(int i = 0; i<number; i++){
            StreamCreationRequestV23 streamRequest = new StreamCreationRequestV23();
            streamRequest.setTitle(title+"_"+i);
            //STATUS, TIMELINE

            if(eventType.equalsIgnoreCase("STATUS")){
                streamRequest.setEventType(StreamCreationRequestV23.EventTypeEnum.STATUS);

                List<String> filteredValues = Arrays.stream(NotificationStatus.values())
                        .map(Enum::toString)
                        .collect(Collectors.toList());
                streamRequest.setFilterValues(filteredValues);
            }else{
                streamRequest.setEventType(StreamCreationRequestV23.EventTypeEnum.TIMELINE);

                List<String> filteredValues = Arrays.stream(TimelineElementCategoryV23.values())
                        .map(Enum::toString)
                        .collect(Collectors.toList());
                streamRequest.setFilterValues(filteredValues);
            }

            streamCreationRequestListV23.add(streamRequest);
        }
    }



    private void setPaWebhook(String pa){
        switch (pa){
            case "Comune_1":
                webhookB2bClient.setApiKeys(SettableApiKey.ApiKeyType.MVP_1);
                sharedSteps.selectPA(pa);
                break;
            case "Comune_2":
                webhookB2bClient.setApiKeys(SettableApiKey.ApiKeyType.MVP_2);
                sharedSteps.selectPA(pa);
                break;
            case "Comune_Multi":
                webhookB2bClient.setApiKeys(SettableApiKey.ApiKeyType.GA);
                sharedSteps.selectPA(pa);
                break;
            default:
                throw new IllegalArgumentException();
        }
    }

    @When("si crea(no) i(l) nuov(o)(i) stream per il {string} con versione {string} e apiKey aggiornata")
    public void createdStreamNewApiKey(String pa, String versione) {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        createdStream(pa, versione);
    }

    @When("si crea(no) i(l) nuov(o)(i) stream per il {string} con versione {string} e filtro di timeline {string}")
    public void createdStreamByFilterValue(String pa, String versione,String filter) {
        filterValues.add(filter);
        createdStream(pa, versione);
    }


    @When("si crea(no) i(l) nuov(o)(i) stream per il {string} con versione {string}")
    public void createdStream(String pa, String versione) {
        setPaWebhook(pa);
        switch (versione) {
            case "V10":
                this.eventStreamList = new LinkedList<>();
                for(StreamCreationRequest request: streamCreationRequestList){
                    try{
                        if (filterValues!= null && !filterValues.isEmpty()){
                            request.setFilterValues(filterValues);
                        }
                        StreamMetadataResponse eventStream = webhookB2bClient.createEventStream(request);
                        this.eventStreamList.add(eventStream);
                    }catch (HttpStatusCodeException e) {
                        this.notificationError = e;
                        if (e instanceof HttpStatusCodeException) {
                            sharedSteps.setNotificationError((HttpStatusCodeException) e);
                        }
                    }
                }
                break;
            case "V23":
                this.eventStreamListV23 = new LinkedList<>();
                for(StreamCreationRequestV23 request: streamCreationRequestListV23){
                    try{
                        if (filterValues!= null && !filterValues.isEmpty()){
                            request.setFilterValues(filterValues);
                        }
                        request.setGroups(sharedSteps.getRequestNewApiKey().getGroups());
                        StreamMetadataResponseV23 eventStream = webhookB2bClient.createEventStreamV23(request);
                        this.eventStreamListV23.add(eventStream);
                    }catch (HttpStatusCodeException e) {
                        this.notificationError = e;
                        if (e instanceof HttpStatusCodeException) {
                            sharedSteps.setNotificationError((HttpStatusCodeException) e);
                        }
                    }
                }
                break;
            default:
                throw new IllegalArgumentException();
        }
    }

    @When("si crea(no) i(l) nuov(o)(i) stream per il {string} con replaceId {string} con un gruppo disponibile {string} e apiKey aggiornata")
    public void createdStreamByGroupsUpdateApiKey(String pa, String replaceId, String position) {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        createdStreamByGroups( pa, replaceId,  position);
    }

    @When("si crea(no) i(l) nuov(o)(i) stream per il {string} con replaceId {string} con un gruppo disponibile {string}")
    public void createdStreamByGroups(String pa, String replaceId, String position) {
        setPaWebhook(pa);
        List<String> listGroups = new ArrayList<>();
        switch (position) {
            case "FIRST":
                Assertions.assertNotNull(sharedSteps.getGroupIdByPa(pa, GroupPosition.FIRST));
                listGroups.add(sharedSteps.getGroupIdByPa(pa, GroupPosition.FIRST));
                break;
            case "LAST":
                Assertions.assertNotNull(sharedSteps.getGroupIdByPa(pa, GroupPosition.LAST));
                listGroups.add(sharedSteps.getGroupIdByPa(pa, GroupPosition.LAST));
                break;
            case "ALL":
                Assertions.assertNotNull(sharedSteps.getGroupAllActiveByPa(pa));
                listGroups = sharedSteps.getGroupAllActiveByPa(pa);
                break;
            case "UGUALI":
                Assertions.assertNotNull(sharedSteps.getRequestNewApiKey());
                listGroups = sharedSteps.getRequestNewApiKey().getGroups();
                break;
            case "ALTRA_PA":
                if ("Comune_1".equalsIgnoreCase(pa)){
                    pa = "Comune_Multi";
                    Assertions.assertNotNull(sharedSteps.getGroupIdByPa(pa, GroupPosition.LAST));
                    listGroups.add(sharedSteps.getGroupIdByPa(pa, GroupPosition.LAST));
                }else {
                    Assertions.assertNotNull(sharedSteps.getGroupIdByPa(pa, GroupPosition.LAST));
                    listGroups.add(sharedSteps.getGroupIdByPa(pa, GroupPosition.LAST));
                }
                break;
            case "NO_GROUPS":
                listGroups = null;
                break;

            default:
                throw new IllegalArgumentException();
        }

        this.eventStreamListV23 = new LinkedList<>();
        for(StreamCreationRequestV23 request: streamCreationRequestListV23){
            try{
                request.setGroups(listGroups);
                if ("SET".equalsIgnoreCase(replaceId)){
                    request.setReplacedStreamId(sharedSteps.getEventStreamV23().getStreamId());
                }
                StreamMetadataResponseV23 eventStream = webhookB2bClient.createEventStreamV23(request);
                this.eventStreamListV23.add(eventStream);
            }catch (HttpStatusCodeException e) {
                this.notificationError = e;
                if (e instanceof HttpStatusCodeException) {
                    sharedSteps.setNotificationError((HttpStatusCodeException) e);
                }
            }
        }
    }

    @And("si cancella(no) (lo)(gli) stream creat(o)(i) con versione {string} e apiKey aggiornata")
    public void deleteStreamUpadateApiKey(String versione) {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        deleteStream(versione);
    }
    @And("si cancella(no) (lo)(gli) stream creat(o)(i) con versione {string}")
    public void deleteStream(String versione) {
        switch (versione) {
            case "V10":
                for(StreamMetadataResponse eventStream: eventStreamList){
                    webhookB2bClient.deleteEventStream(eventStream.getStreamId());
                }
                break;
            case "V23":
                try{
                    for(StreamMetadataResponseV23 eventStream: eventStreamListV23){
                        webhookB2bClient.deleteEventStreamV23(eventStream.getStreamId());
                    }
                }catch (HttpStatusCodeException e) {
                    this.notificationError = e;
                    if (e instanceof HttpStatusCodeException) {
                        sharedSteps.setNotificationError((HttpStatusCodeException) e);
                    }
                }

                break;
            default:
                throw new IllegalArgumentException();
        }
    }


    @And("si aggiorna(no) (lo)(gli) stream creat(o)(i) con versione {string} e apiKey aggiornata")
    public void updateStreamUpadateApiKey(String versione) {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        updateStream(versione);
    }

    @And("si {string} un gruppo allo stream creat(o)(i) con versione {string} per il comune {string} e apiKey aggiornata")
    public void updateGroupsStreamUpadateApiKey(String action, String versione, String pa) {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        if(sharedSteps.getRequestNewApiKey()!= null){
            streamRequestV23 = new StreamRequestV23();
            if ("rimuove".equalsIgnoreCase(action) && sharedSteps.getRequestNewApiKey()!= null && sharedSteps.getRequestNewApiKey().getGroups().size()>=2) {
                streamRequestV23.setGroups(sharedSteps.getRequestNewApiKey().getGroups().subList(0, 0));
            } else if ("aggiunge".equalsIgnoreCase(action)) {
                streamRequestV23.setGroups(sharedSteps.getGroupAllActiveByPa(pa));
            }
        }


        updateStream(versione);
    }

    @And("si aggiorna(no) (lo)(gli) stream creat(o)(i) con versione {string} con un gruppo che non appartiene al comune {string}")
    public void updateStreamByGroupsNoPA(String versione,String pa) {

        try {
            streamRequest = new StreamRequestV23();
            if ("Comune_1".equalsIgnoreCase(pa)) {
                streamRequest.setGroups(List.of(sharedSteps.getGroupIdByPa("Comune_Multi", GroupPosition.FIRST)));
            }else {
                streamRequest.setGroups(List.of(sharedSteps.getGroupIdByPa("Comune_1", GroupPosition.FIRST)));
            }

        } catch (HttpStatusCodeException e) {
            this.notificationError = e;
            if (e instanceof HttpStatusCodeException) {
                sharedSteps.setNotificationError((HttpStatusCodeException) e);
            }
        }
        updateStream(versione);
    }

    @And("si aggiorna(no) (lo)(gli) stream creat(o)(i) con versione {string} -Cross Versioning")
    public void updateStreamVersioning (String versione) {

        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        UUID idStream = null;
        if (eventStreamList!= null && !eventStreamList.isEmpty()){
            idStream = eventStreamList.get(0).getStreamId();
        } else if (eventStreamListV23 != null && !eventStreamListV23.isEmpty()) {
            idStream = eventStreamListV23.get(0).getStreamId();
        }
        switch (versione) {
            case "V10":
                webhookB2bClient.updateEventStream(idStream,null);
                break;
            case "V23":
                try{
                    webhookB2bClient.updateEventStreamV23(idStream,streamRequestV23);
                }catch (HttpStatusCodeException e) {
                    this.notificationError = e;
                    if (e instanceof HttpStatusCodeException) {
                        sharedSteps.setNotificationError((HttpStatusCodeException) e);
                    }
                }
                break;
            default:
                throw new IllegalArgumentException();
        }
    }

    @And("si aggiorna(no) (lo)(gli) stream creat(o)(i) con versione {string}")
    public void updateStream (String versione) {

        switch (versione) {
            case "V10":
                for(StreamMetadataResponse eventStream: eventStreamList){
                    webhookB2bClient.updateEventStream(eventStream.getStreamId(),null);
                }
                break;
            case "V23":
                try{
                    streamRequest = new StreamRequestV23();
                    streamRequest.setGroups(sharedSteps.getRequestNewApiKey().getGroups());
                    for(StreamMetadataResponseV23 eventStream: eventStreamListV23){
                        webhookB2bClient.updateEventStreamV23(eventStream.getStreamId(),streamRequestV23);
                    }
                }catch (HttpStatusCodeException e) {
                    this.notificationError = e;
                    if (e instanceof HttpStatusCodeException) {
                        sharedSteps.setNotificationError((HttpStatusCodeException) e);
                    }
                }

                break;
            default:
                throw new IllegalArgumentException();
        }
    }



    @And("si disabilita(no) (lo)(gli) stream creat(o)(i) con versione {string} e apiKey aggiornata")
    public void disableStreamUpdateApiKey(String versione) {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        disableStream(versione);
    }

    @And("si disabilita(no) (lo)(gli) stream che non esiste e apiKey aggiornata")
    public void disableStreamNotexist() {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        try{
            webhookB2bClient.disableEventStreamV23(UUID.randomUUID());
        }catch (HttpStatusCodeException e) {
            this.notificationError = e;
            if (e instanceof HttpStatusCodeException) {
                sharedSteps.setNotificationError((HttpStatusCodeException) e);
            }
        }
    }

    @And("si cancella(no) (lo)(gli) stream che non esiste e apiKey aggiornata")
    public void deleteStreamNotexist() {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        try{
            webhookB2bClient.deleteEventStreamV23(UUID.randomUUID());
        }catch (HttpStatusCodeException e) {
            this.notificationError = e;
            if (e instanceof HttpStatusCodeException) {
                sharedSteps.setNotificationError((HttpStatusCodeException) e);
            }
        }
    }

    @And("si consuma(no) (lo)(gli) stream che non esiste e apiKey aggiornata")
    public void consumeStreamNotexist() {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        try{
            webhookB2bClient.consumeEventStreamHttpV23(UUID.randomUUID(), null);
        }catch (HttpStatusCodeException e) {
            this.notificationError = e;
            if (e instanceof HttpStatusCodeException) {
                sharedSteps.setNotificationError((HttpStatusCodeException) e);
            }
        }
    }

    @And("si legge(no) (lo)(gli) stream che non esiste e apiKey aggiornata")
    public void readStreamNotexist() {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        try{
            webhookB2bClient.getEventStream(UUID.randomUUID());
        }catch (HttpStatusCodeException e) {
            this.notificationError = e;
            if (e instanceof HttpStatusCodeException) {
                sharedSteps.setNotificationError((HttpStatusCodeException) e);
            }
        }
    }

    @And("si aggiorna(no) (lo)(gli) stream che non esiste e apiKey aggiornata")
    public void updateStreamNotexist() {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        try{
            webhookB2bClient.updateEventStreamV23(UUID.randomUUID(),new StreamRequestV23());
        }catch (HttpStatusCodeException e) {
            this.notificationError = e;
            if (e instanceof HttpStatusCodeException) {
                sharedSteps.setNotificationError((HttpStatusCodeException) e);
            }
        }
    }

    @And("si disabilita(no) (lo)(gli) stream creat(o)(i) con versione {string}")
    public void disableStream(String versione) {
        switch (versione) {
            case "V23":
                try{
                    for(StreamMetadataResponseV23 eventStream: eventStreamListV23){
                        webhookB2bClient.disableEventStreamV23(eventStream.getStreamId());
                    }
                }catch (HttpStatusCodeException e) {
                    this.notificationError = e;
                    if (e instanceof HttpStatusCodeException) {
                        sharedSteps.setNotificationError((HttpStatusCodeException) e);
                    }
                }
                break;
            default:
                throw new IllegalArgumentException();
        }
    }

    @And("viene verificata la corretta cancellazione con versione {string}")
    public void verifiedTheCorrectDeletion(String versione) {
        switch (versione) {
            case "V10":
                List<StreamListElement> streamListElements = webhookB2bClient.listEventStreams();
                for(StreamMetadataResponse eventStream: eventStreamList){
                    StreamListElement streamListElement = streamListElements.stream().filter(elem -> elem.getStreamId() == eventStream.getStreamId()).findAny().orElse(null);
                    Assertions.assertNull(streamListElement);
                }
                break;
            case "V23":
                List<it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.StreamListElement> streamListElementsV23 = webhookB2bClient.listEventStreamsV23();
                for(StreamMetadataResponseV23 eventStream: eventStreamListV23){
                    it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.StreamListElement streamListElementV23 = streamListElementsV23.stream().filter(elem -> elem.getStreamId() == eventStream.getStreamId()).findAny().orElse(null);
                    Assertions.assertNull(streamListElementV23);
                }
                break;
            default:
                throw new IllegalArgumentException();
        }
    }

    @Then("lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione {string} e apiKey aggiornata")
    public void streamBeenCreatedAndCorrectlyRetrievedByStreamIdUpdateApiKey(String versione) {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        streamBeenCreatedAndCorrectlyRetrievedByStreamId(versione);
    }

    @Then("lo stream è stato creato e viene correttamente recuperato dal sistema tramite stream id con versione {string}")
    public void streamBeenCreatedAndCorrectlyRetrievedByStreamId(String versione) {

        switch (versione) {
            case "V10":
                Assertions.assertDoesNotThrow(() -> {
                    StreamMetadataResponse eventStream = webhookB2bClient.getEventStream(this.eventStreamList.get(0).getStreamId());
                });
                sharedSteps.setEventStream(webhookB2bClient.getEventStream(this.eventStreamList.get(0).getStreamId()));
                break;
            case "V23":
                Assertions.assertDoesNotThrow(() -> {
                    StreamMetadataResponseV23 eventStream = webhookB2bClient.getEventStreamV23(this.eventStreamListV23.get(0).getStreamId());
                });
                sharedSteps.setEventStreamV23(webhookB2bClient.getEventStreamV23(this.eventStreamListV23.get(0).getStreamId()));
                break;
            default:
                throw new IllegalArgumentException();
        }
    }

    @And("lo stream viene recuperato dal sistema tramite stream id con versione {string} e apiKey aggiornata")
    public void streamBeenRetrievedByStreamIdUpdateApiKey(String versione) {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        streamBeenRetrievedByStreamId(versione);
    }

    @Then("lo stream viene recuperato dal sistema tramite stream id con versione {string}")
    public void streamBeenRetrievedByStreamId(String versione) {

        switch (versione) {
            case "V10":
                try{
                    StreamMetadataResponse eventStream = webhookB2bClient.getEventStream(this.eventStreamList.get(0).getStreamId());
                }catch (HttpStatusCodeException e) {
                    this.notificationError = e;
                    if (e instanceof HttpStatusCodeException) {
                        sharedSteps.setNotificationError((HttpStatusCodeException) e);
                    }
                }
                break;
            case "V23":
                try{
                    StreamMetadataResponseV23 eventStream = webhookB2bClient.getEventStreamV23(this.eventStreamListV23.get(0).getStreamId());
                }catch (HttpStatusCodeException e) {
                    this.notificationError = e;
                    if (e instanceof HttpStatusCodeException) {
                        sharedSteps.setNotificationError((HttpStatusCodeException) e);
                    }
                }
                break;
            default:
                throw new IllegalArgumentException();
        }
    }

    @And("vengono letti gli eventi dello stream versione V23")
    public void readStreamEventsV23() {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        try{
            List<ProgressResponseElement> progressResponseElements = webhookB2bClient.consumeEventStream(this.eventStreamList.get(0).getStreamId(), null);
            logger.info("EventProgress: " + progressResponseElements);
        }catch (HttpStatusCodeException e) {
            this.notificationError = e;
            if (e instanceof HttpStatusCodeException) {
                sharedSteps.setNotificationError((HttpStatusCodeException) e);
            }
        }
    }


    @And("vengono letti gli eventi dello stream")
    public void readStreamEvents() {
        Assertions.assertDoesNotThrow(() -> {
            List<ProgressResponseElement> progressResponseElements = webhookB2bClient.consumeEventStream(this.eventStreamList.get(0).getStreamId(), null);
            logger.info("EventProgress: " + progressResponseElements);
        });
    }



    @And("vengono letti gli eventi dello stream del {string} fino allo stato {string}")
    public void readStreamEventsState(String pa,String status) {
        Integer numCheck = 10;
        Integer waiting = sharedSteps.getWorkFlowWait();

        setPaWebhook(pa);
        NotificationStatus notificationStatus;
        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus notificationInternalStatus;
        switch (status) {
            case "ACCEPTED":
                numCheck = 2;
                notificationStatus = NotificationStatus.ACCEPTED;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.ACCEPTED;
                break;
            case "DELIVERING":
                numCheck = 2;
                waiting = waiting * 4;
                notificationStatus = NotificationStatus.DELIVERING;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.DELIVERING;
                break;
            case "DELIVERED":
                numCheck = 3;
                waiting = waiting * 4;
                notificationStatus = NotificationStatus.DELIVERED;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.DELIVERED;
                break;
            case "CANCELLED":
                notificationStatus = NotificationStatus.CANCELLED;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.CANCELLED;
                break;
            case "EFFECTIVE_DATE":
                notificationStatus = NotificationStatus.EFFECTIVE_DATE;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.EFFECTIVE_DATE;
                break;

            case "REFUSED":
                notificationStatus = NotificationStatus.REFUSED;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.REFUSED;
                break;

            default:
                throw new IllegalArgumentException();
        }
        ProgressResponseElement progressResponseElement = null;

        boolean finded = false;
        for (int i = 0; i < numCheck; i++) {

            try {
                Thread.sleep(waiting);
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }

            sharedSteps.setSentNotification(b2bClient.getSentNotification(sharedSteps.getSentNotification().getIun()));
            NotificationStatusHistoryElement notificationStatusHistoryElement = sharedSteps.getSentNotification().getNotificationStatusHistory().stream().filter(elem -> elem.getStatus().equals(notificationInternalStatus)).findAny().orElse(null);

            if (notificationStatusHistoryElement != null) {
                finded = true;
                break;
            }
        }

        Assertions.assertTrue(finded);
        for (int i = 0; i < 4; i++) {
            progressResponseElement = searchInWebhook(notificationStatus,null,0);
            logger.debug("PROGRESS-ELEMENT: "+progressResponseElement);

            if (progressResponseElement != null) {
                break;
            }

            try {
                Thread.sleep(sharedSteps.getWait());
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }
        }

        try{
            Assertions.assertNotNull(progressResponseElement);
            logger.info("EventProgress: " + progressResponseElement);
        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    " {IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }

    }

    @And("vengono letti gli eventi dello stream del {string} fino allo stato {string} con la versione V23")
    public void readStreamEventsStateV23(String pa,String status) {
        Integer numCheck = 10;
        Integer waiting = sharedSteps.getWorkFlowWait();

        setPaWebhook(pa);
        NotificationStatus notificationStatus;
        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus notificationInternalStatus;
        switch (status) {
            case "ACCEPTED":
                numCheck = 2;
                notificationStatus = NotificationStatus.ACCEPTED;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.ACCEPTED;
                break;
            case "DELIVERING":
                numCheck = 2;
                waiting = waiting * 4;
                notificationStatus = NotificationStatus.DELIVERING;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.DELIVERING;
                break;
            case "DELIVERED":
                numCheck = 3;
                waiting = waiting * 4;
                notificationStatus = NotificationStatus.DELIVERED;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.DELIVERED;
                break;
            case "CANCELLED":
                notificationStatus = NotificationStatus.CANCELLED;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.CANCELLED;
                break;
            case "EFFECTIVE_DATE":
                notificationStatus = NotificationStatus.EFFECTIVE_DATE;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.EFFECTIVE_DATE;
                break;

            case "REFUSED":
                notificationStatus = NotificationStatus.REFUSED;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.REFUSED;
                break;

            default:
                throw new IllegalArgumentException();
        }
        ProgressResponseElementV23 progressResponseElement = null;

        boolean finded = false;
        for (int i = 0; i < numCheck; i++) {

            try {
                Thread.sleep(waiting);
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }

            sharedSteps.setSentNotification(b2bClient.getSentNotification(sharedSteps.getSentNotification().getIun()));
            NotificationStatusHistoryElement notificationStatusHistoryElement = sharedSteps.getSentNotification().getNotificationStatusHistory().stream().filter(elem -> elem.getStatus().equals(notificationInternalStatus)).findAny().orElse(null);

            if (notificationStatusHistoryElement != null) {
                finded = true;
                break;
            }
        }

        Assertions.assertTrue(finded);
        for (int i = 0; i < 4; i++) {
            progressResponseElement = searchInWebhookV23(notificationStatus,null,0,0);
            logger.debug("PROGRESS-ELEMENT: "+progressResponseElement);

            if (progressResponseElement != null) {
                break;
            }

            try {
                Thread.sleep(sharedSteps.getWait());
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }
        }

        try{
            Assertions.assertNotNull(progressResponseElement);
            logger.info("EventProgress: " + progressResponseElement);
        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    " {IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }

    }



    @And("vengono letti gli eventi dello stream del {string} fino allo stato {string} con versione V23 e apiKey aggiornata con position {int}")
    public void readStreamEventsStateV23(String pa,String status, Integer position) {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        setPaWebhook(pa);
        NotificationStatus notificationStatus;
        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus notificationInternalStatus;
        switch (status) {
            case "ACCEPTED":
                notificationStatus = NotificationStatus.ACCEPTED;
                break;
            case "DELIVERING":
                notificationStatus = NotificationStatus.DELIVERING;
                break;
            case "DELIVERED":
                notificationStatus = NotificationStatus.DELIVERED;
                break;
            case "CANCELLED":
                notificationStatus = NotificationStatus.CANCELLED;
                break;
            case "EFFECTIVE_DATE":
                notificationStatus = NotificationStatus.EFFECTIVE_DATE;
                break;

            case "REFUSED":
                notificationStatus = NotificationStatus.REFUSED;
                break;

            default:
                throw new IllegalArgumentException();
        }
        ProgressResponseElementV23 progressResponseElement = null;

        for (int i = 0; i < 4; i++) {
            progressResponseElement = searchInWebhookV23(notificationStatus,null,0,position);
            logger.debug("PROGRESS-ELEMENT: "+progressResponseElement);

            if (progressResponseElement != null) {
                break;
            }

            try {
                Thread.sleep(sharedSteps.getWait());
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }
        }

        try{
            Assertions.assertNotNull(progressResponseElement);
            logger.info("EventProgress: " + progressResponseElement);
        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    " {IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }

    }


    @And("vengono letti gli eventi dello stream del {string} del validatore fino allo stato {string}")
    public void readStreamEventsStateValidatore(String pa,String status) {
        setPaWebhook(pa);
        NotificationStatus notificationStatus;
        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus notificationInternalStatus;
        switch (status) {
            case "ACCEPTED":
                notificationStatus = NotificationStatus.ACCEPTED;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.ACCEPTED;
                break;
            case "DELIVERING":
                notificationStatus = NotificationStatus.DELIVERING;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.DELIVERING;
                break;
            case "DELIVERED":
                notificationStatus = NotificationStatus.DELIVERED;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.DELIVERED;
                break;
            case "CANCELLED":
                notificationStatus = NotificationStatus.CANCELLED;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.CANCELLED;
                break;
            case "EFFECTIVE_DATE":
                notificationStatus = NotificationStatus.EFFECTIVE_DATE;
                notificationInternalStatus =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.NotificationStatus.EFFECTIVE_DATE;
                break;
            default:
                throw new IllegalArgumentException();
        }
        ProgressResponseElement progressResponseElement = null;
        int wait = 48;
        boolean finded = false;
        for (int i = 0; i < wait; i++) {
            progressResponseElement = searchInWebhook(notificationStatus,null,0);
            logger.debug("PROGRESS-ELEMENT: "+progressResponseElement);

            sharedSteps.setSentNotification(b2bClient.getSentNotification(sharedSteps.getSentNotification().getIun()));
            NotificationStatusHistoryElement notificationStatusHistoryElement = sharedSteps.getSentNotification().getNotificationStatusHistory().stream().filter(elem -> elem.getStatus().equals(notificationInternalStatus)).findAny().orElse(null);
            if (notificationStatusHistoryElement != null && !finded) {
                wait = i + 4;
                finded = true;
            }
            if (progressResponseElement != null) {
                break;
            }
            try {
                Thread.sleep(10 * 1000L);
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }
        }
        try{
            Assertions.assertNotNull(progressResponseElement);
            logger.info("EventProgress: " + progressResponseElement);
        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    " {IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }

    }

    @And("vengono letti gli eventi dello stream del {string} con la verifica di Allegato non trovato con la versione V23")
    public void readStreamEventsStateRefusedV23(String pa) {

        setPaWebhook(pa);
        NotificationStatus notificationStatus;
        notificationStatus = NotificationStatus.REFUSED;
        ProgressResponseElementV23 progressResponseElement = null;

        for (int i = 0; i < 4; i++) {
            progressResponseElement = searchInWebhookFileNotFoundV23(notificationStatus,null,0);
            logger.debug("PROGRESS-ELEMENT: "+progressResponseElement);

            if (progressResponseElement != null) {
                break;
            }

            try {
                Thread.sleep(sharedSteps.getWait());
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }
        }

        try{
            Assertions.assertNotNull(progressResponseElement);
            logger.info("EventProgress: " + progressResponseElement);
        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    " {IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }
    }

    @And("vengono letti gli eventi dello stream del {string} con la verifica di Allegato non trovato")
    public void readStreamEventsStateRefused(String pa) {

        setPaWebhook(pa);
        NotificationStatus notificationStatus;
        notificationStatus = NotificationStatus.REFUSED;
        ProgressResponseElement progressResponseElement = null;

        for (int i = 0; i < 4; i++) {
            progressResponseElement = searchInWebhookFileNotFound(notificationStatus,null,0);
            logger.debug("PROGRESS-ELEMENT: "+progressResponseElement);

            if (progressResponseElement != null) {
                break;
            }

            try {
                Thread.sleep(sharedSteps.getWait());
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }
        }

        try{
            Assertions.assertNotNull(progressResponseElement);
            logger.info("EventProgress: " + progressResponseElement);
        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    " {IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }
    }

    @Then("vengono letti gli eventi dello stream del {string} fino all'elemento di timeline {string}")
    public void readStreamTimelineElement(String pa,String timelineEventCategory) {
        setPaWebhook(pa);
        it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23 timelineElementCategory;
        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23 timelineElementInternalCategory;

        Integer numCheck = 10;
        Integer waiting = sharedSteps.getWorkFlowWait();

        switch (timelineEventCategory) {
            case "REQUEST_ACCEPTED":
                numCheck = 2;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.REQUEST_ACCEPTED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.REQUEST_ACCEPTED;
                break;
            case "AAR_GENERATION":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.AAR_GENERATION;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.AAR_GENERATION;
                break;
            case "GET_ADDRESS":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.GET_ADDRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.GET_ADDRESS;
                break;
            case "SEND_DIGITAL_DOMICILE":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.SEND_DIGITAL_DOMICILE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_DOMICILE;
                break;
            case "NOTIFICATION_VIEWED":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.NOTIFICATION_VIEWED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_VIEWED;
                break;
            case "SEND_COURTESY_MESSAGE":
                numCheck = 10;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.SEND_COURTESY_MESSAGE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_COURTESY_MESSAGE;
                break;
            case "DIGITAL_FAILURE_WORKFLOW":
                numCheck = 9;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.DIGITAL_FAILURE_WORKFLOW;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.DIGITAL_FAILURE_WORKFLOW;
                break;
            case "DIGITAL_SUCCESS_WORKFLOW":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.DIGITAL_SUCCESS_WORKFLOW;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.DIGITAL_SUCCESS_WORKFLOW;
                break;
            case "SCHEDULE_ANALOG_WORKFLOW":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.SCHEDULE_ANALOG_WORKFLOW;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SCHEDULE_ANALOG_WORKFLOW;
                break;
            case "NOT_HANDLED":
                numCheck = 9;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.NOT_HANDLED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOT_HANDLED;
                break;
            case "SEND_DIGITAL_FEEDBACK":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.SEND_DIGITAL_FEEDBACK;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_FEEDBACK;
                break;
            case "SEND_ANALOG_PROGRESS":
                numCheck = 8;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.SEND_ANALOG_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_PROGRESS;
                break;
            case "SEND_ANALOG_FEEDBACK":
                numCheck = 10;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.SEND_ANALOG_FEEDBACK;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_FEEDBACK;
                break;
            case "SEND_ANALOG_DOMICILE":
                numCheck = 9;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.SEND_ANALOG_DOMICILE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_DOMICILE;
                break;
            case "SEND_DIGITAL_PROGRESS":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.SEND_DIGITAL_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_PROGRESS;
                break;
            case "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS":
                numCheck = 15;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS;
                break;
            case "PUBLIC_REGISTRY_CALL":
                numCheck = 2;
                waiting = waiting * 4;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.PUBLIC_REGISTRY_CALL;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.PUBLIC_REGISTRY_CALL;
                break;
            case "PUBLIC_REGISTRY_RESPONSE":
                numCheck = 2;
                waiting = waiting * 4;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.PUBLIC_REGISTRY_RESPONSE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.PUBLIC_REGISTRY_RESPONSE;
                break;
            case "PAYMENT":
                numCheck = 9;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.PAYMENT;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.PAYMENT;
                break;
            case "NOTIFICATION_CANCELLATION_REQUEST":
                numCheck = 9;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.NOTIFICATION_CANCELLATION_REQUEST;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_CANCELLATION_REQUEST;
                break;
            case "NOTIFICATION_CANCELLED":
                numCheck = 10;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.NOTIFICATION_CANCELLED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_CANCELLED;
                break;
            case "REFINEMENT":
                numCheck = 15;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.REFINEMENT;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.REFINEMENT;
                break;
            default:
                throw new IllegalArgumentException();
        }
        ProgressResponseElement progressResponseElement = null;

        boolean finish = false;
        for (int i = 0; i < numCheck; i++) {

            try {
                Thread.sleep(waiting);
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }

            sharedSteps.setSentNotification(b2bClient.getSentNotification(sharedSteps.getSentNotification().getIun()));
            TimelineElementV23 timelineElement = sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals(timelineElementInternalCategory)).findAny().orElse(null);
            if (timelineElement != null) {
                finish = true;
                break;
            }
        }

        Assertions.assertTrue(finish);
        for (int i = 0; i < 4; i++) {
            progressResponseElement = searchInWebhook(timelineElementCategory,null,0);
            logger.debug("PROGRESS-ELEMENT: "+progressResponseElement);

            if (progressResponseElement != null) {
                break;
            }

            try {
                Thread.sleep(sharedSteps.getWait());
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }
        }
        try{
            Assertions.assertNotNull(progressResponseElement);
            Assertions.assertNotSame(progressResponseElement.getTimestamp(), sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals(timelineElementInternalCategory)).findAny().get().getTimestamp());
            logger.info("EventProgress: " + progressResponseElement);

        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    "{IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }
    }


    @Then("vengono letti gli eventi dello stream del {string} fino all'elemento di timeline {string} con la versione V23")
    public void readStreamTimelineElementV23(String pa,String timelineEventCategory) {
        setPaWebhook(pa);
        it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23 timelineElementCategory;
        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23 timelineElementInternalCategory;

        Integer numCheck = 10;
        Integer waiting = sharedSteps.getWorkFlowWait();

        switch (timelineEventCategory) {
            case "REQUEST_ACCEPTED":
                numCheck = 2;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.REQUEST_ACCEPTED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.REQUEST_ACCEPTED;
                break;
            case "AAR_GENERATION":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.AAR_GENERATION;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.AAR_GENERATION;
                break;
            case "GET_ADDRESS":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.GET_ADDRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.GET_ADDRESS;
                break;
            case "SEND_DIGITAL_DOMICILE":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.SEND_DIGITAL_DOMICILE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_DOMICILE;
                break;
            case "NOTIFICATION_VIEWED":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.NOTIFICATION_VIEWED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_VIEWED;
                break;
            case "SEND_COURTESY_MESSAGE":
                numCheck = 10;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.SEND_COURTESY_MESSAGE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_COURTESY_MESSAGE;
                break;
            case "DIGITAL_FAILURE_WORKFLOW":
                numCheck = 9;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.DIGITAL_FAILURE_WORKFLOW;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.DIGITAL_FAILURE_WORKFLOW;
                break;
            case "DIGITAL_SUCCESS_WORKFLOW":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.DIGITAL_SUCCESS_WORKFLOW;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.DIGITAL_SUCCESS_WORKFLOW;
                break;
            case "SCHEDULE_ANALOG_WORKFLOW":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.SCHEDULE_ANALOG_WORKFLOW;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SCHEDULE_ANALOG_WORKFLOW;
                break;
            case "NOT_HANDLED":
                numCheck = 9;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.NOT_HANDLED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOT_HANDLED;
                break;
            case "SEND_DIGITAL_FEEDBACK":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.SEND_DIGITAL_FEEDBACK;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_FEEDBACK;
                break;
            case "SEND_ANALOG_PROGRESS":
                numCheck = 8;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.SEND_ANALOG_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_PROGRESS;
                break;
            case "SEND_ANALOG_FEEDBACK":
                numCheck = 10;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.SEND_ANALOG_FEEDBACK;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_FEEDBACK;
                break;
            case "SEND_ANALOG_DOMICILE":
                numCheck = 9;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.SEND_ANALOG_DOMICILE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_DOMICILE;
                break;
            case "SEND_DIGITAL_PROGRESS":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.SEND_DIGITAL_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_PROGRESS;
                break;
            case "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS":
                numCheck = 15;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS;
                break;
            case "PUBLIC_REGISTRY_CALL":
                numCheck = 2;
                waiting = waiting * 4;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.PUBLIC_REGISTRY_CALL;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.PUBLIC_REGISTRY_CALL;
                break;
            case "PUBLIC_REGISTRY_RESPONSE":
                numCheck = 2;
                waiting = waiting * 4;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.PUBLIC_REGISTRY_RESPONSE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.PUBLIC_REGISTRY_RESPONSE;
                break;
            case "PAYMENT":
                numCheck = 9;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.PAYMENT;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.PAYMENT;
                break;
            case "NOTIFICATION_CANCELLATION_REQUEST":
                numCheck = 9;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.NOTIFICATION_CANCELLATION_REQUEST;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_CANCELLATION_REQUEST;
                break;
            case "NOTIFICATION_CANCELLED":
                numCheck = 10;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.NOTIFICATION_CANCELLED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_CANCELLED;
                break;
            case "REFINEMENT":
                numCheck = 15;
                timelineElementCategory = it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23.REFINEMENT;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.REFINEMENT;
                break;
            default:
                throw new IllegalArgumentException();
        }
        ProgressResponseElementV23 progressResponseElement = null;

        boolean finish = false;
        for (int i = 0; i < numCheck; i++) {

            try {
                Thread.sleep(waiting);
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }

            sharedSteps.setSentNotification(b2bClient.getSentNotification(sharedSteps.getSentNotification().getIun()));
            TimelineElementV23 timelineElement = sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals(timelineElementInternalCategory)).findAny().orElse(null);
            if (timelineElement != null) {
                finish = true;
                break;
            }
        }

        Assertions.assertTrue(finish);
        for (int i = 0; i < 4; i++) {
            progressResponseElement = searchInWebhookV23(timelineElementCategory,null,0,0);
            logger.debug("PROGRESS-ELEMENT: "+progressResponseElement);

            if (progressResponseElement != null) {
                break;
            }

            try {
                Thread.sleep(sharedSteps.getWait());
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }
        }
        try{
            Assertions.assertNotNull(progressResponseElement);
            // Assertions.assertNotSame(progressResponseElement.getTimestamp(), sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals(timelineElementInternalCategory)).findAny().get().getTimestamp());
            logger.info("EventProgress: " + progressResponseElement);

        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    "{IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }
    }

    @Then("verifica non presenza di eventi nello stream del {string}")
    public void readStreamTimelineElementNotPresent(String pa,String timelineEventCategory,Integer position) {
        if (sharedSteps.getResponseNewApiKey() != null) {
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        ProgressResponseElement progressResponseElement = null;
        ResponseEntity<List<ProgressResponseElement>> listResponseEntity = webhookB2bClient.consumeEventStreamHttp(this.eventStreamList.get(0).getStreamId(), null);
        List<ProgressResponseElement> progressResponseElements = listResponseEntity.getBody();
        Assertions.assertTrue(progressResponseElements.isEmpty());

    }


    @Then("vengono letti gli eventi dello stream del {string} fino all'elemento di timeline {string} con versione V23 e apiKey aggiornata con position {int}")
    public void readStreamTimelineElementV23(String pa,String timelineEventCategory,Integer position) {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        setPaWebhook(pa);
        TimelineElementCategoryV23 timelineElementCategory;
        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23 timelineElementInternalCategory;

        Integer numCheck = 10;
        Integer waiting = sharedSteps.getWorkFlowWait();

        switch (timelineEventCategory) {
            case "REQUEST_ACCEPTED":
                numCheck = 2;
                timelineElementCategory = TimelineElementCategoryV23.REQUEST_ACCEPTED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.REQUEST_ACCEPTED;
                break;
            case "AAR_GENERATION":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = TimelineElementCategoryV23.AAR_GENERATION;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.AAR_GENERATION;
                break;
            case "GET_ADDRESS":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = TimelineElementCategoryV23.GET_ADDRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.GET_ADDRESS;
                break;
            case "SEND_DIGITAL_DOMICILE":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = TimelineElementCategoryV23.SEND_DIGITAL_DOMICILE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_DOMICILE;
                break;
            case "NOTIFICATION_VIEWED":
                numCheck = 2;
                waiting = waiting * 2;
                timelineElementCategory = TimelineElementCategoryV23.NOTIFICATION_VIEWED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_VIEWED;
                break;
            case "SEND_COURTESY_MESSAGE":
                numCheck = 10;
                timelineElementCategory = TimelineElementCategoryV23.SEND_COURTESY_MESSAGE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_COURTESY_MESSAGE;
                break;
            case "DIGITAL_FAILURE_WORKFLOW":
                numCheck = 9;
                timelineElementCategory = TimelineElementCategoryV23.DIGITAL_FAILURE_WORKFLOW;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.DIGITAL_FAILURE_WORKFLOW;
                break;
            case "DIGITAL_SUCCESS_WORKFLOW":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = TimelineElementCategoryV23.DIGITAL_SUCCESS_WORKFLOW;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.DIGITAL_SUCCESS_WORKFLOW;
                break;
            case "SCHEDULE_ANALOG_WORKFLOW":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = TimelineElementCategoryV23.SCHEDULE_ANALOG_WORKFLOW;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SCHEDULE_ANALOG_WORKFLOW;
                break;
            case "NOT_HANDLED":
                numCheck = 9;
                timelineElementCategory = TimelineElementCategoryV23.NOT_HANDLED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOT_HANDLED;
                break;
            case "SEND_DIGITAL_FEEDBACK":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = TimelineElementCategoryV23.SEND_DIGITAL_FEEDBACK;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_FEEDBACK;
                break;
            case "SEND_ANALOG_PROGRESS":
                numCheck = 8;
                timelineElementCategory = TimelineElementCategoryV23.SEND_ANALOG_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_PROGRESS;
                break;
            case "SEND_ANALOG_FEEDBACK":
                numCheck = 10;
                timelineElementCategory = TimelineElementCategoryV23.SEND_ANALOG_FEEDBACK;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_FEEDBACK;
                break;
            case "SEND_ANALOG_DOMICILE":
                numCheck = 9;
                timelineElementCategory = TimelineElementCategoryV23.SEND_ANALOG_DOMICILE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_DOMICILE;
                break;
            case "SEND_DIGITAL_PROGRESS":
                numCheck = 2;
                waiting = waiting * 3;
                timelineElementCategory = TimelineElementCategoryV23.SEND_DIGITAL_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_PROGRESS;
                break;
            case "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS":
                numCheck = 15;
                timelineElementCategory = TimelineElementCategoryV23.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS;
                break;
            case "PUBLIC_REGISTRY_CALL":
                numCheck = 2;
                waiting = waiting * 4;
                timelineElementCategory = TimelineElementCategoryV23.PUBLIC_REGISTRY_CALL;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.PUBLIC_REGISTRY_CALL;
                break;
            case "PUBLIC_REGISTRY_RESPONSE":
                numCheck = 2;
                waiting = waiting * 4;
                timelineElementCategory = TimelineElementCategoryV23.PUBLIC_REGISTRY_RESPONSE;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.PUBLIC_REGISTRY_RESPONSE;
                break;
            case "PAYMENT":
                numCheck = 9;
                timelineElementCategory = TimelineElementCategoryV23.PAYMENT;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.PAYMENT;
                break;
            case "NOTIFICATION_CANCELLATION_REQUEST":
                numCheck = 9;
                timelineElementCategory = TimelineElementCategoryV23.NOTIFICATION_CANCELLATION_REQUEST;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_CANCELLATION_REQUEST;
                break;
            case "NOTIFICATION_CANCELLED":
                numCheck = 10;
                timelineElementCategory = TimelineElementCategoryV23.NOTIFICATION_CANCELLED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_CANCELLED;
                break;
            case "REFINEMENT":
                numCheck = 15;
                timelineElementCategory = TimelineElementCategoryV23.REFINEMENT;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.REFINEMENT;
                break;
            case "NOTIFICATION_RADD_RETRIEVED":
                numCheck = 15;
                timelineElementCategory = TimelineElementCategoryV23.NOTIFICATION_RADD_RETRIEVED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_RADD_RETRIEVED;
                break;


            default:
                throw new IllegalArgumentException();
        }
        ProgressResponseElementV23 progressResponseElement = null;


        for (int i = 0; i < 4; i++) {
            progressResponseElement = searchInWebhookV23(timelineElementCategory,null,0, position);
            logger.debug("PROGRESS-ELEMENT: "+progressResponseElement);

            if (progressResponseElement != null) {
                break;
            }

            try {
                Thread.sleep(sharedSteps.getWait());
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }
        }
        try{
            Assertions.assertNotNull(progressResponseElement);
            //TODO Verificare...
            Assertions.assertNotSame(progressResponseElement.getElement().getTimestamp(), sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals(timelineElementInternalCategory)).findAny().get().getTimestamp());
            //  Assertions.assertNotSame(progressResponseElement.getTimestamp(), sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals(timelineElementInternalCategory)).findAny().get().getTimestamp());
            logger.info("EventProgress: " + progressResponseElement);
            sharedSteps.setProgressResponseElementV23(progressResponseElement);
        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    "{IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }
    }



    @Then("Si verifica che l'elemento di timeline REFINEMENT abbia il timestamp uguale a quella presente nel webhook")
    public void readStreamTimelineElementAndVerifyDate() {
        OffsetDateTime EventTimestamp=null;
        OffsetDateTime NotificationTimestamp=null;
        try{
            Assertions.assertNotNull(progressResponseElementList);

            EventTimestamp = progressResponseElementList.stream().filter(elem -> elem.getTimelineEventCategory().equals( it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23.REFINEMENT)).findAny().get().getTimestamp();
            NotificationTimestamp =sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals( it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SCHEDULE_REFINEMENT)).findAny().get().getDetails().getSchedulingDate();
            logger.info("event timestamp : {}",EventTimestamp);
            logger.info("notification timestamp : {}",NotificationTimestamp);

            Assertions.assertNotSame(EventTimestamp,NotificationTimestamp);

        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    "{IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }
    }

    @Then("Si verifica che l'elemento di timeline REFINEMENT abbia il timestamp uguale a quella presente nel webhook con la versione V23")
    public void readStreamTimelineElementAndVerifyDateV23() {
        OffsetDateTime EventTimestamp=null;
        OffsetDateTime NotificationTimestamp=null;
        try{
            Assertions.assertNotNull(progressResponseElementListV23);
            //TODO Verificare...
            EventTimestamp = progressResponseElementListV23.stream().filter(elem -> elem.getElement().getCategory().equals(TimelineElementCategoryV23.REFINEMENT)).findAny().get().getElement().getTimestamp();
            //EventTimestamp = progressResponseElementListV23.stream().filter(elem -> elem.getTimelineEventCategory().equals(TimelineElementCategoryV23.REFINEMENT)).findAny().get().getTimestamp();
            NotificationTimestamp =sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals( it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SCHEDULE_REFINEMENT)).findAny().get().getDetails().getSchedulingDate();
            logger.info("event timestamp : {}",EventTimestamp);
            logger.info("notification timestamp : {}",NotificationTimestamp);

            Assertions.assertNotSame(EventTimestamp,NotificationTimestamp);

        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    "{IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamListV23.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }
    }


    @Then("Si verifica che l'elemento di timeline {string} dello stream di {string} non abbia il timestamp uguale a quella della notifica")
    public void readStreamTimelineElementAndVerify(String timelineEventCategory,String pa) {
        setPaWebhook(pa);
        TimelineElementCategoryV23 timelineElementCategory;
        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23 timelineElementInternalCategory;

        Integer numCheck = 10;
        Integer waiting = sharedSteps.getWorkFlowWait();

        switch (timelineEventCategory) {
            case "NOTIFICATION_VIEWED":
                timelineElementCategory = TimelineElementCategoryV23.NOTIFICATION_VIEWED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_VIEWED;
                break;
            case "SEND_DIGITAL_PROGRESS":
                timelineElementCategory = TimelineElementCategoryV23.SEND_DIGITAL_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_PROGRESS;
                break;
            case "SEND_DIGITAL_FEEDBACK":
                timelineElementCategory = TimelineElementCategoryV23.SEND_DIGITAL_FEEDBACK;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_FEEDBACK;
                break;
            case "SEND_ANALOG_PROGRESS":
                timelineElementCategory = TimelineElementCategoryV23.SEND_ANALOG_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_PROGRESS;
                break;
            case "SEND_ANALOG_FEEDBACK":
                timelineElementCategory = TimelineElementCategoryV23.SEND_ANALOG_FEEDBACK;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_FEEDBACK;
                break;
            case "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS":
                timelineElementCategory = TimelineElementCategoryV23.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS;
                break;
            case "PAYMENT":
                timelineElementCategory = TimelineElementCategoryV23.PAYMENT;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.PAYMENT;
                break;
            default:
                throw new IllegalArgumentException();
        }

        boolean finish = false;
        for (int i = 0; i < numCheck; i++) {

            try {
                Thread.sleep(waiting);
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }

            sharedSteps.setSentNotification(b2bClient.getSentNotification(sharedSteps.getSentNotification().getIun()));
            TimelineElementV23 timelineElement = sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals(timelineElementInternalCategory)).findAny().orElse(null);
            if (timelineElement != null) {
                finish = true;
                break;
            }
        }

        Assertions.assertTrue(finish);
        OffsetDateTime EventTimestamp=null;
        OffsetDateTime NotificationTimestamp=null;
        try{
            Assertions.assertNotNull(progressResponseElementList);

            EventTimestamp = progressResponseElementList.stream().filter(elem -> elem.getTimelineEventCategory().equals(timelineElementCategory)).findAny().get().getTimestamp();
            NotificationTimestamp =sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals(timelineElementInternalCategory)).findAny().get().getTimestamp();

            logger.info("event timestamp : {}",EventTimestamp);
            logger.info("notification timestamp : {}",NotificationTimestamp);

            Assertions.assertTrue(EventTimestamp!=NotificationTimestamp);

        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    "{IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }
    }

    @Then("Si verifica che l'elemento di timeline {string} dello stream di {string} non abbia il timestamp uguale a quella della notifica con la versione V23")
    public void readStreamTimelineElementAndVerifyV23(String timelineEventCategory,String pa) {
        setPaWebhook(pa);
        TimelineElementCategoryV23 timelineElementCategory;
        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23 timelineElementInternalCategory;

        Integer numCheck = 10;
        Integer waiting = sharedSteps.getWorkFlowWait();

        switch (timelineEventCategory) {
            case "NOTIFICATION_VIEWED":
                timelineElementCategory = TimelineElementCategoryV23.NOTIFICATION_VIEWED;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.NOTIFICATION_VIEWED;
                break;
            case "SEND_DIGITAL_PROGRESS":
                timelineElementCategory = TimelineElementCategoryV23.SEND_DIGITAL_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_PROGRESS;
                break;
            case "SEND_DIGITAL_FEEDBACK":
                timelineElementCategory = TimelineElementCategoryV23.SEND_DIGITAL_FEEDBACK;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_DIGITAL_FEEDBACK;
                break;
            case "SEND_ANALOG_PROGRESS":
                timelineElementCategory = TimelineElementCategoryV23.SEND_ANALOG_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_PROGRESS;
                break;
            case "SEND_ANALOG_FEEDBACK":
                timelineElementCategory = TimelineElementCategoryV23.SEND_ANALOG_FEEDBACK;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_ANALOG_FEEDBACK;
                break;
            case "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS":
                timelineElementCategory = TimelineElementCategoryV23.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS;
                break;
            case "PAYMENT":
                timelineElementCategory = TimelineElementCategoryV23.PAYMENT;
                timelineElementInternalCategory =
                        it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElementCategoryV23.PAYMENT;
                break;
            default:
                throw new IllegalArgumentException();
        }

        boolean finish = false;
        for (int i = 0; i < numCheck; i++) {

            try {
                Thread.sleep(waiting);
            } catch (InterruptedException exc) {
                throw new RuntimeException(exc);
            }

            sharedSteps.setSentNotification(b2bClient.getSentNotification(sharedSteps.getSentNotification().getIun()));
            TimelineElementV23 timelineElement = sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals(timelineElementInternalCategory)).findAny().orElse(null);
            if (timelineElement != null) {
                finish = true;
                break;
            }
        }

        Assertions.assertTrue(finish);
        OffsetDateTime EventTimestamp=null;
        OffsetDateTime NotificationTimestamp=null;
        try{
            Assertions.assertNotNull(progressResponseElementListV23);
            //TODO Verificare...
            EventTimestamp = progressResponseElementListV23.stream().filter(elem -> elem.getElement().getCategory().equals(timelineElementCategory)).findAny().get().getElement().getTimestamp();
            NotificationTimestamp =sharedSteps.getSentNotification().getTimeline().stream().filter(elem -> elem.getCategory().equals(timelineElementInternalCategory)).findAny().get().getTimestamp();

            logger.info("event timestamp : {}",EventTimestamp);
            logger.info("notification timestamp : {}",NotificationTimestamp);

            Assertions.assertTrue(EventTimestamp!=NotificationTimestamp);

        }catch(AssertionFailedError assertionFailedError){
            String message = assertionFailedError.getMessage()+
                    "{IUN: "+sharedSteps.getSentNotification().getIun()+" -WEBHOOK: "+this.eventStreamListV23.get(0).getStreamId()+" }";
            throw new AssertionFailedError(message,assertionFailedError.getExpected(),assertionFailedError.getActual(),assertionFailedError.getCause());
        }
    }


    private <T> ProgressResponseElement searchInWebhook(T timeLineOrStatus,String lastEventId, int deepCount){

        it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23 timelineElementCategory = null;
        NotificationStatus notificationStatus = null;
        if(timeLineOrStatus instanceof it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23){
            timelineElementCategory = (it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model.TimelineElementCategoryV23)timeLineOrStatus;
        }else if(timeLineOrStatus instanceof NotificationStatus){
            notificationStatus = (NotificationStatus)timeLineOrStatus;
        }else{
            throw new IllegalArgumentException();
        }
        ProgressResponseElement progressResponseElement = null;
        ResponseEntity<List<ProgressResponseElement>> listResponseEntity = webhookB2bClient.consumeEventStreamHttp(this.eventStreamList.get(0).getStreamId(), lastEventId);
        int retryAfter = Integer.parseInt(listResponseEntity.getHeaders().get("retry-after").get(0));
        List<ProgressResponseElement> progressResponseElements = listResponseEntity.getBody();

        sharedSteps.setProgressResponseElements(progressResponseElements);

        System.out.println("ELEMENTI NEL WEBHOOK: "+progressResponseElements.toString());
        if(deepCount >= 250){
            throw new IllegalStateException("LOP: PROGRESS-ELEMENTS: "+progressResponseElements
                    +" WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" IUN: "+sharedSteps.getSentNotification().getIun()+" DEEP: "+deepCount);
        }
        ProgressResponseElement lastProgress = null;
        for(ProgressResponseElement elem: progressResponseElements){
            if(lastProgress == null){
                lastProgress = elem;
            }else if (lastProgress.getEventId().compareTo(elem.getEventId()) < 0){
                lastProgress = elem;
            }
            if(elem.getIun() != null && elem.getIun().equals(sharedSteps.getSentNotification().getIun())){
                if(!progressResponseElementList.contains(elem)){
                    progressResponseElementList.addLast(elem);
                }
                if(((elem.getTimelineEventCategory() != null && (elem.getTimelineEventCategory().equals(timelineElementCategory)))
                        || (elem.getNewStatus() != null && (elem.getNewStatus().equals(notificationStatus))))){
                    progressResponseElement = elem;
                    break;
                }
            }
        }//for

        if(progressResponseElement != null){
            return progressResponseElement;
        }else if(retryAfter == 0){
            try{
                Thread.sleep(500);
                return searchInWebhook(timeLineOrStatus,lastProgress.getEventId(),(deepCount+1));
            }catch (IllegalStateException illegalStateException){
                if(deepCount == 249 || deepCount == 248 || deepCount == 247){
                    throw new IllegalStateException((illegalStateException.getMessage()+("LOP: PROGRESS-ELEMENTS: "+progressResponseElements
                            +" WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" IUN: "+sharedSteps.getSentNotification().getIun()+" DEEP: "+deepCount)));
                }else{
                    throw illegalStateException;
                }
            }catch (InterruptedException interruptedException){
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(interruptedException);
            }
        }else{
            return null;
        }
    }//searchInWebhookTimelineElement

    private <T> ProgressResponseElementV23 searchInWebhookV23(T timeLineOrStatus,String lastEventId, int deepCount, int position){

        it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23 timelineElementCategory = null;
        NotificationStatus notificationStatus = null;
        if(timeLineOrStatus instanceof TimelineElementCategoryV23){
            timelineElementCategory = ( it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementCategoryV23)timeLineOrStatus;
        }else if(timeLineOrStatus instanceof NotificationStatus){
            notificationStatus = (NotificationStatus)timeLineOrStatus;
        }else{
            throw new IllegalArgumentException();
        }
        ProgressResponseElementV23 progressResponseElement = null;
        ResponseEntity<List<ProgressResponseElementV23>> listResponseEntity = webhookB2bClient.consumeEventStreamHttpV23(this.eventStreamList.get(position).getStreamId(), lastEventId);
        int retryAfter = Integer.parseInt(listResponseEntity.getHeaders().get("retry-after").get(0));
        List<ProgressResponseElementV23> progressResponseElements = listResponseEntity.getBody();

        sharedSteps.setProgressResponseElementsV23(progressResponseElements);

        System.out.println("ELEMENTI NEL WEBHOOK: "+progressResponseElements.toString());
        if(deepCount >= 250){
            throw new IllegalStateException("LOP: PROGRESS-ELEMENTS: "+progressResponseElements
                    +" WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" IUN: "+sharedSteps.getSentNotification().getIun()+" DEEP: "+deepCount);
        }
        ProgressResponseElementV23 lastProgress = null;
        for(ProgressResponseElementV23 elem: progressResponseElements){
            if(lastProgress == null){
                lastProgress = elem;
            }else if (lastProgress.getEventId().compareTo(elem.getEventId()) < 0){
                lastProgress = elem;
            }
            if(elem.getIun() != null && elem.getIun().equals(sharedSteps.getSentNotification().getIun())){
                if(!progressResponseElementListV23.contains(elem)){
                    progressResponseElementListV23.addLast(elem);
                }

                //TODO Verificare...

                if(((elem.getElement().getCategory() != null && (elem.getElement().getCategory().equals(timelineElementCategory)))
                        || (elem.getNewStatus() != null && (elem.getNewStatus().equals(notificationStatus))))){
                    progressResponseElement = elem;
                    break;
                }
            }
        }//for

        if(progressResponseElement != null){
            return progressResponseElement;
        }else if(retryAfter == 0){
            try{
                Thread.sleep(500);
                return searchInWebhookV23(timeLineOrStatus,lastProgress.getEventId(),(deepCount+1),position);
            }catch (IllegalStateException illegalStateException){
                if(deepCount == 249 || deepCount == 248 || deepCount == 247){
                    throw new IllegalStateException((illegalStateException.getMessage()+("LOP: PROGRESS-ELEMENTS: "+progressResponseElements
                            +" WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" IUN: "+sharedSteps.getSentNotification().getIun()+" DEEP: "+deepCount)));
                }else{
                    throw illegalStateException;
                }
            }catch (InterruptedException interruptedException){
                logger.error("Thread.sleep error retry");
                throw new RuntimeException(interruptedException);
            }
        }else{
            return null;
        }
    }//searchInWebhookTimelineElement


    private <T> ProgressResponseElement searchInWebhookFileNotFound(T timeLineOrStatus,String lastEventId, int deepCount){

        TimelineElementCategoryV23 timelineElementCategory = null;
        NotificationStatus notificationStatus = null;
        if(timeLineOrStatus instanceof TimelineElementCategoryV23){
            timelineElementCategory = (TimelineElementCategoryV23)timeLineOrStatus;
        }else if(timeLineOrStatus instanceof NotificationStatus){
            notificationStatus = (NotificationStatus)timeLineOrStatus;
        }else{
            throw new IllegalArgumentException();
        }
        ProgressResponseElement progressResponseElement = null;
        ResponseEntity<List<ProgressResponseElement>> listResponseEntity = webhookB2bClient.consumeEventStreamHttp(this.eventStreamList.get(0).getStreamId(), lastEventId);
        int retryAfter = Integer.parseInt(listResponseEntity.getHeaders().get("retry-after").get(0));
        List<ProgressResponseElement> progressResponseElements = listResponseEntity.getBody();
        if(deepCount >= 200){
            throw new IllegalStateException("LOP: PROGRESS-ELEMENTS: "+progressResponseElements
                    +" WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" IUN: "+sharedSteps.getSentNotification().getIun()+" DEEP: "+deepCount);
        }
        ProgressResponseElement lastProgress = null;
        for(ProgressResponseElement elem: progressResponseElements){
            if("REFUSED".equalsIgnoreCase(elem.getNewStatus().getValue()) && elem.getValidationErrors() != null && elem.getValidationErrors().size()>0){
                if (elem.getValidationErrors().get(0).getErrorCode()!= null && "FILE_NOTFOUND".equalsIgnoreCase(elem.getValidationErrors().get(0).getErrorCode()) )
                    progressResponseElement = elem;
                break;
            }
        }//for
        return progressResponseElement;
    }//searchInWebhookTimelineElement

    private <T> ProgressResponseElementV23 searchInWebhookFileNotFoundV23(T timeLineOrStatus,String lastEventId, int deepCount){

        TimelineElementCategoryV23 timelineElementCategory = null;
        NotificationStatus notificationStatus = null;
        if(timeLineOrStatus instanceof TimelineElementCategoryV23){
            timelineElementCategory = (TimelineElementCategoryV23)timeLineOrStatus;
        }else if(timeLineOrStatus instanceof NotificationStatus){
            notificationStatus = (NotificationStatus)timeLineOrStatus;
        }else{
            throw new IllegalArgumentException();
        }
        ProgressResponseElementV23 progressResponseElement = null;
        ResponseEntity<List<ProgressResponseElementV23>> listResponseEntity = webhookB2bClient.consumeEventStreamHttpV23(this.eventStreamListV23.get(0).getStreamId(), lastEventId);
        int retryAfter = Integer.parseInt(listResponseEntity.getHeaders().get("retry-after").get(0));
        List<ProgressResponseElementV23> progressResponseElements = listResponseEntity.getBody();
        if(deepCount >= 200){
            throw new IllegalStateException("LOP: PROGRESS-ELEMENTS: "+progressResponseElements
                    +" WEBHOOK: "+this.eventStreamList.get(0).getStreamId()+" IUN: "+sharedSteps.getSentNotification().getIun()+" DEEP: "+deepCount);
        }
        ProgressResponseElementV23 lastProgress = null;
        for(ProgressResponseElementV23 elem: progressResponseElements){
            if("REFUSED".equalsIgnoreCase(elem.getNewStatus().getValue()) ){
                //TODO Verificare se Corretto
                break;
            }
        }//for

        //TODO Verificare il corretto comportamento...

/**          ProgressResponseElementV23 lastProgress = null;
 for(ProgressResponseElementV23 elem: progressResponseElements){
 if("REFUSED".equalsIgnoreCase(elem.getNewStatus().getValue()) && elem.getValidationErrors() != null && elem.getValidationErrors().size()>0){
 if (elem.getValidationErrors().get(0).getErrorCode()!= null && "FILE_NOTFOUND".equalsIgnoreCase(elem.getValidationErrors().get(0).getErrorCode()) )
 progressResponseElement = elem;
 break;
 }
 }//for
 **/

        return progressResponseElement;
    }//searchInWebhookTimelineElement


    @And("{string} legge la notifica")
    public void userReadNotification(String recipient) {
        sharedSteps.selectUser(recipient);
        Assertions.assertDoesNotThrow(() -> {
            webRecipientClient.getReceivedNotification(sharedSteps.getSentNotification().getIun(), null);
        });
        try {
            Thread.sleep(sharedSteps.getWorkFlowWait());
        } catch (InterruptedException exc) {
            throw new RuntimeException(exc);
        }
    }

    @And("{string} legge la notifica dopo i 10 giorni")
    public void userReadNotificationAfterTot(String recipient) {
        sharedSteps.selectUser(recipient);

        try {
            Thread.sleep(sharedSteps.getSchedulingDaysSuccessAnalogRefinement().toMillis());
        } catch (InterruptedException exc) {
            throw new RuntimeException(exc);
        }

        Assertions.assertDoesNotThrow(() -> {
            webRecipientClient.getReceivedNotification(sharedSteps.getSentNotification().getIun(), null);
        });
        try {
            Thread.sleep(sharedSteps.getWorkFlowWait());
        } catch (InterruptedException exc) {
            throw new RuntimeException(exc);
        }
    }

    @Then("si verifica nello stream del {string} che la notifica abbia lo stato VIEWED con versione {string}")
    public void checkViewedStateV23(String pa, String versione) {
        try{
            Thread.sleep(sharedSteps.getWait()*2);
        } catch (InterruptedException interruptedException) {
            interruptedException.printStackTrace();
        }
        setPaWebhook(pa);
        switch (versione) {
            case "V10":
                ProgressResponseElement progressResponseElement = searchInWebhook(NotificationStatus.VIEWED, null, 0);
                Assertions.assertNotNull(progressResponseElement);
                break;
            case "V23":
                ProgressResponseElementV23 progressResponseElementV23 = searchInWebhookV23(NotificationStatus.VIEWED, null, 0,0);
                Assertions.assertNotNull(progressResponseElementV23);
                break;
            default:
                throw new IllegalArgumentException();
        }

    }

    @Then("si verifica nello stream del {string} che la notifica abbia lo stato VIEWED")
    public void checkViewedState(String pa) {
        try{
            Thread.sleep(sharedSteps.getWait()*2);
        } catch (InterruptedException interruptedException) {
            interruptedException.printStackTrace();
        }
        setPaWebhook(pa);
        ProgressResponseElement progressResponseElement = searchInWebhook(NotificationStatus.VIEWED, null, 0);
        Assertions.assertNotNull(progressResponseElement);
    }


    @After("@clean")
    public void doSomethingAfter() {
        setPaWebhook("Comune_1");
        cleanWebhook();
    }

    @After("@cleanC2")
    public void cleanC2() {
        setPaWebhook("Comune_2");
        cleanWebhook();
    }

    @After("@cleanC3")
    public void cleanC3() {
        setPaWebhook("Comune_Multi");
        cleanWebhook();
        SharedSteps.lastEventID = 0;
    }

    private void cleanWebhook(){
        for(StreamMetadataResponse eventStream: eventStreamList){
            webhookB2bClient.deleteEventStream(eventStream.getStreamId());
            List<StreamListElement> streamListElements = webhookB2bClient.listEventStreams();
            StreamListElement streamListElement = streamListElements.stream().filter(elem -> elem.getStreamId() == eventStream.getStreamId()).findAny().orElse(null);
            logger.info("STREAM SIZE: " + streamListElements.size());
            logger.info("UUID DELETED: " + this.eventStreamList.get(0).getStreamId());
            Assertions.assertNull(streamListElement);
        }
    }

    @Then("l'ultima creazione ha prodotto un errore con status code {string}")
    public void lastCreationProducedAnErrorWithStatusCode(String statusCode) {
        List<StreamListElement> streamListElements = webhookB2bClient.listEventStreams();
        System.out.println("streamListElements: "+streamListElements.size());
        System.out.println("eventStreamList: "+eventStreamList.size());
        System.out.println("requestNumber: "+requestNumber);
        Assertions.assertTrue((this.notificationError != null) &&
                (this.notificationError.getStatusCode().toString().substring(0,3).equals(statusCode)) && (eventStreamList.size() == (requestNumber-1)));
    }


    @Given("vengono cancellati tutti gli stream presenti del {string} con versione {string}")
    public void deleteAll(String pa,String versione) {
        setPaWebhook(pa);
        switch (versione) {
            case "V10":
                List<StreamListElement> streamListElements = webhookB2bClient.listEventStreams();
                for(StreamListElement elem: streamListElements){
                    webhookB2bClient.deleteEventStream(elem.getStreamId());
                }
                break;
            case "V23":
                List<it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.StreamListElement> streamListElementsV23 = webhookB2bClient.listEventStreamsV23();
                for(it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.StreamListElement elem: streamListElementsV23){
                    webhookB2bClient.deleteEventStreamV23(elem.getStreamId());
                }
                break;
            default:
                throw new IllegalArgumentException();
        }
    }


    @And("vengono prodotte le evidenze: metadati, requestID, IUN e stati")
    public void evidenceProducedIunRequestIdAndState() {
        logger.info("METADATI: "+'\n'+sharedSteps.getNewNotificationResponse());
        logger.info("REQUEST-ID: "+'\n'+sharedSteps.getNewNotificationResponse().getNotificationRequestId());
        logger.info("IUN: "+'\n'+sharedSteps.getSentNotification().getIun());
        for(ProgressResponseElement element: progressResponseElementList){
            logger.info("EVENT: "+'\n'+element.getTimelineEventCategory()+" "+element.getTimestamp());
        }

    }

    @Then("viene verificato che il ProgressResponseElement del webhook abbia un EventId incrementale e senza duplicati V23")
    public void vieneVerificatoCheIlProgressResponseElementIdDelWebhookSiaIncrementaleESenzaDuplicatiV23() {

        List<ProgressResponseElementV23> progressResponseElements = sharedSteps.getProgressResponseElementsV23();
        Assertions.assertNotNull(progressResponseElements);
        boolean counterIncrement = true ;
        int lastEventID = SharedSteps.lastEventID;
        //logger.info("ELEMENTI NEL WEBHOOK LAST EVENT ID1: "+lastEventID);
        for(ProgressResponseElementV23 elem: progressResponseElements){
            if (lastEventID==0){
                lastEventID = Integer.parseInt(elem.getEventId());
                continue;
            }
            if (Integer.parseInt(elem.getEventId())<=lastEventID){
                counterIncrement = false;
                break;
            }else {
                lastEventID = Integer.parseInt(elem.getEventId());
            }
        }//for
        try{
            Assertions.assertTrue(counterIncrement);
        }catch (AssertionFailedError assertionFailedError){
            throw new AssertionFailedError(assertionFailedError.getMessage()+" PROGRESS-ELEMENT: \n"+progressResponseElements);
        }

        SharedSteps.lastEventID=lastEventID;
        //logger.info("ELEMENTI NEL WEBHOOK LAST EVENT ID2: "+lastEventID);
    }


    @Then("viene verificato che il ProgressResponseElement del webhook abbia un EventId incrementale e senza duplicati")
    public void vieneVerificatoCheIlProgressResponseElementIdDelWebhookSiaIncrementaleESenzaDuplicati() {

        List<ProgressResponseElement> progressResponseElements = sharedSteps.getProgressResponseElements();
        Assertions.assertNotNull(progressResponseElements);
        boolean counterIncrement = true ;
        int lastEventID = SharedSteps.lastEventID;
        //logger.info("ELEMENTI NEL WEBHOOK LAST EVENT ID1: "+lastEventID);
        for(ProgressResponseElement elem: progressResponseElements){
            if (lastEventID==0){
                lastEventID = Integer.parseInt(elem.getEventId());
                continue;
            }
            if (Integer.parseInt(elem.getEventId())<=lastEventID){
                counterIncrement = false;
                break;
            }else {
                lastEventID = Integer.parseInt(elem.getEventId());
            }
        }//for
        try{
            Assertions.assertTrue(counterIncrement);
        }catch (AssertionFailedError assertionFailedError){
            throw new AssertionFailedError(assertionFailedError.getMessage()+" PROGRESS-ELEMENT: \n"+progressResponseElements);
        }

        SharedSteps.lastEventID=lastEventID;
        //logger.info("ELEMENTI NEL WEBHOOK LAST EVENT ID2: "+lastEventID);
    }

    @And("vengono letti gli eventi dello stream che contenga {int} eventi con la versione {string}")
    public void readStreamNumberEventsV23(Integer numEventi, String versione) {
        switch (versione) {
            case "V10":
                Assertions.assertDoesNotThrow(() -> {
                    List<ProgressResponseElement> progressResponseElements = webhookB2bClient.consumeEventStream(this.eventStreamList.get(0).getStreamId(), null);
                    logger.info("EventProgress: " + progressResponseElements);

                    Assertions.assertEquals(progressResponseElements.size() , numEventi);
                    System.out.println("ELEMENTI NEL WEBHOOK: "+progressResponseElements.size());
                });
                break;
            case "V23":
                Assertions.assertDoesNotThrow(() -> {
                    List<ProgressResponseElementV23> progressResponseElements = webhookB2bClient.consumeEventStreamV23(this.eventStreamListV23.get(0).getStreamId(), null);
                    logger.info("EventProgress: " + progressResponseElements);

                    Assertions.assertEquals(progressResponseElements.size() , numEventi);
                    System.out.println("ELEMENTI NEL WEBHOOK: "+progressResponseElements.size());
                });
                break;
            default:
                throw new IllegalArgumentException();
        }
    }


    @And("vengono letti gli eventi dello stream che contenga {int} eventi")
    public void readStreamNumberEvents(Integer numEventi) {
        Assertions.assertDoesNotThrow(() -> {
            List<ProgressResponseElement> progressResponseElements = webhookB2bClient.consumeEventStream(this.eventStreamList.get(0).getStreamId(), null);
            logger.info("EventProgress: " + progressResponseElements);

            Assertions.assertEquals(progressResponseElements.size() , numEventi);
            System.out.println("ELEMENTI NEL WEBHOOK: "+progressResponseElements.size());
        });

    }


    @And("verifica corrispondenza tra i detail del webhook e quelli della timeline")
    public void verificaCorrispondenzaTraIDetailDelWebhookEQuelliDellaTimeline() {

        TimelineElementDetailsV23 timelineElementDetails = sharedSteps.getTimelineElementV23().getDetails();
        it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementDetailsV23 timelineElementWebhookDetails = sharedSteps.getProgressResponseElementV23().getElement().getDetails();

        TimelineElementDetailsV23 timelineElementDetailsV23 = new TimelineElementDetailsV23();
        timelineElementDetailsV23 = sharedSteps.deepCopy( timelineElementWebhookDetails, TimelineElementDetailsV23.class );
        Assertions.assertTrue(timelineElementDetails.equals(timelineElementDetailsV23));

        timelineElementDetailsV23 = sharedSteps.deepCopy( timelineElementWebhookDetails, TimelineElementDetailsV23.class );

        Assertions.assertTrue(timelineElementDetails.equals(timelineElementDetailsV23));

//TODO Verificare il corretto funziionamento...

        int comparisonResult = ComparisonChain.start()
                .compare(timelineElementDetails.getLegalFactId(), timelineElementWebhookDetails.getLegalFactId())
                .compare(timelineElementDetails.getRecIndex(), timelineElementWebhookDetails.getRecIndex())
                .compare(timelineElementDetails.getOldAddress().getAddress(), timelineElementWebhookDetails.getOldAddress().getAddress())
                .compare(timelineElementDetails.getOldAddress().getMunicipality(), timelineElementWebhookDetails.getOldAddress().getMunicipality())
                .compare(timelineElementDetails.getOldAddress().getProvince(), timelineElementWebhookDetails.getOldAddress().getProvince())
                .compare(timelineElementDetails.getOldAddress().getZip(), timelineElementWebhookDetails.getOldAddress().getZip())

                .compare(timelineElementDetails.getGeneratedAarUrl(), timelineElementWebhookDetails.getGeneratedAarUrl())
                .compare(timelineElementDetails.getPhysicalAddress().getAddress(), timelineElementWebhookDetails.getPhysicalAddress().getAddress())
                .compare(timelineElementDetails.getLegalfactId(), timelineElementWebhookDetails.getLegalfactId())
                .compare(timelineElementDetails.getEndWorkflowStatus(), timelineElementWebhookDetails.getEndWorkflowStatus())
                .compare(timelineElementDetails.getCompletionWorkflowDate(), timelineElementWebhookDetails.getCompletionWorkflowDate())
                .compare(timelineElementDetails.getLegalFactGenerationDate(), timelineElementWebhookDetails.getLegalFactGenerationDate())
                .compare(timelineElementDetails.getDigitalAddress().getAddress(), timelineElementWebhookDetails.getDigitalAddress().getAddress())
                .compare(timelineElementDetails.getDigitalAddress().getType(), timelineElementWebhookDetails.getDigitalAddress().getType())
                .compare(timelineElementDetails.getAttemptDate(), timelineElementWebhookDetails.getAttemptDate())
                .compare(timelineElementDetails.getIsAvailable(), timelineElementWebhookDetails.getIsAvailable())
                .compare(timelineElementDetails.getEventTimestamp(), timelineElementWebhookDetails.getEventTimestamp())
                .compare(timelineElementDetails.getRaddType(), timelineElementWebhookDetails.getRaddType())
                .compare(timelineElementDetails.getRaddTransactionId(), timelineElementWebhookDetails.getRaddTransactionId())
                .compare(timelineElementDetails.getDelegateInfo().getTaxId(), timelineElementWebhookDetails.getDelegateInfo().getTaxId())
                .compare(timelineElementDetails.getNotificationCost(), timelineElementWebhookDetails.getNotificationCost())
                .compare(timelineElementDetails.getNotificationDate(), timelineElementWebhookDetails.getNotificationDate())
                .compare(timelineElementDetails.getSendDate(), timelineElementWebhookDetails.getSendDate())
                .compare(timelineElementDetails.getSchedulingDate(), timelineElementWebhookDetails.getSchedulingDate())
                .compare(timelineElementDetails.getLastAttemptDate(), timelineElementWebhookDetails.getLastAttemptDate())
                .compare(timelineElementDetails.getAnalogCost(), timelineElementWebhookDetails.getAnalogCost())
                .compare(timelineElementDetails.getAttemptDate(), timelineElementWebhookDetails.getAttemptDate())
                .compare(timelineElementDetails.getNumberOfPages(), timelineElementWebhookDetails.getNumberOfPages())
                .compare(timelineElementDetails.getEnvelopeWeight(), timelineElementWebhookDetails.getEnvelopeWeight())
                .compare(timelineElementDetails.getProductType(), timelineElementWebhookDetails.getProductType())
                .compare(timelineElementDetails.getAmount(), timelineElementWebhookDetails.getAmount())
                .compare(timelineElementDetails.getCreditorTaxId(), timelineElementWebhookDetails.getCreditorTaxId())
                .compare(timelineElementDetails.getDeliveryDetailCode(), timelineElementWebhookDetails.getDeliveryDetailCode())
                .compare(timelineElementDetails.getNoticeCode(), timelineElementWebhookDetails.getNoticeCode())
                .compare(timelineElementDetails.getSchedulingAnalogDate(), timelineElementWebhookDetails.getSchedulingAnalogDate())

                .result();

        Assertions.assertTrue(comparisonResult>0);



    }

    @Then("verifica deanonimizzazione degli eventi di timeline")
    public void verificaDeanonimizzazioneDegliEventiDiTimeline() {
        it.pagopa.pn.client.b2b.webhook.generated.openapi.clients.externalb2bwebhook.model_v2_3.TimelineElementDetailsV23 timelineElementWebhookDetails = sharedSteps.getProgressResponseElementV23().getElement().getDetails();

        Assertions.assertNotNull(timelineElementWebhookDetails.getPhysicalAddress().getAddress());
        Assertions.assertNotNull(timelineElementWebhookDetails.getPhysicalAddress().getMunicipality());
        Assertions.assertNotNull(timelineElementWebhookDetails.getPhysicalAddress().getProvince());
        Assertions.assertNotNull(timelineElementWebhookDetails.getPhysicalAddress().getZip());
        Assertions.assertNotNull(timelineElementWebhookDetails.getDigitalAddress().getAddress());
        Assertions.assertNotNull(timelineElementWebhookDetails.getDelegateInfo().getTaxId());
        Assertions.assertNotNull(timelineElementWebhookDetails.getDelegateInfo().getDenomination());
    }

    @When("vengono letti gli eventi di timeline dello stream con versione {string} -Cross Versioning")
    public void vengonoLettiGliEventiDiTimelineDelloStreamDel(String versione) {
        if(sharedSteps.getResponseNewApiKey()!= null){
            webhookB2bClient.setApiKey(sharedSteps.getResponseNewApiKey().getApiKey());
        }
        switch (versione) {
            case "V10":
                try{
                    ResponseEntity<List<ProgressResponseElement>> listResponseEntity = webhookB2bClient.consumeEventStreamHttp(this.eventStreamListV23.get(0).getStreamId(), null);

                }catch (HttpStatusCodeException e) {
                    this.notificationError = e;
                    if (e instanceof HttpStatusCodeException) {
                        sharedSteps.setNotificationError((HttpStatusCodeException) e);
                    }
                }
                break;
            case "V23":
                try{
                    ResponseEntity<List<ProgressResponseElementV23>> listResponseEntity = webhookB2bClient.consumeEventStreamHttpV23(this.eventStreamList.get(0).getStreamId(), null);

                }catch (HttpStatusCodeException e) {
                    this.notificationError = e;
                    if (e instanceof HttpStatusCodeException) {
                        sharedSteps.setNotificationError((HttpStatusCodeException) e);
                    }
                }
                break;
            default:
                throw new IllegalArgumentException();
        }

    }


    public List<String> getFilterValues() {
        return filterValues;
    }

    public void setFilterValues(List<String> filterValues) {
        this.filterValues = filterValues;
    }
}


