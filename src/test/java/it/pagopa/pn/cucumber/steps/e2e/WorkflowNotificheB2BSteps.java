package it.pagopa.pn.cucumber.steps.e2e;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.cucumber.core.backend.TestCaseState;
import io.cucumber.core.gherkin.Pickle;
import io.cucumber.core.gherkin.Step;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;
import io.cucumber.java.Transpose;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.plugin.event.TestCase;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.*;
import it.pagopa.pn.client.b2b.pa.impl.IPnPaB2bClient;
import it.pagopa.pn.client.b2b.pa.testclient.IPnPrivateDeliveryPushExternalClientImpl;
import it.pagopa.pn.client.b2b.pa.testclient.PnExternalServiceClientImpl;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.privateDeliveryPush.model.NotificationHistoryResponse;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.privateDeliveryPush.model.ResponsePaperNotificationFailedDto;
import it.pagopa.pn.cucumber.steps.SharedSteps;
import it.pagopa.pn.cucumber.utils.*;
import org.junit.jupiter.api.Assertions;
import org.opentest4j.AssertionFailedError;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import java.lang.invoke.MethodHandles;
import java.lang.reflect.Field;
import java.time.Duration;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.concurrent.atomic.AtomicReference;

import static java.time.OffsetDateTime.now;
import static java.util.concurrent.TimeUnit.MILLISECONDS;
import static org.awaitility.Awaitility.await;

class AttachmentSpec {
    public String documentType;

    public String toReportString() {
        return "documentType " + this.documentType;
    }
    public boolean matchesAttachmentDetails(List<AttachmentDetails> attachmentDetails) {
        return attachmentDetails.stream().anyMatch(attachment -> attachment.getDocumentType().equals(this.documentType));
    }
}

interface TimelineEventSpec {
    public List<String> toReportString();
    public void checkTimelineElement(TimelineElement fullElement);
    public boolean isExhausted();
}

class SimpleTimelineEventSpec implements TimelineEventSpec {
    public String category;
    public String deliveryDetailCode;

    public Integer recIndex;

    public Integer sent_attempt_made;

    public String deliveryFailureCause;

    public List<AttachmentSpec> attachments;

    public boolean exhausted = false;

    public List<String> toReportString() {
        List<String> result = new ArrayList<String>();
        if (this.category != null) {
            result.add("Category - " + this.category);
        }
        if (this.deliveryDetailCode != null) {
            result.add("deliveryDetailCode - " + this.deliveryDetailCode);
        }
        if (this.recIndex != null) {
            result.add("recIndex - " + this.recIndex);
        }
        if (this.sent_attempt_made != null) {
            result.add("sent_attempt_made - " + this.sent_attempt_made);
        }
        if (this.deliveryFailureCause != null) {
            result.add("deliveryFailureCause - " + this.deliveryFailureCause);
        }
        if (this.attachments != null) {
            result.add("attachments - " + this.attachments.stream().reduce("", (reportString, attachment) -> reportString + attachment.toReportString() + " / ", String::concat));
        }
        return result;
    }

    public void checkTimelineElement(TimelineElement fullElement) {
        if (!this.exhausted && this.matchesTimelineElement(fullElement)) {
            this.exhausted = true;
        }
    }

    public boolean isExhausted() {
        return this.exhausted;
    }

    public boolean matchesTimelineElement(TimelineElement fullElement) {
        boolean result = true;
        if (this.category != null) {
            result = result && this.category.equals(fullElement.getCategory().getValue());
        }
        if (this.deliveryDetailCode != null) {
            result = result && this.deliveryDetailCode.equals(fullElement.getDetails().getDeliveryDetailCode());
        }
        if (this.recIndex != null) {
            result = result && this.recIndex.equals(fullElement.getDetails().getRecIndex());
        }
        if (this.sent_attempt_made != null) {
            result = result && this.sent_attempt_made.equals(this.getSentAttemptMade(fullElement));
        }
        if (this.deliveryFailureCause != null) {
            result = result && this.deliveryFailureCause.equals(fullElement.getDetails().getDeliveryFailureCause());
        }
        if (this.attachments != null) {
            result = result && fullElement.getDetails().getAttachments() != null && this.attachments.stream().allMatch(attachment -> attachment.matchesAttachmentDetails(fullElement.getDetails().getAttachments()));
        }
        return result;
    }

    private Integer getSentAttemptMade(TimelineElement timelineElement) {
        if (timelineElement.getDetails().getSentAttemptMade() != null) {
            return timelineElement.getDetails().getSentAttemptMade();
        } else if (timelineElement.getElementId().contains("ATTEMPT_")) {
            int attemptIndex = timelineElement.getElementId().indexOf("ATTEMPT_") + "ATTEMPT_".length();
            return Integer.valueOf(timelineElement.getElementId().substring(attemptIndex, attemptIndex+1));
        } else {
            return null;
        }
    }
}

class ParallelTimelineEventSpec implements TimelineEventSpec {
    public List<SimpleTimelineEventSpec> simpleSpecs = new ArrayList<SimpleTimelineEventSpec>();

    ParallelTimelineEventSpec(SimpleTimelineEventSpec spec1, SimpleTimelineEventSpec spec2) {
        this.simpleSpecs.add(spec1);
        this.simpleSpecs.add(spec2);
    }

    public List<String> toReportString() {
        List<String> result = new ArrayList<String>();
        if (simpleSpecs.size() == 0) {
            result.add("Empty parallel step");
        } else {
            result.add("Parallel step with " + simpleSpecs.size() + " elements, showing the first one");
            result.addAll(this.simpleSpecs.get(0).toReportString());
        }
        return result;
    }

    public void checkTimelineElement(TimelineElement fullElement) {
        this.simpleSpecs.stream().forEach(simpleSpec -> simpleSpec.checkTimelineElement(fullElement));
    }

    public boolean isExhausted() {
        return this.simpleSpecs.stream().allMatch(simpleSpec -> simpleSpec.isExhausted());
    }
}

class AlternativeTimelineEventSpec implements TimelineEventSpec {
    public List<SimpleTimelineEventSpec> simpleSpecs = new ArrayList<SimpleTimelineEventSpec>();

    AlternativeTimelineEventSpec(SimpleTimelineEventSpec spec1, SimpleTimelineEventSpec spec2) {
        this.simpleSpecs.add(spec1);
        this.simpleSpecs.add(spec2);
    }

    public List<String> toReportString() {
        List<String> result = new ArrayList<String>();
        if (simpleSpecs.size() == 0) {
            result.add("Empty alternative step");
        } else {
            result.add("Alternative step with " + simpleSpecs.size() + " elements, showing the first one");
            result.addAll(this.simpleSpecs.get(0).toReportString());
        }
        return result;
    }

    public void checkTimelineElement(TimelineElement fullElement) {
        this.simpleSpecs.stream().forEach(simpleSpec -> simpleSpec.checkTimelineElement(fullElement));
    }

    public boolean isExhausted() {
        return this.simpleSpecs.stream().anyMatch(simpleSpec -> simpleSpec.isExhausted());
    }
}

public class WorkflowNotificheB2BSteps {

    @Value("${pn.configuration.workflow.polling.millis:10000}")
    private Integer polling;

    private final SharedSteps sharedSteps;
    private final IPnPaB2bClient b2bClient;
    private final PnExternalServiceClientImpl externalClient;
    private final IPnPrivateDeliveryPushExternalClientImpl pnPrivateDeliveryPushExternalClient;
    private static final Logger logger = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private TimelineWorkflowSequence timelineWorkflowSequence;
    private OffsetDateTime lastTimeStamp = null;

    private Map.Entry<String, TimelineWorkflowSequenceElement> getLast(LinkedHashMap<String, TimelineWorkflowSequenceElement> LinkedHMap) {
        int count = 1;

        for (Map.Entry<String, TimelineWorkflowSequenceElement> it:LinkedHMap.entrySet()){
            if (count == LinkedHMap.size()) {
                return it;
            }
            count++;
        }
        return null;
    }

    @Autowired
    public WorkflowNotificheB2BSteps(SharedSteps sharedSteps, IPnPrivateDeliveryPushExternalClientImpl pnPrivateDeliveryPushExternalClient) {
        this.sharedSteps = sharedSteps;
        this.b2bClient = sharedSteps.getB2bClient();
        this.externalClient = sharedSteps.getPnExternalServiceClient();
        this.pnPrivateDeliveryPushExternalClient = pnPrivateDeliveryPushExternalClient;
    }

    private void checkLegalFacts(TimelineElement elementFromNotification, TimelineElement elementFromTest) {
        if(Objects.nonNull(elementFromTest.getLegalFactsIds())) {
            Assertions.assertNotNull(elementFromNotification.getLegalFactsIds());
            Assertions.assertEquals(elementFromNotification.getLegalFactsIds().size(), elementFromTest.getLegalFactsIds().size());
            for (int i = 0; i < elementFromNotification.getLegalFactsIds().size(); i++) {
                Assertions.assertEquals(elementFromNotification.getLegalFactsIds().get(i).getCategory(), elementFromTest.getLegalFactsIds().get(i).getCategory());
                Assertions.assertNotNull(elementFromNotification.getLegalFactsIds().get(i).getKey());
            }
        }
    }

    private void checkTimelineElementEquality(String timelineEventCategory, TimelineElement elementFromNotification, TimelineWorkflowSequenceElement dataFromTest) {
        TimelineElement elementFromTest = dataFromTest.getTimelineElement();
        TimelineElementDetails detailsFromNotification = elementFromNotification.getDetails();
        TimelineElementDetails detailsFromTest = elementFromTest.getDetails();
        DelegateInfo delegateInfoFromTest = detailsFromTest != null ? detailsFromTest.getDelegateInfo() : null;
        DelegateInfo delegateInfoFromNotification = detailsFromNotification != null ? detailsFromNotification.getDelegateInfo() : null;

        switch (timelineEventCategory) {
            case "SEND_COURTESY_MESSAGE":
            case "SEND_DIGITAL_DOMICILE":
                if (detailsFromTest != null) {
                    Assertions.assertEquals(detailsFromNotification.getDigitalAddress(), detailsFromTest.getDigitalAddress());
                    Assertions.assertEquals(detailsFromNotification.getRecIndex(), detailsFromTest.getRecIndex());
                }
                break;
            case "REQUEST_REFUSED":
                if (detailsFromTest != null) {
                    Assertions.assertNotNull(detailsFromNotification.getRefusalReasons());
                    Assertions.assertEquals(detailsFromNotification.getRefusalReasons().size(), detailsFromTest.getRefusalReasons().size());
                    for (int i = 0; i < detailsFromNotification.getRefusalReasons().size(); i++) {
                        Assertions.assertEquals(detailsFromNotification.getRefusalReasons().get(i).getErrorCode(), detailsFromTest.getRefusalReasons().get(i).getErrorCode());
                    }
                }
                break;
            case "AAR_GENERATION":
                if (detailsFromTest != null) {
                    Assertions.assertNotNull(detailsFromNotification.getGeneratedAarUrl());
                }
                break;
            case "SEND_DIGITAL_FEEDBACK":
                if (detailsFromTest != null) {
                    Assertions.assertNotNull(detailsFromNotification.getResponseStatus());
                    Assertions.assertEquals(detailsFromNotification.getResponseStatus().getValue(), detailsFromTest.getResponseStatus().getValue());
                    Assertions.assertEquals(detailsFromNotification.getDigitalAddress(), detailsFromTest.getDigitalAddress());
                    Assertions.assertEquals(detailsFromNotification.getSendingReceipts().size(), detailsFromTest.getSendingReceipts().size());
                    for (int i = 0; i < detailsFromNotification.getSendingReceipts().size(); i++) {
                        Assertions.assertEquals(detailsFromNotification.getSendingReceipts().get(i), detailsFromTest.getSendingReceipts().get(i));
                    }
                }
                break;
            case "REQUEST_ACCEPTED":
            case "COMPLETELY_UNREACHABLE":
                checkLegalFacts(elementFromNotification, elementFromTest);
                break;
            case "DIGITAL_SUCCESS_WORKFLOW":
            case "DIGITAL_FAILURE_WORKFLOW":
                checkLegalFacts(elementFromNotification, elementFromTest);
                if (detailsFromTest != null) {
                    Assertions.assertEquals(detailsFromNotification.getDigitalAddress(), detailsFromTest.getDigitalAddress());
                }
                break;
            case "GET_ADDRESS":
                if (detailsFromTest != null) {
                    Assertions.assertEquals(detailsFromNotification.getDigitalAddressSource(), detailsFromTest.getDigitalAddressSource());
                    Assertions.assertEquals(detailsFromNotification.getIsAvailable(), detailsFromTest.getIsAvailable());
                }
                break;
            case "SEND_ANALOG_FEEDBACK":
                if (detailsFromTest != null) {
                    if(Objects.nonNull(detailsFromTest.getDeliveryDetailCode()))
                        Assertions.assertEquals(detailsFromNotification.getDeliveryDetailCode(), detailsFromTest.getDeliveryDetailCode());
                    if(Objects.nonNull(detailsFromTest.getPhysicalAddress()))
                        Assertions.assertEquals(detailsFromNotification.getPhysicalAddress(), detailsFromTest.getPhysicalAddress());
                    if(Objects.nonNull(detailsFromTest.getResponseStatus()))
                        Assertions.assertEquals(detailsFromNotification.getResponseStatus().getValue(), detailsFromTest.getResponseStatus().getValue());
                    if(Objects.nonNull(detailsFromTest.getDeliveryFailureCause())) {
                        List<String> failureCauses = Arrays.asList(detailsFromTest.getDeliveryFailureCause().split(" "));
                        Assertions.assertTrue(failureCauses.contains(elementFromNotification.getDetails().getDeliveryFailureCause()));
                    }
                }
                break;
            case "SEND_ANALOG_PROGRESS":
            case "SEND_SIMPLE_REGISTERED_LETTER_PROGRESS":
                if (detailsFromTest != null) {
                    checkLegalFacts(elementFromNotification, elementFromTest);
                    if (Objects.nonNull(detailsFromTest.getDeliveryDetailCode())) {
                        Assertions.assertEquals(detailsFromNotification.getDeliveryDetailCode(), detailsFromTest.getDeliveryDetailCode());
                    }
                    if (Objects.nonNull(detailsFromTest.getAttachments())) {
                        Assertions.assertNotNull(detailsFromNotification.getAttachments());
                        Assertions.assertEquals(detailsFromNotification.getAttachments().size(), detailsFromTest.getAttachments().size());

                        for (int i = 0; i < detailsFromNotification.getAttachments().size(); i++) {
                            Assertions.assertEquals(detailsFromNotification.getAttachments().get(i).getDocumentType(), detailsFromTest.getAttachments().get(i).getDocumentType());
                        }
                    }

                    if(Objects.nonNull(detailsFromTest.getDeliveryFailureCause())) {
                        List<String> failureCauses = Arrays.asList(detailsFromTest.getDeliveryFailureCause().split(" "));
                        Assertions.assertEquals(Boolean.TRUE, failureCauses.contains(elementFromNotification.getDetails().getDeliveryFailureCause()));
                    }
                }
                break;
            case "ANALOG_SUCCESS_WORKFLOW":
            case "PREPARE_SIMPLE_REGISTERED_LETTER":
                if (detailsFromTest != null && detailsFromTest.getPhysicalAddress() != null) {
                    Assertions.assertEquals(detailsFromNotification.getPhysicalAddress(), detailsFromTest.getPhysicalAddress());
                }
                break;
            case "SEND_ANALOG_DOMICILE":
            case "SEND_SIMPLE_REGISTERED_LETTER":
                if (detailsFromTest != null) {
                    if(Objects.nonNull(detailsFromTest.getPhysicalAddress()))
                        Assertions.assertEquals(detailsFromNotification.getPhysicalAddress(), detailsFromTest.getPhysicalAddress());
                    if(Objects.nonNull(detailsFromTest.getAnalogCost()))
                        Assertions.assertEquals(detailsFromNotification.getAnalogCost(), detailsFromTest.getAnalogCost());
                    Assertions.assertEquals(detailsFromNotification.getRecIndex(), detailsFromTest.getRecIndex());
                }
                break;
            case "NOTIFICATION_VIEWED":
                checkLegalFacts(elementFromNotification, elementFromTest);
                if (delegateInfoFromTest != null) {
                    Assertions.assertEquals(delegateInfoFromNotification.getTaxId(), sharedSteps.getTaxIdFromDenomination(delegateInfoFromTest.getDenomination()));
                    Assertions.assertEquals(delegateInfoFromNotification.getDelegateType(), delegateInfoFromTest.getDelegateType());
                }
                break;
        }
    }

    private TimelineElement getAndStoreTimeline(String timelineEventCategory, TimelineWorkflowSequenceElement dataFromTest) {
        String iun;

        if (timelineEventCategory.equals(TimelineElementCategory.REQUEST_REFUSED.getValue())) {
            String requestId = sharedSteps.getNewNotificationResponse().getNotificationRequestId();
            byte[] decodedBytes = Base64.getDecoder().decode(requestId);
            iun = new String(decodedBytes);
            NewNotificationRequest newNotificationRequest = sharedSteps.getNotificationRequest();
            // get timeline from delivery-push
            NotificationHistoryResponse notificationHistory = pnPrivateDeliveryPushExternalClient.getNotificationHistory(iun, newNotificationRequest.getRecipients().size(), sharedSteps.getNotificationCreationDate());
            List<TimelineElement> timelineElementList = notificationHistory.getTimeline();
            FullSentNotification fullSentNotification = new FullSentNotification();
            fullSentNotification.setTimeline(timelineElementList);
            sharedSteps.setSentNotification(fullSentNotification);
        } else {
            // proceed with default flux
            iun = sharedSteps.getSentNotification().getIun();
            sharedSteps.setSentNotification(b2bClient.getSentNotification(iun));
        }

        // get timeline event id
        return sharedSteps.getTimelineElementByEventId(timelineEventCategory, dataFromTest);
    }

    private void loadTimeline(String timelineEventCategory, boolean existCheck, @Transpose TimelineWorkflowSequenceElement dataFromTest) {
        logger.info("LOADING TIMELINE");
        // calc how much time wait
        Float pollingTime = dataFromTest != null ? dataFromTest.getPollingTime() : null;
        Integer numCheck = dataFromTest != null ? dataFromTest.getNumCheck() : null;
        TimelineElementWait timelineElementWait = sharedSteps.getTimelineElementCategory(timelineEventCategory);
        Integer defaultPollingTime = timelineElementWait.getWaiting();
        Integer defaultNumCheck = timelineElementWait.getNumCheck();
        Float waitingTime = (pollingTime != null ? pollingTime : defaultPollingTime) * (numCheck != null ? numCheck : defaultNumCheck);
        AtomicReference<Integer> checksDone = new AtomicReference<>(0);

        await()
            .atMost(waitingTime.longValue(), MILLISECONDS)
            .with()
            .pollInterval(pollingTime != null ? pollingTime.longValue() : defaultPollingTime, MILLISECONDS)
            .pollDelay(0, MILLISECONDS)
            .ignoreException(AssertionFailedError.class)
            .conditionEvaluationListener(condition -> {
                Long remainingTime = condition.getRemainingTimeInMS();
                logger.info("{} (elapsed time {}, remaining time {})", condition.getDescription(), condition.getElapsedTimeInMS(), remainingTime);
                if (remainingTime <= (pollingTime != null ? pollingTime : defaultPollingTime)) {
                    logger.info("TIMELINE: " + sharedSteps.getSentNotification().getTimeline());
                    logger.info("TIMELINE CATEGORY: " + timelineEventCategory);
                }
            })
            .untilAsserted(() -> {
                TimelineElement timelineElement = getAndStoreTimeline(timelineEventCategory, dataFromTest);
                if (existCheck) {
                    Assertions.assertNotNull(timelineElement);
                } else {
                    checksDone.set(checksDone.get() + 1);
                    // when we want check if element doesn't exist, the await method must wait all the time specified and fails only if the condition is unmet
                    Assertions.assertNull(timelineElement);
                    Assertions.assertTrue(checksDone.get().equals(numCheck != null ? numCheck : defaultNumCheck));
                }
            });

    }

    private void loadNotificationByStatus(NotificationStatus notificationInternalStatus, boolean existCheck, @Transpose PollingData pollingData) {
        // calc how much time wait
        Float pollingTime = pollingData != null ? pollingData.getPollingTime() : null;
        Integer numCheck = pollingData != null ? pollingData.getNumCheck() : null;
        Integer defaultPollingTime = sharedSteps.getWorkFlowWait();
        Integer defaultNumCheck = 5;
        Float waitingTime = (pollingTime != null ? pollingTime : defaultPollingTime) * (numCheck != null ? numCheck : defaultNumCheck);
        AtomicReference<Integer> checksDone = new AtomicReference<>(0);

        await()
            .atMost(waitingTime.longValue(), MILLISECONDS)
            .with()
            .pollInterval(pollingTime != null ? pollingTime.longValue() : defaultPollingTime, MILLISECONDS)
            .pollDelay(0, MILLISECONDS)
            .ignoreExceptions()
            .untilAsserted(() -> {
                sharedSteps.setSentNotification(b2bClient.getSentNotification(sharedSteps.getSentNotification().getIun()));

                logger.info("NOTIFICATION_STATUS_HISTORY: " + sharedSteps.getSentNotification().getNotificationStatusHistory());

                NotificationStatusHistoryElement notificationStatusHistoryElement = sharedSteps.getSentNotification().getNotificationStatusHistory().stream().filter(elem -> elem.getStatus().equals(notificationInternalStatus)).findAny().orElse(null);

                if (existCheck) {
                    Assertions.assertNotNull(notificationStatusHistoryElement);
                } else {
                    checksDone.set(checksDone.get() + 1);
                    Assertions.assertNull(notificationStatusHistoryElement);
                    Assertions.assertTrue(checksDone.get().equals(numCheck != null ? numCheck : defaultNumCheck));
                }
            });
    }

    NotificationStatus getNotificationInternalStatus(String status) {
        switch (status) {
            case "ACCEPTED":
                return NotificationStatus.ACCEPTED;
            case "DELIVERING":
                return NotificationStatus.DELIVERING;
            case "DELIVERED":
                return NotificationStatus.DELIVERED;
            case "VIEWED":
                return NotificationStatus.VIEWED;
            case "CANCELLED":
                return NotificationStatus.CANCELLED;
            case "EFFECTIVE_DATE":
                return NotificationStatus.EFFECTIVE_DATE;
            case "UNREACHABLE":
                return NotificationStatus.UNREACHABLE;
            default:
                throw new IllegalArgumentException();
        }
    }

    @Before
    public void validateScenario(Scenario scenario) throws Exception {
        // get scenario steps
        Field delegate = scenario.getClass().getDeclaredField("delegate");
        delegate.setAccessible(true);
        TestCaseState state = (TestCaseState) delegate.get(scenario);
        Field testCaseF = state.getClass().getDeclaredField("testCase");
        testCaseF.setAccessible(true);
        TestCase testCase = (TestCase) testCaseF.get(state);
        Field pickle = testCase.getClass().getDeclaredField("pickle");
        pickle.setAccessible(true);
        Pickle pickleState = (Pickle) pickle.get(testCase);
        List<Step> steps = pickleState.getSteps();
        Boolean isSequence = false;
        Boolean isEmptySequence = false;
        for(Step step: steps) {
            String stepText = step.getText();
            if (stepText.equals("viene inizializzata la sequence per il controllo sulla timeline")) {
                isSequence = true;
                isEmptySequence = true;
            } else if (stepText.startsWith("si aggiunge alla sequence il controllo che")) {
                if (!isSequence)
                    throw new RuntimeException("Sequence not initialized. Add \"viene inizializzata la sequence per il controllo sulla timeline\" before the step: " + stepText);
                isEmptySequence = false;
            } else if (stepText.equals("viene verificata la sequence")) {
                if (!isSequence)
                    throw new RuntimeException("Sequence not initialized. Add \"viene inizializzata la sequence per il controllo sulla timeline\" before the step: " + stepText);
                if (isEmptySequence)
                    throw new RuntimeException("Sequence empty. Add a step that starts with \"si aggiunge alla sequence...\" before this step: " + stepText);
                isSequence = false;
                isEmptySequence = false;
            } else if (isSequence) { // step that mustn't be in the sequence
                throw new RuntimeException("Sequence initialized and the step \"" + stepText + "\" cannot be in. Close the sequence with \"viene verificata la sequence\" before this step.");
            }
        }
        // sequence not closed
        if (isSequence) {
            throw new RuntimeException("Sequence not closed. Close the sequence with \"viene verificata la sequence\".");
        }
    }

    @After
    public void clean() {
        lastTimeStamp = null;
        timelineWorkflowSequence = null;
    }

    @Then("viene inizializzata la sequence per il controllo sulla timeline")
    public void vieneInizializzatoControlloTimeline(@Transpose TimelineWorkflowSequence timelineWorkflowSequence) {
        timelineWorkflowSequence.setPollingTime((float) polling * timelineWorkflowSequence.getPollingTimeMultiplier());
        this.timelineWorkflowSequence = timelineWorkflowSequence;
    }

    @And("si aggiunge alla sequence il controllo che {string} esista")
    public void aggiungoSequenceCheEsista(String timelineCategory, @Transpose TimelineWorkflowSequenceElement sequenceElement) {
        sequenceElement.setAction(SequenceAction.EXIST);
        TimelineElementCategory timelineElementCategory = TimelineElementCategory.valueOf(timelineCategory);
        sequenceElement.getTimelineElement().setCategory(timelineElementCategory);
        LinkedHashMap<String, TimelineWorkflowSequenceElement> sequence = timelineWorkflowSequence.getSequence();
        Integer sequenceNumber = sequence.size();
        timelineWorkflowSequence.getSequence().put("seg-" + sequenceNumber, sequenceElement);
    }

    @And("si aggiunge alla sequence il controllo che {string} non esista")
    public void aggiungoSequenceCheNonEsista(String timelineCategory, @Transpose TimelineWorkflowSequenceElement sequenceElement) {
        sequenceElement.setAction(SequenceAction.NOT_EXIST);
        TimelineElementCategory timelineElementCategory = TimelineElementCategory.valueOf(timelineCategory);
        sequenceElement.getTimelineElement().setCategory(timelineElementCategory);
        LinkedHashMap<String, TimelineWorkflowSequenceElement> sequence = timelineWorkflowSequence.getSequence();
        Integer sequenceNumber = sequence.size();
        timelineWorkflowSequence.getSequence().put("seg-" + sequenceNumber, sequenceElement);
    }

    @And("viene verificata la sequence")
    public void verificaSequence() {
        LinkedHashMap<String, TimelineWorkflowSequenceElement> sequence = timelineWorkflowSequence.getSequence();
        logger.info("START SEQUENCE CHECK");
        // get last timeline element and load timeline
        Map.Entry<String, TimelineWorkflowSequenceElement> lastEntry = getLast(sequence);
        TimelineWorkflowSequenceElement timelineWorkflowSequenceElement = lastEntry.getValue();
        // TODO: it will be removed
        timelineWorkflowSequenceElement.setPollingTime(timelineWorkflowSequence.getPollingTime());
        timelineWorkflowSequenceElement.setNumCheck(timelineWorkflowSequence.getNumCheck());
        //
        loadTimeline(timelineWorkflowSequenceElement.getTimelineElement().getCategory().getValue(), !timelineWorkflowSequenceElement.getAction().equals(SequenceAction.NOT_EXIST), timelineWorkflowSequenceElement);
        // check the sequence
        for (Map.Entry<String, TimelineWorkflowSequenceElement> pair : sequence.entrySet()) {
            TimelineWorkflowSequenceElement sequenceElement = pair.getValue();
            String timelineEventCategory = sequenceElement.getTimelineElement().getCategory().getValue();
            SequenceAction action = sequenceElement.getAction();
            switch (action) {
                case EXIST:
                    TimelineElement timelineElement = vieneVerificatoElementoTimeline(timelineEventCategory, sequenceElement);
                    if (lastTimeStamp != null) {
                        try {
                            logger.info("CHECK THAT THE TIMELINE EVENT IS AFTER OR EQUAL TO THE PREVIOUS ONE");
                            logger.info("PREVIOUS: " + lastTimeStamp + " CURRENT: " + timelineElement.getTimestamp());
                            Assertions.assertTrue(lastTimeStamp.isBefore(timelineElement.getTimestamp()) ||
                                    lastTimeStamp.isEqual(timelineElement.getTimestamp())
                            );
                        } catch (AssertionFailedError assertionFailedError) {
                            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
                        }
                    }
                    lastTimeStamp = timelineElement.getTimestamp();
                    break;
                case NOT_EXIST:
                    vieneVerificatoCheElementoTimelineNonEsista(timelineEventCategory, sequenceElement);
                    break;
            }
        }

    }

    @And("viene schedulato il perfezionamento per decorrenza termini per il caso {string}")
    public void vieneSchedulatoIlPerfezionamento(String timelineCategory, @Transpose TimelineWorkflowSequenceElement dataFromTest) {
        TimelineElement timelineElement = sharedSteps.getTimelineElementByEventId(TimelineElementCategory.SCHEDULE_REFINEMENT.getValue(), dataFromTest);

        TimelineElement timelineElementForDateCalculation = null;
        if (timelineCategory.equals(TimelineElementCategory.DIGITAL_SUCCESS_WORKFLOW.getValue())) {
            timelineElementForDateCalculation = sharedSteps.getTimelineElementByEventId(TimelineElementCategory.SEND_DIGITAL_FEEDBACK.getValue(), dataFromTest);
        } else if (timelineCategory.equals(TimelineElementCategory.DIGITAL_FAILURE_WORKFLOW.getValue())) {
            timelineElementForDateCalculation = sharedSteps.getTimelineElementByEventId(TimelineElementCategory.DIGITAL_FAILURE_WORKFLOW.getValue(), dataFromTest);
        }  else if (timelineCategory.equals(TimelineElementCategory.ANALOG_SUCCESS_WORKFLOW.getValue())) {
            timelineElementForDateCalculation = sharedSteps.getTimelineElementByEventId(TimelineElementCategory.SEND_ANALOG_FEEDBACK.getValue(), dataFromTest);
        } else if (timelineCategory.equals(TimelineElementCategory.ANALOG_FAILURE_WORKFLOW.getValue())) {
            timelineElementForDateCalculation = sharedSteps.getTimelineElementByEventId(TimelineElementCategory.SEND_ANALOG_FEEDBACK.getValue(), dataFromTest);
        }

        try {
            Assertions.assertNotNull(timelineElementForDateCalculation);
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }

        OffsetDateTime notificationDate = null;
        Duration schedulingDaysRefinement = null;
        if (timelineCategory.equals(TimelineElementCategory.DIGITAL_SUCCESS_WORKFLOW.getValue())) {
            notificationDate = timelineElementForDateCalculation.getDetails().getNotificationDate();
            schedulingDaysRefinement = sharedSteps.getSchedulingDaysSuccessDigitalRefinement();
        } else if (timelineCategory.equals(TimelineElementCategory.DIGITAL_FAILURE_WORKFLOW.getValue())) {
            notificationDate = timelineElementForDateCalculation.getTimestamp();
            schedulingDaysRefinement = sharedSteps.getSchedulingDaysFailureDigitalRefinement();
        } else if (timelineCategory.equals(TimelineElementCategory.ANALOG_SUCCESS_WORKFLOW.getValue())) {
            notificationDate = timelineElementForDateCalculation.getTimestamp();
            schedulingDaysRefinement = sharedSteps.getSchedulingDaysSuccessAnalogRefinement();
        } else if (timelineCategory.equals(TimelineElementCategory.ANALOG_FAILURE_WORKFLOW.getValue())) {
            notificationDate = timelineElementForDateCalculation.getDetails().getNotificationDate();
            schedulingDaysRefinement = sharedSteps.getSchedulingDaysFailureAnalogRefinement();
        }

        OffsetDateTime schedulingDate = notificationDate.plus(schedulingDaysRefinement);
        Integer hour = schedulingDate.atZoneSameInstant(ZoneId.of("Europe/Rome")).getHour();
        Integer minutes = schedulingDate.atZoneSameInstant(ZoneId.of("Europe/Rome")).getMinute();
        if ((hour == 21 && minutes > 0) || hour > 21) {
            Duration timeToAddInNonVisibilityTimeCase = sharedSteps.getTimeToAddInNonVisibilityTimeCase();
            schedulingDate = schedulingDate.plus(timeToAddInNonVisibilityTimeCase);
        }
        try {
            logger.info("CHECK THAT SCHEDULING DATE IS EQUAL TO CALCULATED ONE");
            Assertions.assertEquals(timelineElement.getDetails().getSchedulingDate(), schedulingDate);
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }

    @And("si attende che sia presente il perfezionamento per decorrenza termini")
    public void siAttendePresenzaPerfezionamentoDecorrenzaTermini(@Transpose TimelineWorkflowSequenceElement dataFromTest) throws InterruptedException {
        logger.info("WAITING FOR REFINEMENT");
        String iun = sharedSteps.getSentNotification().getIun();
        if (dataFromTest != null && dataFromTest.getTimelineElement() != null) {
            TimelineElement timelineElement = sharedSteps.getTimelineElementByEventId(TimelineElementCategory.SCHEDULE_REFINEMENT.getValue(), dataFromTest);
            OffsetDateTime schedulingDate = timelineElement.getDetails().getSchedulingDate();
            OffsetDateTime currentDate = now().atZoneSameInstant(ZoneId.of("UTC")).toOffsetDateTime();
            Long remainingTime = ChronoUnit.MILLIS.between(currentDate, schedulingDate);
            if (remainingTime > 0) {
                Thread.sleep(remainingTime + 30 * 1000);
            }
            // get the updated notification
            sharedSteps.setSentNotification(b2bClient.getSentNotification(iun));
        }
    }

    @And("si attende che si ritenti l'invio dopo l'evento {string}")
    public void siAttendeCheSiRitentiInvio(String timelineEventCategory, @Transpose TimelineWorkflowSequenceElement dataFromTest) throws InterruptedException {
        logger.info("WAITING FOR THE RETRY OF THE FIRST SEND");
        String iun = sharedSteps.getSentNotification().getIun();
        if (dataFromTest != null && dataFromTest.getTimelineElement() != null) {
            TimelineElement timelineElement = sharedSteps.getTimelineElementByEventId(timelineEventCategory, dataFromTest);
            OffsetDateTime firstSend = timelineElement.getTimestamp();
            Duration secondNotificationWorkflowWaitingTime = sharedSteps.getSecondNotificationWorkflowWaitingTime();
            OffsetDateTime nextSend = firstSend.plus(secondNotificationWorkflowWaitingTime);
            OffsetDateTime currentDate = now().atZoneSameInstant(ZoneId.of("UTC")).toOffsetDateTime();
            Long remainingTime = ChronoUnit.MILLIS.between(currentDate, nextSend);
            if (remainingTime > 0) {
                Thread.sleep(remainingTime + 30 * 1000);
            }
            // get the updated notification
            sharedSteps.setSentNotification(b2bClient.getSentNotification(iun));
        }
    }

    @And("viene verificato che il destinatario {string} di tipo {string} sia nella tabella pn-paper-notification-failed")
    public void vieneVerificatoDestinatarioInPnPaperNotificationFailed(String denomination, String recipientTye) {
        logger.info("CHECK THAT USER IS COMPLETELY UNREACHABLE");
        String taxId = sharedSteps.getTaxIdFromDenomination(denomination);
        // get internal id from data-vault
        String internalId = externalClient.getInternalIdFromTaxId(recipientTye, taxId);
        // get notifications not delivered from delivery-push
        List<ResponsePaperNotificationFailedDto> notificationFailedList = this.pnPrivateDeliveryPushExternalClient.getPaperNotificationFailed(internalId, true);
        String iun = sharedSteps.getSentNotification().getIun();
        ResponsePaperNotificationFailedDto notificationFailed = notificationFailedList.stream().filter(elem -> elem.getIun().equals(iun)).findFirst().orElse(null);
        try {
            Assertions.assertNotNull(notificationFailed);
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }

    @And("viene verificato che il destinatario {string} di tipo {string} non sia nella tabella pn-paper-notification-failed")
    public void vieneVerificatoDestinatarioNonInPnPaperNotificationFailed(String denomination, String recipientTye) {
        logger.info("CHECK THAT USER ISN'T COMPLETELY UNREACHABLE");
        String taxId = sharedSteps.getTaxIdFromDenomination(denomination);
        // get internal id from data-vault
        String internalId = externalClient.getInternalIdFromTaxId(recipientTye, taxId);
        // get notifications not delivered from delivery-push
        List<ResponsePaperNotificationFailedDto> notificationFailedList = pnPrivateDeliveryPushExternalClient.getPaperNotificationFailed(internalId, true);
        String iun = sharedSteps.getSentNotification().getIun();
        ResponsePaperNotificationFailedDto notificationFailed = notificationFailedList.stream().filter(elem -> elem.getIun().equals(iun)).findFirst().orElse(null);
        try {
            Assertions.assertNull(notificationFailed);
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }

    @Then("viene verificato che l'elemento di timeline {string} esista")
    public TimelineElement vieneVerificatoElementoTimeline(String timelineEventCategory, @Transpose TimelineWorkflowSequenceElement dataFromTest) {
        boolean mustLoadTimeline = dataFromTest != null ? dataFromTest.getLoadTimeline() : false;
        if (mustLoadTimeline) {
            loadTimeline(timelineEventCategory, true, dataFromTest);
        }
        try {
            TimelineElement timelineElement = sharedSteps.getTimelineElementByEventId(timelineEventCategory, dataFromTest);
            logger.info("CHECK IF TIMELINE ELEMENT EXISTS: " + timelineEventCategory);
            Assertions.assertNotNull(timelineElement);
            if (dataFromTest != null && dataFromTest.getTimelineElement() != null) {
                checkTimelineElementEquality(timelineEventCategory, timelineElement, dataFromTest);
            }
            return timelineElement;
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
        return null;
    }

    @And("viene verificato che l'elemento di timeline {string} non esista")
    public void vieneVerificatoCheElementoTimelineNonEsista(String timelineEventCategory, @Transpose TimelineWorkflowSequenceElement dataFromTest) {
        boolean mustLoadTimeline = dataFromTest != null ? dataFromTest.getLoadTimeline() : false;
        if (mustLoadTimeline) {
            loadTimeline(timelineEventCategory, false, dataFromTest);
        }
        TimelineElement timelineElement = sharedSteps.getTimelineElementByEventId(timelineEventCategory, dataFromTest);
        try {
            logger.info("CHECK IF TIMELINE ELEMENT DOESN'T EXIST: " + timelineEventCategory);
            Assertions.assertNull(timelineElement);
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }

    @And("controlla che il timestamp di {string} sia dopo quello di invio e di attesa di lettura del messaggio di cortesia")
    public void verificaTimestamp(String timelineEventCategory, @Transpose TimelineWorkflowSequenceElement dataFromTest) {
        TimelineElement timelineElementCategory = getAndStoreTimeline(timelineEventCategory, dataFromTest);
        TimelineElement timelineElementSendCourtesyMessage = getAndStoreTimeline("SEND_COURTESY_MESSAGE", dataFromTest);

        Duration waitingForReadCourtesyMessage = sharedSteps.getWaitingForReadCourtesyMessage();

        OffsetDateTime timestampEventCategory = timelineElementCategory.getTimestamp();
        OffsetDateTime timestampEventSendCourtesyMessage = timelineElementSendCourtesyMessage.getTimestamp();
        OffsetDateTime timestampEventSendCourtesyMessageWithWaitingTime = timestampEventSendCourtesyMessage.plus(waitingForReadCourtesyMessage);

        Boolean test = timestampEventCategory.isEqual(timestampEventSendCourtesyMessageWithWaitingTime) || timestampEventCategory.isAfter(timestampEventSendCourtesyMessageWithWaitingTime);

        logger.info("timestamp " + timelineEventCategory + ": " + timestampEventCategory);
        logger.info("timestamp SEND_COURTESY_MESSAGE ( +" + waitingForReadCourtesyMessage + " minutes): " + timestampEventSendCourtesyMessageWithWaitingTime);
        logger.info("timestamp " + timelineEventCategory + " is after or equal timestamp SEND_COURTESY_MESSAGE?: " + test);

        Assertions.assertTrue(test);
    }

    @And("viene verificato che il numero di elementi di timeline {string} sia di {long}")
    public void getTimelineElementListSize(String timelineEventCategory, Long size, @Transpose TimelineWorkflowSequenceElement dataFromTest) {
        List<TimelineElement> timelineElementList = sharedSteps.getSentNotification().getTimeline();
        String iun;
        if (timelineEventCategory.equals(TimelineElementCategory.REQUEST_REFUSED.getValue())) {
            String requestId = sharedSteps.getNewNotificationResponse().getNotificationRequestId();
            byte[] decodedBytes = Base64.getDecoder().decode(requestId);
            iun = new String(decodedBytes);
        } else {
            // proceed with default flux
            iun = sharedSteps.getSentNotification().getIun();
        }
        try {
            logger.info("CHECK THAT THE NUMBER OF THE TIMELINE ELEMENTS IS: " + size);
            if (dataFromTest != null && dataFromTest.getTimelineElement() != null) {
                // get timeline event id
                String timelineEventId = sharedSteps.getTimelineEventId(timelineEventCategory, iun, dataFromTest);
                if (timelineEventCategory.equals(TimelineElementCategory.SEND_ANALOG_PROGRESS.getValue()) || timelineEventCategory.equals(TimelineElementCategory.SEND_SIMPLE_REGISTERED_LETTER_PROGRESS.getValue())) {
                    TimelineElement timelineElementFromTest = dataFromTest.getTimelineElement();
                    TimelineElementDetails timelineElementDetails = timelineElementFromTest.getDetails();
                    Assertions.assertEquals(size, timelineElementList.stream().filter(elem -> elem.getElementId().startsWith(timelineEventId) && elem.getDetails().getDeliveryDetailCode().equals(timelineElementDetails.getDeliveryDetailCode())).count());
                } else {
                    Assertions.assertEquals(size, timelineElementList.stream().filter(elem -> elem.getElementId().startsWith(timelineEventId)).count());
                }
            } else {
                Assertions.assertEquals(size, timelineElementList.stream().filter(elem -> elem.getCategory().getValue().equals(timelineEventCategory)).count());
            }
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }

    @Then("si verifica che lo stato della notifica sia {string}")
    public void verificaEsisteStatoNotifica(String status, @Transpose PollingData pollingData) {
        NotificationStatus notificationInternalStatus = getNotificationInternalStatus(status);

        boolean mustLoadNotification = pollingData != null ? pollingData.getLoadTimeline() : false;
        if (mustLoadNotification) {
            loadNotificationByStatus(notificationInternalStatus, true, pollingData);
        }
        try {
            List<NotificationStatusHistoryElement> notificationStatusHistoryElements = sharedSteps.getSentNotification().getNotificationStatusHistory();
            logger.info("NOTIFICATION_STATUS_HISTORY: " + notificationStatusHistoryElements);
            Assertions.assertNotNull(notificationStatusHistoryElements);

            NotificationStatusHistoryElement notificationStatusHistoryElement = sharedSteps.getSentNotification().getNotificationStatusHistory().stream().filter(elem -> elem.getStatus().equals(notificationInternalStatus)).findAny().orElse(null);

            Assertions.assertNotNull(notificationStatusHistoryElement);

        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }

    @Then("si verifica che lo stato della notifica non sia {string}")
    public void verificaNonEsisteStatoNotifica(String status, @Transpose PollingData pollingData) {
        NotificationStatus notificationInternalStatus = getNotificationInternalStatus(status);

        boolean mustLoadNotification = pollingData != null ? pollingData.getLoadTimeline() : false;
        if (mustLoadNotification) {
            loadNotificationByStatus(notificationInternalStatus, false, pollingData);
        }
        try {
            List<NotificationStatusHistoryElement> notificationStatusHistoryElements = sharedSteps.getSentNotification().getNotificationStatusHistory();
            logger.info("NOTIFICATION_STATUS_HISTORY: " + notificationStatusHistoryElements);
            Assertions.assertNotNull(notificationStatusHistoryElements);

            NotificationStatusHistoryElement notificationStatusHistoryElement = sharedSteps.getSentNotification().getNotificationStatusHistory().stream().filter(elem -> elem.getStatus().equals(notificationInternalStatus)).findAny().orElse(null);

            Assertions.assertNull(notificationStatusHistoryElement);

        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }

    @And("vengono verificati gli eventi precedenti in ordine")
    public void vengonoVerificatiEventiPrecedenti(Map<String, String> rowData) {
        List<TimelineEventSpec> eventData = generateEventData(rowData);
        List<TimelineElement> timelineElements = sharedSteps.getSentNotification().getTimeline();
        this.checkEventsAgainstTimelineEvents(eventData, timelineElements);
    }

    private List<TimelineEventSpec> generateEventData(Map<String, String> rowData) {
        int index = 0;
        List<TimelineEventSpec> result = new ArrayList<TimelineEventSpec>();

        String keyInData = "seq" + index;
        while (rowData.get(keyInData) != null) {
            ObjectMapper objectMapper = new ObjectMapper();
            try {
                SimpleTimelineEventSpec newSpec = objectMapper.readValue(rowData.get(keyInData), SimpleTimelineEventSpec.class);
                if (rowData.get(keyInData + "-parallel") != null) {
                    SimpleTimelineEventSpec secondSpec = objectMapper.readValue(rowData.get(keyInData + "-parallel"), SimpleTimelineEventSpec.class);
                    result.add(new ParallelTimelineEventSpec(newSpec, secondSpec));
                } else if (rowData.get(keyInData + "-alternative") != null) {
                    SimpleTimelineEventSpec secondSpec = objectMapper.readValue(rowData.get(keyInData + "-alternative"), SimpleTimelineEventSpec.class);
                    result.add(new AlternativeTimelineEventSpec(newSpec, secondSpec));
                } else {
                    result.add(newSpec);
                }
                index++;
                keyInData = "seq" + index;
            } catch (Exception e) {
                System.out.println(e.getMessage());
                Assertions.fail("Wrong specification of steps");
            }
        }
        return result;
    }

    private void checkEventsAgainstTimelineEvents(List<TimelineEventSpec> eventData, List<TimelineElement> timelineElements) {
        int eventIndex = 0;
        int timelineIndex = 0;
        while (eventIndex < eventData.size() && timelineIndex < timelineElements.size()) {
            eventData.get(eventIndex).checkTimelineElement(timelineElements.get(timelineIndex));
            if (eventData.get(eventIndex).isExhausted()) {
                eventIndex++;
            }
            timelineIndex++;
        }
        boolean allEventsFound = eventIndex == eventData.size();
        if (!allEventsFound) {
            System.out.println("Failed to arrive to this element");
            System.out.println(eventData.get(eventIndex).toReportString());
            Assertions.fail("Failed to verify the given elements in order");
        }
    }
}
