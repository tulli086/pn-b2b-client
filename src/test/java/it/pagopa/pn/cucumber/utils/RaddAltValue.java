package it.pagopa.pn.cucumber.utils;


import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Arrays;
import java.util.Map;

public enum RaddAltValue {
//physicalAddress sportello radd
    ADDRESS_RADD("address_radd","SI"),
    ADDRESS_RADD_ROW("address_radd_row","SI"),
    ADDRESS_RADD_CAP("address_radd_cap","SI"),
    ADDRESS_RADD_CITY("address_radd_city","SI"),
    ADDRESS_RADD_PROVINCE("address_radd_province",""),
    ADDRESS_RADD_COUNTRY("address_radd_country","ITALIA"),

    RADD_DESCRIPTION("radd_description",null),
    RADD_PHONE_NUMBER("radd_phoneNumber",null),
    RADD_GEO_LOCATION("radd_geoLocation","SI"),
    RADD_GEO_LOCATION_LATITUDINE("radd_geoLocation_latitudine",null),
    RADD_GEO_LOCATION_LONGITUDINE("radd_geoLocation_longitudine",null),
    RADD_OPENING_TIME("radd_openingTime",null),
    RADD_START_VALIDITY("radd_start_validity",""),
    RADD_END_VALIDITY("radd_end_validity",""),

    //valori filtro per ricerca sportello
    RADD_FILTER_LIMIT("radd_filter_limit","ITALIA"),
    RADD_FILTER_FILEKEY("radd_filter_filekey","ITALIA"),
    RADD_EXTERNAL_CODE("radd_externalCode",null);



    private static final String NULL_VALUE = "NULL";

    public final String key;
    private final String defaultValue;
    private static final ObjectMapper mapper = new ObjectMapper();



    RaddAltValue(String key, String defaultValue){
        this.key = key;
        this.defaultValue = defaultValue;
    }



    public static String getDefaultValue(String key) {
        RaddAltValue notificationValue =
                Arrays.stream(RaddAltValue.values()).filter(value -> value.key.equals(key)).findFirst().orElse(null);

        return (notificationValue == null ? null :  notificationValue.defaultValue);
    }



    public static String getValue(Map<String, String> data, String key){
        if(data.containsKey(key)){
            return data.get(key).equals(NULL_VALUE) ? null : (data.get(key).contains("_CHAR")? getCharSeq(data.get(key)):data.get(key));
        }else{
            return getDefaultValue(key);
        }
    }

    public static String getCharSeq(String request){
        StringBuilder result = new StringBuilder();
        Integer number = Integer.parseInt(request.substring(0,request.indexOf("_")));
        for(int i = 0; i < number; i++){
            result.append("a");
        }
        return result.toString();
    }


}