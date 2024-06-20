package it.pagopa.pn.client.b2b.pa.parsing.parser;

import it.pagopa.pn.client.b2b.pa.parsing.config.PnLegalFactTokenProperty;
import it.pagopa.pn.client.b2b.pa.parsing.config.PnLegalFactTokens;
import it.pagopa.pn.client.b2b.pa.parsing.model.IPnDestinatario;
import it.pagopa.pn.client.b2b.pa.parsing.model.PnParserRecord;
import it.pagopa.pn.client.b2b.pa.parsing.model.impl.PnDestinatario;
import it.pagopa.pn.client.b2b.pa.parsing.model.impl.PnDestinatarioAnalogico;
import it.pagopa.pn.client.b2b.pa.parsing.dto.*;
import it.pagopa.pn.client.b2b.pa.parsing.model.IPnLegalFact;
import it.pagopa.pn.client.b2b.pa.parsing.model.impl.PnDestinatarioDigitale;
import it.pagopa.pn.client.b2b.pa.parsing.parser.impl.PnContentExtractor;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class PnContentToken extends PnContentExtractor {
    private final PnLegalFactTokenProperty tokenProperty;


    public PnContentToken(PnLegalFactTokens pnLegalFactTokens) {
        super(pnLegalFactTokens);
        this.tokenProperty = pnLegalFactTokens.getTokenProps();
    }

    public IPnLegalFact getLegalFactNotificaDowntime(PnParserRecord.PnParserContent content) {

        return PnLegalFactNotificaDowntime.builder()
                .dataOraDecorrenza(getDataOraDecorrenza(content))
                .dataOraFine(getDataOraFineDecorrenza(content))
                .build();
    }

    public IPnLegalFact getLegalFactNotificaDigitale(PnParserRecord.PnParserContent content) {
        return PnLegalFactNotificaDigitale.builder()
                .iun(getIun(content, false))
                .pnDestinatario((PnDestinatarioDigitale) getDestinatario(content, true, false,true, false))
                .dataAttestazioneOpponibile(
                        cleanUp(getField(PnTextSlidingWindow.builder()
                            .originalText(content.text())
                            .slidedText(content.text())
                            .tokenStart(tokenProperty.getDataAttestazioneOpponibileStart())
                            .tokenEnd(tokenProperty.getDataAttestazioneOpponibileEnd4())
                            .build(), content.valueList())
                            .value(), true))
                .build();
    }

    public IPnLegalFact getLegalFactNotificaMancatoRecapito(PnParserRecord.PnParserContent content) {
        return PnLegalFactNotificaMancatoRecapito.builder()
                .iun(getIun(content, false))
                .pnDestinatario((PnDestinatario) getDestinatario(content, true, false,false, false))
                .primaData(getPrimaData(content))
                .secondaData(getSecondaData(content))
                .dataAttestazioneOpponibile(
                        cleanUp(getField(PnTextSlidingWindow.builder()
                            .originalText(content.text())
                            .slidedText(content.text())
                            .tokenStart(tokenProperty.getDataAttestazioneOpponibileStart())
                            .tokenEnd(tokenProperty.getDataAttestazioneOpponibileEnd5())
                            .build(), content.valueList())
                            .value(), true))
                .build();
    }

    public IPnLegalFact getLegalFactNotificaPresaInCarico(PnParserRecord.PnParserContent content) {
        return PnLegalFactNotificaPresaInCarico.builder()
                .dataAttestazioneOpponibile(
                        cleanUp(getField(PnTextSlidingWindow.builder()
                            .originalText(content.text())
                            .slidedText(content.text())
                            .tokenStart(tokenProperty.getDataAttestazioneOpponibileStart())
                            .tokenEnd(tokenProperty.getDataAttestazioneOpponibileEnd3())
                            .build(), content.valueList())
                            .value(), true))
                .mittente(getMittente(content))
                .cfMittente(getCfMittente(content))
                .iun(getIun(content, true))
                .pnDestinatario((PnDestinatario) getDestinatario(content, false,true, false, false))
                .build();
    }

    public IPnLegalFact getLegalFactNotificaPresaInCaricoMultiDestinatario(PnParserRecord.PnParserContent content) {
        return PnLegalFactNotificaPresaInCaricoMultiDestinatario.builder()
                .dataAttestazioneOpponibile(
                        cleanUp(getField(PnTextSlidingWindow.builder()
                            .originalText(content.text())
                            .slidedText(content.text())
                            .tokenStart(tokenProperty.getDataAttestazioneOpponibileStart())
                            .tokenEnd(tokenProperty.getDataAttestazioneOpponibileEnd3())
                            .build(), content.valueList())
                            .value(), true))
                .mittente(getMittente(content))
                .cfMittente(getCfMittente(content))
                .iun(getIun(content, true))
                .pnDestinatario((PnDestinatario) getDestinatario(content, false,true, false, true))
                .destinatariAnalogici(getDestinatariAnalogici(content))
                .build();
    }

    public IPnLegalFact getLegalFactNotificaAvvenutoAccesso(PnParserRecord.PnParserContent content) {
        return PnLegalFactNotificaAvvenutoAccesso.builder()
                .iun(cleanUp(getField(PnTextSlidingWindow.builder()
                            .originalText(content.text())
                            .slidedText(content.text())
                            .tokenStart(tokenProperty.getIunStart())
                            .tokenEnd(tokenProperty.getIunEnd1())
                            .build(), content.valueList())
                            .value(), false))
                .dataAttestazioneOpponibile(
                        cleanUp(getField(PnTextSlidingWindow.builder()
                            .originalText(content.text())
                            .slidedText(content.text())
                            .tokenStart(tokenProperty.getDataAttestazioneOpponibileStart())
                            .tokenEnd(tokenProperty.getDataAttestazioneOpponibileEnd1())
                            .build(), content.valueList())
                            .value(), true))
                .pnDestinatario((PnDestinatario)getDestinatario(content, false, false,false, false))
                .build();
    }

    public IPnLegalFact getLegalFactNotificaAvvenutoAccessoDelegato(PnParserRecord.PnParserContent content) {
        return PnLegalFactNotificaAvvenutoAccessoDelegato.builder()
                .iun(cleanUp(getField(PnTextSlidingWindow.builder()
                            .originalText(content.text())
                            .slidedText(content.text())
                            .tokenStart(tokenProperty.getIunStart())
                            .tokenEnd(tokenProperty.getIunEnd1())
                            .build(), content.valueList())
                            .value(), false))
                .dataAttestazioneOpponibile(
                        cleanUp(getField(PnTextSlidingWindow.builder()
                            .originalText(content.text())
                            .slidedText(content.text())
                            .tokenStart(tokenProperty.getDataAttestazioneOpponibileStart())
                            .tokenEnd(tokenProperty.getDataAttestazioneOpponibileEnd2())
                            .build(), content.valueList())
                            .value(), true))
                .pnDestinatario((PnDestinatario) getDestinatarioOrDelegato(content, true))
                .delegato((PnDestinatario) getDestinatarioOrDelegato(content, false))
                .build();
    }


    private IPnDestinatario getDestinatario(PnParserRecord.PnParserContent content, boolean isDigitale, boolean isAnalogico, boolean isWithNotificaDigitale, boolean isWithNotificaMultiDestinatario) {
        if(isDigitale) {
            return new PnDestinatarioDigitale(
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getNomeCognomeRagioneSocialeStart1())
                        .tokenEnd(tokenProperty.getNomeCognomeRagioneSocialeEnd())
                        .build(), content.valueList())
                        .value(), true),
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getCodiceFiscaleStart())
                        .tokenEnd(tokenProperty.getCodiceFiscaleEnd3())
                        .build(), content.valueList())
                        .value(), false),
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getDomicilioDigitaleStart())
                        .tokenEnd(tokenProperty.getDomicilioDigitaleEnd())
                        .build(), content.valueList())
                        .value(), false),
                    isWithNotificaDigitale
                    ?
                        cleanUp(getField(PnTextSlidingWindow.builder()
                                            .originalText(content.text())
                                            .slidedText(content.text())
                                            .tokenStart(tokenProperty.getTipologiaDomicilioDigitaleStart())
                                            .tokenEnd(tokenProperty.getTipologiaDomicilioDigitaleEnd2())
                                            .build(), content.valueList())
                                            .value(), true)
                    :
                        cleanUp(getField(PnTextSlidingWindow.builder()
                                            .originalText(content.text())
                                            .slidedText(content.text())
                                            .tokenStart(tokenProperty.getTipologiaDomicilioDigitaleStart())
                                            .tokenEnd(tokenProperty.getTipologiaDomicilioDigitaleEnd3())
                                            .build(), content.valueList())
                                            .value(), true));
        } else if(isAnalogico) {
            return new PnDestinatarioAnalogico(
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getNomeCognomeRagioneSocialeStart1())
                        .tokenEnd(tokenProperty.getNomeCognomeRagioneSocialeEnd())
                        .build(), content.valueList())
                        .value(), true),
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getCodiceFiscaleStart())
                        .tokenEnd(tokenProperty.getCodiceFiscaleEnd3())
                        .build(), content.valueList())
                        .value(), false),
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getDomicilioDigitaleStart())
                        .tokenEnd(tokenProperty.getDomicilioDigitaleEnd())
                        .build(), content.valueList())
                        .value(), false),
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getTipologiaDomicilioDigitaleStart())
                        .tokenEnd(tokenProperty.getTipologiaDomicilioDigitaleEnd1())
                        .build(), content.valueList())
                        .value(), true),
                    isWithNotificaMultiDestinatario
                    ?
                            getIndirizzoFisico(content, true)
                    :
                            getIndirizzoFisico(content, false)
            );
        }
        return new PnDestinatario(cleanUp(getField(PnTextSlidingWindow.builder()
                    .originalText(content.text())
                    .slidedText(content.text())
                    .tokenStart(tokenProperty.getNomeCognomeRagioneSocialeStart1())
                    .tokenEnd(tokenProperty.getNomeCognomeRagioneSocialeEnd())
                    .build(), content.valueList())
                    .value(), true),
                cleanUp(getField(PnTextSlidingWindow.builder()
                    .originalText(content.text())
                    .slidedText(content.text())
                    .tokenStart(tokenProperty.getCodiceFiscaleStart())
                    .tokenEnd(tokenProperty.getCodiceFiscaleEnd1())
                    .build(), content.valueList())
                    .value(), false));
    }

    private List<PnDestinatarioAnalogico> getDestinatariAnalogici(PnParserRecord.PnParserContent content) {
        List<PnDestinatarioAnalogico> pnDestinatarioAnalogicoList = new ArrayList<>();
        String text = content.text();
        List<String> valueList = content.valueList();
        int cntDestinatario = countDuplicates(text, tokenProperty.getNomeCognomeRagioneSocialeStart1());

        for(int i = 1; i <= cntDestinatario; i++) {
            String nomeCognomeRagioneSociale =
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getNomeCognomeRagioneSocialeStart1())
                        .tokenEnd(tokenProperty.getNomeCognomeRagioneSocialeEnd())
                        .build(), content.valueList())
                        .value(), true);
            String codiceFiscale =
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getCodiceFiscaleStart())
                        .tokenEnd(tokenProperty.getCodiceFiscaleEnd3())
                        .build(), content.valueList())
                        .value(), false);
            String domicilioDigitale =
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getDomicilioDigitaleStart())
                        .tokenEnd(tokenProperty.getDomicilioDigitaleEnd())
                        .build(), content.valueList())
                        .value(), false);
            String tipologiaDomicilio =
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getTipologiaDomicilioDigitaleStart())
                        .tokenEnd(tokenProperty.getTipologiaDomicilioDigitaleEnd1())
                        .build(), content.valueList())
                        .value(), true);
            String indirizzoFisico;
            if (i == cntDestinatario) {
                indirizzoFisico = getIndirizzoFisico(content, false);
            } else {
                indirizzoFisico = getIndirizzoFisico(content, true);
            }
            pnDestinatarioAnalogicoList.add(
                    new PnDestinatarioAnalogico(nomeCognomeRagioneSociale,
                            codiceFiscale,
                            domicilioDigitale,
                            cleanUp(tipologiaDomicilio, true),
                            cleanUp(indirizzoFisico, true)));
            int slidingIndex = text.indexOf(indirizzoFisico) + indirizzoFisico.length();
            text = text.substring(slidingIndex);
            for (String element : Arrays.asList(nomeCognomeRagioneSociale, codiceFiscale, domicilioDigitale, tipologiaDomicilio, indirizzoFisico)) {
                valueList.remove(element);
            }
        }
        return pnDestinatarioAnalogicoList;
    }

    private IPnDestinatario getDestinatarioOrDelegato(PnParserRecord.PnParserContent content, boolean isDestinatario) {
        if(isDestinatario) {
            return new PnDestinatario(cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getNomeCognomeRagioneSocialeStart1())
                        .tokenEnd(tokenProperty.getNomeCognomeRagioneSocialeEnd())
                        .build(), content.valueList())
                        .value(), true),
                    cleanUp(getField(PnTextSlidingWindow.builder()
                        .originalText(content.text())
                        .slidedText(content.text())
                        .tokenStart(tokenProperty.getCodiceFiscaleStart())
                        .tokenEnd(tokenProperty.getCodiceFiscaleEnd2())
                        .build(), content.valueList())
                        .value(), false));
        }
        return new PnDestinatario(cleanUp(getField(PnTextSlidingWindow.builder()
                    .originalText(content.text())
                    .slidedText(content.text())
                    .tokenStart(tokenProperty.getNomeCognomeRagioneSocialeStart2())
                    .tokenEnd(tokenProperty.getNomeCognomeRagioneSocialeEnd())
                    .build(), content.valueList())
                    .value(), true),
                cleanUp(getField(PnTextSlidingWindow.builder()
                    .originalText(content.text())
                    .slidedText(content.text())
                    .tokenStart(tokenProperty.getCodiceFiscaleStart())
                    .tokenEnd(tokenProperty.getCodiceFiscaleEnd1())
                    .build(), content.valueList())
                    .value(), false));
    }

    private String getDataOraDecorrenza(PnParserRecord.PnParserContent content) {
        return cleanUp(getField(PnTextSlidingWindow.builder()
                    .originalText(content.text())
                    .slidedText(content.text())
                    .tokenStart(tokenProperty.getDataDecorrenzaStart())
                    .tokenEnd(tokenProperty.getDataDecorrenzaEnd())
                    .build(), content.valueList())
                    .value(), true)
                .concat(" ")
                .concat(cleanUp(getField(PnTextSlidingWindow.builder()
                    .originalText(content.text())
                    .slidedText(content.text())
                    .tokenStart(tokenProperty.getOraDecorrenzaStart())
                    .tokenEnd(tokenProperty.getOraDecorrenzaEnd())
                    .build(), content.valueList())
                    .value(), true));
    }

    private String getDataOraFineDecorrenza(PnParserRecord.PnParserContent content) {
        return cleanUp(getField(PnTextSlidingWindow.builder()
                    .originalText(content.text())
                    .slidedText(content.text())
                    .tokenStart(tokenProperty.getDataFineDecorrenzaStart())
                    .tokenEnd(tokenProperty.getDataFineDecorrenzaEnd())
                    .build(), content.valueList())
                    .value(), true)
                .concat(" ")
                .concat(cleanUp(getField(PnTextSlidingWindow.builder()
                    .originalText(content.text())
                    .slidedText(content.text())
                    .tokenStart(tokenProperty.getOraFineDecorrenzaStart())
                    .tokenEnd(tokenProperty.getOraFineDecorrenzaEnd())
                    .build(), content.valueList())
                    .value(), true));
    }

    private String getIun(PnParserRecord.PnParserContent content, boolean isNotificaPresaInCarico) {
        if (isNotificaPresaInCarico) {
            return cleanUp(getField(PnTextSlidingWindow.builder()
                    .originalText(content.text())
                    .slidedText(content.text())
                    .tokenStart(tokenProperty.getIunStart())
                    .tokenEnd(tokenProperty.getIunEnd2())
                    .build(), content.valueList())
                    .value(), false);
        }
        return cleanUp(getField(PnTextSlidingWindow.builder()
                .originalText(content.text())
                .slidedText(content.text())
                .tokenStart(tokenProperty.getIunStart())
                .tokenEnd(tokenProperty.getIunEnd1())
                .build(), content.valueList())
                .value(), false);
    }

    private String getMittente(PnParserRecord.PnParserContent content) {
        return cleanUp(getField(PnTextSlidingWindow.builder()
                .originalText(content.text())
                .slidedText(content.text())
                .tokenStart(tokenProperty.getMittenteStart())
                .tokenEnd(tokenProperty.getMittenteEnd())
                .build(), content.valueList())
                .value(), true);
    }
    private String getCfMittente(PnParserRecord.PnParserContent content) {
        return cleanUp(getField(PnTextSlidingWindow.builder()
                .originalText(content.text())
                .slidedText(content.text())
                .tokenStart(tokenProperty.getCfMittenteStart())
                .tokenEnd(tokenProperty.getCfMittenteEnd())
                .build(), content.valueList())
                .value(), false);
    }

    private String getPrimaData(PnParserRecord.PnParserContent content) {
        return cleanUp(getField(PnTextSlidingWindow.builder()
                .originalText(content.text())
                .slidedText(content.text())
                .tokenStart(tokenProperty.getPrimaDataStart())
                .tokenEnd(tokenProperty.getPrimaDataEnd())
                .build(), content.valueList())
                .value(), true);
    }

    private String getSecondaData(PnParserRecord.PnParserContent content) {
        return cleanUp(getField(PnTextSlidingWindow.builder()
                .originalText(content.text())
                .slidedText(content.text())
                .tokenStart(tokenProperty.getSecondaDataStart())
                .tokenEnd(tokenProperty.getSecondaDataEnd())
                .build(), content.valueList())
                .value(), true);
    }

    private String getIndirizzoFisico(PnParserRecord.PnParserContent content, boolean isWithNotificaMultiDestinatario) {
        if(isWithNotificaMultiDestinatario) {
            return cleanUp(getField(PnTextSlidingWindow.builder()
                    .originalText(content.text())
                    .slidedText(content.text())
                    .tokenStart(tokenProperty.getIndirizzoFisicoStart())
                    .tokenEnd(tokenProperty.getIndirizzoFisicoEnd1())
                    .build(), content.valueList())
                    .value(), true);
        } else {
            return cleanUp(getField(PnTextSlidingWindow.builder()
                    .originalText(content.text())
                    .slidedText(content.text())
                    .tokenStart(tokenProperty.getIndirizzoFisicoStart())
                    .tokenEnd(tokenProperty.getIndirizzoFisicoEnd2())
                    .build(), content.valueList())
                    .value(), true);
        }
    }
}