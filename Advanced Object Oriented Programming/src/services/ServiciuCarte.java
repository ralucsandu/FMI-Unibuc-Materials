package services;

import models.Carte;
import read_write.Scriere;

import java.util.*;

public class ServiciuCarte {
    private static ServiciuCarte instance = null;
    private List<Carte> lista_de_carti;

    private ServiciuCarte() {
        lista_de_carti = new ArrayList<>();
    }
    public static ServiciuCarte get_instance() {
        if(instance == null) {
            instance = new ServiciuCarte();
        }
        return instance;
    }

    public void adauga_carte(Carte carte, boolean csv) {
        boolean ok = false;
        for(Carte b : lista_de_carti)
            if (b.equals(carte)) {
                ok = true;
                //System.out.println("Deja avem aceasta carte");
                break;
            }
        if(!ok) {
            lista_de_carti.add(new Carte(carte));
            if(!csv) {
                Scriere.scrie_carte_csv(carte);
                Scriere.audit("Adauga carte noua");
            }
            ordoneaza_carti();
        }
    }

    private void ordoneaza_carti() {
        Collections.sort(lista_de_carti);
    }

    public void afiseaza_carti_existente() {
        for(Carte b : lista_de_carti)
            System.out.println(b.toString());
    }
}
