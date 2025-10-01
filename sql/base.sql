CREATE DATABASE situationbanque;
USE situationbanque;

-- Table Personne
CREATE TABLE Personne (
    idPersonne INT AUTO_INCREMENT PRIMARY KEY,
    Nom VARCHAR(50) NOT NULL,
    Prenom VARCHAR(50),
    Adresse VARCHAR(100),
    DateDeNaissance DATE NOT NULL,
    CIN VARCHAR(20) UNIQUE,
    Coordonnees VARCHAR(100)
);

-- Table Client
CREATE TABLE Client (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    numeroClient VARCHAR(20) UNIQUE NOT NULL,
    idPersonne INT NOT NULL,
    FOREIGN KEY (idPersonne) REFERENCES Personne (idPersonne)
);

-- Table TypeCompte
CREATE TABLE TypeCompte (
    idTypeCompte INT AUTO_INCREMENT PRIMARY KEY,
    codeType VARCHAR(20) UNIQUE NOT NULL, -- ex: COURANT, DEPOT, EPARGNE, PRET
    description VARCHAR(100)
);

-- Table TypeOperation
CREATE TABLE TypeOperation (
    idTypeOperation INT AUTO_INCREMENT PRIMARY KEY,
    codeOperation VARCHAR(20) UNIQUE NOT NULL, -- ex: DEPOT, RETRAIT, REMBOURSEMENT, INTERET
    description VARCHAR(100)
);

-- Table Taux
CREATE TABLE Taux (
    idTaux INT AUTO_INCREMENT PRIMARY KEY,
    taux DECIMAL(5,4) NOT NULL,
    dateChangementTaux DATE NOT NULL,
    idTypeCompte INT NOT NULL,
    FOREIGN KEY (idTypeCompte) REFERENCES TypeCompte (idTypeCompte)
);

-- Table Compte
CREATE TABLE Compte (
    idCompte INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    numeroCompte VARCHAR(20) UNIQUE NOT NULL,
    idTypeCompte INT NOT NULL,
    dateOuverture DATE NOT NULL,
    FOREIGN KEY (idClient) REFERENCES Client (idClient),
    FOREIGN KEY (idTypeCompte) REFERENCES TypeCompte (idTypeCompte)
);

-- Table Operation
CREATE TABLE Operation (
    idOperation INT AUTO_INCREMENT PRIMARY KEY,
    idCompte INT NOT NULL,
    idTypeOperation INT NOT NULL,
    montant DECIMAL(15, 2) NOT NULL,
    dateOperation DATE NOT NULL,
    FOREIGN KEY (idTypeOperation) REFERENCES TypeOperation (idTypeOperation),
    FOREIGN KEY (idCompte) REFERENCES Compte (idCompte)
);

-- Table HistoriqueSolde
CREATE TABLE HistoriqueSolde (
    idHistorique INT AUTO_INCREMENT PRIMARY KEY,
    idCompte INT NOT NULL,
    solde DECIMAL(15, 2) NOT NULL,
    dateChangement DATE NOT NULL,
    FOREIGN KEY (idCompte) REFERENCES Compte (idCompte)
);


-- Table Pret
CREATE TABLE Pret (
    idPret INT AUTO_INCREMENT PRIMARY KEY,
    idCompte INT NOT NULL, -- Compte de type 'pret'
    montant DECIMAL(15, 2) NOT NULL CHECK (montant > 0),
    datePret DATE NOT NULL,
    dureeMois INT NOT NULL CHECK (dureeMois > 0),
    FOREIGN KEY (idCompte) REFERENCES Compte (idCompte)
);

-- Table Remboursement
CREATE TABLE Remboursement (
    idRemboursement INT AUTO_INCREMENT PRIMARY KEY,
    idPret INT NOT NULL,
    montant DECIMAL(15, 2) NOT NULL CHECK (montant > 0),
    dateRemboursement DATE NOT NULL,
    FOREIGN KEY (idPret) REFERENCES Pret (idPret)
);
