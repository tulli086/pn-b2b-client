package it.pagopa.pn.client.b2b.pa.utils;


import lombok.Synchronized;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;

@Component
@Slf4j
public class WebhookSynchronizer {
    private static final int MAX_NUMBER_OF_STREAM = 10;
    private final Semaphore semaphoreForPa1 = new Semaphore(MAX_NUMBER_OF_STREAM,true);
    private final Semaphore semaphoreForPa2 = new Semaphore(MAX_NUMBER_OF_STREAM,true);
    private final Semaphore semaphoreForPa3 = new Semaphore(MAX_NUMBER_OF_STREAM,true);


    @Synchronized
    public Boolean acquireStreamCreationSlot(int numberOfStreamRequest,String pa) throws InterruptedException {
        if(numberOfStreamRequest > MAX_NUMBER_OF_STREAM)throw new IllegalArgumentException();
        Semaphore semaphoreToAcquire = switch(pa){
            case "Comune_1" -> this.semaphoreForPa1;
            case "Comune_2" -> this.semaphoreForPa2;
            case "Comune_Multi" -> this.semaphoreForPa3;
            default -> throw new IllegalArgumentException();
        };
        return semaphoreToAcquire.tryAcquire(numberOfStreamRequest,90, TimeUnit.MINUTES);
    }
    @Synchronized
    public void releaseStreamCreationSlot(int numberOfStreamRequest, String pa) {
        Semaphore semaphoreToRelease = switch(pa){
            case "Comune_1" -> this.semaphoreForPa1;
            case "Comune_2" -> this.semaphoreForPa2;
            case "Comune_Multi" -> this.semaphoreForPa3;
            default -> throw new IllegalArgumentException();
        };
        semaphoreToRelease.release(numberOfStreamRequest);
    }


}
