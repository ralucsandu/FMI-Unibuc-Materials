package models;
import java.util.Objects;
 public abstract class Persoana implements Comparable<Persoana>{
        protected Integer id_persoana;
        protected String nume;
        protected String prenume;

     public Persoana() {
         this.id_persoana = 0;
         this.nume = "NUME";
         this.prenume = "PRENUME";
     }

     public Persoana(Integer id_persoana, String nume, String prenume) {
            this.id_persoana = id_persoana;
            this.nume = nume;
            this.prenume = prenume;
        }
        public Integer getIdPersoana() {
            return id_persoana;
        }
        public void setIdPersoana(Integer id_persoana) {
            this.id_persoana = id_persoana;
        }
        public String getNumePersoana() {
            return nume;
        }
        public void setNumePersoana(String nume) {
            this.nume = nume;
        }

        public String getPrenumePersoana() {
         return prenume;
     }
        public void setPrenumePersoana(String prenume) {
         this.prenume = prenume;
     }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            Persoana pers = (Persoana) o;
            return id_persoana.equals(pers.id_persoana) && nume.equals(pers.nume);
        }

        @Override
        public int hashCode() {
            return Objects.hash(id_persoana, nume);
        }

     @Override
     public int compareTo(Persoana p) {
         if(this.nume.equals(p.getNumePersoana())) {
             return this.prenume.compareTo(p.getPrenumePersoana());
         } else {
             return this.nume.compareTo(p.getNumePersoana());
         }
     }
 }
