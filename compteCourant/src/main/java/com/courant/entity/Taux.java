package com.courant.entity;

import javax.persistence.*;
import java.util.Date;
import java.io.Serializable;


@Entity
@Table(name = "Taux")
public class Taux implements Serializable{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idTaux;

    @Column(nullable = false)
    private Double taux;

    @Temporal(TemporalType.DATE)
    private Date dateChangementTaux;

    @ManyToOne
    @JoinColumn(name = "idTypeCompte", nullable = false)
    private TypeCompte typeCompte;

    public Integer getIdTaux() {
        return idTaux;
    }

    public void setIdTaux(Integer idTaux) {
        this.idTaux = idTaux;
    }

    public Double getTaux() {
        return taux;
    }

    public void setTaux(Double taux) {
        this.taux = taux;
    }

    public Date getDateChangementTaux() {
        return dateChangementTaux;
    }

    public void setDateChangementTaux(Date dateChangementTaux) {
        this.dateChangementTaux = dateChangementTaux;
    }

    public TypeCompte getTypeCompte() {
        return typeCompte;
    }

    public void setTypeCompte(TypeCompte typeCompte) {
        this.typeCompte = typeCompte;
    }
}
