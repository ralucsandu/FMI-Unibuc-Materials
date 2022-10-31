package models;

import java.util.Objects;

public class CarteAudio extends Carte{

    private String durata;
    public CarteAudio() {
        super(0, "", new Autor(), 0,new Categorie());
        this.durata="";
    }
    public CarteAudio(Integer id_carte, String titlu, Autor autor, Integer nr_pagini, Categorie categorie, String durata) {
        super(id_carte, titlu, autor, nr_pagini,categorie);
        this.durata=durata;
    }

    public CarteAudio(CarteAudio carteAudio){
        super(carteAudio.getIdCarte(), carteAudio.getDenumireCarte(), carteAudio.getAutor(), carteAudio.getNrPagini(), carteAudio.getCategorie());
        this.durata = carteAudio.getDurata();
    }

    public String getDurata() {
        return durata;
    }

    public void setDurata(String durata) {
        this.durata = durata;
    }

    @Override
    public String toString() {
        return "Carte audio{" +
                "id_carte=" + id_carte +
                ", titlu ='" + titlu + '\'' +
                ", autor =" + autor +
                ", nr_pagini =" + nr_pagini +
                ", categorie =" + categorie +
                ", durata =" + durata +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) return false;
        CarteAudio agenda = (CarteAudio) o;
        return Objects.equals(durata, agenda.durata);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), durata);
    }
}