#ifndef UTILIZATOR_HPP_INCLUDED
#define UTILIZATOR_HPP_INCLUDED
#include "Interfata.hpp"
#include <iostream>
#include <string.h>

using namespace std;

class Utilizator: public Interfata
{
private:
    int numarConturi;
    char* Nume;
    string Prenume;
    const int IDutilizator;
    bool AreImprumuturi;
    double ValoareImprumut;
    char InitialaTata;
    float Procent;  //procentul pe care il economiseste lunar din salariu o persoana care are imprumuturi
                    //va fi de forma 0.x (0.1, 0.2, 0.3 etc)
    string Cnp;
    float SalariuMediu;
    int* Conturi; //contine numarul(id-ul) fiecarui cont al utilizatorului, daca acesta are mai multe
    string* DatePersonale; //date_personale[0]=nr de telefon, date_personale[1]=adresa de e-mail,
                           //date_personale[2]=strada unde locuieste utilizatorul,
                           //date_personale[3]=numarul strazii;
    double Impozit; //cat la suta plateste impozit pentru stat in functie de ocupatie

public:
    static long NumarUtilizatori; //numarul total de utilizatori ai bancii(numarul de instante(obiecte) ale clasei)

//Constructorul de copiere:
    Utilizator(const Utilizator& user);
//Constructorul fara parametri:
    Utilizator();
//Constructorul cu parametri:
    Utilizator(char* Nume,string Prenume,bool AreImprumuturi,double ValoareImprumut, float Procent, char InitialaTata,string Cnp,
               float SalariuMediu,int numarConturi,int* Conturi,string* DatePersonale,
               double Impozit);

//Alt constructor cu parametri:
    Utilizator(char* Nume, string Prenume, char InitialaTata, string Cnp, string* DatePersonale);

//Operatorul egal:
    Utilizator& operator=(const Utilizator& user);

//Operatorul << :
    friend ostream& operator<<(ostream& out, const Utilizator& u);

//Operatorul >>:
    friend istream& operator>>(istream& in, Utilizator& u);

//Operatorul ++ preincrementare
    const Utilizator& operator++()
    {
        this->numarConturi++;
        return *this;
    }
//Operatorul ++ postincrementare
    const Utilizator operator++(int)
    {
        Utilizator nrc(*this);
        this->numarConturi++;
        return nrc;
    }
//Operatorul -- preincrementare:
    const Utilizator& operator--()
    {
        this->numarConturi--;
        return *this;
    }
//Operatorul - la dreapta:
    Utilizator operator-(float valoareScazuta);

//Operatorul * la dreapta:
    Utilizator operator*(int valoareInmultita);
//Operatori conditionali:
    bool operator>=(const Utilizator& u);
    bool operator<=(const Utilizator& u);

//getters:
    char* getNume();
    string getPrenume();
    int getIDutilizator();
    bool getAreImprumuturi();
    double getValoareImprumut();
    float getProcent();
    char getInitialaTata();
    string getCnp();
    float getSalariuMediu();
    int* getConturi();
    int getNrConturi();
    string* getDatePersonale();
    double getImpozit();
//setters:
    void setNume(char* Nume);
    void setPrenume(string Prenume);
    void setAreImprumuturi(bool AreImprumuturi);
    void setValoareImprumut(double ValoareImprumut);
    void setProcent(float Procent);
    void setInitialaTata(char InitialaTata);
    void setCnp(string Cnp);
    void setSalariuMediu(float SalariuMediu);
    void setConturi(int* conturi, int nr);
    void setDatePersonale(string* date);
    void setImpozit(double Impozit);

//functia de afisare:
    void afisare();
//functia de citire:
    void citire();
///Functionalitate: metoda care calculeaza in cate luni un utilizator poate restitui imprumutul facut
    int inCateLuniSeVaPuteaRestituiImprumutul();
///Metoda care afiseaza datele personale ale utilizatorului, fara cele legate de cont
    void afiseaza_date();
//Destructorul:
    ~Utilizator();
};

#endif // UTILIZATOR_HPP_INCLUDED
