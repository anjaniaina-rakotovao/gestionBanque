INSERT INTO TypeCompte (codeType, description) VALUES
('DEPOT', 'Compte dépôt / épargne'),
('PRET', 'Compte dédié aux prêts'),
('COURANT', 'Compte courant classique');


INSERT INTO TypeOperation (codeOperation, description) VALUES
('CREDIT', 'Opération crédit'),
('DEBIT', 'Opération débit'),
('DEPOT', 'Dépôt sur compte'),
('RETRAIT', 'Retrait sur compte'),
('REMBOURSEMENT', 'Remboursement de prêt');


INSERT INTO Taux (taux, dateChangementTaux, idTypeCompte) VALUES
(5.0, '2025-09-30', (SELECT idTypeCompte FROM TypeCompte WHERE codeType = 'DEPOT')),
(2.0, '2025-09-30', (SELECT idTypeCompte FROM TypeCompte WHERE codeType = 'PRET'));

INSERT INTO Personne (Nom, Prenom, Adresse, DateDeNaissance, CIN, Coordonnees) VALUES
('Rakotovao', 'Anjaniaina', 'Antananarivo', '1995-05-15', 'CIN12345', '0312345678'),
('Rabe', 'Hery', 'Toamasina', '1990-08-20', 'CIN67890', '0329876543'),
('Andrianarisoa', 'Lala', 'Fianarantsoa', '1985-12-01', 'CIN54321', '0331234567');

INSERT INTO Client (numeroClient, idPersonne) VALUES
('CL001', (SELECT idPersonne FROM Personne WHERE Nom = 'Rakotovao')),
('CL002', (SELECT idPersonne FROM Personne WHERE Nom = 'Rabe')),
('CL003', (SELECT idPersonne FROM Personne WHERE Nom = 'Andrianarisoa'));

-- Compte Dépôt
INSERT INTO Compte (idClient, numeroCompte, idTypeCompte, dateOuverture) VALUES
((SELECT idClient FROM Client WHERE numeroClient = 'CL001'),
 'DEPOT001',
 (SELECT idTypeCompte FROM TypeCompte WHERE codeType = 'DEPOT'),
 '2025-09-30');

-- Compte Prêt
INSERT INTO Compte (idClient, numeroCompte, idTypeCompte, dateOuverture) VALUES
((SELECT idClient FROM Client WHERE numeroClient = 'CL001'),
 'PRET001',
 (SELECT idTypeCompte FROM TypeCompte WHERE codeType = 'PRET'),
 '2025-09-30');

-- Compte Courant
INSERT INTO Compte (idClient, numeroCompte, idTypeCompte, dateOuverture) VALUES
((SELECT idClient FROM Client WHERE numeroClient = 'CL001'),
 'COURANT001',
 (SELECT idTypeCompte FROM TypeCompte WHERE codeType = 'COURANT'),
 '2025-09-30');

