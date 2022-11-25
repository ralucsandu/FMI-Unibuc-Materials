package models;

import java.time.LocalDate;
import java.util.Objects;

public class BonFiscal {
    private LocalDate data_imprumut;
    private Cititor cititor;
    private Carte carte_imprumutata;
    private LocalDate data_returnare;

    public BonFiscal() {
        this.data_imprumut = LocalDate.now();
        this.cititor = new Cititor();
        this.carte_imprumutata = new Carte();
        this.data_returnare = LocalDate.now();
    }

    public BonFiscal(Cititor cititor, Carte carte_imprumutata, LocalDate data_returnare) {
        this.data_imprumut = LocalDate.now();
        this.cititor = cititor;
        this.carte_imprumutata = new Carte(carte_imprumutata);
        this.data_returnare = data_returnare;
    }
    public BonFiscal(LocalDate data_imprumut, Cititor cititor, Carte carte_imprumutata, LocalDate data_returnare) {
        this.data_imprumut = data_imprumut;
        this.cititor = cititor;
        this.carte_imprumutata = new Carte(carte_imprumutata);
        this.data_returnare = data_returnare;
    }

    public BonFiscal(BonFiscal bon_fiscal){
        this.data_imprumut = bon_fiscal.getDataImprumut();
        this.cititor = bon_fiscal.getCititor();
        this.carte_imprumutata = bon_fiscal.getCarteImprumutata();
        this.data_returnare = bon_fiscal.getDataReturnare();
    }

    public LocalDate getDataImprumut() {
        return data_imprumut;
    }

    public void setDataImprumut(LocalDate data_imprumut) {
        this.data_imprumut = data_imprumut;
    }

    public Cititor getCititor() {
        return cititor;
    }

    public void setCititor(Cititor cititor) {
        this.cititor = cititor;
    }

    public Carte getCarteImprumutata() {
        return carte_imprumutata;
    }

    public void setCarteImprumutata(Carte carte_imprumutata) {
        this.carte_imprumutata = carte_imprumutata;
    }

    public LocalDate getDataReturnare() {
        return data_returnare;
    }

    public void setDataReturnare(LocalDate data_returnare) {
        this.data_returnare = data_returnare;
    }

    @Override
    public String toString() {
        return "BonFiscal{" +
                "loanDate=" + data_imprumut +
                ", cititor=" + cititor +
                ", carte_imprumutata=" + carte_imprumutata +
                ", data_returnare=" + data_returnare +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BonFiscal bonFiscal = (BonFiscal) o;
        return Objects.equals(data_imprumut, bonFiscal.data_imprumut) && Objects.equals(cititor, bonFiscal.cititor) && Objects.equals(carte_imprumutata, bonFiscal.carte_imprumutata) && Objects.equals(data_returnare, bonFiscal.data_returnare);
    }

    @Override
    public int hashCode() {
        return Objects.hash(data_imprumut, cititor, carte_imprumutata, data_returnare);
    }
}
