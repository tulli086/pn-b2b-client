package it.pagopa.pn.client.b2b.pa.utils;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.ToString;

@AllArgsConstructor
@Data
@ToString
public class Pair <K, E> {
    K value1;
    E value2;
}