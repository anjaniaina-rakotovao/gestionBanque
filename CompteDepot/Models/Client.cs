using System;
using System.Collections.Generic;

namespace CompteDepot.Models;

public partial class Client
{
    public int IdClient { get; set; }

    public string NumeroClient { get; set; } = null!;

    public int IdPersonne { get; set; }

    public virtual ICollection<Compte> Comptes { get; set; } = new List<Compte>();

    public virtual Personne IdPersonneNavigation { get; set; } = null!;
}
