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


@Slf4j
@Component
public class PnLegalFactParser implements IPnParserService {
    private final PnB2bLegalFactTextTokens pnB2bLegalFactTextTokens;
    private PnTextToken textToken;
    @Value("classpath:pdfToParse/AOT_avvenuto_accesso_delegato.pdf")
//    @Value("classpath:pdfToParse/PN_DOWNTIME_LEGAL_FACTS-cd8d10909ce94a5a8759398f34078636.pdf")
//    @Value("classpath:pdfToParse/PN_LEGAL_FACTS-avvenuto accesso.pdf")
//    @Value("classpath:pdfToParse/PN_LEGAL_FACTS-mancato recapito digitale.pdf")
//    @Value("classpath:pdfToParse/PN_LEGAL_FACTS-notifica digitale.pdf")
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
        textToken = new PnTextToken(pdfText);

        if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_DOWNTIME)) {
            return getLegalFactNotificaDowntime();
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_DIGITALE)) {
            return getLegalFactNotificaDigitale();
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_MANCATO_RECAPITO)) {
            return getLegalFactNotificaMancatoRecapito();
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_PRESA_IN_CARICO)) {
            return getLegalFactNotificaPresaInCarico();
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_PRESA_IN_CARICO_MULTIDESTINATARIO)) {
            return getLegalFactNotificaPresaInCaricoMultiDestinatario();
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_AVVENUTO_SUCCESSO)) {
            return getLegalFactNotificaAvvenutoSuccesso();
        } else if(legalFactType.equals(LegalFactType.LEGALFACT_NOTIFICA_AVVENUTO_SUCCESSO_DELEGATO)) {
            return getLegalFactNotificaAvvenutoSuccessoDelegato();
        }

        return null;
    }

    private IPnLegalFact getLegalFactNotificaDowntime() {
        return PnLegalFactNotificaDowntime.builder()
                .dataOraDecorrenza(textToken.extractValue(pnB2bLegalFactTextTokens.getStartDataOraDecorrenza(), pnB2bLegalFactTextTokens.getEndDataOraDecorrenza()))
                .dataOraFine(textToken.extractValue(pnB2bLegalFactTextTokens.getStartDataOraFine(), pnB2bLegalFactTextTokens.getEndDataOraFine()))
                .build();
    }

    private IPnLegalFact getLegalFactNotificaDigitale() {
        return PnLegalFactNotificaDigitale.builder()
                .iun(textToken.extractValue(pnB2bLegalFactTextTokens.getStartIun(), pnB2bLegalFactTextTokens.getEndIun()))
                .pnDestinatarioDigitale(new PnDestinatarioDigitale(
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSociale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndDomicilioDigitale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartTipoDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndTipoDomicilioDigitale())))
                .dataAttestazioneOpponibile(textToken.extractValue(pnB2bLegalFactTextTokens.getStartDataNotificaDigitale(), pnB2bLegalFactTextTokens.getEndDataNotificaDigitale()))
                .build();
    }

    private IPnLegalFact getLegalFactNotificaMancatoRecapito() {
        return PnLegalFactNotificaMancatoRecapito.builder()
                .iun(textToken.extractValue(pnB2bLegalFactTextTokens.getStartIun(), pnB2bLegalFactTextTokens.getEndIun()))
                .pnDestinatarioDigitale(new PnDestinatarioDigitale(
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSociale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndDomicilioDigitale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartTipoDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndTipoDomicilioDigitale())))
                .primaData(textToken.extractValue(pnB2bLegalFactTextTokens.getStartPrimaData(), pnB2bLegalFactTextTokens.getEndPrimaData()))
                .secondaData(textToken.extractValue(pnB2bLegalFactTextTokens.getStartSecondaData(), pnB2bLegalFactTextTokens.getEndSecondaData()))
                .build();
    }

    private IPnLegalFact getLegalFactNotificaPresaInCarico() {
        return PnLegalFactNotificaPresaInCarico.builder()
                .dataAttestazioneOpponibile(textToken.extractValue(pnB2bLegalFactTextTokens.getStartDataNotificaPresaInCarico(), pnB2bLegalFactTextTokens.getEndDataNotificaPresaInCarico()))
                .mittente(textToken.extractValue(pnB2bLegalFactTextTokens.getStartMittente(), pnB2bLegalFactTextTokens.getEndMittente()))
                .cfMittente(textToken.extractValue(pnB2bLegalFactTextTokens.getStartCfMittente(), pnB2bLegalFactTextTokens.getEndCfMittente()))
                .iun(textToken.extractValue(pnB2bLegalFactTextTokens.getStartIunNotificaPresaInCarico(), pnB2bLegalFactTextTokens.getEndIunNotificaPresaInCarico()))
                .pnDestinatarioDigitale(new PnDestinatarioDigitale(
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSociale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndDomicilioDigitale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartTipoDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndTipoDomicilioDigitale())))
                .build();
    }

    private IPnLegalFact getLegalFactNotificaPresaInCaricoMultiDestinatario() {
        PnLegalFactNotificaPresaInCaricoMultiDestinatario multiDestinatario = PnLegalFactNotificaPresaInCaricoMultiDestinatario.builder()
                .dataAttestazioneOpponibile(textToken.extractValue(pnB2bLegalFactTextTokens.getStartDataNotificaPresaInCarico(), pnB2bLegalFactTextTokens.getEndDataNotificaPresaInCarico()))
                .mittente(textToken.extractValue(pnB2bLegalFactTextTokens.getStartMittente(), pnB2bLegalFactTextTokens.getEndMittente()))
                .cfMittente(textToken.extractValue(pnB2bLegalFactTextTokens.getStartCfMittente(), pnB2bLegalFactTextTokens.getEndCfMittente()))
                .iun(textToken.extractValue(pnB2bLegalFactTextTokens.getStartIunNotificaPresaInCarico(), pnB2bLegalFactTextTokens.getEndIunNotificaPresaInCarico()))
                .pnDestinatarioDigitale(new PnDestinatarioDigitale(
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSociale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndDomicilioDigitale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartTipoDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndTipoDomicilioDigitale())))
                .build();
        multiDestinatario.addDestinatario(
                textToken.extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSociale()),
                textToken.extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale()),
                textToken.extractValue(pnB2bLegalFactTextTokens.getStartDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndDomicilioDigitale()),
                textToken.extractValue(pnB2bLegalFactTextTokens.getStartTipoDomicilioDigitale(), pnB2bLegalFactTextTokens.getEndTipoDomicilioDigitale()),
                textToken.extractValue(pnB2bLegalFactTextTokens.getStartIndirizzoFisico(), pnB2bLegalFactTextTokens.getEndIndirizzoFisico()));
        return multiDestinatario;
    }

    private IPnLegalFact getLegalFactNotificaAvvenutoSuccesso() {
        return PnLegalFactNotificaAvvenutoSuccesso.builder()
                .iun(textToken.extractValue(pnB2bLegalFactTextTokens.getStartIun(), pnB2bLegalFactTextTokens.getEndIun()))
                .pnDestinatarioDigitale(new PnDestinatarioDigitale(
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSociale(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSociale()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale())))
                .dataAttestazioneOpponibile(textToken.extractValue(pnB2bLegalFactTextTokens.getStartDataDestinatario(), pnB2bLegalFactTextTokens.getEndDataDestinatario()))
                .build();
    }

    private IPnLegalFact getLegalFactNotificaAvvenutoSuccessoDelegato() {
        return PnLegalFactNotificaAvvenutoSuccessoDelegato.builder()
                .iun(textToken.extractValue(pnB2bLegalFactTextTokens.getStartIun(), pnB2bLegalFactTextTokens.getEndIun()))
                .pnDestinatarioDigitale(new PnDestinatarioDigitale(
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSocialeDestinatario(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSocialeDestinatario()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale())))
                .pnDelegato(new PnDestinatarioDigitale(
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartNomeCognomeRagioneSocialeDelegato(), pnB2bLegalFactTextTokens.getEndNomeCognomeRagioneSocialeDelegato()),
                        textToken.extractValue(pnB2bLegalFactTextTokens.getStartCodiceFiscale(), pnB2bLegalFactTextTokens.getEndCodiceFiscale())))
                .dataAttestazioneOpponibile(textToken.extractValue(pnB2bLegalFactTextTokens.getStartDataDelegato(), pnB2bLegalFactTextTokens.getEndDataDelegato()))
                .build();
    }


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