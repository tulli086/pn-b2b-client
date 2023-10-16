package it.pagopa.pn.client.b2b.pa.testclient;

import it.pagopa.pn.client.b2b.web.generated.openapi.clients.gpd.model.PaymentPositionModel;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.gpd.model.PaymentPositionModelBaseResponse;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.gpd.model.PaymentPositionsInfo;
import it.pagopa.pn.client.b2b.web.generated.openapi.clients.payment_info.model.PaymentInfo;
import org.springframework.web.client.RestClientException;

import java.time.LocalDate;
import java.util.List;

public interface IPnPaymentInfoClientImpl {

    public List<Object> getPaymentInfoV21(List<Object> requestBody) throws RestClientException ;


    }
