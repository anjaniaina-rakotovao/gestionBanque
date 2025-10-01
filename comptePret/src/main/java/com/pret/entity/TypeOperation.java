package com.pret.entity;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "TypeOperation")
public class TypeOperation implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idTypeOperation;

    @Column(unique = true, nullable = false)
    private String codeOperation; 

    private String description;

    public Integer getIdTypeOperation() {
        return idTypeOperation;
    }

    public void setIdTypeOperation(Integer idTypeOperation) {
        this.idTypeOperation = idTypeOperation;
    }

    public String getCodeOperation() {
        return codeOperation;
    }

    public void setCodeOperation(String codeOperation) {
        this.codeOperation = codeOperation;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
