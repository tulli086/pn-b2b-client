package it.pagopa.pn.cucumber.utils;

import it.pagopa.pn.client.b2b.pa.generated.openapi.clients.externalb2bpa.model.TimelineElement;

public class TimelineWorkflowSequenceElement {
    TimelineElement timelineElement;
    boolean isFirstSendRetry;
    Integer progressIndex;
    Float pollingTime;
    Integer numCheck;
    boolean loadTimeline;
    SequenceAction action;

    public boolean getIsFirstSendRetry() {
        return isFirstSendRetry;
    }

    public void setFirstSendRetry(boolean firstSendRetry) {
        isFirstSendRetry = firstSendRetry;
    }

    public TimelineElement getTimelineElement() {
        return timelineElement;
    }

    public void setTimelineElement(TimelineElement timelineElement) {
        this.timelineElement = timelineElement;
    }

    public Integer getProgressIndex() {
        return progressIndex;
    }

    public void setProgressIndex(Integer progressIndex) {
        this.progressIndex = progressIndex;
    }

    public Float getPollingTime() {
        return pollingTime;
    }

    public void setPollingTime(Float pollingTime) {
        this.pollingTime = pollingTime;
    }

    public Integer getNumCheck() {
        return numCheck;
    }

    public void setNumCheck(Integer numCheck) {
        this.numCheck = numCheck;
    }

    public boolean getLoadTimeline() {
        return loadTimeline;
    }

    public void setLoadTimeline(boolean loadTimeline) {
        this.loadTimeline = loadTimeline;
    }

    public SequenceAction getAction() {
        return action;
    }

    public void setAction(SequenceAction action) {
        this.action = action;
    }
}
