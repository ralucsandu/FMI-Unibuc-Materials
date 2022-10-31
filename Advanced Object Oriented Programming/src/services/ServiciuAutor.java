package services;

import read_write.*;
import models.Autor;
import java.util.*;

public class ServiciuAutor {
    private static ServiciuAutor instance = null;
    private List<Autor> lista_autori;

    private ServiciuAutor() {
        lista_autori = new ArrayList<>();
    }

    public static ServiciuAutor get_instance() {
        if(instance == null) {
            instance = new ServiciuAutor();
        }
        return instance;
    }

    public void adauga_autor(Autor autor, boolean csv) {
        boolean ok = false; //in variabila ok retinem daca autorul exista deja sau nu in lista
        for (Autor a : lista_autori)
            if (a.equals(autor)) {
                ok = true;
                break;
            }
        if(!ok) {
            lista_autori.add(new Autor(autor));
            if(!csv) {
                Scriere.scrie_autor_csv(autor);
                Scriere.audit("Adauga autor nou");
            }
            ordoneaza_autori();
        }
    }

    private void ordoneaza_autori() {
        Collections.sort(lista_autori);
    }

    public void afiseaza_autori_existenti() {
        for (Autor a : lista_autori)
            System.out.println(a.toString());
    }
}