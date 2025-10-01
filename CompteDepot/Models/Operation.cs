using System;
using System.Collections.Generic;

namespace CompteDepot.Models;

public partial class Operation
{
    public int IdOperation { get; set; }

    public int IdCompte { get; set; }

    public int IdTypeOperation { get; set; }

    public decimal Montant { get; set; }

    public DateOnly DateOperation { get; set; }

    public virtual Compte IdCompteNavigation { get; set; } = null!;

    public virtual Typeoperation IdTypeOperationNavigation { get; set; } = null!;
}
