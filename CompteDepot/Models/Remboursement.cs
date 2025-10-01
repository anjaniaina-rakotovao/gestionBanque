using System;
using System.Collections.Generic;

namespace CompteDepot.Models;

public partial class Remboursement
{
    public int IdRemboursement { get; set; }

    public int IdPret { get; set; }

    public decimal Montant { get; set; }

    public DateOnly DateRemboursement { get; set; }

    public virtual Pret IdPretNavigation { get; set; } = null!;
}
