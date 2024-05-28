package it.pagopa.pn.client.b2b.pa.parsing.parser;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@AllArgsConstructor
public class PnTextToken {
    private String text;

    public String extractValue(String start, String end) {
        String substring = text.split(start)[1];
        int endIndex = substring.indexOf(end);
        text = substring;
        return substring.substring(0, endIndex).trim();
    }
}