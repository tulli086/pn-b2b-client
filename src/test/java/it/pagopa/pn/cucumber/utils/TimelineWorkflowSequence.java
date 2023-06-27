package it.pagopa.pn.cucumber.utils;

import java.util.NavigableMap;

public class TimelineWorkflowSequence {
    Integer pollingTime;
    Integer numCheck;
    NavigableMap<String, TimelineWorkflowSequenceElement> sequence;

    public Integer getPollingTime() {
        return pollingTime;
    }

    public void setPollingTime(Integer pollingTime) {
        this.pollingTime = pollingTime;
    }

    public Integer getNumCheck() {
        return numCheck;
    }

    public void setNumCheck(Integer numCheck) {
        this.numCheck = numCheck;
    }

    public NavigableMap<String, TimelineWorkflowSequenceElement> getSequence() {
        return sequence;
    }

    public void setSequence(NavigableMap<String, TimelineWorkflowSequenceElement> sequence) {
        this.sequence = sequence;
    }
}
