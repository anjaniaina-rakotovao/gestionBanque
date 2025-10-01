package com.pret.entity;

import javax.persistence.*;
import java.util.Date;
import java.io.Serializable;


@Entity
public class Personne implements Serializable{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idPersonne;

    private String nom;
    private String prenom;
    private String adresse;

    @Temporal(TemporalType.DATE)
    private Date dateDeNaissance;

    @Column(unique = true)
    private String CIN;

    private String coordonnees;

    public Integer getIdPersonne() {
        return idPersonne;
    }

    public void setIdPersonne(Integer idPersonne) {
        this.idPersonne = idPersonne;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public Date getDateDeNaissance() {
        return dateDeNaissance;
    }

    public void setDateDeNaissance(Date dateDeNaissance) {
        this.dateDeNaissance = dateDeNaissance;
    }

    public String getCIN() {
        return CIN;
    }

    public void setCIN(String cIN) {
        CIN = cIN;
    }

    public String getCoordonnees() {
        return coordonnees;
    }

    public void setCoordonnees(String coordonnees) {
        this.coordonnees = coordonnees;
    }

    // getters et setters
}

