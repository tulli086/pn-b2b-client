package it.pagopa.pn.cucumber.utils;

public class PollingData {
    Float pollingTime;
    Integer numCheck;
    boolean loadTimeline;

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

}
