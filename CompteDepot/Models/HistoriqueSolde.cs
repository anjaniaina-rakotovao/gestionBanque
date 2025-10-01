using System;
using System.Collections.Generic;

namespace CompteDepot.Models;

public partial class Historiquesolde
{
    public int IdHistorique { get; set; }

    public int IdCompte { get; set; }

    public decimal Solde { get; set; }

    public DateOnly DateChangement { get; set; }

    public virtual Compte IdCompteNavigation { get; set; } = null!;
}
