#include <bits/stdc++.h>
using namespace std;
typedef long long i64;
typedef struct Node * Arbore;
mt19937_64 rnd(time(0));//numere random pe 64 de biti

struct Node
{
    // valoarea data din input.
    i64 valoare;

    // prioritatea aleasa random.
    i64 prioritate;

    // Cate noduri are in subarbore.
    int g;

    // Fii.
    Arbore st, dr;

    // Recalculeaza greutatea.
    void Recalc()
    {
        g = 1;
        if (st)
            g += st->g;
        if (dr)
            g += dr->g;
    }

    // Construim un nod nou.
    Node(i64 val) : valoare(val), prioritate(rnd()), g(1), st(nullptr), dr(nullptr) { }//prioritatile sunt alese random pentru a avea eficienta programul

    // stergem totul recursiv
    ~Node()
    {
        if (st)
            delete st;
        if (dr)
            delete dr;
    }
};

/**
 * Uneste doi arbori.
 * ATENTIE: Conteaza ordinea. o sa il puna pe A IN STANGA lui B
 * ATENTIE: a trebuie sa fie mai mic decat b ca valori.
 */
Arbore Join(Arbore a, Arbore b)
{
    if (a == nullptr)
        return b;
    if (b == nullptr)
        return a;

    // Vrem sa il punem pe a sus.
    if (a->prioritate > b->prioritate)
    {
        a->dr = Join(a->dr, b);
        a->Recalc();//recalculam greutatea
        return a;
    }
    // Daca nu, il punem pe a ca fiu al lui b.
    b->st = Join(a, b->st);
    b->Recalc();//recalculam greutatea
    return b;
}

/**
 * Intoarce o pereche care contine
 * { primele K valori, restul }
 */
pair <Arbore, Arbore> SplitByRank(Arbore a, int K)
{
    if (K <= 0)// pentru cazul in care primeste numar negativ
        return { nullptr, a };
    if (a == nullptr)
        return { nullptr, nullptr };

    // Avem cel putin K elememente in stanga.
    if (a->st && a->st->g >= K)
    {
        pair <Arbore, Arbore> split_st = SplitByRank(a->st, K);
        a->st = split_st.second;//ce a ramas din subarborele stang punem la a
        a->Recalc();
        return { split_st.first, a };
    }

    // Avem mai putin de K elemente in stanga.
    int nr_actual = 1;//luam in considerare radacina
    if (a->st)
        nr_actual += a->st->g;

    // mai avem nevoie de K - nr_actual elemente din a->dr
    pair <Arbore, Arbore> split_dr = SplitByRank(a->dr, K - nr_actual);
    a->dr = split_dr.first;
    a->Recalc();
    return { a, split_dr.second };
}

/**
 * Intoarce o pereche care contine
 * { <= K, > K }
 */
pair <Arbore, Arbore> SplitByValue(Arbore a, i64 val)
{
    if (a == nullptr)
        return { nullptr, nullptr };

    // A o sa fie in a doua bucata.
    if (a->valoare > val)
    {
        pair <Arbore, Arbore> split_st = SplitByValue(a->st, val);
        a->st = split_st.second;
        a->Recalc();
        return { split_st.first, a };
    }

    // A o sa fie in prima bucata.
    pair <Arbore, Arbore> split_dr = SplitByValue(a->dr, val);
    a->dr = split_dr.first;
    a->Recalc();
    return { a, split_dr.second };
}

// Intoarce daca exista sau nu val.
int Find(Arbore root, i64 val)
{
    while (root)
    {
        if (root->valoare == val)
            return true;
        if (root->valoare > val)
            root = root->st;
        else
            root = root->dr;
    }
    return false;
}

/**
 * Adauga un element.
 */
Arbore Insert(Arbore root, i64 val)
{
    // Exista deja.
    if (Find(root, val))
        return root;

    Arbore a = new Node(val);
    pair <Arbore, Arbore> s = SplitByValue(root, val);

    return Join(Join(s.first, a), s.second);
}

/**
 * Sterge un element.
 */
Arbore Delete(Arbore root, i64 val)
{
    // { <= val, > val }
    pair <Arbore, Arbore> split_1 = SplitByValue(root, val);

    // { < val, poate pe val (daca exista) }
    pair <Arbore, Arbore> split_2 = SplitByValue(split_1.first, val - 1);

    if (split_2.second != nullptr)
        delete split_2.second;

    return Join(split_2.first, split_1.second);
}

/**
 * Returneaza al k-ulea element.
 */
Arbore GetKthElement(Arbore root, int K, i64& val)
{
    // Vrem sa punem mana pe al k-lea element.
    // { primele K, restul }
    pair <Arbore, Arbore> split_1 = SplitByRank(root, K);

    // { primele K - 1, al k-lea }
    pair <Arbore, Arbore> split_2 = SplitByRank(split_1.first, K - 1);

    if (split_2.second != nullptr)
        val = split_2.second->valoare;
    else
        throw runtime_error("Get invalid element of DS");
    return Join(Join(split_2.first, split_2.second), split_1.second);
}
/**
 * Pozitia unui element dat
 */
Arbore GetOrderOfElement(Arbore root, i64 val, int& ord)
{
    // { <= val, > val }
    pair <Arbore, Arbore> split = SplitByValue(root, val);

    if (split.first == nullptr)
        throw runtime_error("Get order of inexistent element!");
    else
        ord = split.first->g;//ordinea este greutatea

    return Join(split.first, split.second);
}

class ArboreEchilibrat
{
    Arbore radacina;

public:

    ~ArboreEchilibrat()
    {
        if (radacina)
            delete radacina;
    }

    ArboreEchilibrat()
    {
        radacina = nullptr;
    }

    void Insereaza(i64 val)
    {
        radacina = Insert(radacina, val);
    }

    void Sterge(i64 val)
    {
        radacina = Delete(radacina, val);
    }

    i64 k_element(int K)
    {
        i64 val;
        radacina = GetKthElement(radacina, K, val);
        return val;
    }

    i64 Min()
    {
        return k_element(1);
    }

    i64 Max()
    {
        return k_element(radacina->g);
    }

    int PositionOfElement(i64 val)  //am creat functia pentru a o folosi la succesor si predecesor
    {
        int ord;
        radacina = GetOrderOfElement(radacina, val, ord);
        return ord;
    }

    i64 Succesor(i64 val)
    {
        int poz = PositionOfElement(val);
        return k_element(poz + 1);
    }

    i64 Predecesor(i64 val)
    {
        int poz = PositionOfElement(val);
        return k_element(poz - 1);
    }

    int Cardinal()
    {
        if (radacina == nullptr)
            return 0;
        return radacina->g;
    }

    int EsteIn(i64 val)
    {
        return Find(radacina, val);
    }
};

class FakeArbore  //clasa creata pentru a verifica daca functiile sunt corecte
{
public:

    set <i64> valori;

    void Insereaza(i64 val)
    {
        valori.insert(val);
    }

    void Sterge(i64 val)
    {
        valori.erase(val);
    }

    i64 k_element(int K)
    {
        for (i64 i : valori)
        {
            K--;
            if (K == 0)//am gasit al k-ulea element
                return i;
        }
        throw runtime_error("Invalid position!");
    }

    i64 Min()
    {
        return k_element(1);
    }

    i64 Max()
    {
        return k_element(valori.size());
    }

    int PositionOfElement(i64 val)
    {
        int ord = 0;
        for (i64 i : valori)
        {
            ord++;
            if (i == val)
                return ord;
        }
        throw runtime_error("Invalid position!");
    }

    i64 Succesor(i64 val)
    {
        int poz = PositionOfElement(val);
        return k_element(poz + 1);
    }

    i64 Predecesor(i64 val)
    {
        int poz = PositionOfElement(val);
        return k_element(poz - 1);
    }

    int Cardinal()
    {
        return valori.size();
    }

    int EsteIn(i64 val)
    {
        return (valori.find(val) != valori.end());
    }

    i64 GetRandomElement()  //ne da un numar random din valori
    {
        int ord = 1 + rnd() % valori.size();
        return k_element(ord);
    }

};
void InserareStergere(int NR_OP,
                      double p_modif = 0.5,
                      double p_insert = 0.6)
{
    ArboreEchilibrat arbore;
    FakeArbore arbore_fake;
    // Distributia de numere random in intervalul dat.
    uniform_real_distribution <double> distributie(0., 1.);

    while (NR_OP)
    {
        // vrem sa modificam ceva.
        if (distributie(rnd) < p_modif)
        {
            auto timp_inceput = chrono::high_resolution_clock::now();
            // Adaugam ceva.
            if (distributie(rnd) < p_insert)
            {
                i64 val = rnd();
                arbore.Insereaza(val);
                arbore_fake.Insereaza(val);
                cerr << "Am adaugat " << val << "\n";
                NR_OP--;
                auto timp_final = chrono::high_resolution_clock::now();
                cout<< (timp_final - timp_inceput).count() / 1e9<<"\n\n";
            }

            else
            {
                auto timp_inc = chrono::high_resolution_clock::now();
                // Vrem sa stergem ceva.
                // Nu putem sa stergem nimic, ca e gol.
                if (arbore_fake.valori.size() == 0)
                    continue;
                i64 val = arbore_fake.GetRandomElement();
                arbore.Sterge(val);
                arbore_fake.Sterge(val);
                cerr << "Am sters " << val << '\n';
                NR_OP--;
                auto timp_fi = chrono::high_resolution_clock::now();
                cout<< (timp_fi - timp_inc).count() / 1e9<<"\n\n";//il transformam in secunde
            }
        }

    }
    cout << "OK!\n";
}
void InserareMin(int NR_OP,
                 double p_modif = 0.5,
                 double p_insert = 0.6)
{
    FakeArbore arbore_fake;
    ArboreEchilibrat arbore;
    i64 expected=0,obtained=0;
    // Distributia de numere random in intervalul dat.
    uniform_real_distribution <double> distributie(0., 1.);

    while (NR_OP)
    {
        // vrem sa modificam ceva.
        if (distributie(rnd) < p_modif)
        {
            auto timp_inceput = chrono::high_resolution_clock::now();
            // Adaugam ceva.
            if (distributie(rnd) < p_insert)
            {
                i64 val = rnd();
                arbore.Insereaza(val);
                arbore_fake.Insereaza(val);
                cerr << "Am adaugat " << val << "\n";
                NR_OP--;
                auto timp_final = chrono::high_resolution_clock::now();
                cout<< (timp_final - timp_inceput).count() / 1e9<<"\n\n";
            }

            else
            {
                auto timp_inc = chrono::high_resolution_clock::now();
                // Vrem sa facem min.
                // Nu putem sa facem min, ca e gol.
                if (arbore_fake.valori.size() == 0)
                    continue;
                expected = arbore_fake.Min();
                obtained = arbore.Min();
                cerr << "Minimul este:  " <<obtained<<", iar cel astepat este "<<expected<<"\n";
                NR_OP--;
                auto timp_fi = chrono::high_resolution_clock::now();
                cout<< (timp_fi - timp_inc).count() / 1e9<<"\n\n";//il transformam in secunde
            }
        }

    }
    cout << "OK!\n";

}
void InserareMax(int NR_OP,
                 double p_modif = 0.5,
                 double p_insert = 0.6)
{
    FakeArbore arbore_fake;
    ArboreEchilibrat arbore;
    i64 expected=0,obtained=0;
    // Distributia de numere random in intervalul dat.
    uniform_real_distribution <double> distributie(0., 1.);

    while (NR_OP)
    {
        // vrem sa modificam ceva.
        if (distributie(rnd) < p_modif)
        {
            auto timp_inceput = chrono::high_resolution_clock::now();
            // Adaugam ceva.
            if (distributie(rnd) < p_insert)
            {
                i64 val = rnd();
                arbore.Insereaza(val);
                arbore_fake.Insereaza(val);
                cerr << "Am adaugat " << val << "\n";
                NR_OP--;
                auto timp_final = chrono::high_resolution_clock::now();
                cout<< (timp_final - timp_inceput).count() / 1e9<<"\n\n";
            }

            else
            {
                auto timp_inc = chrono::high_resolution_clock::now();
                // Vrem sa facem max.
                // Nu putem sa facem max, ca e gol.
                if (arbore_fake.valori.size() == 0)
                    continue;
                expected = arbore_fake.Max();
                obtained = arbore.Max();
                cerr << "Maximul este:  " <<obtained<<", iar cel astepat este "<<expected<<"\n";
                NR_OP--;
                auto timp_fi = chrono::high_resolution_clock::now();
                cout<< (timp_fi - timp_inc).count() / 1e9<<"\n\n";//il transformam in secunde
            }
        }

    }
    cout << "OK!\n";

}
void InserareSuccesor(int NR_OP,
                      double p_modif = 0.5,
                      double p_insert = 0.6)
{
    FakeArbore arbore_fake;
    ArboreEchilibrat arbore;
    i64 expected=0,obtained=0;
    // Distributia de numere random in intervalul dat.
    uniform_real_distribution <double> distributie(0., 1.);

    while (NR_OP)
    {
        // vrem sa modificam ceva.
        if (distributie(rnd) < p_modif)
        {
            auto timp_inceput = chrono::high_resolution_clock::now();
            // Adaugam ceva.
            if (distributie(rnd) < p_insert)
            {
                i64 val = rnd();
                arbore.Insereaza(val);
                arbore_fake.Insereaza(val);
                cerr << "Am adaugat " << val << "\n";
                NR_OP--;
                auto timp_final = chrono::high_resolution_clock::now();
                cout<< (timp_final - timp_inceput).count() / 1e9<<"\n\n";
            }

            else
            {
                auto timp_inc = chrono::high_resolution_clock::now();
                // Vrem sa facem succesorul.
                // Nu putem sa facem succesorul, ca e gol.
                if (arbore_fake.valori.size() == 0)
                    continue;
                i64 val = arbore_fake.GetRandomElement();
                if (val == arbore_fake.Max())
                    continue;
                expected = arbore_fake.Succesor(val);
                obtained = arbore.Succesor(val);
                cerr << "Succesorul lui:  " <<val<<" este "<<obtained<<", iar cel astepat este "<<expected<<"\n";
                NR_OP--;
                auto timp_fi = chrono::high_resolution_clock::now();
                cout<< (timp_fi - timp_inc).count() / 1e9<<"\n\n";//il transformam in secunde
            }
        }

    }
    cout << "OK!\n";

}
void InserarePredecesor(int NR_OP,
                        double p_modif = 0.5,
                        double p_insert = 0.6)
{
    FakeArbore arbore_fake;
    ArboreEchilibrat arbore;
    i64 expected=0,obtained=0;
    // Distributia de numere random in intervalul dat.
    uniform_real_distribution <double> distributie(0., 1.);

    while (NR_OP)
    {
        // vrem sa modificam ceva.
        if (distributie(rnd) < p_modif)
        {
            auto timp_inceput = chrono::high_resolution_clock::now();
            // Adaugam ceva.
            if (distributie(rnd) < p_insert)
            {
                i64 val = rnd();
                arbore.Insereaza(val);
                arbore_fake.Insereaza(val);
                cerr << "Am adaugat " << val << "\n";
                NR_OP--;
                auto timp_final = chrono::high_resolution_clock::now();
                cout<< (timp_final - timp_inceput).count() / 1e9<<"\n\n";
            }

            else
            {
                auto timp_inc = chrono::high_resolution_clock::now();
                // Vrem sa facem predecesorul.
                // Nu putem sa facem predecesorul, ca e gol.
                if (arbore_fake.valori.size() == 0)
                    continue;
                i64 val = arbore_fake.GetRandomElement();
                if (val == arbore_fake.Min())
                    continue;
                expected = arbore_fake.Predecesor(val);
                obtained = arbore.Predecesor(val);
                cerr << "Predecesorul lui:  " <<val<<" este "<<obtained<<", iar cel astepat este "<<expected<<"\n";
                NR_OP--;
                auto timp_fi = chrono::high_resolution_clock::now();
                cout<< (timp_fi - timp_inc).count() / 1e9<<"\n\n";//il transformam in secunde
            }
        }

    }
    cout << "OK!\n";
}
void InserareK_element(int NR_OP,
                       double p_modif = 0.5,
                       double p_insert = 0.6)
{
    FakeArbore arbore_fake;
    ArboreEchilibrat arbore;
    i64 expected=0,obtained=0;
    // Distributia de numere random in intervalul dat.
    uniform_real_distribution <double> distributie(0., 1.);

    while (NR_OP)
    {
        // vrem sa modificam ceva.
        if (distributie(rnd) < p_modif)
        {
            auto timp_inceput = chrono::high_resolution_clock::now();
            // Adaugam ceva.
            if (distributie(rnd) < p_insert)
            {
                i64 val = rnd();
                arbore.Insereaza(val);
                arbore_fake.Insereaza(val);
                cerr << "Am adaugat " << val << "\n";
                NR_OP--;
                auto timp_final = chrono::high_resolution_clock::now();
                cout<< (timp_final - timp_inceput).count() / 1e9<<"\n\n";
            }
            else
            {
                auto timp_inc = chrono::high_resolution_clock::now();
                // Vrem sa facem k_elemnt.
                // Nu putem sa facem k_elemnt, ca e gol.
                if (arbore_fake.valori.size() == 0)
                    continue;
                int poz = rnd() % arbore_fake.valori.size() + 1;
                expected = arbore_fake.k_element(poz);
                obtained = arbore.k_element(poz);
                cerr << "ELmenentul de pe pozitia:  " <<poz<<" este "<<obtained<<", iar cel astepat este "<<expected<<"\n";
                NR_OP--;
                auto timp_fi = chrono::high_resolution_clock::now();
                cout<< (timp_fi - timp_inc).count() / 1e9<<"\n\n";//il transformam in secunde
            }
        }

    }
    cout << "OK!\n";
}
void InserareCardinal(int NR_OP,
                      double p_modif = 0.5,
                      double p_insert = 0.6)
{
    FakeArbore arbore_fake;
    ArboreEchilibrat arbore;
    i64 expected=0,obtained=0;
    // Distributia de numere random in intervalul dat.
    uniform_real_distribution <double> distributie(0., 1.);

    while (NR_OP)
    {
        // vrem sa modificam ceva.
        if (distributie(rnd) < p_modif)
        {
            auto timp_inceput = chrono::high_resolution_clock::now();
            // Adaugam ceva.
            if (distributie(rnd) < p_insert)
            {
                i64 val = rnd();
                arbore.Insereaza(val);
                arbore_fake.Insereaza(val);
                cerr << "Am adaugat " << val << "\n";
                NR_OP--;
                auto timp_final = chrono::high_resolution_clock::now();
                cout<< (timp_final - timp_inceput).count() / 1e9<<"\n\n";
            }

            else
            {
                auto timp_inc = chrono::high_resolution_clock::now();
                // Vrem sa facem cardinalul.
                // Nu putem sa facem cardinalul, ca e gol.
                if (arbore_fake.valori.size() == 0)
                    continue;
                expected = arbore_fake.Cardinal();
                obtained = arbore.Cardinal();
                cerr << "Cardinalul  este "<<obtained<<", iar cel astepat este "<<expected<<"\n";
                NR_OP--;
                auto timp_fi = chrono::high_resolution_clock::now();
                cout<< (timp_fi - timp_inc).count() / 1e9<<"\n\n";//il transformam in secunde
            }
        }
    }
    cout << "OK!\n";
}
void InserareCautare(int NR_OP,
                     double p_modif = 0.5,
                     double p_insert = 0.6)
{
    FakeArbore arbore_fake;
    ArboreEchilibrat arbore;
    i64 expected=0,obtained=0;
    // Distributia de numere random in intervalul dat.
    uniform_real_distribution <double> distributie(0., 1.);

    while (NR_OP)
    {
        // vrem sa modificam ceva.
        if (distributie(rnd) < p_modif)
        {
            auto timp_inceput = chrono::high_resolution_clock::now();
            // Adaugam ceva.
            if (distributie(rnd) < p_insert)
            {
                i64 val = rnd();
                arbore.Insereaza(val);
                arbore_fake.Insereaza(val);
                cerr << "Am adaugat " << val << "\n";
                NR_OP--;
                auto timp_final = chrono::high_resolution_clock::now();
                cout<< (timp_final - timp_inceput).count() / 1e9<<"\n\n";
            }

            else
            {
                auto timp_inc = chrono::high_resolution_clock::now();
                // Vrem sa facem cautarea.
                // Nu putem sa facem cautarea, ca e gol.
                if (arbore_fake.valori.size() == 0)
                    continue;
                if (rnd() % 2)  //este in cand dam un numar random dar care exista
                {
                    i64 val = arbore_fake.GetRandomElement();
                    expected = arbore_fake.EsteIn(val);
                    obtained = arbore.EsteIn(val);
                    cerr << "Valoarea "<<val<< " este in treap? [0-nu/1-da]: "<<obtained<<", iar cel astepat este "<<expected<<"\n";
                }
                else
                {
                    // Dam ceva probabil ce nu exista.
                    i64 val = rnd();
                    expected = arbore_fake.EsteIn(val);
                    obtained = arbore.EsteIn(val);
                    cerr << "Valoarea "<<val<< " este in treap? [0-nu/1-da]: "<<obtained<<", iar cel astepat este "<<expected<<"\n";
                }

                NR_OP--;
                auto timp_fi = chrono::high_resolution_clock::now();
                cout<< (timp_fi - timp_inc).count() / 1e9<<"\n\n";//il transformam in secunde
            }
        }

    }
    cout << "OK!\n";

}
void InserareRandom(int NR_OP)
{
    ArboreEchilibrat arbore;
    FakeArbore arbore_fake;
    auto timp_inceput = chrono::high_resolution_clock::now();
    while (NR_OP)
    {
        i64 val = rnd();
        arbore.Insereaza(val);
        arbore_fake.Insereaza(val);
        cerr << "Am adaugat " << val << "\n";
        NR_OP--;
    }
    cout << "OK!\n";
    auto timp_final = chrono::high_resolution_clock::now();
    cout<< (timp_final - timp_inceput).count() / 1e9<<"\n\n";//il transformam in secunde
}
// Testeaza pe un test random ca ambele abordari dau la fel.
void GenerateRandomTest(
    int NR_OP,
    double p_modif = 0.5,
    double p_insert = 0.6)
{
    // Cream arborele, si fake-ul.
    ArboreEchilibrat arbore;
    FakeArbore arbore_fake;

    // Distributia de numere random in intervalul dat.
    uniform_real_distribution <double> distributie(0., 1.);
    auto timp_inceput = chrono::high_resolution_clock::now();
    while (NR_OP)
    {
        // vrem sa modificam ceva.
        if (distributie(rnd) < p_modif)
        {
            // Adaugam ceva.
            if (distributie(rnd) < p_insert)
            {
                i64 val = rnd();
                arbore.Insereaza(val);
                arbore_fake.Insereaza(val);
                cerr << "Am adaugat " << val << "\n";
                NR_OP--;
            }
            else
            {
                // Vrem sa stergem ceva.
                // Nu putem sa stergem nimic, ca e gol.
                if (arbore_fake.valori.size() == 0)
                    continue;
                i64 val = arbore_fake.GetRandomElement();
                arbore.Sterge(val);
                arbore_fake.Sterge(val);
                cerr << "Am sters " << val << '\n';
                NR_OP--;
            }
        }
        else
        {
            // Vrem sa intrebam ceva.
            if (arbore_fake.valori.size() == 0)
                continue;

            int random_op = rnd() % 7;//alege random
            i64 expected = 0, obtained = 0;//in expected avem rezultatele de la arborele fake, iar in obtained rezultatele de la arborele nostru

            if (random_op == 0)  //min
            {
                expected = arbore_fake.Min();
                obtained = arbore.Min();
            }
            else if (random_op == 1)  //max
            {
                expected = arbore_fake.Max();
                obtained = arbore.Max();
            }
            else if (random_op == 2)  //succesor pt numar random din valori
            {
                i64 val = arbore_fake.GetRandomElement();
                if (val == arbore_fake.Max())
                    continue;
                expected = arbore_fake.Succesor(val);
                obtained = arbore.Succesor(val);
            }
            else if (random_op == 3)  //predecesor pt numar random din valori
            {
                i64 val = arbore_fake.GetRandomElement();
                if (val == arbore_fake.Min())
                    continue;
                expected = arbore_fake.Predecesor(val);
                obtained = arbore.Predecesor(val);
            }
            else if (random_op == 4)  //k_element pentru o pozitie random din valori
            {
                int poz = rnd() % arbore_fake.valori.size() + 1;
                expected = arbore_fake.k_element(poz);
                obtained = arbore.k_element(poz);
            }
            else if (random_op == 5)  //cardinal
            {
                expected = arbore_fake.Cardinal();
                obtained = arbore.Cardinal();
            }
            else
            {
                // Dam ceva ce exista.
                if (rnd() % 2)  //este in cand dam un numar random dar care exista
                {
                    i64 val = arbore_fake.GetRandomElement();
                    expected = arbore_fake.EsteIn(val);
                    obtained = arbore.EsteIn(val);
                }
                else
                {
                    // Dam ceva probabil ce nu exista.
                    i64 val = rnd();
                    expected = arbore_fake.EsteIn(val);
                    obtained = arbore.EsteIn(val);
                }
            }

            cerr << "Am pus intrebare de tipul " << random_op
                 << ", ma asteptam la " << expected << " si am primit "
                 << obtained << "\n";

            if (expected != obtained)
            {
                cout << "Expected " << expected << " but got " << obtained
                     << " for operation " << random_op << "!\n";
                cout << "State of the fake tree: { ";
                for (auto i : arbore_fake.valori)
                    cout << i << ' ';
                cout << "}\n";
                return;
            }

            NR_OP--;
        }
    }
    cout << "OK!\n";
    auto timp_final = chrono::high_resolution_clock::now();
    cout<< (timp_final - timp_inceput).count() / 1e9<<"\n\n";//il transformam in secunde
}

/**
 * Prima linie: Nr de operatii
 * Urmatoarele linii:
 *
 * + x -> Insert(x)
 * - x -> Delete(x)
 * min -> Min()
 * max -> Max()
 * > x -> Succesor()
 * < x -> Predecesor()
 * ! K -> k_element()
 * Card -> Cardinal()
 * ? x -> EsteIn()
 *
 * Intoarce timpul necesar.
 */
double ComputeOutput(string input, string output)
{
    auto timp_inceput = chrono::high_resolution_clock::now();
    ifstream in(input);
    ofstream out(output);

    ArboreEchilibrat ds;

    int nr_op;
    in >> nr_op;

    while (nr_op--)
    {
        string op;
        in >> op;
        if (op == "+")  //inserare
        {
            i64 x;
            in >> x;
            ds.Insereaza(x);
            out<<"\nAm inserat valoarea: "<<x<<endl;
        }
        if (op == "-")  //delete
        {
            i64 x;
            in >> x;
            ds.Sterge(x);
            out<<"\nAm sters valoarea: "<<x<<endl;

        }
        if(op=="min")
        {
            out<<"\nValoarea minima: "<<ds.Min()<<endl;
        }
        if(op=="max")
        {
            out<<"\nValoarea maxima: "<<ds.Max()<<endl;
        }
        if(op==">")
        {
            i64 x;
            in >> x;
            out<<"\nSuccesorul lui "<<x<<" este "<<ds.Succesor(x);
        }
        if(op=="<")
        {
            i64 x;
            in >> x;
            out<<"\nPredecesorul lui "<<x<<" este "<<ds.Predecesor(x);
        }
        if(op=="!")
        {
            int k;
            in >> k;
            out<<"\nAl "<<k<<"-lea element minim este:"<<ds.k_element(k);

        }
        if(op=="Card")
        {
            out<<"\nCardinalul este: "<<ds.Cardinal();
        }
        if (op == "?")
        {
            i64 x;
            in >> x;
            out <<"\nValoarea "<<x <<" este in treap [0:nu / 1:da] "<<ds.EsteIn(x) << '\n';
        }
    }

    auto timp_final = chrono::high_resolution_clock::now();
    return (timp_final - timp_inceput).count() / 1e9;//il transformam in secunde
}

int main()
{
    for (int i = 0; i <= 1; i++) //acest test ofera posibilitatea sa se observe faptul ca putem adauga numere mari de tipul: 972788155321194609 sau -949314519530419175
    {
      cout << "Test #" << i << ": ";
       GenerateRandomTest(200);
    }
    /*for (int i = 0; i <= 10; i++) //test folosit pentru a vedea cat ii ia programului sa faca inserari
    {
        cout << "Test #" << i << ": ";
        InserareRandom(200);
    }*/

    /*for (int i = 0; i <= 1; i++)//test folosit pentru a vedea cat ii ia programului sa faca inserari respectiv stergeri per operatie
     {
         cout << "Test #" << i << ": ";
         InserareStergere(50);
     }*/

    /*for (int i = 0; i <= 1; i++) //test folosit pentru a vedea cat ii ia programului sa faca inserari respectiv minim per operatie
     {
         cout << "Test #" << i << ": ";
         InserareMin(50);
     }*/

    /*for (int i = 0; i <= 1; i++) //test folosit pentru a vedea cat ii ia programului sa faca inserari respectiv maxim per operatie
     {
         cout << "Test #" << i << ": ";
         InserareMax(50);
     }*/

    /* for (int i = 0; i <= 1; i++) //test folosit pentru a vedea cat ii ia programului sa faca inserari respectiv succesor per operatie
      {
          cout << "Test #" << i << ": ";
          InserareSuccesor(50);
      }*/

    /*for (int i = 0; i <= 1; i++) //test folosit pentru a vedea cat ii ia programului sa faca inserari respectiv predecesor per operatie
      {
          cout << "Test #" << i << ": ";
          InserarePredecesor(50);
      }*/

    /*for (int i = 0; i <= 1; i++) //test folosit pentru a vedea cat ii ia programului sa faca inserari respectiv k_element per operatie
     {
         cout << "Test #" << i << ": ";
         InserareK_element(50);
     }*/

    /*for (int i = 0; i <= 1; i++) //test folosit pentru a vedea cat ii ia programului sa faca inserari respectiv cardinalul per operatie
      {
          cout << "Test #" << i << ": ";
          InserareCardinal(50);
      }*/

    /*for (int i = 0; i <= 1; i++)
    {
          cout << "Test #" << i << ": ";
          InserareCautare(50);
    }*/

    //cout<<ComputeOutput("date1.in","date1.out")<<endl;
    //cout<<ComputeOutput("date2.in","date2.out")<<endl;//incercam sa introducem aceeasi valoare
    //cout<<ComputeOutput("date3.in","date3.out")<<endl;
    //cout<<ComputeOutput("date4.in","date4.out")<<endl;//caz cu valori minime pozitive
    //cout<<ComputeOutput("date5.in","date5.out")<<endl;//valori mai mari
    //cout<<ComputeOutput("date6.in","date6.out")<<endl;//daca sterg ceva ce nu este in arbore nu imi modifica cu nimic structura de date
    /**
      *  Urmatoarele teste se decomenteaza unul cate unul
      *   (se decomenteaza unul apoi se comenteaza la loc si dupa se decomenteaza urmatorul si tot asa)
      */
    //cout<<ComputeOutput("date7.in","date7.out")<<endl;//test in care se cere sa se afiseze un element de pe o pozitie care nu exista-- arunca o exceptie pentru a opri programul
    //cout<<ComputeOutput("date8.in","date8.out")<<endl;//cer succesorul unui element care nu exista si arunc o exceptie  pentru a opri programul" Get order of inexistent element!"
    return 0;
}

