package services;

import models.Student;
import read_write.Scriere;

import java.util.*;

public class ServiciuStudent {
    private List<Student> lista_studenti;
    private static ServiciuStudent instance = null;
    private ServiciuStudent() {
        lista_studenti = new ArrayList<>();
    }

    public static ServiciuStudent get_instance() {
        if (instance == null)
            instance = new ServiciuStudent();
        return instance;
    }

    public void adauga_student(Student student,boolean csv) {
        boolean ok = false;
        for (Student s : lista_studenti)
            if (s.equals(student)) {
                ok = true;
                break;
            }
        if (!ok) {
            lista_studenti.add(new Student(student));
            if(!csv) {
                Scriere.scrie_student_csv(student);
                Scriere.audit("Adauga student nou");
            }
            ordoneaza_studenti();
        }
    }
    private void ordoneaza_studenti() {
        Collections.sort(lista_studenti);
    }
    public void afiseaza_studenti_existenti() {
        for (Student s : lista_studenti)
            System.out.println(s.toString());
    }
}