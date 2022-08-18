import tensorflow as tf
import seaborn as sns
import keras
from sklearn.datasets import make_classification
from sklearn.metrics import plot_confusion_matrix, ConfusionMatrixDisplay
from keras.models import Sequential
from keras.layers import Dense, Conv2D , MaxPool2D , Flatten , Dropout
from keras.preprocessing.image import ImageDataGenerator
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
import cv2

model_transfer = tf.keras.applications.EfficientNetV2M(weights = 'imagenet', include_top = False)

#am folosit un model preantrenat pe setul de imagini imagenet,
#include_top e parametrul prin care aleg sa nu includ fully-connected layer-ul de la finalul network-ului

#model_transfer.summary() #asa vad toate layerele modelului

output_preantrenat = model_transfer.get_layer('block3b_add')  # primele layere sunt cele care extrag features mai generale(detecteaza linii, forme), de aceea
                                                             # nu vrem sa le antrenam din nou; vom taia practic modelul de la layerul selectat
                                                             # din model_transfer transferam
                                                             # output_preantrenat reprezinta outputul din model_transfer la layerul selectat

frozen_model = tf.keras.Model(inputs = model_transfer.input, outputs = output_preantrenat.output) # fac un nou model, care sa aiba inputul la fel ca modelul mare, iar outputul la fel ca output_preantrenat
inputs = tf.keras.layers.Input(shape=(16,16,3)) # imaginile mele au dimensiunile 16x16
x = frozen_model(inputs)
#adaug layere convolutionale; he_normal() reprezinta un tip de initializare pentru weight-uri
x = tf.keras.layers.Conv2D(32, (2, 2), padding='same', activation='relu', kernel_initializer=tf.keras.initializers.he_normal())(x)
x = tf.keras.layers.Conv2D(64, (2, 2), padding='same', activation='relu', kernel_initializer=tf.keras.initializers.he_normal())(x)
x = tf.keras.layers.Conv2D(128, (2, 2), padding='same', activation='relu', kernel_initializer=tf.keras.initializers.he_normal())(x)
x = Dense(128, activation="relu")(x)
x = tf.keras.layers.Dropout(0.8)(x) #Dropout e util pentru a ne scapa de overfitting
gap = tf.keras.layers.GlobalAveragePooling2D()(x)
outputs = Dense(7, activation="softmax")(gap) #softmax practic transforma predictiile in probabilitati

model_transfer_invata = tf.keras.Model(inputs = inputs, outputs = outputs) # asta e practic modelul nou

model_transfer_invata.summary()

optimizator = tf.keras.optimizers.Adam(learning_rate=0.001)
model_transfer_invata.compile(loss = tf.keras.losses.SparseCategoricalCrossentropy(from_logits = False), optimizer = optimizator, metrics=['accuracy'])
                                        #folosim aceasta functie de loss pentru ca avem 7 categorii de poze

class GeneratorDeDate(tf.keras.utils.Sequence):  # clasa utila pentru a face lazy loading

    def __init__(self, folder_poze, dimensiune_batch, input_shape, nr_clase, nume_fisiere,
                 shuffle=True):  # folder_poze reprezinta locul de unde luam pozele
        self.input_shape = input_shape
        self.dimensiune_batch = dimensiune_batch
        self.nr_clase = nr_clase
        self.shuffle = shuffle
        self.folder_poze = folder_poze
        self.nume_fisiere = nume_fisiere
        self.iduri_poze, self.categorii_poze = self.preia_date(folder_poze)
        self.indici = np.arange(len(self.iduri_poze))
        self.final_de_epoca()

    def preia_date(self, folder_root):
        # incarca caile catre imagini si etichetele corespunzatoare din folderul folder_poze
        self.iduri_poze = []
        self.categorii_poze = []
        with open(self.nume_fisiere, 'r') as f:
            for linie in f.readlines()[1:]:
                splitted = linie.split(',')
                self.iduri_poze.append("./{0}/".format(folder_root) + splitted[0])
                self.categorii_poze.append(int(splitted[1]))
        return self.iduri_poze, self.categorii_poze  # iduri_poze va contine imaginile, iar categorii_poze va contine etichetele imaginilor

    def __len__(self):  # returneaza numarul de batch-uri per epoca : dimensiunea setului de date impartit la dimensiune batch-ului;
        # dimensiune_batch reprezinta practic numarul de poze pe care le proceseaza modelul intr-o tura
        return int(np.floor(len(self.iduri_poze) / self.dimensiune_batch))

    def __getitem__(self, index):
        # ia niste indici si pentru fiecare index deschide imaginea, o citeste si o transforma in RGB; ia de asemenea si label-ul imaginii
        batch_indices = self.indici[index * self.dimensiune_batch: (index + 1) * self.dimensiune_batch]
        batch_x = [cv2.cvtColor(cv2.imread(self.iduri_poze[index]), cv2.COLOR_BGR2RGB) for index in batch_indices]
        batch_y = [self.categorii_poze[index] for index in batch_indices]
        return np.array(batch_x), np.array(batch_y)

    def final_de_epoca(self):
        # da shuffle de la finalul fiecarei epoci la indici pentru a nu citi aceiasi indici de fiecare data;
        # conteaza pentru antrenarea mai bine a modelului
        self.indici = np.arange(len(self.iduri_poze))
        if self.shuffle:
            np.random.shuffle(self.indici)

validare = GeneratorDeDate("train+validation", 32, (16,16,3), 7, "validation.txt", shuffle=True)

(iduri_antrenare, categorii_antrenare) = [], []

with open('train.txt') as f1:
    next(f1)
    for linie in f1.readlines():
        id_imagine, categorie_imagine = linie.split(',')
        imagine_curenta = cv2.cvtColor(cv2.imread('./train+validation/' + id_imagine), cv2.COLOR_BGR2RGB)
        iduri_antrenare.append(imagine_curenta)
        categorii_antrenare.append(int(categorie_imagine[0]))

iduri_antrenare = np.array(iduri_antrenare)
categorii_antrenare = np.array(categorii_antrenare)

#aici am incercat o mica augumentare de date, dar nu a prea mers din cauza ca imaginile sunt atat de mici
aug_date = ImageDataGenerator(
    rotation_range=10,
    horizontal_flip=True)
aug_date.fit(iduri_antrenare)

#aici practic pun un checkpoint ca sa retin cea mai mare acuratete
checkpoint_pe_model = tf.keras.callbacks.ModelCheckpoint(
    filepath = 'C:/Users/Raluca/Pictures/proiect_kaggle' + '/checkpoint_maxim',
    save_weights_only = True,
    monitor = 'val_accuracy',
    mode = 'max',
    save_best_only = True)

model_transfer_invata.fit(aug_date.flow(iduri_antrenare, categorii_antrenare, batch_size = 512), callbacks = [checkpoint_pe_model],shuffle = True,
                            epochs = 50, validation_data = validare, verbose = 1)

model_transfer_invata.load_weights('C:/Users/Raluca/Pictures/proiect_kaggle' + '/checkpoint_maxim') #salvez acuratetea maxima

with open('test.txt', 'r') as f:
    next(f)
    linii = f.readlines()
    test_set = [cv2.cvtColor(cv2.imread('./test/' + file.strip()), cv2.COLOR_BGR2RGB) for file in linii]

test_set = np.array(test_set)

labeluri_prezise = model_transfer_invata.predict(test_set)

labeluri_prezise = np.argmax(labeluri_prezise, 1)
print(labeluri_prezise.shape)

g = open('1_apr_2.csv', 'w')
g.write("id,label\n")
index = 0
with open('test.txt', 'r') as f:
    next(f)
    linii = f.readlines()
    print(linii[-1].strip())
    for i in linii:
        g.write(f"{i.strip()},{labeluri_prezise[index]}\n")
        index += 1

(iduri_validare, categorii_validare) = [], []

with open('validation.txt') as f1:
    next(f1)
    for linie in f1.readlines():
        id_imagine, categorie_imagine = linie.split(',')
        imagine_curenta = cv2.cvtColor(cv2.imread('./train+validation/' + id_imagine), cv2.COLOR_BGR2RGB)
        iduri_validare.append(imagine_curenta)
        categorii_validare.append(int(categorie_imagine[0]))

iduri_validare = np.array(iduri_validare)
categorii_validare = np.array(categorii_validare)

labeluri_validare_prezise = model_transfer_invata.predict(iduri_validare)

matrice_de_confuzie = confusion_matrix(categorii_validare, labeluri_validare_prezise.argmax(axis=1))
aplic_functie = ConfusionMatrixDisplay(confusion_matrix = matrice_de_confuzie)
aplic_functie.plot()

plt.show()

