package it.pagopa.pn.client.b2b.pa.exception;

import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;


@Aspect
@Component
public class PnB2bExceptionAspect {
//    @Around("execution(* it.pagopa.pn..*.*(..))")
//    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
//        Object proceed = joinPoint.proceed();
//        return proceed;
//    }

    @AfterThrowing(pointcut = "execution(* it.pagopa.pn..*.*(..))", throwing = "ex")
    public void handleExceptions(Exception ex) {
        logErrorBasedOnExceptionType(ex);
    }

    private void logErrorBasedOnExceptionType(Exception exception) {
        if(exception instanceof RestClientException) {
//            throw new PnB2bAssertionClientException(exception.getMessage(), description, ERROR_CODE_B2B_APIKEY_MANAGER_FAILED);
        }
//        else if (ex instanceof IOException ioEx) {
//            log.error("IOException occurred: {}", ioEx.getMessage());
//        } else {
//            log.error("Exception occurred: {}", ex.getMessage());
//        }
    }
}
