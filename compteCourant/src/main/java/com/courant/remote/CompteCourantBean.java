package com.courant.remote;

import javax.ejb.Stateless;
import javax.persistence.*;
import com.courant.entity.*;
import java.util.Date;
import java.util.List;

@Stateless(name = "CompteCourantBeanUnique")
public class CompteCourantBean implements CompteCourantRemote {

        @PersistenceContext(unitName = "BanquePU")
        private EntityManager em;

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

        @Override
        public void crediter(String numeroCompte, double montant, Date dateOperation) {
                Compte compte = em.createQuery("SELECT c FROM Compte c WHERE c.numeroCompte = :num", Compte.class)
                                .setParameter("num", numeroCompte)
                                .getSingleResult();
                double solde = getSoldeDate(numeroCompte, dateOperation);
                double newSolde = solde + montant;

                TypeOperation typeOperation = em
                                .createQuery("SELECT tp FROM TypeOperation tp WHERE tp.codeOperation = :typeOperation",
                                                TypeOperation.class)
                                .setParameter("typeOperation", "CREDIT")
                                .getSingleResult();

                em.persist(new HistoriqueSolde(null, compte, newSolde, dateOperation));
                em.persist(new Operation(null, montant, dateOperation, compte, typeOperation));

        }

        @Override
        public void debiter(String numeroCompte, double montant, Date dateOperation) {
                Compte compte = em.createQuery("SELECT c FROM Compte c WHERE c.numeroCompte = :num", Compte.class)
                                .setParameter("num", numeroCompte)
                                .getSingleResult();
                double solde = getSoldeDate(numeroCompte, dateOperation);
                double newSolde = solde - montant;

                TypeOperation typeOperation = em
                                .createQuery("SELECT tp FROM TypeOperation tp WHERE tp.codeOperation = :typeOperation",
                                                TypeOperation.class)
                                .setParameter("typeOperation", "DEBIT")
                                .getSingleResult();

                em.persist(new HistoriqueSolde(null, compte, newSolde, dateOperation));
                em.persist(new Operation(null, montant, dateOperation, compte, typeOperation));
        }

        @Override
        public List<TypeOperation> getTousTypeOperations() {
                return em.createQuery("SELECT t FROM TypeOperation t", TypeOperation.class)
                                .getResultList();
        }

        @Override
        public List<TypeOperation> getTypeOperationsCourant() {
                return em.createQuery("SELECT t FROM TypeOperation t", TypeOperation.class)
                                .setMaxResults(2)
                                .getResultList();
        }

        @Override
        public TypeOperation getTypeOperationId(Integer idTypeOperation) {
                return em.createQuery("SELECT tp FROM TypeOperation tp WHERE tp.idTypeOperation = :idTypeOperation",
                                TypeOperation.class)
                                .setParameter("idTypeOperation", idTypeOperation)
                                .getSingleResult();
        }

}
