import sys
def get_section(name, lista): #se parcurge lista 
    flag = False
    l_ret = []

    for line in lista:
        if line.lower() == name.lower():
            flag = True
            continue
        if line.lower() == "end":
            flag = False
        if flag == True:
            l_ret.append(line)

    return l_ret

def load_config_file(file_name): #se introduce fisierul si se verifica existenta campurilor
    full_list=[]
    f=open(file_name)
    for line in f:
        line=line.strip()
        if len(line)>0:
            full_list.append(line)
    variables= get_section("Variabile:", full_list)
    terminals= get_section("Terminali:", full_list)
    relations= get_section("Relatii:", full_list)

    ok=True
    for v in variables:
        if v < 'A' or v >'Z':#daca variabila nu este litera mare
            ok = False
    if ok == False:
        print("Este o problema la variables")
    else:
        for t in terminals:
            if t >='A' and t <='Z':# daca terminalii nu sunt litere mici
                ok=False
        if ok==False:
            print("Este o problema la terminali")
        else:
            l_relations=[]#vectorii pentru relatii
            for x in relations:
                y=x.split(",")#separam variabila de partea dreapta a regulii
                l_relations.append([y[0], y[1]])
                if y[0] not in variables:
                    print(f"({y[0]},{y[1]}) nu este o relatie")
                    ok=False
                else:
                    for letter in y[1]:
                        if letter not in variables:
                            if letter not in terminals:
                                 print(f"({y[0]},{y[1]}) nu este o relatie")
                                 ok = False
            relations=l_relations

    return variables, terminals, relations, ok

#se genereaza cuvintele gramaticii pentru o lungime data
multime = set()
CuvInainte = set()
def generate_words(variabilele, terminalele, regulile, cuvantul, lungime):
    gasire = False


    #stabilim un numar maxim pentru lungimea unui cuvant astfel incat sa nu avem bucla infinita la functia recursiva
    if len(cuvantul) >= 10:
        return


    # in cazul in care cuvantul care se genereaza a mai fost generat atunci se va trece peste el
    # altfel, daca nu a mai fost generat atunci se adauga in set-ul pentru cuvintele deja generate
    if cuvantul in CuvInainte:
        return
    CuvInainte.add(cuvantul)
    #se verifica daca mai sunt variabile de parcurs, daca nu, atunci daca cuvantul
    # are lungimea corespunzatoare se va retine
    for caracter in cuvantul:
        if caracter in variabilele:
            gasire = True
            var = caracter
            break
    if not gasire:
        if len(cuvantul) <= lungime:
            multime.add(cuvantul)
        return

    # se parcurge fiecare regula in parte si se inlocuieste variabila curenta
    for reg in regulile:
        if reg[0] == var:
            if reg[1] == '*':#final
                generate_words(variabilele, terminalele, regulile, cuvantul.replace(reg[0], '', 1), lungime)
            else:
                generate_words(variabilele, terminalele, regulile, cuvantul.replace(reg[0], reg[1], 1), lungime)



list1, list2, list3, code = load_config_file(sys.argv[1])
lungime = 10
generate_words(list1, list2, list3, "A", lungime)
print(multime)


'''variabile, terminali, relatii, ok = load_config_file(sys.argv[1]) #a se decomenta cand se comenteaza liniile 97-100 
print(f"Variabile: {variabile}")
print(f"Terminali: {terminali}")
print(f"relatii: {relatii}")
if ok == True:
    print("Fisierul contine un grammar!")
else:
    print("nu contine grammar")'''