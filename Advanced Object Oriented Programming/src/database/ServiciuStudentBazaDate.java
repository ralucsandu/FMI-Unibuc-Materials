package database;

import models.Student;
import repository.StudentRepo;

import java.time.LocalDate;
import java.util.Map;
import java.util.Scanner;

public class ServiciuStudentBazaDate {
    private StudentRepo studentRepo;

    public ServiciuStudentBazaDate() {
        this.studentRepo = new StudentRepo();
    }

    public void adauga_student_sql(Student student) {
        studentRepo.adauga_student_sql(student);
    }

    public void sterge_student_sql(Map<Integer, Student> studenti, Scanner scanner) {
        System.out.println("Studentii existenti in baza de date: ");
        for (Map.Entry<Integer, Student> me : studenti.entrySet()) {
            System.out.println(me.getKey() + ". " + me.getValue().getNumePersoana() + " " + me.getValue().getPrenumePersoana() + " " + me.getValue().getFacultate());
        }
        System.out.println("Introduceti id-ul studentului pe care va doriti sa il stergeti! ");
        String id_student = scanner.nextLine();
        Student student = studenti.get(Integer.parseInt(id_student));
        studentRepo.sterge_student_sql(student);
        System.out.println("Stergerea s-a realizat cu succes!");
    }

    public void update_student_sql(Map<Integer, Student> studenti, Scanner scanner) {
        System.out.println("Studentii existenti:");
        for (Map.Entry<Integer, Student> me : studenti.entrySet()) {
            System.out.println(me.getKey() + ". " + me.getValue().getNumePersoana() + " " + me.getValue().getPrenumePersoana()+ " " + me.getValue().getFacultate());
        }
        System.out.println("Introduceti id-ul studentului pe care doriti sa-l actualizati!");
        String id_student = scanner.nextLine();
        System.out.println("Introduceti noua facultate!");
        String facultate = scanner.nextLine();
        Student stud = studenti.get(Integer.parseInt(id_student));
        studentRepo.update_student_sql(stud, facultate);
        System.out.println("Actualizarea s-a realizat cu succes!");
    }

    public Student modifica_student(Scanner scanner) {
        System.out.println("STUDENT");
        System.out.println("Introduceti datele studentului: id/nume/prenume/facultate/data_inscriere(format: an/luna/zi)");
        String linie = scanner.nextLine();
        String[] fields = linie.split("/");
        return new Student(Integer.parseInt(fields[0]),fields[1], fields[2], fields[3], LocalDate.of(Integer.parseInt(fields[4]), Integer.parseInt(fields[5]), Integer.parseInt(fields[6])));
    }

    public Map<Integer, Student> get_toti_studentii() {
        return studentRepo.get_studenti();
    }
}