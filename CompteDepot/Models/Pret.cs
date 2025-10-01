using System;
using System.Collections.Generic;

namespace CompteDepot.Models;

public partial class Pret
{
    public int IdPret { get; set; }

    public int IdCompte { get; set; }

    public decimal Montant { get; set; }

    public DateOnly DatePret { get; set; }

    public int DureeMois { get; set; }

    public virtual Compte IdCompteNavigation { get; set; } = null!;

    public virtual ICollection<Remboursement> Remboursements { get; set; } = new List<Remboursement>();
}
