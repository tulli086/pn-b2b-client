package it.pagopa.pn.client.b2b.pa.parsing.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@Builder
public class PnTextSlidingWindow {
    private String originalText;
    private String slidedText;
    private String tokenStart;
    private String tokenEnd;


    public void slideWindow(String pointToSlide) {
        int slidingIndex = slidedText.indexOf(pointToSlide);
        if(slidingIndex == -1)
            return;
        else
            slidingIndex = slidingIndex + pointToSlide.length();
        this.slidedText = slidedText.substring(slidingIndex);
    }
}