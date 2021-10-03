#ifndef IMPRUMUT_HPP_INCLUDED
#define IMPRUMUT_HPP_INCLUDED
#include <iostream>
#include <ctime>
#include <cstring>
using namespace std;

class Imprumut
{
protected:
    float valoareImprumut;
    long idCont;
private:
    string durata; //durata perioadei in care trebuie restituit imprumutul, de forma "ani, luni, zile"
    double sumaAchitata; //suma achitata pana in prezent
public:
//Constructorul de copiere:
    Imprumut(const Imprumut& loan);
//Constructorul fara parametri:
    Imprumut();
//Constructorul cu parametri:
    Imprumut(float valoareImprumut, long idCont);
    Imprumut(string durata, double sumaAchitata);
//Destructorul:
    ~Imprumut();
//Operatorul egal:
    Imprumut& operator=(const Imprumut& loan);
//Operatorul << :
    friend ostream& operator<<(ostream& out, const Imprumut& i);
//Operatorul >>:
    friend istream& operator>>(istream& in, Imprumut& i);
//Operatorul --:
    const Imprumut& operator--()
    {
        int ani, luni, zile;
        getZileLuniAniDurata(zile, luni, ani);
        //presupunem ca toate lunile au 30 de zile
        zile--;
        if (zile < 1)
        {
            zile = 30;
            luni--;
        }
        if (luni < 1)
        {
            luni = 12;
            ani--;
        }
        durata = to_string(ani) + "," + to_string(luni) + "," + to_string(zile);
        return *this;
    }
//Operatorul cast explicit:
    explicit operator int();
//getters:
    float getValoareImprumut();
    long getIdCont();
    string getDurata();
    double getSumaAchitata();
//setters:
    void setDurata(string durata);
    void setSumaAchitata(double sumaAchitata);
    void setValoareImprumut(float valoareImprumut);
///Functionalitate: metoda pentru a determina la ce data trebuie returnat imprumutul, stiind numarul de ani, luni si zile
    string CandTrebuieReturnat();
    void getZileLuniAniDurata(int &ani,int &luni,int &zile);
///Operatorul >:
    bool operator>(const Imprumut &imp) const
    {
        return valoareImprumut>imp.valoareImprumut;
    }
};

#endif // IMPRUMUT_HPP_INCLUDED
