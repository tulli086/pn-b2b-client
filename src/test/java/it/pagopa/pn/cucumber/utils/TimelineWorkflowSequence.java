package it.pagopa.pn.cucumber.utils;

import java.util.LinkedHashMap;

public class TimelineWorkflowSequence {
    Float pollingTime;
    Float pollingTimeMultiplier;
    Integer numCheck;
    LinkedHashMap<String, TimelineWorkflowSequenceElement> sequence;

    public Float getPollingTime() {
        return pollingTime;
    }

    public void setPollingTime(Float pollingTime) {
        this.pollingTime = pollingTime;
    }

    public Float getPollingTimeMultiplier() {
        return pollingTimeMultiplier;
    }

    public void setPollingTimeMultiplier(Float pollingTimeMultiplier) {
        this.pollingTimeMultiplier = pollingTimeMultiplier;
    }

    public Integer getNumCheck() {
        return numCheck;
    }

    public void setNumCheck(Integer numCheck) {
        this.numCheck = numCheck;
    }

    public LinkedHashMap<String, TimelineWorkflowSequenceElement> getSequence() {
        return sequence;
    }

    public void setSequence(LinkedHashMap<String, TimelineWorkflowSequenceElement> sequence) {
        this.sequence = sequence;
    }
}
