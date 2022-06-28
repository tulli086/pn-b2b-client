package it.pagopa.pn.client.b2b.pa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Component;

@SpringBootApplication
public class SearchNotification implements CommandLineRunner {

    @Autowired
    private MainBean mainBean;

    public static void main(String[] args) {
        SpringApplication.run(SearchNotification.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        mainBean.doAll();
        System.exit( 0 );
    }

    @Component
    public static class MainBean {

        @Autowired
        private PnPaB2bUtils utils;


        public void doAll() {
            System.out.println( utils.getNotificationByIun( "TPZH-WLML-JUXK-202206-P-1" ) );
        }

    }

}
