package com.courant.entity;

import javax.persistence.*;
import java.util.Date;
import java.io.Serializable;


@Entity
@Table(name = "Remboursement")
public class Remboursement implements Serializable{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idRemboursement;

    @Column(nullable = false)
    private Double montant;

    @Temporal(TemporalType.DATE)
    private Date dateRemboursement;

    @ManyToOne
    @JoinColumn(name = "idPret", nullable = false)
    private Pret pret;

    public Integer getIdRemboursement() {
        return idRemboursement;
    }

    public void setIdRemboursement(Integer idRemboursement) {
        this.idRemboursement = idRemboursement;
    }

    public Double getMontant() {
        return montant;
    }

    public void setMontant(Double montant) {
        this.montant = montant;
    }

    public Date getDateRemboursement() {
        return dateRemboursement;
    }

    public void setDateRemboursement(Date dateRemboursement) {
        this.dateRemboursement = dateRemboursement;
    }

    public Pret getPret() {
        return pret;
    }

    public void setPret(Pret pret) {
        this.pret = pret;
    }
}
