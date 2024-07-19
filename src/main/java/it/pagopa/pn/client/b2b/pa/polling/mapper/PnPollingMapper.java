package it.pagopa.pn.client.b2b.pa.polling.mapper;

import lombok.Getter;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;


@Getter
@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class PnPollingMapper {
    private final ModelMapper modelMapper;

    public PnPollingMapper(ModelMapper modelMapper) {
        this.modelMapper = modelMapper;
    }
}