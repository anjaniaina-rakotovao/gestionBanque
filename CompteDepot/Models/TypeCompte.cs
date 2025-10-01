using System;
using System.Collections.Generic;

namespace CompteDepot.Models;

public partial class Typecompte
{
    public int IdTypeCompte { get; set; }

    public string CodeType { get; set; } = null!;

    public string? Description { get; set; }

    public virtual ICollection<Compte> Comptes { get; set; } = new List<Compte>();

    public virtual ICollection<Taux> Tauxes { get; set; } = new List<Taux>();
}
