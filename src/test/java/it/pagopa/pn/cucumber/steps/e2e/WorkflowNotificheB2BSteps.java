package it.pagopa.pn.cucumber.steps.e2e;

import io.cucumber.java.Transpose;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.*;
import it.pagopa.pn.client.b2b.pa.impl.IPnPaB2bClient;
import it.pagopa.pn.client.b2b.pa.testclient.IPnPrivateDeliveryPushExternalClientImpl;
import it.pagopa.pn.client.b2b.pa.testclient.PnExternalServiceClientImpl;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.privateDeliveryPush.model.NotificationHistoryResponse;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.privateDeliveryPush.model.ResponsePaperNotificationFailedDto;
import it.pagopa.pn.cucumber.steps.SharedSteps;
import it.pagopa.pn.cucumber.utils.DataTest;
import it.pagopa.pn.cucumber.utils.TimelineElementWait;
import org.junit.jupiter.api.Assertions;
import org.opentest4j.AssertionFailedError;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.lang.invoke.MethodHandles;
import java.time.Duration;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;
import java.util.Objects;

import static java.time.OffsetDateTime.now;
import static java.util.concurrent.TimeUnit.MILLISECONDS;
import static org.awaitility.Awaitility.await;

public class WorkflowNotificheB2BSteps {

    private final SharedSteps sharedSteps;
    private final IPnPaB2bClient b2bClient;
    private final PnExternalServiceClientImpl externalClient;
    private final IPnPrivateDeliveryPushExternalClientImpl pnPrivateDeliveryPushExternalClient;

    private static final Logger logger = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

    @Autowired
    public WorkflowNotificheB2BSteps(SharedSteps sharedSteps, IPnPrivateDeliveryPushExternalClientImpl pnPrivateDeliveryPushExternalClient) {
        this.sharedSteps = sharedSteps;
        this.b2bClient = sharedSteps.getB2bClient();
        this.externalClient = sharedSteps.getPnExternalServiceClient();
        this.pnPrivateDeliveryPushExternalClient = pnPrivateDeliveryPushExternalClient;
    }

    private void checkTimelineElementEquality(String timelineEventCategory, TimelineElement elementFromNotification, DataTest dataFromTest) {
        TimelineElement elementFromTest = dataFromTest.getTimelineElement();
        TimelineElementDetails detailsFromNotification = elementFromNotification.getDetails();
        TimelineElementDetails detailsFromTest = elementFromTest.getDetails();
        DelegateInfo delegateInfoFromTest = detailsFromTest != null ? detailsFromTest.getDelegateInfo() : null;
        DelegateInfo delegateInfoFromNotification = detailsFromNotification != null ? detailsFromNotification.getDelegateInfo() : null;

        switch (timelineEventCategory) {
            case "SEND_COURTESY_MESSAGE":
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
                Assertions.assertNotNull(elementFromNotification.getLegalFactsIds());
                Assertions.assertEquals(elementFromNotification.getLegalFactsIds().size(), elementFromTest.getLegalFactsIds().size());
                for (int i = 0; i < elementFromNotification.getLegalFactsIds().size(); i++) {
                    Assertions.assertEquals(elementFromNotification.getLegalFactsIds().get(i).getCategory(), elementFromTest.getLegalFactsIds().get(i).getCategory());
                    Assertions.assertNotNull(elementFromNotification.getLegalFactsIds().get(i).getKey());
                }
                break;
            case "SEND_DIGITAL_DOMICILE":
                if (detailsFromTest != null) {
                    Assertions.assertEquals(detailsFromNotification.getDigitalAddress(), detailsFromTest.getDigitalAddress());
                }
                break;
            case "DIGITAL_SUCCESS_WORKFLOW":
            case "DIGITAL_FAILURE_WORKFLOW":
                Assertions.assertNotNull(elementFromNotification.getLegalFactsIds());
                Assertions.assertEquals(elementFromNotification.getLegalFactsIds().size(), elementFromTest.getLegalFactsIds().size());
                for (int i = 0; i < elementFromNotification.getLegalFactsIds().size(); i++) {
                    Assertions.assertEquals(elementFromNotification.getLegalFactsIds().get(i).getCategory(), elementFromTest.getLegalFactsIds().get(i).getCategory());
                    Assertions.assertNotNull(elementFromNotification.getLegalFactsIds().get(i).getKey());
                }
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
                    if(Objects.nonNull(elementFromTest.getLegalFactsIds())) {
                        Assertions.assertEquals(elementFromNotification.getLegalFactsIds().size(), elementFromTest.getLegalFactsIds().size());
                        for (int i = 0; i < elementFromNotification.getLegalFactsIds().size(); i++) {
                            Assertions.assertEquals(elementFromNotification.getLegalFactsIds().get(i).getCategory(), elementFromTest.getLegalFactsIds().get(i).getCategory());
                            Assertions.assertNotNull(elementFromNotification.getLegalFactsIds().get(i).getKey());
                        }
                    }
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
            case "SEND_SIMPLE_REGISTERED_LETTER":
                if (detailsFromTest != null) {
                    Assertions.assertEquals(detailsFromNotification.getPhysicalAddress(), detailsFromTest.getPhysicalAddress());
                    Assertions.assertEquals(detailsFromNotification.getAnalogCost(), detailsFromTest.getAnalogCost());
                }
                break;
            case "NOTIFICATION_VIEWED":
                Assertions.assertNotNull(elementFromNotification.getLegalFactsIds());
                Assertions.assertEquals(elementFromNotification.getLegalFactsIds().size(), elementFromTest.getLegalFactsIds().size());
                for (int i = 0; i < elementFromNotification.getLegalFactsIds().size(); i++) {
                    Assertions.assertEquals(elementFromNotification.getLegalFactsIds().get(i).getCategory(), elementFromTest.getLegalFactsIds().get(i).getCategory());
                    Assertions.assertNotNull(elementFromNotification.getLegalFactsIds().get(i).getKey());
                }
                if (delegateInfoFromTest != null) {
                    Assertions.assertEquals(delegateInfoFromNotification.getTaxId(), sharedSteps.getTaxIdFromDenomination(delegateInfoFromTest.getDenomination()));
                    Assertions.assertEquals(delegateInfoFromNotification.getDelegateType(), delegateInfoFromTest.getDelegateType());
                    Assertions.assertEquals(delegateInfoFromNotification.getDenomination(), delegateInfoFromTest.getDenomination());
                }
            case "COMPLETELY_UNREACHABLE":
                if(Objects.nonNull(elementFromTest.getLegalFactsIds())) {
                    Assertions.assertEquals(elementFromNotification.getLegalFactsIds().size(), elementFromTest.getLegalFactsIds().size());
                    for (int i = 0; i < elementFromNotification.getLegalFactsIds().size(); i++) {
                        Assertions.assertEquals(elementFromNotification.getLegalFactsIds().get(i).getCategory(), elementFromTest.getLegalFactsIds().get(i).getCategory());
                        Assertions.assertNotNull(elementFromNotification.getLegalFactsIds().get(i).getKey());
                    }
                }
        }
    }

    private TimelineElement getAndStoreTimeline(String timelineEventCategory, DataTest dataFromTest) {
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

    private void loadTimeline(String timelineEventCategory, boolean existCheck, @Transpose DataTest dataFromTest) {
        // calc how much time wait
        Integer pollingTime = dataFromTest != null ? dataFromTest.getPollingTime() : null;
        Integer numCheck = dataFromTest != null ? dataFromTest.getNumCheck() : null;
        TimelineElementWait timelineElementWait = sharedSteps.getTimelineElementCategory(timelineEventCategory);
        Integer defaultPollingTime = timelineElementWait.getWaiting();
        Integer defaultNumCheck = timelineElementWait.getNumCheck();
        Integer waitingTime = (pollingTime != null ? pollingTime : defaultPollingTime) * (numCheck != null ? numCheck : defaultNumCheck);

        await()
                .atMost(waitingTime, MILLISECONDS)
                .with()
                .pollInterval(pollingTime != null ? pollingTime : defaultPollingTime, MILLISECONDS)
                .pollDelay(0, MILLISECONDS)
                .ignoreExceptions()
                .untilAsserted(() -> {
                    TimelineElement timelineElement = getAndStoreTimeline(timelineEventCategory, dataFromTest);
                    List<TimelineElement> timelineElementList = sharedSteps.getSentNotification().getTimeline();

                    logger.info("NOTIFICATION_TIMELINE: " + timelineElementList);
                    Assertions.assertNotNull(timelineElementList);
                    Assertions.assertNotEquals(timelineElementList.size(), 0);
                    if (existCheck) {
                        Assertions.assertNotNull(timelineElement);
                    } else {
                        Assertions.assertNull(timelineElement);
                    }
                });
    }

    @And("viene schedulato il perfezionamento per decorrenza termini per il caso {string}")
    public void vieneSchedulatoIlPerfezionamento(String timelineCategory, @Transpose DataTest dataFromTest) {
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

        Assertions.assertNotNull(timelineElementForDateCalculation);

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
        Assertions.assertEquals(timelineElement.getDetails().getSchedulingDate(), schedulingDate);
    }

    @And("si attende che sia presente il perfezionamento per decorrenza termini")
    public void siAttendePresenzaPerfezionamentoDecorrenzaTermini(@Transpose DataTest dataFromTest) throws InterruptedException {
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
    public void siAttendeCheSiRitentiInvio(String timelineEventCategory, @Transpose DataTest dataFromTest) throws InterruptedException {
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
        String taxId = sharedSteps.getTaxIdFromDenomination(denomination);
        // get internal id from data-vault
        String internalId = externalClient.getInternalIdFromTaxId(recipientTye, taxId);
        // get notifications not delivered from delivery-push
        List<ResponsePaperNotificationFailedDto> notificationFailedList = this.pnPrivateDeliveryPushExternalClient.getPaperNotificationFailed(internalId, true);
        String iun = sharedSteps.getSentNotification().getIun();
        ResponsePaperNotificationFailedDto notificationFailed = notificationFailedList.stream().filter(elem -> elem.getIun().equals(iun)).findFirst().orElse(null);
        Assertions.assertNotNull(notificationFailed);
    }

    @And("viene verificato che il destinatario {string} di tipo {string} non sia nella tabella pn-paper-notification-failed")
    public void vieneVerificatoDestinatarioNonInPnPaperNotificationFailed(String denomination, String recipientTye) {
        String taxId = sharedSteps.getTaxIdFromDenomination(denomination);
        // get internal id from data-vault
        String internalId = externalClient.getInternalIdFromTaxId(recipientTye, taxId);
        // get notifications not delivered from delivery-push
        List<ResponsePaperNotificationFailedDto> notificationFailedList = pnPrivateDeliveryPushExternalClient.getPaperNotificationFailed(internalId, true);
        String iun = sharedSteps.getSentNotification().getIun();
        ResponsePaperNotificationFailedDto notificationFailed = notificationFailedList.stream().filter(elem -> elem.getIun().equals(iun)).findFirst().orElse(null);
        Assertions.assertNull(notificationFailed);
    }

    @Then("viene verificato che l'elemento di timeline {string} esista")
    public void vieneVerificatoElementoTimeline(String timelineEventCategory, @Transpose DataTest dataFromTest) {
        boolean mustLoadTimeline = dataFromTest != null ? dataFromTest.getLoadTimeline() : false;
        if (mustLoadTimeline) {
            loadTimeline(timelineEventCategory, true, dataFromTest);
        }
        try {
            TimelineElement timelineElement = sharedSteps.getTimelineElementByEventId(timelineEventCategory, dataFromTest);
            logger.info("TIMELINE_ELEMENT: " + timelineElement);
            Assertions.assertNotNull(timelineElement);
            if (dataFromTest != null && dataFromTest.getTimelineElement() != null) {
                checkTimelineElementEquality(timelineEventCategory, timelineElement, dataFromTest);
            }
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }

    @And("viene verificato che l'elemento di timeline {string} non esista")
    public void vieneVerificatoCheElementoTimelineNonEsista(String timelineEventCategory, @Transpose DataTest dataFromTest) {
        loadTimeline(timelineEventCategory, false, dataFromTest);
        TimelineElement timelineElement = sharedSteps.getTimelineElementByEventId(timelineEventCategory, dataFromTest);
        try {
            logger.info("TIMELINE_ELEMENT: " + timelineElement);
            Assertions.assertNull(timelineElement);
        } catch (AssertionFailedError assertionFailedError) {
            sharedSteps.throwAssertFailerWithIUN(assertionFailedError);
        }
    }

    @And("controlla che il timestamp di {string} sia dopo quello di invio e di attesa di lettura del messaggio di cortesia")
    public void verificaTimestamp(String timelineEventCategory, @Transpose DataTest dataFromTest) {
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
    public void getTimelineElementListSize(String timelineEventCategory, Long size, @Transpose DataTest dataFromTest) {
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
        if (dataFromTest != null && dataFromTest.getTimelineElement() != null) {
            // get timeline event id
            String timelineEventId = sharedSteps.getTimelineEventId(timelineEventCategory, iun, dataFromTest);
            if (timelineEventCategory.equals(TimelineElementCategory.SEND_ANALOG_PROGRESS.getValue())) {
                TimelineElement timelineElementFromTest = dataFromTest.getTimelineElement();
                TimelineElementDetails timelineElementDetails = timelineElementFromTest.getDetails();
                Assertions.assertEquals(size, timelineElementList.stream().filter(elem -> elem.getElementId().startsWith(timelineEventId) && elem.getDetails().getDeliveryDetailCode().equals(timelineElementDetails.getDeliveryDetailCode())).count());
            } else {
                Assertions.assertEquals(size, timelineElementList.stream().filter(elem -> elem.getElementId().startsWith(timelineEventId)).count());
            }
        } else {
            Assertions.assertEquals(size, timelineElementList.stream().filter(elem -> elem.getCategory().getValue().equals(timelineEventCategory)).count());
        }
    }
}
