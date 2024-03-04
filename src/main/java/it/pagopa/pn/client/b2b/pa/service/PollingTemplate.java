package it.pagopa.pn.client.b2b.pa.service;

public abstract class PollingTemplate implements PollingService{

    public void waitForEvent(){
        System.out.println(this.getMessage());
    }

    abstract String getMessage();
}
