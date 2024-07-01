package it.pagopa.pn.client.b2b.pa.parsing.parser.impl;

import it.pagopa.pn.client.b2b.pa.parsing.config.PnLegalFactTokens;
import it.pagopa.pn.client.b2b.pa.parsing.exception.PnParserException;
import it.pagopa.pn.client.b2b.pa.parsing.parser.PnTextSlidingWindow;
import it.pagopa.pn.client.b2b.pa.parsing.model.PnParserRecord;
import it.pagopa.pn.client.b2b.pa.parsing.parser.IPnContentExtractor;
import it.pagopa.pn.client.b2b.pa.parsing.service.IPnParserService;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.text.TextPosition;
import org.springframework.core.io.Resource;
import java.io.IOException;
import java.util.*;
import static it.pagopa.pn.client.b2b.pa.parsing.util.PnParserContentUtil.*;


@Slf4j
public class PnContentExtractor implements IPnContentExtractor {
    private final PnLegalFactTokens pnLegalFactTokens;


    public PnContentExtractor(PnLegalFactTokens pnLegalFactTokens) {
        this.pnLegalFactTokens = pnLegalFactTokens;
    }

    @Override
    public PnParserRecord.PnParserContent extractContent(Resource resource, String source, IPnParserService.LegalFactType legalFactType) {
        try (final PDDocument document = Loader.loadPDF(resource.getFile())) {
            PnBoldWordExtractor boldWordExtractor = new PnBoldWordExtractor();
            boldWordExtractor.setSortByPosition(true);
            boldWordExtractor.getText(document);

            PDFTextStripper pdfTextStripper = new PDFTextStripper();
            pdfTextStripper.setSortByPosition(true);
            pdfTextStripper.setStartPage(0);
            pdfTextStripper.setEndPage(document.getNumberOfPages());

            List<String> boldValueList = boldWordExtractor.getBoldWordList();
            if(boldValueList.isEmpty()) throw new PnParserException("PDF not valid: document did not contain bold words!!!");

            return getContent(pdfTextStripper.getText(document), boldValueList, legalFactType);
        } catch (IOException exception) {
            log.error("PdfBox error: {}", exception.getMessage());
        } catch (RuntimeException exception) {
            log.error("Error during parsing: {}", exception.getMessage());
        }
        return null;
    }

    @Override
    public PnParserRecord.PnParserContent getContent(String text, List<String> valuesList, IPnParserService.LegalFactType legalFactType) {
        String cleanedText = cleanUpText(text, pnLegalFactTokens.getTokenProps());
        List<String> cleanedList = cleanUpList(cleanedText, valuesList, pnLegalFactTokens.getTokenProps());
        return new PnParserRecord.PnParserContent(cleanedText, composeBrokenValue(cleanedText, cleanedList, legalFactType));
    }

    @Override
    public String getField(PnTextSlidingWindow pnTextSlidingWindow, List<String> valuesList) {
        for(String value: valuesList) {
            String field = getFieldByToken(pnTextSlidingWindow, value);
            if(field != null && !pnTextSlidingWindow.isToDiscard(value)) {
                return field;
            }
            pnTextSlidingWindow.slideWindow(value);
        }
        return null;
    }

    @Override
    public String cleanUp(String text, boolean mantainWhitespace) {
        if(mantainWhitespace) {
            return text.replaceAll(pnLegalFactTokens.getTokenProps().getRegexCarriageNewline(), " ");
        }
        return text.replaceAll(pnLegalFactTokens.getTokenProps().getRegexCarriageNewline(), "");
    }

    public int countDuplicates(String text, String toSearch) {
        if (toSearch.isEmpty()) {
            return 0;
        }
        int count = 0;
        int fromIndex = 0;
        while ((fromIndex = text.indexOf(toSearch, fromIndex)) != -1) {
            count++;
            fromIndex += toSearch.length();
        }
        return count;
    }

    private List<String> composeBrokenValue(String text, List<String> toRecomposeList, IPnParserService.LegalFactType legalFactType) {
        PnTextSlidingWindow pnTextSlidingWindow = PnTextSlidingWindow.builder().slidedText(text).originalText(text).build();
        List<String> composeList = new ArrayList<>(toRecomposeList);
        LinkedList<String> linkedList = new LinkedList<>(toRecomposeList);
        ListIterator<String> iterator = linkedList.listIterator(0);

        while (iterator.hasNext()) {
            String value = iterator.next();
            for(PnLegalFactTokens.TokenFieldGroup group: pnLegalFactTokens.getFieldTokenList()) {
                if(group.getLegalFactTypeList().contains(legalFactType)) {
                    pnTextSlidingWindow.setTokenStart(group.getTokenStart());
                    pnTextSlidingWindow.setTokenEnd(group.getTokenEnd());
                    List<Integer> brokenValueList = concatenateValue(pnTextSlidingWindow, value, composeList, pnLegalFactTokens.getTokenProps());
                    if(brokenValueList != null) {
                        for(int i = 1; i <= brokenValueList.size(); i++) {
                            iterator.next();
                        }
                        break;
                    }
                }
            }
            pnTextSlidingWindow.slideWindow(value);
        }
        return composeList;
    }


    @Getter
    private class PnBoldWordExtractor extends PDFTextStripper {
        private final String BOLD = "bold";
        private List<String> boldWordList;

        public PnBoldWordExtractor() {
            super();
            boldWordList = new ArrayList<>();
        }

        @Override
        protected void writeString(String text, List<TextPosition> textPositions)  {
            StringBuilder boldWord = new StringBuilder();
            boolean isBold = false;

            for (TextPosition textPosition: textPositions) {
                if (textPosition.getFont().getName().toLowerCase().contains(BOLD)) {
                    isBold = true;
                    boldWord.append(textPosition.getUnicode());
                } else {
                    foundBoldWord(boldWord, isBold);
                    isBold = false;
                }
            }
            foundBoldWord(boldWord, isBold);
        }

        private void foundBoldWord(StringBuilder boldWord, boolean isBold) {
            if (isBold && !boldWord.isEmpty()) {
                boldWordList.add(boldWord.toString().trim());
                boldWord.setLength(0);
            }
        }
    }
}