package models;

import java.util.Objects;

public class Carte implements Comparable<Carte> {
    protected Integer id_carte;
    protected String titlu;
    protected Autor autor;
    protected Integer nr_pagini;
    protected Categorie categorie;

    public Carte(){
        this.id_carte = 0;
        this.titlu = "";
        this.autor = new Autor();
        this.nr_pagini=0;
        this.categorie = new Categorie();
    }
    public Carte(Integer id_carte, String titlu, Autor autor, Integer nr_pagini, Categorie categorie) {
        this.id_carte = id_carte;
        this.titlu = titlu;
        this.autor = autor;
        this.nr_pagini = nr_pagini;
        this.categorie = categorie;
    }
    public Carte (Carte carte){
        this.id_carte = carte.getIdCarte();
        this.titlu = carte.getDenumireCarte();
        this.autor = carte.getAutor();
        this.nr_pagini = carte.getNrPagini();
        this.categorie = carte.getCategorie();
    }
    public Integer getIdCarte() {
        return id_carte;
    }

    public void setIdCarte(Integer id_carte) {
        this.id_carte = id_carte;
    }

    public String getDenumireCarte() {
        return titlu;
    }

    public void setDenumireCarte(String titlu) {
        this.titlu = titlu;
    }

    public Autor getAutor() {
        return autor;
    }

    public void setAutor(Autor autor) {
        this.autor = autor;
    }

    public Integer getNrPagini() {
        return nr_pagini;
    }

    public void setNrPagini(int nr_pagini) {
        this.nr_pagini = nr_pagini;
    }

    public Categorie getCategorie() {
        return categorie;
    }

    public void setCategorie(Categorie categorie) {
        this.categorie = categorie;
    }

    public String bookType(){
        return "Carte";
    }
    @Override
    public String toString() {
        return "Cartea cu id-ul " + id_carte + " se numeste '" + titlu + "', este scrisa de " + autor + ", are " + nr_pagini + " pagini " + "si apartine de " + categorie;

    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Carte carte = (Carte) o;
        return id_carte==carte.getIdCarte() && nr_pagini.equals(carte.getNrPagini()) &&
                titlu.equals(carte.getDenumireCarte()) &&
                autor.equals(carte.getAutor()) && categorie.equals(carte.getCategorie());
    }

    @Override
    public int hashCode() {
        return Objects.hash(id_carte, titlu, autor, nr_pagini, categorie);
    }

    @Override
    public int compareTo(Carte o) {
        return this.titlu.compareTo(o.getDenumireCarte());
    }
}