package it.pagopa.pn.client.b2b.pa.parsing.parser;

import it.pagopa.pn.client.b2b.pa.parsing.config.PnB2bLegalFactTextTokens;
import it.pagopa.pn.client.b2b.pa.parsing.service.IPnParserService;
import lombok.extern.slf4j.Slf4j;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;


@Slf4j
@Component
public class PnLegalFactParser implements IPnParserService {
    private final PnB2bLegalFactTextTokens pnB2bLegalFactTextTokens;

//    @Value("classpath:pdfToParse/AOT_avvenuto_accesso_delegato.pdf")
//    @Value("classpath:pdfToParse/PN_DOWNTIME_LEGAL_FACTS-cd8d10909ce94a5a8759398f34078636.pdf")
//    @Value("classpath:pdfToParse/PN_LEGAL_FACTS-avvenuto accesso.pdf")
//    @Value("classpath:pdfToParse/PN_LEGAL_FACTS-mancato recapito digitale.pdf")
    @Value("classpath:pdfToParse/PN_LEGAL_FACTS-notifica digitale.pdf")
//    @Value("classpath:pdfToParse/PN_LEGAL_FACTS-notifica presa in carico.pdf")
//    @Value("classpath:pdfToParse/PN_LEGAL_FACTS-notifica presa in carico_multidest.pdf")
    private Resource localPdf;


    @Autowired
    public PnLegalFactParser(PnB2bLegalFactTextTokens pnB2bLegalFactTextTokens)  {
        this.pnB2bLegalFactTextTokens = pnB2bLegalFactTextTokens;
    }

    private HashMap<String, String> parse(String source, String campo, LegalFactType legalFactType) throws IOException {
        HashMap<String, String> result = new HashMap();

        String pdfText = extractContent(source);
        log.info("PDF TEXT{}", pdfText);

        if(legalFactType.equals(IPnParserService.LegalFactType.LEGALFACT_NOTIFICA_DOWNTIME)) {

        } else if(legalFactType.equals(IPnParserService.LegalFactType.LEGALFACT_NOTIFICA_DIGITALE)) {
            String iun = extractValue(pdfText, pnB2bLegalFactTextTokens.getStartIun(), pnB2bLegalFactTextTokens.getEndIun());
            log.info("IUN {}",  iun);
            result.put(campo, iun);
        } else if(legalFactType.equals(IPnParserService.LegalFactType.LEGALFACT_NOTIFICA_MANCATO_RECAPITO)) {

        } else if(legalFactType.equals(IPnParserService.LegalFactType.LEGALFACT_NOTIFICA_PRESA_IN_CARICO)) {

        } else if(legalFactType.equals(IPnParserService.LegalFactType.LEGALFACT_NOTIFICA_PRESA_IN_CARICO_MULTIDESTINATARIO)) {

        } else if(legalFactType.equals(IPnParserService.LegalFactType.LEGALFACT_NOTIFICA_AVVENUTO_SUCCESSO)) {

        } else if(legalFactType.equals(IPnParserService.LegalFactType.LEGALFACT_NOTIFICA_AVVENUTO_SUCCESSO_DELEGATO)) {

        }

        return result;
    }

    private String extractValue(String text, String start, String end) {
        String substring = text.split(start)[1];
        int endStart = substring.lastIndexOf(end);
        return substring.substring(0, endStart).trim();
    }

    public String extractContent(final String source) throws IOException {
        log.info("Sorgente {}", source);
        File file = localPdf.getFile();
        try (final PDDocument document = Loader.loadPDF(file)) {
            final PDFTextStripper pdfStripper = new PDFTextStripper();
            pdfStripper.setSortByPosition(true);
            return pdfStripper.getText(document);
        } catch (Exception exception) {
            log.error("Error parsing PDF {}", exception);
        }
        return null;
    }

    @Override
    public String extractSingle(String source, String campo, LegalFactType legalFactType) throws IOException {
        HashMap<String, String> map = parse(source, campo, legalFactType);
        return map.get(campo);
    }

    @Override
    public HashMap<String, String> extractMulti(String source, LegalFactType legalFactType) throws IOException {
        return parse(source, null, legalFactType);
    }
}