package database;

import models.Cititor;
import repository.CititorRepo;

import java.time.LocalDate;
import java.util.Map;
import java.util.Scanner;

public class ServiciuCititorBazaDate {
    private CititorRepo cititorRepo;

    public ServiciuCititorBazaDate() {
        this.cititorRepo = new CititorRepo();
    }

    public void adauga_cititor_sql(Cititor cititor) {
        cititorRepo.adauga_cititor_sql(cititor);
    }

    public void sterge_cititor_sql(Map<Integer, Cititor> cititori, Scanner scanner) {
        System.out.println("Cititorii existenti in baza de date: ");
        for (Map.Entry<Integer, Cititor> me : cititori.entrySet()) {
            System.out.println(me.getKey() + ". " + me.getValue().getNumePersoana() + " " + me.getValue().getPrenumePersoana());
        }
        System.out.println("Introduceti id-ul cititorului pe care va doriti sa il stergeti! ");
        String id_cititor = scanner.nextLine();
        Cititor cititor = cititori.get(Integer.parseInt(id_cititor));
        cititorRepo.sterge_cititor_sql(cititor);
        System.out.println("Stergerea s-a realizat cu succes!");
    }

    public void update_cititor_sql(Map<Integer, Cititor> cititori, Scanner scanner) {
        System.out.println("Cititori existenti:");
        for (Map.Entry<Integer, Cititor> me : cititori.entrySet()) {
            System.out.println(me.getKey() + ". " + me.getValue().getNumePersoana() + " " + me.getValue().getPrenumePersoana());
        }
        System.out.println("Introduceti id-ul cititorului pe care doriti sa-l actualizati!");
        String id_cititor = scanner.nextLine();
        System.out.println("Introduceti noul cititor");
        String nume = scanner.nextLine();
        Cititor cit = cititori.get(Integer.parseInt(id_cititor));
        cititorRepo.update_cititor_sql(cit, nume);
        System.out.println("Actualizarea s-a realizat cu succes!");
    }

    public Cititor modifica_cititor(Scanner scanner) {
        System.out.println("CITITOR");
        System.out.println("Introduceti datele cititorului: id/nume/prenume/data_inscriere(format: an/luna/zi)");
        String linie = scanner.nextLine();
        String[] fields = linie.split("/");
        return new Cititor(Integer.parseInt(fields[0]),fields[1], fields[2], LocalDate.of(Integer.parseInt(fields[3]), Integer.parseInt(fields[4]), Integer.parseInt(fields[5])));
    }

    public Map<Integer, Cititor> get_toti_cititorii() {
        return cititorRepo.get_cititori();
    }
}