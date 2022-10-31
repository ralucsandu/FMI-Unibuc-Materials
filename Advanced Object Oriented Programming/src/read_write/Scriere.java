package read_write;

import models.*;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Timestamp;

public class Scriere {
    private static Scriere instance = null;

    public static Scriere get_instance() {
        if (instance == null)
            instance = new Scriere();
        return instance;
    }

    public static void audit(String operationType) {
        try (var out = new BufferedWriter(new FileWriter("src/read_write/audit.csv", true))) {
            Timestamp timestamp = new Timestamp(System.currentTimeMillis());
            out.write(operationType + ", " + timestamp.toString() + "\n");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static void scrie_autor_csv(Autor autor) {
        try (var out = new BufferedWriter(new FileWriter("src/read_write/autori.csv", true))) {
            out.write(autor.getIdPersoana() + ", " + autor.getNumePersoana() + ", " + autor.getPrenumePersoana() + '\n');
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static void scrie_cititor_csv(Cititor cititor) {
        try (var out = new BufferedWriter(new FileWriter("src/read_write/cititori.csv", true))) {
            out.write(cititor.getIdPersoana() + ", " + cititor.getNumePersoana() + ", " + cititor.getPrenumePersoana() + ", " + cititor.getdata_inscriere().getDayOfMonth() + ", " + cititor.getdata_inscriere().getMonthValue() + ", " + cititor.getdata_inscriere().getYear() + '\n');
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static void scrie_carte_csv(Carte carte){
        try(var out = new BufferedWriter(new FileWriter("src/read_write/carti.csv", true))){
            out.write(carte.getIdCarte() + ", " + carte.getDenumireCarte() + ", " + carte.getAutor() + ", " + carte.getNrPagini() + ", " + carte.getCategorie());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static void scrie_categorie_csv(Categorie categorie){
        try(var out = new BufferedWriter(new FileWriter("src/read_write/categorii.csv", true))){
            out.write(categorie.getIdCategorie() + ", " + categorie.getDenumire());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static void scrie_student_csv(Student student){
        try(var out = new BufferedWriter(new FileWriter("src/read_write/studenti.csv", true))){
            out.write(student.getIdPersoana() + ", " + student.getNumePersoana() + ", " + student.getPrenumePersoana()
                    + ", " + student.getFacultate() + ", " + student.getdata_inscriere());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}