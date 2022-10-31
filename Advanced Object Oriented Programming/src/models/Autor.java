package models;

public class Autor extends Persoana {
    public Autor() {
        super(0, "", "");
    }
    public Autor(Integer id_persoana, String nume, String prenume) {
        super(id_persoana, nume, prenume);
    }

    public Autor(Autor autor){
        super(autor.getIdPersoana(), autor.getNumePersoana(), autor.getPrenumePersoana());
    }

    @Override
    public String toString() {
        return "autorul cu id-ul " + id_persoana + " si numele " + nume + ' ' + prenume ;
    }

    @Override
    public boolean equals(Object o) {
        return super.equals(o);
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }
}
