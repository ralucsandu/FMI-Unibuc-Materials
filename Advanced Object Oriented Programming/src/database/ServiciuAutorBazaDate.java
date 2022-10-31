package database;

import models.Autor;
import repository.AutorRepo;

import java.util.*;

public class ServiciuAutorBazaDate {
    private AutorRepo autorRepo;

    public ServiciuAutorBazaDate() {
        this.autorRepo = new AutorRepo();
    }

    public void adauga_autor_sql(Autor autor) {
        autorRepo.adauga_autor_sql(autor);
    }

    public void sterge_autor_sql(Map<Integer, Autor> autori, Scanner scanner) {
        System.out.println("Autorii existenti in baza de date: ");
        for (Map.Entry<Integer, Autor> me : autori.entrySet()) {
            System.out.println(me.getKey() + ". " + me.getValue().getNumePersoana() + " " + me.getValue().getPrenumePersoana());
        }
        System.out.println("Introduceti id-ul autorului pe care va doriti sa il stergeti! ");
        String id_autor = scanner.nextLine();
        Autor autor = autori.get(Integer.parseInt(id_autor));
        autorRepo.sterge_autor_sql(autor);
        System.out.println("Stergerea s-a realizat cu succes!");
    }

    public Autor introdu_autor(Scanner scanner) {
        System.out.println("AUTOR");
        System.out.println("Introduceti datele autorului: id/nume/prenume");
        String linie = scanner.nextLine();
        String[] fields = linie.split("/");
        return new Autor(Integer.parseInt(fields[0]),fields[1], fields[2]);
    }

    public Map<Integer, Autor> get_toti_autorii() {
        return autorRepo.get_toti_autorii();
    }
}