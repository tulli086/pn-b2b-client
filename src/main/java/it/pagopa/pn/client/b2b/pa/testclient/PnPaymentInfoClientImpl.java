package it.pagopa.pn.client.b2b.pa.testclient;


import it.pagopa.pn.client.b2b.web.generated.openapi.clients.payment_info.ApiClient;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.payment_info.api.PaymentInfoApi;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.payment_info.model.PaymentInfo;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.payment_info.model.PaymentInfoRequest;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.payment_info.model.PaymentInfoV21;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.util.List;


@Component
public class PnPaymentInfoClientImpl implements IPnPaymentInfoClientImpl{

    private final ApplicationContext ctx;
    private final RestTemplate restTemplate;


    private final String basePath;

    private final String key;

    private final PaymentInfoApi paymentInfoApi;


   // private final String paId;
    private final String operatorId;

    public PnPaymentInfoClientImpl(
            ApplicationContext ctx,
            RestTemplate restTemplate,
            @Value("${pn.webapi.external.base-url.pagopa}") String deliveryBasePath ,
            @Value("${pn.external.bearer-token-payinfo}") String key
    ) {

       // this.paId = paId;
        this.operatorId = "AutomationMv";
        this.ctx = ctx;
        this.restTemplate = restTemplate;
        this.basePath = deliveryBasePath;
        this.key=key;
        this.paymentInfoApi = new PaymentInfoApi(newApiClient( restTemplate, basePath,key));




    }

    private static ApiClient newApiClient(RestTemplate restTemplate, String basePath, String key) {
        ApiClient newApiClient = new ApiClient( restTemplate );
        newApiClient.setBasePath( basePath );
        newApiClient.setBearerToken(key);
        return newApiClient;
    }


    public PaymentInfo getPaymentInfo(String paTaxId, String noticeNumber) throws RestClientException {
        return paymentInfoApi.getPaymentInfoWithHttpInfo(paTaxId, noticeNumber).getBody();
    }

    @Override
    public List<PaymentInfoV21> getPaymentInfoV21(List<PaymentInfoRequest> paymentInfoRequest) throws RestClientException {
        return paymentInfoApi.getPaymentInfoV21WithHttpInfo(paymentInfoRequest).getBody();
    }

}
