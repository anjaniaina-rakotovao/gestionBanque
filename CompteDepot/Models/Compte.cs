using System;
using System.Collections.Generic;

namespace CompteDepot.Models;

public partial class Compte
{
    public int IdCompte { get; set; }

    public int IdClient { get; set; }

    public string NumeroCompte { get; set; } = null!;

    public int IdTypeCompte { get; set; }

    public DateOnly DateOuverture { get; set; }

    public virtual ICollection<Historiquesolde> Historiquesoldes { get; set; } = new List<Historiquesolde>();

    public virtual Client IdClientNavigation { get; set; } = null!;

    public virtual Typecompte IdTypeCompteNavigation { get; set; } = null!;

    public virtual ICollection<Operation> Operations { get; set; } = new List<Operation>();

    public virtual ICollection<Pret> Prets { get; set; } = new List<Pret>();
}
