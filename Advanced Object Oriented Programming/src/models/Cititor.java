package models;

import java.time.LocalDate;
import java.util.Objects;

public class Cititor extends Persoana {
    protected LocalDate data_inscriere;

    public Cititor() {
        super(0, "", "");
        this.data_inscriere = null;
    }

    public Cititor(int id_persoana, String nume, String prenume) {
        super(id_persoana, nume, prenume);
        this.data_inscriere = LocalDate.now();
    }

    public Cititor(int id_persoana, String nume, String prenume, LocalDate data_inscriere) {
        super(id_persoana, nume, prenume);
        this.data_inscriere = data_inscriere;
    }
    public Cititor(Cititor cititor){
        super(cititor.getIdPersoana(), cititor.getNumePersoana(), cititor.getPrenumePersoana());
        this.data_inscriere = cititor.getdata_inscriere();
    }

    public LocalDate getdata_inscriere(){
        return data_inscriere;
    }

    public void setdata_inscriere(LocalDate data_inscriere) {
        this.data_inscriere = data_inscriere;
    }

    @Override
    public String toString() {
        return "Cititor{" +
                ", id_persoana=" + id_persoana +
                ", nume='" + nume + '\'' +
                ", prenume='" + prenume + '\'' +
                " data_inscriere=" + data_inscriere +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) return false;
        Cititor cititor = (Cititor) o;
        return Objects.equals(id_persoana, cititor.id_persoana) && Objects.equals(nume, cititor.nume)&&Objects.equals(prenume, cititor.prenume);
    }
    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), data_inscriere);
    }

}
