package it.pagopa.pn.client.b2b.pa.polling.mapper;

import it.pagopa.pn.client.b2b.pa.polling.model.PnGenericFullSentNotification;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;


@Component
public class PnGenericFullSentNotificationMapper {
    private final ModelMapper modelMapper;


    public PnGenericFullSentNotificationMapper(ModelMapper modelMapper) {
        this.modelMapper = modelMapper;
    }

    public PnGenericFullSentNotification mapToGeneric(Object object) {
        if(object == null) {
            return null;
        }
        return modelMapper.map(object, PnGenericFullSentNotification.class);
    }
}