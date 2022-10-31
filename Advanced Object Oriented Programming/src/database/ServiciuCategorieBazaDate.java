package database;

import models.Categorie;
import repository.CategorieRepo;

import java.util.Map;
import java.util.Scanner;

public class ServiciuCategorieBazaDate {
    private CategorieRepo categRepo;

    public ServiciuCategorieBazaDate() {
        this.categRepo = new CategorieRepo();
    }

    public void adauga_categorie_sql(Categorie categ) {
        categRepo.adauga_categorie_sql(categ);
        System.out.println("Categorie adaugata!");
    }

    public void sterge_categorie_sql(Map<Integer, Categorie> categs, Scanner scanner) {
        System.out.println("Categorii deja existente: ");
        for (Map.Entry<Integer, Categorie> me : categs.entrySet()) {
            System.out.println(me.getKey() + ". " + me.getValue().getDenumire());
        }
        System.out.println("Introduceti id-ul categoriei pe care doriti sa o stergeti!");
        String id_categorie = scanner.nextLine();
        Categorie categ = categs.get(Integer.parseInt(id_categorie));
        categRepo.sterge_categorie_sql(categ);
        System.out.println("Stergerea s-a realizat cu succes!");
    }

    public void update_categorie_sql(Map<Integer, Categorie> categs, Scanner scanner) {
        System.out.println("Categorii existente:");
        for (Map.Entry<Integer, Categorie> me : categs.entrySet()) {
            System.out.println(me.getKey() + ". " + me.getValue().getDenumire());
        }
        System.out.println("Introduceti id-ul categoriei pe care doriti sa o actualizati!");
        String id_categorie = scanner.nextLine();
        System.out.println("Introduceti noua denumire");
        String denumire = scanner.nextLine();
        Categorie categ = categs.get(Integer.parseInt(id_categorie));
        categRepo.update_categorie_sql(categ, denumire);
        System.out.println("Actualizarea s-a realizat cu succes!");
    }

    public Categorie modifica_categorie_sql(Scanner scanner) {
        System.out.println("CATEGORIE");
        System.out.println("Introduceti urmatoarele: id/denumire");
        String linie = scanner.nextLine();
        String[] fields = linie.split("/");
        return new Categorie(Integer.parseInt(fields[0]), fields[1]);
    }

    public Map<Integer, Categorie> get_categs() {
        return categRepo.get_categs();
    }
}