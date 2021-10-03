#ifndef ATMEXTRACT_HPP_INCLUDED
#define ATMEXTRACT_HPP_INCLUDED
#include "ATM.hpp"
#include <iostream>
using namespace std;

///copil al clasei abstracte ATM
class ATMextract: public ATM
{
public:
    void MakeTransaction(Cont& cont);
    ATMextract();
    ATMextract(const ATMextract& atm);
    ATMextract(string adresa[3]);
    ATMextract& operator=(const ATMextract& atm);
    ~ATMextract();
    virtual ostream& AfisareVirtuala(ostream& out)const;
    virtual istream& CitireVirtuala (istream& in);
};

#endif // ATMEXTRACT_HPP_INCLUDED
