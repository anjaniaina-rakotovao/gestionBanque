package com.pret.remote;

import java.util.Date;
import javax.ejb.Remote;

import java.util.List;

@Remote
public interface ComptePretRemote {
    void fairePretDate(String numeroCompte, double montant, int dureeMois, Date datePret);

    void faireRemboursement(String numeroCompte, int idPret, double montant, Date dateRemboursement);

    double obtenirResteCapBrutRembourse(String numeroCompte, int idPret, Date date);

    double obtenirResteInteretRembourse(String numeroCompte, int idPret, Date date);

    double obtenirResteAPayer(String numeroCompte, int idPret, Date date);

    boolean estRembourse(String numeroCompte, int idPret, Date date);

    double getSoldeDate(String numeroCompte, Date dateChangement);

    List<String> getNumCompteClient(String numeroClient);
}
