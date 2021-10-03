#ifndef ATM_HPP_INCLUDED
#define ATM_HPP_INCLUDED
#include "Cont.hpp"
#include <iostream>
#include <string.h>

///clasa abstracta
class ATM
{
protected:
    float valoare;
    string adresa[3]; //adresa[0]=oras, adresa[1]=strada, adresa[2]=numarul
public:
    ATM();
    ATM(float valoare, string adresa[3]);
    ATM& operator=(const ATM& atm);
    ATM(const ATM& atm);
    virtual void MakeTransaction(Cont& cont) = 0;
    virtual ostream& AfisareVirtuala(ostream& out)const;
    virtual istream& CitireVirtuala (istream& in);
    friend istream& operator>>(istream & in,ATM& atm);
    friend ostream& operator<<(ostream & out,const ATM& atm);
    ~ATM()
    {
    }
};

#endif // ATM_HPP_INCLUDED
