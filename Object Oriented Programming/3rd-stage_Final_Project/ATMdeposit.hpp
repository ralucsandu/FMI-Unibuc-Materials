#ifndef ATMDEPOSIT_HPP_INCLUDED
#define ATMDEPOSIT_HPP_INCLUDED
#include "ATM.hpp"
#include<iostream>
using namespace std;
///copil al clasei abstracte ATM
class ATMdeposit: public ATM
{
public:
    void MakeTransaction(Cont& cont);
    ATMdeposit();
    ATMdeposit(const ATMdeposit& atm);
    ATMdeposit(string adresa[3]);
    ATMdeposit& operator=(const ATMdeposit& atm);
    ~ATMdeposit();
    virtual ostream& AfisareVirtuala(ostream& out)const;
    virtual istream& CitireVirtuala (istream& in);
};

#endif // ATMDEPOSIT_HPP_INCLUDED
