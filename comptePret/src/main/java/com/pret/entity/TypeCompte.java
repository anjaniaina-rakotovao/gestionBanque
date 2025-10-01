package com.pret.entity;

import javax.persistence.*;
import java.io.Serializable;


@Entity
@Table(name = "TypeCompte")
public class TypeCompte implements Serializable{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idTypeCompte;

    @Column(unique = true, nullable = false)
    private String codeType; // COURANT, DEPOT, PRET

    private String description;

    public Integer getIdTypeCompte() {
        return idTypeCompte;
    }

    public void setIdTypeCompte(Integer idTypeCompte) {
        this.idTypeCompte = idTypeCompte;
    }

    public String getCodeType() {
        return codeType;
    }

    public void setCodeType(String codeType) {
        this.codeType = codeType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
