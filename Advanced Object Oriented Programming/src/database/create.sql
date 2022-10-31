CREATE TABLE `proiectpao`.`persoana` (
  `id_persoana` INT NOT NULL AUTO_INCREMENT,
  `nume` VARCHAR(50) NOT NULL,
  `prenume` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_persoana`));

CREATE TABLE `proiectpao`.`categorie` (
  `id_categorie` INT NOT NULL,
  `denumire` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`id_categorie`));

CREATE TABLE `proiectpao`.`autor` (
  `id_autor` INT NOT NULL AUTO_INCREMENT,
  `nume` VARCHAR(50) NOT NULL,
  `prenume` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_autor`));

CREATE TABLE `proiectpao`.`cititor` (
  `id_cititor` INT NOT NULL AUTO_INCREMENT,
  `nume` VARCHAR(50) NOT NULL,
  `prenume` VARCHAR(100) NOT NULL,
  `data_inscriere` DATE NOT NULL,
  PRIMARY KEY (`id_cititor`));

CREATE TABLE `proiectpao`.`student` (
  `id_student` INT NOT NULL AUTO_INCREMENT,
  `nume` VARCHAR(50) NOT NULL,
  `prenume` VARCHAR(100) NOT NULL,
  `data_inscriere` DATE NOT NULL,
  `facultate` VARCHAR(50) NULL DEFAULT '\"Facultate\"',
  PRIMARY KEY (`id_student`));

CREATE TABLE `proiectpao`.`carte` (
  `id_carte` INT NOT NULL AUTO_INCREMENT,
  `titlu` VARCHAR(45) NOT NULL,
  `id_autor` INT NULL DEFAULT NULL,
  `nr_pagini` INT NULL DEFAULT NULL,
  `id_categorie` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_carte`),
  INDEX `carte_fk_autor_idx` (`id_autor` ASC) INVISIBLE,
  INDEX `carte_fk_categorie_idx` (`id_categorie` ASC) VISIBLE,
  CONSTRAINT `carte_fk_autor`
    FOREIGN KEY (`id_autor`)
    REFERENCES `proiectpao`.`autor` (`id_autor`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `carte_fk_categorie`
    FOREIGN KEY (`id_categorie`)
    REFERENCES `proiectpao`.`categorie` (`id_categorie`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);

CREATE TABLE `proiectpao`.`carte_audio` (
  `id_carte_audio` INT NOT NULL AUTO_INCREMENT,
  `titlu` VARCHAR(45) NOT NULL,
  `id_autor` INT NULL DEFAULT NULL,
  `nr_pagini` INT NULL DEFAULT 0,
  `id_categorie` INT NULL DEFAULT NULL,
  `durata` VARCHAR(45) NULL DEFAULT '\"0 min\"',
  PRIMARY KEY (`id_carte_audio`),
  INDEX `carteaudio_fk_autor_idx` (`id_autor` ASC) VISIBLE,
  INDEX `carteaudio_fk_categorie_idx` (`id_categorie` ASC) VISIBLE,
  CONSTRAINT `carteaudio_fk_autor`
    FOREIGN KEY (`id_autor`)
    REFERENCES `proiectpao`.`autor` (`id_autor`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `carteaudio_fk_categorie`
    FOREIGN KEY (`id_categorie`)
    REFERENCES `proiectpao`.`categorie` (`id_categorie`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);
