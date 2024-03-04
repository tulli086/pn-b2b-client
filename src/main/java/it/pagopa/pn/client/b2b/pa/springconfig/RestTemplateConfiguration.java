package it.pagopa.pn.client.b2b.pa.springconfig;


import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpRequest;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@Configuration
public class RestTemplateConfiguration {

    public static final String CUCUMBER_SCENARIO_NAME_MDC_ENTRY = "cucumber_scenario_name";

    private static final int MAX_CONN_PER_ROUTE = 10; //DEFAULT 5
    private static final int MAX_CONN_TOTAL = 20; //DEFAULT 10

    @Bean
    @Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
    public RestTemplate restTemplate() {
        RestTemplate restTemplate = new RestTemplate();
        HttpComponentsClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory();

        requestFactory.setHttpClient(httpClient());

        requestFactory.setConnectTimeout(70_000);
        requestFactory.setReadTimeout(70_000);
        requestFactory.setConnectionRequestTimeout(70_000);
        requestFactory.setBufferRequestBody(false);

        restTemplate.setRequestFactory(requestFactory);

        List<ClientHttpRequestInterceptor> interceptors = restTemplate.getInterceptors();
        if( interceptors == null ) {
            interceptors = new ArrayList<>();
            restTemplate.setInterceptors( interceptors );
        }
        interceptors.add(new RequestAndTraceIdInterceptor());

        return restTemplate;
    }

    private HttpClient httpClient() {
        HttpClientBuilder httpClientBuilder =
                HttpClientBuilder.create()
                        .setMaxConnPerRoute(MAX_CONN_PER_ROUTE)
                        .setMaxConnTotal(MAX_CONN_TOTAL);

        return httpClientBuilder.build();
    }

    private static class RequestAndTraceIdInterceptor implements ClientHttpRequestInterceptor {

        public static final String TRACE_ID_RESPONSE_HEADER_NAME = "x-amzn-trace-Id";

        public Logger log = LoggerFactory.getLogger( RequestAndTraceIdInterceptor.class );

        @Override
        public ClientHttpResponse intercept(HttpRequest request, byte[] body, ClientHttpRequestExecution execution) throws IOException {

            ClientHttpResponse response = execution.execute( request, body );

            doLog( request, response );

            return response;
        }

        private void doLog(HttpRequest request, ClientHttpResponse response) {
            String httpMethod = request.getMethodValue();
            String requestUrl = request.getURI().toString();
            String traceId = getTraceIdFromHttpResponse( response );

            String scenarioName = MDC.get( CUCUMBER_SCENARIO_NAME_MDC_ENTRY );
            log.info("Request TraceId, method, url, scenario: [" + traceId + ", " + httpMethod + ", " + requestUrl + ", " + scenarioName + "]");
        }

        private String getTraceIdFromHttpResponse(ClientHttpResponse response) {
            String traceId;

            HttpHeaders responseHeaders = response.getHeaders();
            if ( responseHeaders != null ) {

                List<String> traceIdHeaderValues = responseHeaders.get(TRACE_ID_RESPONSE_HEADER_NAME);
                traceId = getFirstOrNull( traceIdHeaderValues );
            }
            else {
                traceId = null;
            }
            return traceId;
        }

        private String getFirstOrNull( List<String> list ) {
            String result;
            if( list != null && list.size() > 0 ) {
                result = list.get( 0 );
            }
            else {
                result = null;
            }
            return result;
        }
    }
}
