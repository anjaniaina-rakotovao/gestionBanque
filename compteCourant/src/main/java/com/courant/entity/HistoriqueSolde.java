package com.courant.entity;

import javax.persistence.*;
import java.util.Date;
import java.io.Serializable;


@Entity
@Table(name = "HistoriqueSolde")
public class HistoriqueSolde implements Serializable{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idHistorique;

    @Column(nullable = false)
    private Double solde;

    @Temporal(TemporalType.DATE)
    private Date dateChangement;

    @ManyToOne
    @JoinColumn(name = "idCompte", nullable = false)
    private Compte compte;

    public HistoriqueSolde() {

    }

    public HistoriqueSolde(Integer id, Compte compte, double solde, Date date) {
        this.compte = compte;
        this.solde = solde;
        this.dateChangement = date;
    }

    public Integer getIdHistorique() {
        return idHistorique;
    }

    public void setIdHistorique(Integer idHistorique) {
        this.idHistorique = idHistorique;
    }

    public Double getSolde() {
        return solde;
    }

    public void setSolde(Double solde) {
        this.solde = solde;
    }

    public Date getDateChangement() {
        return dateChangement;
    }

    public void setDateChangement(Date dateChangement) {
        this.dateChangement = dateChangement;
    }

    public Compte getCompte() {
        return compte;
    }

    public void setCompte(Compte compte) {
        this.compte = compte;
    }

}
