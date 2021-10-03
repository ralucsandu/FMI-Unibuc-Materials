#ifndef INTERFATA_HPP_INCLUDED
#define INTERFATA_HPP_INCLUDED

#include <iostream>
using namespace std;

class Interfata
{
public:
    virtual void afiseaza_date()=0;
    void proiect()
    {
        cout<<"Proiect realizat de Sandu Raluca-Ioana - grupa 142";
        cout<<"\n--------------------------------------------------";
    }
};

#endif // INTERFATA_HPP_INCLUDED
