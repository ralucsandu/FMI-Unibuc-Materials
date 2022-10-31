package services;

import models.Cititor;
import read_write.Scriere;

import java.util.*;
public class ServiciuCititor {
    private static ServiciuCititor instance = null;
    private List<Cititor> lista_cititori;
    
    private ServiciuCititor() {
        lista_cititori = new ArrayList<>();
    }

    public static ServiciuCititor get_instance() {
        if(instance == null) {
            instance = new ServiciuCititor();
        }
        return instance;
    }

    public void adauga_cititor(Cititor cititor, boolean csv) {
        boolean ok = false;
        for(Cititor c : lista_cititori)
            if (c.equals(cititor)) {
                ok = true;
                System.out.println("eroare");
                break;
            }
        if(ok == false) {
            lista_cititori.add(new Cititor(cititor));
            if(!csv) {
                Scriere.scrie_cititor_csv(cititor);
                Scriere.audit("Adauga cititor nou");
            }
            ordoneaza_cititori();
        }
    }
    private void ordoneaza_cititori() {
        Collections.sort(lista_cititori);
    }
    public void afiseaza_cititori_existenti() {
        for(Cititor c : lista_cititori)
            System.out.println(c.toString());
    }
}
