package com.courant.remote;

import java.util.Date;
import java.util.List;

import javax.ejb.Remote;

import com.courant.entity.*;

@Remote
public interface CompteCourantRemote {
    void crediter(String numeroCompte, double montant, Date dateOperation);

    void debiter(String numeroCompte, double montant, Date dateOperation);

    double getSoldeDate(String numeroCompte, Date dateChangement);

    List<TypeOperation> getTousTypeOperations();

    List<TypeOperation> getTypeOperationsCourant();

    TypeOperation getTypeOperationId(Integer idOperation);

}
