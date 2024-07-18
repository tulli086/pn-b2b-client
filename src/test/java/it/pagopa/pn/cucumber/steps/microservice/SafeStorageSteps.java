package it.pagopa.pn.cucumber.steps.microservice;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import it.pagopa.pn.client.b2b.pa.PnPaB2bUtils;
import it.pagopa.pn.client.b2b.pa.service.IPnSafeStoragePrivateClient;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.FileCreationRequest;
import it.pagopa.pn.client.web.generated.openapi.clients.safeStorage.model.FileCreationResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import java.io.IOException;
@Slf4j
public class SafeStorageSteps {

    private final IPnSafeStoragePrivateClient safeStorageClient;
    private final PnPaB2bUtils b2bUtils;

    private String sha256;
    @Autowired
    public SafeStorageSteps(IPnSafeStoragePrivateClient safeStorageClient,PnPaB2bUtils b2bUtils) {
        this.safeStorageClient = safeStorageClient;
        this.b2bUtils = b2bUtils;
    }


    private String computeSha(String resourceName){
        try {
            this.sha256 = this.b2bUtils.computeSha256(resourceName);
            return this.sha256;
        } catch (IOException e) {
            throw new IllegalStateException(e.getMessage()+" NON è stato possibile computare lo sha");
        }
    }
    @And("Viene caricato un nuovo documento")
    public void notificationCanBeRetrievedWithIUN() {


      System.out.println("TODO");
    }


    private String getFileByType(String type){
        return switch (type) {
            case "PDF" -> "classpath:/multa.pdf";
            case "JSON" -> "classpath:/f24_flat.json";
            default -> "classpath:/multa.pdf";
        };
    }

    @Given("Viene caricato un nuovo documento pdf")
    public void uploadNewPdfDocument() {
        uploadNewDocumentWithDocumentType("PDF");
    }

    @Given("Viene caricato un nuovo documento {string}")
    public void uploadNewDocumentWithDocumentType(String fileType) {
        String resourcePath = getFileByType(fileType);
        String sha256 = computeSha(resourcePath);

        FileCreationRequest request = new FileCreationRequest();
        request.setContentType("application/pdf");
        request.setStatus("SAVED");
        request.setDocumentType("PN_NOTIFICATION_ATTACHMENTS");

        FileCreationResponse fileCreationResponse = this.safeStorageClient.createFile(request);



        String fileKey = fileCreationResponse.getKey();

        String secret = fileCreationResponse.getSecret();
        String url = fileCreationResponse.getUploadUrl();

        this.b2bUtils.loadToPresigned( url, secret, sha256, resourcePath );
        System.out.println("FILEKEY: "+fileKey);
    }
}
