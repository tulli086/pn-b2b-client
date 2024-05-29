package it.pagopa.pn.client.b2b.pa.parsing.parser;

import it.pagopa.pn.client.b2b.pa.parsing.config.PnB2bLegalFactTextTokens;
import it.pagopa.pn.client.b2b.pa.parsing.dto.*;
import it.pagopa.pn.client.b2b.pa.parsing.model.IPnLegalFact;
import it.pagopa.pn.client.b2b.pa.parsing.model.PnDestinatarioDigitale;
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
import java.util.List;
import java.util.Objects;
import java.util.regex.Pattern;

import static it.pagopa.pn.client.b2b.pa.parsing.parser.PnTextToken.*;


@Slf4j
@Component
public class PnLegalFactParser implements IPnParserService {
    private final PnB2bLegalFactTextTokens pnB2bLegalFactTextTokens;
    private PnTextToken textToken;
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

    private IPnLegalFact parse(String source, LegalFactType legalFactType) throws IOException {
        String pdfText = extractContent(source);
        log.info("PDF TEXT{}", pdfText);
//        textToken = new PnTextToken(pdfText);

        if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_DOWNTIME)) {
            return getLegalFactNotificaDowntime(pdfText);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_DIGITALE)) {
            return getLegalFactNotificaDigitale(pdfText);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_MANCATO_RECAPITO)) {
            return getLegalFactNotificaMancatoRecapito(pdfText);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_PRESA_IN_CARICO)) {
            return getLegalFactNotificaPresaInCarico(pdfText);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_PRESA_IN_CARICO_MULTIDESTINATARIO)) {
//            return getLegalFactNotificaPresaInCaricoMultiDestinatario(pdfText);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_AVVENUTO_SUCCESSO)) {
//            return getLegalFactNotificaAvvenutoSuccesso(pdfText);
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_AVVENUTO_SUCCESSO_DELEGATO)) {
//            return getLegalFactNotificaAvvenutoSuccessoDelegato(pdfText);
        }

        return null;
    }

    private IPnLegalFact getLegalFactNotificaDowntime(String pdfText) {

        String dataOraDecorrenza = extractDateTime(Pattern.compile(pnB2bLegalFactTextTokens.getStartDataOraDecorrenza()), pdfText);
        String dataOraFine = extractDateTime(Pattern.compile(pnB2bLegalFactTextTokens.getStartDataOraFine()), pdfText);

        return PnLegalFactNotificaDowntime.builder()
                .dataOraDecorrenza(dataOraDecorrenza)
                .dataOraFine(dataOraFine)
                .build();
    }

    private IPnLegalFact getLegalFactNotificaDigitale(String pdfText) {

        String iun = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartIun()), pdfText);
        String nomeCognome = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale()), pdfText);
        String codiceFiscale = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartCodiceFiscale()), pdfText);
        String domicilioDigitale = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartDomicilioDigitale()), pdfText);
        String tipoDomicilioDigitale = Objects.requireNonNull(extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartTipoDomicilioDigitaleNotificaDigitale(), Pattern.DOTALL), pdfText)).replaceAll("[\\r\\n]", "");
        String dataAttestazioneOpponibile = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartDataNotificaDigitale()), pdfText);

        PnDestinatarioDigitale pnDestinatarioDigitale = new PnDestinatarioDigitale(
                nomeCognome,
                codiceFiscale,
                domicilioDigitale,
                tipoDomicilioDigitale
        );

        return PnLegalFactNotificaDigitale.builder()
                .iun(iun)
                .pnDestinatarioDigitale(pnDestinatarioDigitale)
                .dataAttestazioneOpponibile(dataAttestazioneOpponibile)
                .build();
    }

    private IPnLegalFact getLegalFactNotificaMancatoRecapito(String pdfText) {

        String iun = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartIun()), pdfText);
        String nomeCognome = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale()), pdfText);
        String codiceFiscale = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartCodiceFiscale()), pdfText);
        String domicilioDigitale = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartDomicilioDigitale()), pdfText);
        String tipoDomicilioDigitale = Objects.requireNonNull(extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartTipoDomicilioDigitale()), pdfText));
        List<String> date = extractMultiDate(Pattern.compile(pnB2bLegalFactTextTokens.getStartPrimaData()), pdfText);


        PnDestinatarioDigitale pnDestinatarioDigitale = new PnDestinatarioDigitale(
                nomeCognome,
                codiceFiscale,
                domicilioDigitale,
                tipoDomicilioDigitale
        );

        return PnLegalFactNotificaMancatoRecapito.builder()
                .iun(iun)
                .pnDestinatarioDigitale(pnDestinatarioDigitale)
                .primaData(Objects.requireNonNull(date).get(0))
                .secondaData(date.get(1))
                .build();
    }

    private IPnLegalFact getLegalFactNotificaPresaInCarico(String pdfText) {

        String dataAttestazione = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartDataNotificaPresaInCarico()), pdfText);
        String mittente = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartMittente()), pdfText);
        String cfMittente = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartCfMittente()), pdfText);
        String iun = Objects.requireNonNull(extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartIunNotificaPresaInCarico(), Pattern.DOTALL), pdfText)).replaceAll("[\\r\\n]", "");
        String nomeCognome = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale()), pdfText);
        String codiceFiscale = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartCodiceFiscale()), pdfText);
        String domicilioDigitale = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartDomicilioDigitale()), pdfText);
        String tipoDomicilioDigitale = extractValue(Pattern.compile(pnB2bLegalFactTextTokens.getStartTipoDomicilioDigitale()), pdfText);


        PnDestinatarioDigitale pnDestinatarioDigitale = new PnDestinatarioDigitale(
                nomeCognome,
                codiceFiscale,
                domicilioDigitale,
                tipoDomicilioDigitale
        );


        return PnLegalFactNotificaPresaInCarico.builder()
                .dataAttestazioneOpponibile(dataAttestazione)
                .mittente(mittente)
                .cfMittente(cfMittente)
                .iun(iun)
                .pnDestinatarioDigitale(pnDestinatarioDigitale)
                .build();
    }

//    private IPnLegalFact getLegalFactNotificaPresaInCaricoMultiDestinatario() {
//        PnLegalFactNotificaPresaInCaricoMultiDestinatario multiDestinatario = PnLegalFactNotificaPresaInCaricoMultiDestinatario.builder()
//                .dataAttestazioneOpponibile(extractValue(pnB2bLegalFactTextTokens.getStartDataNotificaPresaInCarico(), pnB2bLegalFactTextTokens.getEndDataNotificaPresaInCarico()))
//                .mittente(extractValue(pnB2bLegalFactTextTokens.getStartMittente(), pnB2bLegalFactTextTokens.getEndMittente()))
//                .cfMittente(extractValue(pnB2bLegalFactTextTokens.getStartCfMittente(), pnB2bLegalFactTextTokens.getEndCfMittente()))
//                .iun(extractValue(pnB2bLegalFactTextTokens.getStartIunNotificaPresaInCarico(), pnB2bLegalFactTextTokens.getEndIunNotificaPresaInCarico()))
//                .pnDestinatarioDigitale(new PnDestinatarioDigitale(
//                        extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSociale()),
//                        extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale()),
//                        extractValue(pnB2bLegalFactTextTokens.getStartDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndDomicilioDigitale()),
//                        extractValue(pnB2bLegalFactTextTokens.getStartTipoDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndTipoDomicilioDigitale())))
//                .build();
//        multiDestinatario.addDestinatario(
//                extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSociale()),
//                extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale()),
//                extractValue(pnB2bLegalFactTextTokens.getStartDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndDomicilioDigitale()),
//                extractValue(pnB2bLegalFactTextTokens.getStartTipoDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndTipoDomicilioDigitale()),
//                extractValue(pnB2bLegalFactTextTokens.getStartIndirizzoFisico(), pnB2bLegalFactTextTokens.getEndIndirizzoFisico()));
//        return multiDestinatario;
//    }
//
//    private IPnLegalFact getLegalFactNotificaAvvenutoSuccesso() {
//        return PnLegalFactNotificaAvvenutoSuccesso.builder()
//                .iun(extractValue(pnB2bLegalFactTextTokens.getStartIun(), pnB2bLegalFactTextTokens.getEndIun()))
//                .pnDestinatarioDigitale(new PnDestinatarioDigitale(
//                        extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSociale()),
//                        extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale())))
//                .dataAttestazioneOpponibile(extractValue(pnB2bLegalFactTextTokens.getStartDataDestinatario(), pnB2bLegalFactTextTokens.getEndDataDestinatario()))
//                .build();
//    }
//
//    private IPnLegalFact getLegalFactNotificaAvvenutoSuccessoDelegato() {
//        return PnLegalFactNotificaAvvenutoSuccessoDelegato.builder()
//                .iun(extractValue(pnB2bLegalFactTextTokens.getStartIun(), pnB2bLegalFactTextTokens.getEndIun()))
//                .pnDestinatarioDigitale(new PnDestinatarioDigitale(
//                        extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSocialeDestinatario(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSocialeDestinatario()),
//                        extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale())))
//                .pnDelegato(new PnDestinatarioDigitale(
//                        extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSocialeDelegato(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSocialeDelegato()),
//                        extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale())))
//                .dataAttestazioneOpponibile(extractValue(pnB2bLegalFactTextTokens.getStartDataDelegato(), pnB2bLegalFactTextTokens.getEndDataDelegato()))
//                .build();
//    }


    private String extractContent(final String source) throws IOException {
        log.info("File Sorgente {}", source);
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
        IPnLegalFact pnLegalFact = parse(source, legalFactType);
        if(pnLegalFact instanceof PnLegalFactNotificaDowntime notificaDowntime) {
            return (String) notificaDowntime.getAllValues().get(campo);
        } else if(pnLegalFact instanceof PnLegalFactNotificaDigitale notificaDigitale) {
            return (String) notificaDigitale.getAllValues().get(campo);
        } else if(pnLegalFact instanceof PnLegalFactNotificaMancatoRecapito notificaMancatoRecapito) {
            return (String) notificaMancatoRecapito.getAllValues().get(campo);
        } else if(pnLegalFact instanceof PnLegalFactNotificaPresaInCaricoMultiDestinatario notificaPresaInCaricoMultiDestinatario) {
            return (String) notificaPresaInCaricoMultiDestinatario.getAllValues().get(campo);
        } else if(pnLegalFact instanceof PnLegalFactNotificaPresaInCarico notificaPresaInCarico) {
                return (String) notificaPresaInCarico.getAllValues().get(campo);
        } else if(pnLegalFact instanceof PnLegalFactNotificaAvvenutoSuccessoDelegato notificaAvvenutoSuccessoDelegato) {
            return (String) notificaAvvenutoSuccessoDelegato.getAllValues().get(campo);
        } else if(pnLegalFact instanceof PnLegalFactNotificaAvvenutoSuccesso notificaAvvenutoSuccesso) {
            return (String) notificaAvvenutoSuccesso.getAllValues().get(campo);
        }
        return null;
    }

    @Override
    public IPnLegalFact extractMulti(String source, LegalFactType legalFactType) throws IOException {
        return parse(source, legalFactType);
    }
}