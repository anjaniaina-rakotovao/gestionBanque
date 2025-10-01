using System;
using System.Collections.Generic;

namespace CompteDepot.Models;

public partial class Personne
{
    public int IdPersonne { get; set; }

    public string Nom { get; set; } = null!;

    public string? Prenom { get; set; }

    public string? Adresse { get; set; }

    public DateOnly DateDeNaissance { get; set; }

    public string? Cin { get; set; }

    public string? Coordonnees { get; set; }

    public virtual ICollection<Client> Clients { get; set; } = new List<Client>();
}
