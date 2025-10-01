package com.pret.entity;

import javax.persistence.*;
import java.util.Date;
import java.io.Serializable;


@Entity
@Table(name = "Operation")
public class Operation implements Serializable{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idOperation;

    @Column(nullable = false)
    private Double montant;

    @Temporal(TemporalType.DATE)
    private Date dateOperation;

    @ManyToOne
    @JoinColumn(name = "idCompte", nullable = false)
    private Compte compte;

    @ManyToOne
    @JoinColumn(name = "idTypeOperation", nullable = false)
    private TypeOperation typeOperation;

    public Operation(Integer idOperation, Double montant, Date dateOperation, Compte compte,
            TypeOperation typeOperation) {
        this.montant = montant;
        this.dateOperation = dateOperation;
        this.compte = compte;
        this.typeOperation = typeOperation;
    }

    public Integer getIdOperation() {
        return idOperation;
    }

    public void setIdOperation(Integer idOperation) {
        this.idOperation = idOperation;
    }

    public Double getMontant() {
        return montant;
    }

    public void setMontant(Double montant) {
        this.montant = montant;
    }

    public Date getDateOperation() {
        return dateOperation;
    }

    public void setDateOperation(Date dateOperation) {
        this.dateOperation = dateOperation;
    }

    public Compte getCompte() {
        return compte;
    }

    public void setCompte(Compte compte) {
        this.compte = compte;
    }

    public TypeOperation getTypeOperation() {
        return typeOperation;
    }

    public void setTypeOperation(TypeOperation typeOperation) {
        this.typeOperation = typeOperation;
    }
}
