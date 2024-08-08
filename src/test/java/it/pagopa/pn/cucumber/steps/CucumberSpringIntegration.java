package it.pagopa.pn.cucumber.steps;

import io.cucumber.spring.CucumberContextConfiguration;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.config.PnB2bClientTimingConfigs;
import it.pagopa.pn.client.b2b.pa.config.springconfig.ApiKeysConfiguration;
import it.pagopa.pn.client.b2b.pa.config.springconfig.BearerTokenConfiguration;
import it.pagopa.pn.client.b2b.pa.config.springconfig.MailSenderConfig;
import it.pagopa.pn.client.b2b.pa.config.springconfig.RestTemplateConfiguration;
import it.pagopa.pn.client.b2b.pa.config.springconfig.TimingConfiguration;
import it.pagopa.pn.client.b2b.pa.polling.design.PnPollingFactory;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceStatusExtraRapidV23;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceStatusRapidV1;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceStatusRapidV20;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceStatusRapidV21;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceStatusRapidV23;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceStatusSlowV1;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceStatusSlowV20;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceStatusSlowV21;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceStatusSlowV23;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceTimelineExtraRapidV23;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceTimelineRapidV1;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceTimelineRapidV20;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceTimelineRapidV21;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceTimelineRapidV23;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceTimelineSlowE2eV23;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceTimelineSlowV1;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceTimelineSlowV20;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceTimelineSlowV21;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceTimelineSlowV23;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceValidationStatusAcceptedExtraRapidV23;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceValidationStatusAcceptedShortV23;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceValidationStatusNoAcceptedV23;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceValidationStatusV1;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceValidationStatusV20;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceValidationStatusV21;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceValidationStatusV23;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceWebhookV20;
import it.pagopa.pn.client.b2b.pa.polling.impl.PnPollingServiceWebhookV23;
import it.pagopa.pn.client.b2b.pa.service.impl.IPnInteropProbingClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnApiKeyManagerExternalClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnAppIOB2bExternalClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnDowntimeLogsExternalClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnExternalChannelsServiceClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnExternalServiceClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnGPDClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnIoUserAttributerExternaClient;
import it.pagopa.pn.client.b2b.pa.service.impl.PnPaB2bExternalClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnPaymentInfoClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnPrivateDeliveryPushExternalClient;
import it.pagopa.pn.client.b2b.pa.service.impl.PnRaddAlternativeClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnRaddFsuClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnServiceDeskClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnWebMandateExternalClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnWebPaClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnWebRecipientExternalClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnWebUserAttributesExternalClientImpl;
import it.pagopa.pn.client.b2b.pa.service.impl.PnWebhookB2bExternalClientImpl;
import it.pagopa.pn.client.b2b.pa.service.utils.InteropTokenSingleton;
import it.pagopa.pn.client.b2b.pa.utils.TimingForPolling;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.scheduling.annotation.EnableScheduling;


@CucumberContextConfiguration
@SpringBootTest(classes = {
        ApiKeysConfiguration.class,
        BearerTokenConfiguration.class,
        TimingConfiguration.class,
        RestTemplateConfiguration.class,
        PnPaB2bUtils.class,
        PnPaB2bExternalClientImpl.class,
        PnWebRecipientExternalClientImpl.class,
        PnWebhookB2bExternalClientImpl.class,
        PnWebMandateExternalClientImpl.class,
        PnExternalServiceClientImpl.class,
        PnWebUserAttributesExternalClientImpl.class,
        PnAppIOB2bExternalClientImpl.class,
        PnApiKeyManagerExternalClientImpl.class,
        PnDowntimeLogsExternalClientImpl.class,
    IPnInteropProbingClientImpl.class,
        PnIoUserAttributerExternaClient.class,
        PnWebPaClientImpl.class,
        PnPrivateDeliveryPushExternalClient.class,
        InteropTokenSingleton.class,
        PnServiceDeskClientImpl.class,
        PnGPDClientImpl.class,
        PnPaymentInfoClientImpl.class,
        PnRaddFsuClientImpl.class,
        PnRaddAlternativeClientImpl.class,
        TimingForPolling.class,
        PnB2bClientTimingConfigs.class,
        PnPollingFactory.class,
        PnPollingServiceTimelineRapidV23.class,
        PnPollingServiceTimelineRapidV21.class,
        PnPollingServiceTimelineRapidV20.class,
        PnPollingServiceTimelineRapidV1.class,
        PnPollingServiceStatusRapidV23.class,
        PnPollingServiceStatusRapidV21.class,
        PnPollingServiceStatusRapidV20.class,
        PnPollingServiceStatusRapidV1.class,
        PnPollingServiceTimelineSlowV23.class,
        PnPollingServiceTimelineSlowE2eV23.class,
        PnPollingServiceTimelineSlowV21.class,
        PnPollingServiceTimelineSlowV20.class,
        PnPollingServiceTimelineSlowV1.class,
        PnPollingServiceStatusSlowV23.class,
        PnPollingServiceStatusSlowV21.class,
        PnPollingServiceStatusSlowV20.class,
        PnPollingServiceStatusSlowV1.class,
        PnPollingServiceValidationStatusV1.class,
        PnPollingServiceValidationStatusV20.class,
        PnPollingServiceValidationStatusV21.class,
        PnPollingServiceValidationStatusV23.class,
        PnPollingServiceValidationStatusNoAcceptedV23.class,
        PnPollingServiceValidationStatusAcceptedShortV23.class,
        PnPollingServiceWebhookV20.class,
        PnPollingServiceWebhookV23.class,
        PnPollingServiceValidationStatusAcceptedExtraRapidV23.class,
        PnPollingServiceStatusExtraRapidV23.class,
        PnPollingServiceTimelineExtraRapidV23.class,
        MailSenderConfig.class,
        PnExternalChannelsServiceClientImpl.class

})
@EnableScheduling
@EnableConfigurationProperties
public class CucumberSpringIntegration {
}