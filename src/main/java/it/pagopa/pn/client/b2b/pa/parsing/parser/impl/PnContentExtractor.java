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
import java.util.regex.Matcher;
import java.util.regex.Pattern;


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
        String cleanedText = cleanUpText(text);
        List<String> cleanedList = cleanUpList(cleanedText, valuesList);
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

    @Override
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

    private String getFieldByToken(PnTextSlidingWindow pnTextSlidingWindow, String value) {
        if(isValueBetweenTokens(pnTextSlidingWindow.getSlidedText(), value, pnTextSlidingWindow.getTokenStart(), pnTextSlidingWindow.getTokenEnd())) {
            return value;
        }
        return null;
    }

    private boolean isValueBetweenTokens(String text, String value, String tokenStart, String tokenEnd) {
        String checkingLeft = extractAdjacentWordByValue(text, value, tokenStart, true);
        String checkingRight = extractAdjacentWordByValue(text, value, tokenEnd, false);
        if(checkingLeft != null || checkingRight != null)
            return isExactlyContained(checkingLeft, tokenStart) && isExactlyContained(checkingRight, tokenEnd);
        return false;
    }

    private boolean isExactlyContained(String source, String subItem) {
        String quotedSubItem = Pattern.quote(subItem);
        String pattern = "(?<!\\S)" + quotedSubItem + "(?!\\S)";

        Pattern p = Pattern.compile(pattern);
        Matcher m = p.matcher(source);
        return m.find();
    }

    private int countTokenWords(String input) {
        if (input == null || input.trim().isEmpty()) {
            return 0;
        }
        String[] words = input.trim().split("\\s+");
        return words.length;
    }

    private String extractAdjacentWordByValue(String text, String value, String token, boolean isLeft) {
        int wordCount = countTokenWords(token);
        String regex = "\\s+";
        int position = text.indexOf(value);
        if(position == -1)
            return null;
        StringBuilder stringBuilder = new StringBuilder();

        if(isLeft) {
            String substring = text.substring(0, position);
            String[] words = substring.split(regex);
            for (int i = Math.max(0, words.length - wordCount * 2); i < words.length; i++) {
                stringBuilder.append(words[i]);
                stringBuilder.append(" ");
            }
        } else {
            String substring = text.substring(position+value.length());
            String[] words = substring.split(regex);
            for (int i = 0; i < Math.min(wordCount * 2, words.length); i++) {
                stringBuilder.append(words[i]);
                stringBuilder.append(" ");
            }
        }
        return stringBuilder.toString().trim();
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
                    List<Integer> brokenValueList = concatenateValue(pnTextSlidingWindow, value, composeList);
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

    private List<Integer> concatenateValue(PnTextSlidingWindow pnTextSlidingWindow, String value, List<String> valueList) {
        String text = pnTextSlidingWindow.getSlidedText();
        String tokenStart = pnTextSlidingWindow.getTokenStart();
        String tokenEnd = pnTextSlidingWindow.getTokenEnd();

        // Trovare l'indice posizionale di tokenStart, value e tokenEnd
        int pos1 = customIndexOf(text, tokenStart, 0);
        int indexValue = text.indexOf(value);
        if (pos1 == -1 || (pos1 > indexValue))
            return null;

        int pos2 = text.indexOf(value, pos1 + tokenStart.length());
        if (pos2 == -1 || !text.substring(pos1 + tokenStart.length() + countControlCharacters(text.substring(pos1, pos2)), pos2).trim().isEmpty())
            return null; // Non vi sono parole tra tokenStart e value

        int pos3 = customIndexOf(text, tokenEnd, pos2 + value.length());
        if (pos3 == -1)
            return null; // Non vi sono parole tra value e tokenEnd

        // Controlla se vi sono parole tra il value ed il tokenEnd
        String betweenText = text.substring(pos2 + value.length(), pos3).trim();
        if (!betweenText.isEmpty()) {
            List<Integer> brokenValueList = cleanUpByBrokenValues(betweenText, valueList);
            if(!brokenValueList.isEmpty()) {
                int substituteIndex = brokenValueList.remove(0);
                String concatenatedValue = value.trim() + "\r\n" + betweenText;
                valueList.set(substituteIndex, concatenatedValue);
                brokenValueList.sort(Collections.reverseOrder());
                brokenValueList.forEach(brokenValue -> valueList.remove(brokenValue.intValue()));
            }
            return brokenValueList;
        }
        return null;
    }

    private int countControlCharacters(String input) {
        if (input == null) {
            return 0;
        }

        int count = 0;
        for (int i = 0; i < input.length(); i++) {
            if (Character.isISOControl(input.charAt(i))) {
                count++;
            }
        }
        return count;
    }

    private List<Integer> cleanUpByBrokenValues(String betweenText, List<String> valueList) {
        List<Integer> brokenValueList = new ArrayList<>();
        String[] splitted = betweenText.split(pnLegalFactTokens.getTokenProps().getRegexCarriageNewline());
        int posToRemove = valueList.indexOf(splitted[0]);
        if (posToRemove != -1)
            brokenValueList.add(posToRemove-1);

        for(String valSplit: splitted) {
            posToRemove = valueList.indexOf(valSplit.trim());
            if (posToRemove != -1)
                brokenValueList.add(posToRemove);
        }
        return brokenValueList;
    }

    private String cleanUpText(String text) {
        String cleanedText = text.replaceAll(pnLegalFactTokens.getTokenProps().getCleanupFooter(), "");
        cleanedText = cleanedText.replaceAll(pnLegalFactTokens.getTokenProps().getRegexCleanupNsbp(), "");
        cleanedText = normalizeLineEndings(cleanedText);
        return cleanedText.trim();
    }

    private List<String> cleanUpList(String text, List<String> boldValueList) {
        List<String> cleanedList = removeUselessValues(boldValueList);
        return removeHashValues(text, cleanedList);
    }

    private String normalizeLineEndings(String text) {
        // Sostituisce tutte le occorrenze di '\r\n' e '\n' con '\n' temporaneamente
        text = text.replace("\r\n", "\n").replace("\r", "\n");
        // Suddivide il testo in righe
        String[] lines = text.split("\n");
        // Unisce le righe con '\r\n'
        StringBuilder normalizedText = new StringBuilder();
        for (String line : lines) {
            if (!line.trim().isEmpty()) {
                normalizedText.append(line.trim()).append("\r\n"); // Rimuove spazi finali e aggiunge '\r\n'
            }
        }
        return normalizedText.toString();
    }

    private int customIndexOf(String source, String toFind, int fromIndex) {
        if (fromIndex < 0 || fromIndex >= source.length()) {
            return -1;
        }
        // Normalizzazione delle stringhe da cui iniziare la ricerca
        String sourceFromIndex = source.substring(fromIndex);
        String normalizedSourceFromIndex = sourceFromIndex.replaceAll("[\r\n\\s]+", "");
        String normalizedToFind = toFind.replaceAll("[\r\n\\s]+", "");

        int indexInNormalized = normalizedSourceFromIndex.indexOf(normalizedToFind);
        if (indexInNormalized == -1) {
            return -1;
        }
        // Calcolo della posizione reale nella stringa originale
        int sourcePos = fromIndex;
        int matchPos = 0;

        while (sourcePos < source.length() && matchPos < indexInNormalized) {
            char currentChar = source.charAt(sourcePos);
            if (!Character.isWhitespace(currentChar) && currentChar != '\r' && currentChar != '\n') {
                matchPos++;
            }
            sourcePos++;
        }
        return sourcePos+1;
    }

    private List<String> removeUselessValues(List<String> boldValueList) {
        List<String> cleanedList = new ArrayList<>(boldValueList);
        cleanedList.remove(0);
        cleanedList.remove(pnLegalFactTokens.getTokenProps().getCleanupDestinatario());
        cleanedList.remove(pnLegalFactTokens.getTokenProps().getCleanupDelegato());
        return cleanedList;
    }

    private List<String> removeHashValues(String text, List<String> boldValueList) {
        List<String> cleanedList = new ArrayList<>(boldValueList);
        if(text.contains(pnLegalFactTokens.getTokenProps().getHashStart())) {
            cleanedList.removeIf(value -> isValueBetweenTokens(text, value, pnLegalFactTokens.getTokenProps().getHashStart(), pnLegalFactTokens.getTokenProps().getHashEnd()));
        }
        return cleanedList;
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