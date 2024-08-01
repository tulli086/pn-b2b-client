package it.pagopa.pn.cucumber.steps;

import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCRUD.Address;
import it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCsv.RegistryRequestResponse;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;

@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class ConditionFilteredUtil {

    public boolean checkStatusAndMessageValid(RegistryRequestResponse elem, List<Map<String, String>> csvData, List<Address> addresses) {
        it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCsv.Address addressReceived = elem.getOriginalRequest().getOriginalAddress();
        return csvData.stream()
                .anyMatch(data -> {
                    String index = data.get("index");
                    return checkStatus(elem, data) && checkInCaseOfError(elem, data)
                            && (addressReceived == null || sameAddress(addresses.get(Integer.parseInt(index)), addressReceived));
                });
    }

    private boolean checkStatus(RegistryRequestResponse elem, Map<String, String > data) {
        String status = data.get("status");
        return elem.getStatus().equalsIgnoreCase(status);
    }

    private boolean checkInCaseOfError(RegistryRequestResponse elem, Map<String, String > data) {
        String errorMessage = data.get("errorMessage");
        String status = data.get("status");
        return  !status.equalsIgnoreCase("REJECTED") || errorMessage == null || (elem.getError() != null && elem.getError().equalsIgnoreCase(errorMessage));
    }

    private boolean sameAddress(Address expectedAddress,
                                it.pagopa.pn.client.b2b.radd.generated.openapi.clients.externalb2braddalt.model_AnagraficaCsv.Address actualAddress) {
        return  ((actualAddress.getAddressRow() == null || actualAddress.getAddressRow().equalsIgnoreCase(expectedAddress.getAddressRow()))
                && (actualAddress.getCap() == null || actualAddress.getCap().equalsIgnoreCase(expectedAddress.getCap()))
                && (actualAddress.getCity() == null || actualAddress.getCity().equalsIgnoreCase(expectedAddress.getCity()))
                && (actualAddress.getPr() == null || actualAddress.getPr().equalsIgnoreCase(expectedAddress.getPr()))
                && (actualAddress.getCountry() == null || actualAddress.getCountry().equalsIgnoreCase(expectedAddress.getCountry())));

    }

    public <T> Predicate<T> distinctByKey(Function<? super T, Object> keyExtractor) {
        Map<Object, Boolean> map = new ConcurrentHashMap<>();
        return t -> {
            Object key = keyExtractor.apply(t);
            if (key == null) key = new Object();
            return map.putIfAbsent(key, Boolean.TRUE) == null;
        };
    }
}
