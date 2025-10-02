package com.pret.remote;

import javax.ejb.Stateless;
import javax.persistence.*;

import com.pret.entity.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Stateless(name = "ComptePretBeanUnique")
public class ComptePretBean implements ComptePretRemote {

    @PersistenceContext(unitName = "BanquePU_pret")
    private EntityManager em;

    @Override
    public List<String> getNumCompteClient(String numeroClient) {
        List<Compte> lc = em.createQuery(
                "SELECT lc FROM Compte lc " +
                        "WHERE lc.client.numeroClient = :numeroClient " +
                        "AND (lc.typeCompte.codeType = 'COURANT' OR lc.typeCompte.codeType = 'PRET')",
                Compte.class)
                .setParameter("numeroClient", numeroClient)
                .getResultList();

        List<String> numCompteClient = new ArrayList<>();
        for (Compte compte : lc) {
            numCompteClient.add(compte.getNumeroCompte());
        }
        return numCompteClient;
    }

  
    public Compte getCompteCourante(String numeroComptePret) {
        Compte comptePret = em.createQuery(
                "SELECT c FROM Compte c WHERE c.numeroCompte = :numeroComptePret",
                Compte.class)
                .setParameter("numeroComptePret", numeroComptePret)
                .getSingleResult();

        Compte compteCourant = em.createQuery(
                "SELECT c FROM Compte c WHERE c.client.idClient = :idClient " +
                        "AND c.typeCompte.codeType = :codeTypeCourant",
                Compte.class)
                .setParameter("idClient", comptePret.getClient().getIdClient())
                .setParameter("codeTypeCourant", "COURANT")
                .getSingleResult();

        return compteCourant;
    }

    @Override
    public void fairePretDate(String numeroCompte, double montant, int dureeMois, Date datePret) {
        Compte compte = em.createQuery(
                "SELECT c FROM Compte c WHERE c.numeroCompte = :num", Compte.class)
                .setParameter("num", numeroCompte)
                .getSingleResult();

        Pret pret = new Pret();
        pret.setCompte(compte);
        pret.setMontant(montant);
        pret.setDatePret(datePret);
        pret.setDureeMois(dureeMois);

        em.persist(pret);

        TypeOperation typeOperation = em.createQuery(
                "SELECT tp FROM TypeOperation tp WHERE tp.codeOperation = :code",
                TypeOperation.class)
                .setParameter("code", "CREDIT")
                .getSingleResult();


        Compte compteCourante = getCompteCourante(numeroCompte);

        double solde = getSoldeDate(compteCourante.getNumeroCompte(), datePret);
        em.persist(new HistoriqueSolde(null, compteCourante, solde + montant, datePret));


        em.persist(new Operation(null, montant, datePret, compte, typeOperation));
    }

    @Override
    public void faireRemboursement(String numeroCompte, int idPret, double montant, Date dateRemboursement) {
        Pret pret = em.find(Pret.class, idPret);
        if (pret == null)
            throw new IllegalArgumentException("Prêt introuvable");

        Remboursement remboursement = new Remboursement();
        remboursement.setPret(pret);
        remboursement.setMontant(montant);
        remboursement.setDateRemboursement(dateRemboursement);

        em.persist(remboursement);

        Compte compte = pret.getCompte();
        TypeOperation typeOperation = em.createQuery(
                "SELECT tp FROM TypeOperation tp WHERE tp.codeOperation = :code",
                TypeOperation.class)
                .setParameter("code", "DEBIT")
                .getSingleResult();

        Compte compteCourante = getCompteCourante(numeroCompte);

        double solde = getSoldeDate(compteCourante.getNumeroCompte(), dateRemboursement);
        em.persist(new HistoriqueSolde(null, compteCourante, solde - montant, dateRemboursement));
        em.persist(new Operation(null, montant, dateRemboursement, compte, typeOperation));
    }

    @Override
    public double obtenirResteCapBrutRembourse(String numeroCompte, int idPret, Date date) {
        Pret pret = em.find(Pret.class, idPret);
        if (pret == null)
            return 0;

        double totalRembourse = em.createQuery(
                "SELECT COALESCE(SUM(r.montant),0) FROM Remboursement r " +
                        "WHERE r.pret.idPret = :idPret AND r.dateRemboursement <= :date",
                Double.class)
                .setParameter("idPret", idPret)
                .setParameter("date", date)
                .getSingleResult();

        return Math.max(pret.getMontant() - totalRembourse, 0);
    }

    @Override
    public double obtenirResteInteretRembourse(String numeroCompte, int idPret, Date date) {
        Pret pret = em.find(Pret.class, idPret);
        if (pret == null)
            return 0;

        List<Remboursement> remboursements = em.createQuery(
                "SELECT r FROM Remboursement r WHERE r.pret.idPret = :idPret ORDER BY r.dateRemboursement ASC",
                Remboursement.class)
                .setParameter("idPret", idPret)
                .getResultList();

        double capitalRestant = pret.getMontant();
        double interetsTotaux = 0;
        Date dateCourante = pret.getDatePret();

        TypeCompte typeCompte = pret.getCompte().getTypeCompte();

        for (Remboursement r : remboursements) {
            if (r.getDateRemboursement().after(date))
                break;

            long jours = (r.getDateRemboursement().getTime() - dateCourante.getTime()) / (1000L * 60 * 60 * 24);
            if (jours < 0)
                jours = 0;

            double taux = obtenirTauxPourDate(typeCompte, dateCourante);

            interetsTotaux += capitalRestant * (taux / 100) * (jours / 365.0);

            capitalRestant -= r.getMontant();
            if (capitalRestant < 0)
                capitalRestant = 0; // éviter capital négatif

            dateCourante = r.getDateRemboursement();
        }

        long joursRestants = (date.getTime() - dateCourante.getTime()) / (1000L * 60 * 60 * 24);
        if (joursRestants < 0)
            joursRestants = 0;

        double tauxFinal = obtenirTauxPourDate(typeCompte, dateCourante);
        interetsTotaux += capitalRestant * (tauxFinal / 100) * (joursRestants / 365.0);

        return Math.max(interetsTotaux, 0);
    }

    private double obtenirTauxPourDate(TypeCompte typeCompte, Date date) {
        List<Taux> tauxList = em.createQuery(
                "SELECT t FROM Taux t WHERE t.typeCompte = :typeCompte AND t.dateChangementTaux <= :date ORDER BY t.dateChangementTaux DESC",
                Taux.class)
                .setParameter("typeCompte", typeCompte)
                .setParameter("date", date)
                .setMaxResults(1)
                .getResultList();

        return tauxList.isEmpty() ? 0 : tauxList.get(0).getTaux();
    }

    @Override
    public double obtenirResteAPayer(String numeroCompte, int idPret, Date date) {
        double capitalRestant = obtenirResteCapBrutRembourse(numeroCompte, idPret, date);
        double interetsRestants = obtenirResteInteretRembourse(numeroCompte, idPret, date);
        return capitalRestant + interetsRestants;
    }

    @Override
    public boolean estRembourse(String numeroCompte, int idPret, Date date) {
        return obtenirResteAPayer(numeroCompte, idPret, date) <= 0;
    }

    @Override
    public double getSoldeDate(String numeroCompte, Date dateChangement) {
        Compte compte = em.createQuery(
                "SELECT c FROM Compte c WHERE c.numeroCompte = :num", Compte.class)
                .setParameter("num", numeroCompte)
                .getSingleResult();

        Integer idCompte = compte.getIdCompte();

        List<HistoriqueSolde> historiques = em.createQuery(
                "SELECT h FROM HistoriqueSolde h " +
                        "WHERE h.compte.idCompte = :idCompte " +
                        "AND h.dateChangement <= :dateChangement " +
                        "ORDER BY h.dateChangement DESC, h.idHistorique DESC",
                HistoriqueSolde.class)
                .setParameter("idCompte", idCompte)
                .setParameter("dateChangement", dateChangement)
                .setMaxResults(1)
                .getResultList();

        if (historiques.isEmpty()) {
            return 0.0;
        } else {
            return historiques.get(0).getSolde();
        }
    }
}
