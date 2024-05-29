package it.pagopa.pn.client.b2b.pa.parsing.parser;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


@Getter
@Setter
@AllArgsConstructor
public class PnTextToken {
    private String text;

    public static String extractValue(Pattern pattern, String text) {
        Matcher matcher = pattern.matcher(text);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    public static String extractDateTime(Pattern pattern, String inputText) {
        Matcher matcher = pattern.matcher(inputText);
        if (matcher.find()) {
            return matcher.group(1) + " " + matcher.group(2);
        }
        return null;
    }

    public static List<String> extractMultiDate(Pattern pattern, String text) {
        Matcher matcher = pattern.matcher(text);
        List<String> dates = new ArrayList<>();
        while (matcher.find()) {
            dates.add(matcher.group(1));
        }
        if (dates.size() >= 2) {
            return dates;
        }
        return null;
    }
}