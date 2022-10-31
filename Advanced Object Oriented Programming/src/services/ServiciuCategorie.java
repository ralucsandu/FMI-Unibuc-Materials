package services;

import java.util.*;
import models.Categorie;
import read_write.Scriere;

public class ServiciuCategorie {
    private static ServiciuCategorie instance = null;
    private List<Categorie> lista_categorii;
    private ServiciuCategorie() {
        lista_categorii = new ArrayList<>();
    }

    public static ServiciuCategorie get_instance() {
        if (instance == null)  {
            instance = new ServiciuCategorie();
        }
        return instance;
    }

    public void adauga_categorie(Categorie categorie, boolean csv) {
        boolean ok = false;
        for (Categorie s : lista_categorii)
            if (s.equals(categorie)) {
                ok = true;
                break;
            }
        if(!ok) {
            lista_categorii.add(new Categorie(categorie));
            if(!csv) {
                Scriere.scrie_categorie_csv(categorie);
                Scriere.audit("Adauga categorie noua");
            }
            ordoneaza_categorii();
        }
    }
    private void ordoneaza_categorii() {
        Collections.sort(lista_categorii);
    }

    public void afiseaza_categorii_existente() {
        for (Categorie s : lista_categorii)
            System.out.println(s.toString());
    }
}