package it.pagopa.pn.client.b2b.pa.polling.mapper;

import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;


@Component
public class PnGenericFullSentNotificationMapper {
    private final ModelMapper modelMapper;

    public PnGenericFullSentNotificationMapper(ModelMapper modelMapper) {
        this.modelMapper = modelMapper;
    }
}