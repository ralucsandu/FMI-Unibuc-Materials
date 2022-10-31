import database.ServiciuAutorBazaDate;
import database.ServiciuCategorieBazaDate;
import database.ServiciuCititorBazaDate;
import database.ServiciuStudentBazaDate;
import models.*;
import services.*;

import read_write.*;

import java.io.IOException;
import java.sql.SQLOutput;
import java.time.LocalDate;
import java.util.Map;
import java.util.Scanner;

public class MainClass {
    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(System.in);
        Citire.citesteAutoriCsv();
        ServiciuCititor s1 = ServiciuCititor.get_instance();
        ServiciuCarte s2 = ServiciuCarte.get_instance();
        ServiciuCategorie s3 = ServiciuCategorie.get_instance();
        ServiciuAutor s4 = ServiciuAutor.get_instance();
        ServiciuStudent s5 = ServiciuStudent.get_instance();
        ServiciuCarteAudio s6 = ServiciuCarteAudio.get_instance();

        ServiciuAutorBazaDate sabd = new ServiciuAutorBazaDate();
        Map<Integer, Autor> autori = sabd.get_toti_autorii();
        Scanner scanner1 = new Scanner(System.in);

        ServiciuCategorieBazaDate scbd = new ServiciuCategorieBazaDate();
        Map<Integer, Categorie> categs = scbd.get_categs();
        Scanner scanner2 = new Scanner(System.in);

        ServiciuCititorBazaDate scitbd = new ServiciuCititorBazaDate();
        Map<Integer, Cititor> cititori = scitbd.get_toti_cititorii();
        Scanner scanner3 = new Scanner(System.in);

        ServiciuStudentBazaDate ssbd = new ServiciuStudentBazaDate();
        Map<Integer, Student> studenti = ssbd.get_toti_studentii();
        Scanner scanner4 = new Scanner(System.in);

        System.out.println("Alegeti una dintre urmatoarele optiuni: ");
        System.out.println("1 - Testeaza etapele I si II");
        System.out.println();
        System.out.println("2 - Testeaza etapa III");
        System.out.println();
        System.out.println("0 - Iesire");
        System.out.println();
        System.out.println("Optiunea mea este: ");
        String option1 = scanner.nextLine();
        switch (option1) {
            case "0": {
                System.out.println("Ati ales sa iesiti din aplicatie!");
                System.exit(0);
            }
            case "1": {
                int ok = 1;
                while (ok == 1) {
                    System.out.println();
                    System.out.println("Alegeti clasa pe care o testati!");
                    System.out.println("1. Cititor");
                    System.out.println("2. Carte");
                    System.out.println("3. Categorie");
                    System.out.println("4. Autor");
                    System.out.println("5. Student");
                    System.out.println("6. Carte audio");
                    System.out.println("0. Iesire");
                    System.out.println("Optiunea mea este: ");
                    String option2 = scanner.nextLine();
                    switch (option2) {
                        case "0": {
                            ok = 0;
                            break;
                        }
                        case "1": {
                            s1.adauga_cititor(new Cititor(1, "Sandu", "Raluca", LocalDate.of(2022, 5, 18)), false);
                            s1.adauga_cititor(new Cititor(2, "Postolache", "Miruna", LocalDate.of(2022, 4, 1)), false);
                            s1.afiseaza_cititori_existenti();
                            break;
                        }
                        case "2": {
                            s2.adauga_carte(new Carte(1, "Charlie si fabrica de ciocolata", new Autor(10, "Dahl", "Roald"), 200, new Categorie(20, "Povestire")), false);
                            s2.afiseaza_carti_existente();
                            break;
                        }
                        case "3": {
                            s3.adauga_categorie(new Categorie(1, "Povestire"), false);
                            s3.afiseaza_categorii_existente();
                            break;
                        }
                        case "4": {
                            s4.adauga_autor(new Autor(100, "Dahl", "Roald"), false);
                            s4.afiseaza_autori_existenti();
                            break;
                        }
                        case "5": {
                            s5.adauga_student(new Student(100, "Pelin", "Raluca", "Politehnica - Automatica si Calculatoare", LocalDate.of(2022, 5, 19)), false);
                            s5.afiseaza_studenti_existenti();
                            break;
                        }
                        case "6": {
                            s6.adauga_carte_audio(new CarteAudio());
                            s6.afiseaza_carti_audio();
                            break;
                        }
                        default: {
                            System.out.println("Optiune invalida. Incercati din nou!");
                        }
                    }
                }
                break;
            }
            case "2": {
                int ok = 1;
                while (ok == 1) {
                    System.out.println();
                    System.out.println("Alegeti clasa pentru care vreti sa testati interactiunea cu baza de date!");
                    System.out.println("1. Autor");
                    System.out.println("2. Categorie");
                    System.out.println("3. Cititor");
                    System.out.println("4. Student");
                    System.out.println("0. Iesire");
                    System.out.println("Optiunea mea este: ");
                    String option3 = scanner.nextLine();
                    switch (option3) {
                        case "0": {
                            ok = 0;
                            break;
                        }
                        case "1": {
                            int ok1 = 1;
                            while (ok1==1){
                                System.out.println();
                                System.out.println("Alegeti dintre urmatoarele optiuni: ");
                                System.out.println("1.Adauga autor");
                                System.out.println("2.Sterge autor");
                                System.out.println("0. Iesire");
                                String option31 = scanner.nextLine();
                                switch(option31){
                                    case "0":{
                                        ok=0;
                                        System.exit(0);;
                                    }
                                    case "1":{
                                        sabd.adauga_autor_sql(sabd.introdu_autor(scanner1));
                                        break;
                                    }
                                    case "2":{
                                        sabd.sterge_autor_sql(autori, scanner1);
                                        break;
                                    }
                                }
                            }
                            break;
                        }
                        case "2": {
                            int ok2 = 1;
                            while (ok2==1){
                                System.out.println();
                                System.out.println("Alegeti dintre urmatoarele optiuni: ");
                                System.out.println("1.Adauga categorie");
                                System.out.println("2.Sterge categorie");
                                System.out.println("0. Iesire");
                                String option32 = scanner.nextLine();
                                switch(option32){
                                    case "0":{
                                        ok=0;
                                        System.exit(0);;
                                    }
                                    case "1":{
                                        scbd.adauga_categorie_sql(scbd.modifica_categorie_sql(scanner2));
                                        break;
                                    }
                                    case "2":{
                                        scbd.sterge_categorie_sql(categs, scanner2);
                                        break;
                                    }
                                }
                            }
                            break;
                        }
                        case "3": {
                            int ok3 = 1;
                            while (ok3==1){
                                System.out.println();
                                System.out.println("Alegeti dintre urmatoarele optiuni: ");
                                System.out.println("1.Adauga cititor");
                                System.out.println("2.Sterge cititor");
                                System.out.println("3.Actualizeaza cititor");
                                System.out.println("0. Iesire");
                                String option33 = scanner.nextLine();
                                switch(option33){
                                    case "0":{
                                        ok=0;
                                        System.exit(0);;
                                    }
                                    case "1":{
                                        scitbd.adauga_cititor_sql(scitbd.modifica_cititor(scanner3));
                                        break;
                                    }
                                    case "2":{
                                        scitbd.sterge_cititor_sql(cititori, scanner3);
                                        break;
                                    }
                                    case "3":{
                                        scitbd.update_cititor_sql(cititori, scanner3);
                                        break;
                                    }
                                }
                            }
                            break;
                        }
                        case "4": {
                            int ok4 = 1;
                            while (ok4==1){
                                System.out.println();
                                System.out.println("Alegeti dintre urmatoarele optiuni: ");
                                System.out.println("1.Adauga student");
                                System.out.println("2.Sterge student");
                                System.out.println("3.Actualizeaza student");
                                System.out.println("0. Iesire");
                                String option34 = scanner.nextLine();
                                switch(option34){
                                    case "0":{
                                        ok=0;
                                        System.exit(0);;
                                    }
                                    case "1":{
                                        ssbd.adauga_student_sql(ssbd.modifica_student(scanner4));
                                        break;
                                    }
                                    case "2":{
                                        ssbd.sterge_student_sql(studenti, scanner4);
                                        break;
                                    }
                                    case "3":{
                                        ssbd.update_student_sql(studenti, scanner4);
                                        break;
                                    }

                                }
                            }
                            break;
                        }
                        default: {
                            System.out.println("Optiune invalida. Incercati din nou!");
                        }
                    }
                }
                break;
            }
        }
    }
}