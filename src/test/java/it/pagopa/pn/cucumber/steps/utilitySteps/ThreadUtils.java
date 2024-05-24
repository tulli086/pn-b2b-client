package it.pagopa.pn.cucumber.steps.utilitySteps;

import static org.awaitility.Awaitility.await;

import java.util.concurrent.TimeUnit;
import lombok.extern.slf4j.Slf4j;
import org.awaitility.core.ConditionTimeoutException;

@Slf4j
public class ThreadUtils {

  private static void threadWait(long wait, TimeUnit timeUnit) {
    if(wait <= 100) {
      wait = 101;
    }
    try {
      await()
          .atMost(wait, timeUnit)
          .with()
          .until(() -> false);
    } catch (ConditionTimeoutException exception) {
      log.info("Thread wait ended.");
    }
  }

  public static void threadWaitMilliseconds(long wait) {
    threadWait(wait, TimeUnit.MILLISECONDS);
  }

  public static void threadWaitSeconds(long wait) {
    threadWait(wait, TimeUnit.SECONDS);
  }

  public static void threadWaitMinutes(long wait) {
    threadWait(wait, TimeUnit.MINUTES);
  }
}
