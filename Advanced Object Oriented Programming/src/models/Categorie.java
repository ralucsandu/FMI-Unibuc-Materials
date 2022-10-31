package models;

import java.util.Objects;

public class Categorie implements Comparable<Categorie> {
    private Integer id_categorie;
    private String denumire;

    public Categorie(){
        this.id_categorie = 0;
        this.denumire = "";
    }

    public Categorie(Integer id_categorie, String denumire) {
        this.id_categorie = id_categorie;
        this.denumire = denumire;

    }

    public Categorie(Categorie categorie) {
        this.id_categorie = categorie.getIdCategorie();
        this.denumire = categorie.getDenumire();
    }

    public Integer getIdCategorie() {
        return id_categorie;
    }

    public void setIdCategorie(Integer id_categorie) {
        this.id_categorie = id_categorie;
    }

    public String getDenumire() {
        return denumire;
    }

    public void setDenumire(String denumire) {
        this.denumire = denumire;
    }


    @Override
    public String toString() {
        return "categoria " + id_categorie + ", numita '" + denumire + '\'';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Categorie categorie = (Categorie) o;
        return id_categorie.equals(categorie.id_categorie) && denumire.equals(categorie.denumire);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id_categorie, denumire);
    }

    @Override
    public int compareTo(Categorie o) {
        return this.denumire.compareTo(o.getDenumire());
    }
}