import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
import cv2

from tensorflow.keras.layers import *
from tensorflow.keras.initializers import he_normal
from tensorflow.keras.activations import softmax, sigmoid

from tensorflow.keras.optimizers import SGD, Adam
from tensorflow.keras import Model
from tensorflow.keras.losses import SparseCategoricalCrossentropy
from tensorflow.keras.optimizers import *

from sklearn.metrics import plot_confusion_matrix, ConfusionMatrixDisplay,confusion_matrix

class GeneratorDeDate(tf.keras.utils.Sequence):  # clasa folosita pentru gestionarea datelor si pentru lazy loading
    def __init__(self, folder_poze, dimensiune_batch, input_shape, nr_clase, nume_fisiere=None, lista_nume_fisiere=None,
                 # folder_poze reprezinta locul de unde luam pozele
                 shuffle=True):
        self.input_shape = input_shape
        self.dimensiune_batch = dimensiune_batch
        self.nr_clase = nr_clase
        self.shuffle = shuffle
        self.folder_poze = folder_poze
        self.nume_fisiere = nume_fisiere
        self.lista_nume_fisiere = lista_nume_fisiere
        self.iduri_poze, self.categorii_poze = self.preia_date(folder_poze)
        self.indici = np.arange(len(self.iduri_poze))
        if dimensiune_batch is None:
            self.dimensiune_batch = len(self.iduri_poze)
        self.final_de_epoca()

    def preia_date(self, root_dir):
        # incarca caile catre imagini si etichetele corespunzatoare din folderul folder_poze
        self.iduri_poze = []
        self.categorii_poze = []
        if self.lista_nume_fisiere is None:
            with open(self.nume_fisiere, 'r') as f:
                for linie in f.readlines()[1:]:
                    splitted = linie.split(',')
                    self.iduri_poze.append(f'./{root_dir}/' + splitted[0])
                    self.categorii_poze.append(int(splitted[1]))
            return self.iduri_poze, self.categorii_poze
        for filename, label in self.lista_nume_fisiere:
            self.iduri_poze.append(f'./{root_dir}/' + filename)
            self.categorii_poze.append(int(label))
        return self.iduri_poze, self.categorii_poze  # iduri_poze va contine imaginile, iar categorii_poze va contine etichetele imaginilor

    def __len__(self):
        return int(np.floor(len(self.iduri_poze) / self.dimensiune_batch))
        # returneaza numarul de batch-uri per epoca : dimensiunea setului de date impartit la dimensiune batch-ului;
        # dimensiune_batch reprezinta practic numarul de poze pe care le proceseaza modelul intr-o epoca

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

def res_block(inputs, filters):
    x = Conv2D(filters, 3, padding='same', activation='relu', kernel_regularizer=tf.keras.regularizers.l2(0.002))(inputs)
    #scopul regularizarii este sa faca functia mai "plata", adica sa nu aiba atat de multa variatie
    x = tf.keras.layers.Dropout(.5)(x) #jumatate din output va fi transformat in zero-uri, in mod aleator; functia de dropout minimizeaza overfittingul
    x = tf.keras.layers.BatchNormalization()(x) #tehnica folosita pentru a antrena retelele neuronale,
                                                #avand ca scop "usurarea" procesului de invatare si reducerea numarului
                                                #de epoci necesare pentru a antrena modelul
    x = Conv2D(filters, 3, padding = 'same', activation = 'relu', kernel_regularizer = tf.keras.regularizers.l2(0.002))(x)
    x = tf.keras.layers.Dropout(.5)(x)
    x = tf.keras.layers.BatchNormalization()(x)
    return x + inputs

#am incercat sa fac acest model dupa arhitectura de la ResNet, adica cu 3 blocuri reziduale, skip connections din 2 in 2 layere
#si layerele finale de tip dense

inputs = Input(shape = (16, 16, 3))

x = Conv2D(64, 3, padding = 'same', activation = 'relu', kernel_regularizer = tf.keras.regularizers.l2(0.002))(inputs)
x = tf.keras.layers.Dropout(.3)(x)

first = res_block(x, 64)
first = tf.keras.layers.BatchNormalization()(first)

pool_1 = MaxPooling2D()(first)
pool_1 = Conv2D(128, 3, padding = 'same', activation = 'relu', kernel_regularizer = tf.keras.regularizers.l2(0.002))(pool_1)
pool_1 = tf.keras.layers.Dropout(.3)(pool_1)

second = res_block(pool_1, 128)
second = tf.keras.layers.BatchNormalization()(second)

pool_2 = MaxPooling2D()(second)
pool_2 = Conv2D(256, 3, padding = 'same', activation = 'relu', kernel_regularizer = tf.keras.regularizers.l2(0.002))(pool_2)
pool_2 = tf.keras.layers.Dropout(.3)(pool_2)

third = res_block(pool_2, 256)
gap = tf.keras.layers.Flatten()(third)

x = Dense(512, activation = sigmoid, kernel_regularizer = tf.keras.regularizers.l2(0.002))(gap)
x = tf.keras.layers.Dropout(0.2)(x)
x = Dense(128, activation = sigmoid, kernel_regularizer = tf.keras.regularizers.l2(0.002))(x)
x = tf.keras.layers.Dropout(0.2)(x)
x = Dense(32, activation = sigmoid, kernel_regularizer = tf.keras.regularizers.l2(0.002))(x)
x = tf.keras.layers.Dropout(0.2)(x)

outputs = Dense(7, activation = softmax, kernel_regularizer = tf.keras.regularizers.l2(0.002))(x)

model = Model(inputs = inputs, outputs = outputs)

#model.summary()

learning_rate = tf.keras.callbacks.LearningRateScheduler(lambda epoch, lr: 1e-3 * (0.98 ** epoch), verbose = 0)

opt = Adam(learning_rate=0.003) #am ales optimizatorul Adam, deoarece testand si ceilalti optimizatori am ajuns la concluzia ca este cel mai bun

model.compile(  #compilez modelul
    loss = SparseCategoricalCrossentropy(), #categorical cross entropy compara eticheta reala cu cea prezisa si calculeaza pierderea
    optimizer = opt,
    metrics = ['accuracy']
)

with open('train.txt') as f:
    next(f)
    train_filenames = [linie.strip().split(',') for linie in f.readlines()]

with open('validation.txt') as f:
    next(f)
    lines = f.readlines()
    split = 100  # aici incercasem sa pun mai multe date in setul de antrenare, adica practic in loc de train = train si validation = validation,
    # voiam sa iau doar 100 de date din validation, iar pe restul sa le pun in setul de antrenare
    train_filenames.extend([linie.strip().split(',') for linie in lines[split:]])
    validation_filenames = [linie.strip().split(',') for linie in lines[:split]]

train = GeneratorDeDate("train+validation", 256, (16, 16, 3), 7, lista_nume_fisiere=train_filenames, shuffle=True)
validation = GeneratorDeDate("train+validation", 32, (16, 16, 3), 7, lista_nume_fisiere=validation_filenames)
train_real = GeneratorDeDate("train+validation", 256, (16, 16, 3), 7, nume_fisiere="train.txt", shuffle=True)
validation_real = GeneratorDeDate("train+validation", 128, (16, 16, 3), 7, nume_fisiere="validation.txt")

model_checkpoint_callback = tf.keras.callbacks.ModelCheckpoint(
    filepath = './checkpoint_maxim',
    save_weights_only = True,
    monitor = 'val_accuracy',
    mode = 'max',
    save_best_only = True)

history = model.fit(train_real, callbacks=[model_checkpoint_callback, learning_rate],
                            epochs = 50, validation_data = validation_real, verbose = 1)

with open('test.txt', 'r') as f:
    next(f)
    lines = f.readlines()
    test_set = [cv2.cvtColor(cv2.imread('./test/' + file.strip()), cv2.COLOR_BGR2RGB) for file in lines]
test_set = np.array(test_set)

labeluri_prezise = model.predict(test_set)

labeluri_prezise = np.argmax(labeluri_prezise, 1)
print(labeluri_prezise.shape)

g = open('resnet_try.csv', 'w')
g.write("id,label\n")
index = 0
with open('test.txt', 'r') as f:
    next(f)
    lines = f.readlines()
    print(lines[-1].strip())
    for i in lines:
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

labeluri_validare_prezise = model.predict(iduri_validare)

matrice_de_confuzie = confusion_matrix(categorii_validare, labeluri_validare_prezise.argmax(axis=1))
aplic_functie = ConfusionMatrixDisplay(confusion_matrix = matrice_de_confuzie)
aplic_functie.plot()
plt.show()