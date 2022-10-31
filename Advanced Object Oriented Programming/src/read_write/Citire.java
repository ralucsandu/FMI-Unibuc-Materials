package read_write;

import models.*;
import services.*;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.time.LocalDate;

public class Citire {
    private static Citire instance = null;

    private Citire() {
    }

    public static Citire get_instance() {
        if (instance == null)
            instance = new Citire();
        return instance;
    }

    public static void citesteAutoriCsv() {
        try(var in = new BufferedReader(new FileReader("src/read_write/autori.csv"))){
            String linie;
            ServiciuAutor as = ServiciuAutor.get_instance();

            while ((linie = in.readLine()) != null) {
                String []fields = linie.replaceAll(" ", "").split(",");
                as.adauga_autor(new Autor(Integer.parseInt(fields[0]), fields[1], fields[2]),true);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void citeste_cititori_csv() {
        try (var in = new BufferedReader(new FileReader("src/read_write/cititori.csv"))) {
            String linie;
            ServiciuCititor rs = ServiciuCititor.get_instance();

            while ((linie = in.readLine()) != null) {
                String [] fields = linie.replaceAll(" ", "").split(",");
                rs.adauga_cititor(new Cititor(Integer.parseInt(fields[0]), fields[1], fields[2], LocalDate.of(Integer.parseInt(fields[4]), Integer.parseInt(fields[3]), Integer.parseInt(fields[2]))), true);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void citeste_carti_csv() {
        try (var in = new BufferedReader(new FileReader("src/read_write/carti.csv"))) {
            String linie;
            ServiciuCarte bs = ServiciuCarte.get_instance();

            while ((linie = in.readLine()) != null) {
                String [] fields = linie.replaceAll(" ", "").split(",");
                bs.adauga_carte(new Carte(Integer.parseInt(fields[0]), fields[1], new Autor(Integer.parseInt(fields[0]), fields[1], fields[2]), Integer.parseInt(fields[3]), new Categorie(Integer.parseInt(fields[0]), fields[1])), true);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void citeste_categorii_csv() {
        try (var in = new BufferedReader(new FileReader("src/read_write/carti.csv"))) {
            String linie;
            ServiciuCategorie bs = ServiciuCategorie.get_instance();

            while ((linie = in.readLine()) != null) {
                String [] fields = linie.replaceAll(" ", "").split(",");
                bs.adauga_categorie(new Categorie(Integer.parseInt(fields[0]), fields[1]), true);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void citeste_studenti_csv() {
        try (var in = new BufferedReader(new FileReader("src/read_write/studenti.csv"))) {
            String linie;
            ServiciuStudent bs = ServiciuStudent.get_instance();

            while ((linie = in.readLine()) != null) {
                String [] fields = linie.replaceAll(" ", "").split(",");
                bs.adauga_student(new Student(Integer.parseInt(fields[0]), fields[1], fields[2], fields[3], LocalDate.of(Integer.parseInt(fields[4]), Integer.parseInt(fields[3]), Integer.parseInt(fields[2]))), true);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}