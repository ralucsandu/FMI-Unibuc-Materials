import matplotlib.pyplot as plt
from sklearn.datasets import make_classification
from sklearn.metrics import plot_confusion_matrix,ConfusionMatrixDisplay
from sklearn.model_selection import train_test_split
import numpy as np
import matplotlib.image as mpimg
from sklearn import svm
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler, Normalizer
from sklearn import preprocessing
from sklearn.metrics import f1_score, accuracy_score, confusion_matrix, ConfusionMatrixDisplay
import csv
from sklearn.model_selection import GridSearchCV

iduri_antrenare = []  #vector care va contine denumirile datelor de antrenare(id-urile)
categorii_antrenare = []  #vector care va contine etichetele categoriilor

with open('train.txt') as f1:
    next(f1) #sar prima linie
    for linie in f1.readlines():
        id_imagine, categorie_imagine = linie.split(',')
        imagine_curenta = mpimg.imread('./train+validation/' + id_imagine) #asa incarcam imaginile
        iduri_antrenare.append(imagine_curenta)  #adaug imaginea in vector
        categorii_antrenare.append(int(categorie_imagine[0]))  #adaug categoria imaginii in vector

iduri_antrenare = np.array(iduri_antrenare) #transform imaginile in numpy array, iar apoi redimensionez array-ul din 4-dimensional in 2-dimensional; daca nu as fi facut asta primeam eroare
iduri_antrenare = iduri_antrenare.flatten().reshape(8000, 768) #768 = 16*16*3

iduri_testare = []

with open('test.txt') as f2:
    next(f2)
    for linie in f2.readlines():
        id_imagine = linie.strip('\n')
        imagine_curenta = mpimg.imread('./test/' + id_imagine)
        iduri_testare.append(imagine_curenta) #analog cu mai sus

iduri_testare = np.array(iduri_testare) #analog cu mai sus, #transform imaginile in numpy array, iar apoi redimensionez array-ul din 4-dimensional in 2-dimensional; daca nu as fi facut asta primeam eroare
iduri_testare = iduri_testare.flatten().reshape(2819, 768) #2819 este numarul de date de testare din fisierul .txt

iduri_validare = []
categorii_validare = []

with open('validation.txt') as f3:
    next(f3)
    for linie in f3.readlines():
        id_imagine, categorie_imagine = linie.split(',')
        imagine_curenta = mpimg.imread('./train+validation/' + id_imagine)
        iduri_validare.append(imagine_curenta)
        categorii_validare.append(int(categorie_imagine[0]))

iduri_validare = np.array(iduri_validare)
categorii_validare = np.array(categorii_validare)

iduri_validare = iduri_validare.flatten().reshape(1173, 768)

def functie_de_normalizare(date_de_antrenare, date_de_testare, date_de_validare,
                           tip_de_normalizare=None):  # functia de normalizare, cu cele trei norme posibile. sursa de inspiratie: laboratorul
    if tip_de_normalizare == 'standard':
        parametru_de_scalare = StandardScaler()
        parametru_de_scalare.fit(date_de_antrenare)
        date_de_antrenare = parametru_de_scalare.transform(date_de_antrenare)
        date_de_testare = parametru_de_scalare.transform(date_de_testare)
        date_de_validare = parametru_de_scalare.transform(date_de_validare)

    elif tip_de_normalizare == 'l1':
        normalizator = Normalizer(norm='l1')
        date_de_antrenare = normalizator.transform(date_de_antrenare)
        date_de_testare = normalizator.transform(date_de_testare)
        date_de_validare = normalizator.transform(date_de_validare)

    elif tip_de_normalizare == 'l2':
        normalizator = Normalizer(norm='l2')
        date_de_antrenare = normalizator.transform(date_de_antrenare)
        date_de_testare = normalizator.transform(date_de_testare)
        date_de_validare = normalizator.transform(date_de_validare)

    return date_de_antrenare, date_de_testare, date_de_validare

antrenare_scalata, testare_scalata, validare_scalata = functie_de_normalizare(iduri_antrenare, iduri_testare, iduri_validare, tip_de_normalizare='standard')
model_svm = svm.SVC(C = 5, kernel = "rbf") #creez modelul
model_svm.fit(antrenare_scalata, categorii_antrenare) #antrenez modelul
labeluri_prezise = model_svm.predict(testare_scalata) #fac predictiile
labeluri_validare_prezise = model_svm.predict(validare_scalata)

print(accuracy_score(labeluri_validare_prezise, categorii_validare))

antrenare_scalata, testare_scalata, validare_scalata = functie_de_normalizare(iduri_antrenare, iduri_testare, iduri_validare, tip_de_normalizare='l2') #normalizez datele
model_svm = svm.SVC(C = 1, kernel = "linear")
model_svm.fit(antrenare_scalata, categorii_antrenare)
labeluri_prezise = model_svm.predict(testare_scalata)
labeluri_validare_prezise = model_svm.predict(validare_scalata)

print(accuracy_score(labeluri_validare_prezise, categorii_validare))

g = open('svm_1apr.txt', 'w')
g.write("id,label\n")
indice = 0
with open('test.txt', 'r') as f:
    next(f)
    lines = f.readlines()
    print(lines[-1].strip())
    for i in lines:
        g.write(f"{i.strip()},{labeluri_prezise[indice]}\n")
        indice += 1
g.close()

#am comentat gridsearch-ul pentru ca dureaza foarte mult sa se ruleze, dar functioneaza :)
# svm_pentru_gridsearch = svm.SVC()  # aici am facut un gridsearch ca sa aflu cea mai buna combinatie de parametri pentru o acuratete cat mai mare
# parametri = {'C': [1, 7.55, 3.5, 2, 10, 6, 4, 5.5], 'kernel': ['rbf', 'linear', 'poly']}
# cv = GridSearchCV(svm_pentru_gridsearch, parametri, verbose=1)
# cv.fit(iduri_antrenare, categorii_antrenare)

confusion_matrix(categorii_validare, labeluri_validare_prezise)
matrice_de_confuzie = confusion_matrix(categorii_validare, labeluri_validare_prezise)
aplic_functie = ConfusionMatrixDisplay(confusion_matrix = matrice_de_confuzie)
aplic_functie.plot()
plt.show()
