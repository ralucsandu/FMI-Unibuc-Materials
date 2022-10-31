package models;

import java.time.LocalDate;
import java.util.Objects;

public class Student extends Cititor {
    private String facultate;

    public Student() {
        super(0, "", "");
        this.facultate = "";
    }

    public Student(Integer id_persoana, String nume, String prenume, String facultate, LocalDate data_inscriere) {
        super(id_persoana, nume, prenume);
        this.facultate = facultate;
        this.data_inscriere = data_inscriere;
    }

    public Student(Integer id_persoana, String nume, String prenume, LocalDate data_inscriere, String facultate) {
        super(id_persoana, nume, prenume, data_inscriere);
        this.facultate = facultate;
    }

    public Student(Student student) {
        this.id_persoana = student.getIdPersoana();
        this.nume = student.getNumePersoana();
        this.prenume = student.getPrenumePersoana();
        this.facultate = student.getFacultate();
        this.data_inscriere = student.getdata_inscriere();
    }

    public String getFacultate() {
        return facultate;
    }

    public void setFacultate(String facultate) {
        this.facultate = facultate;
    }


    @Override
    public String toString() {
        return "Student{" +
                "facultate='" + facultate + '\'' +
                ", data_inscriere=" + data_inscriere +
                ", id_persoana=" + id_persoana +
                ", nume='" + nume + '\'' +
                ", prenume='" + prenume + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) return false;
        Student student = (Student) o;
        return facultate.equals(student.facultate);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), facultate);
    }
}