using System;
using System.Collections.Generic;

namespace CompteDepot.Models;

public partial class Taux
{
    public int IdTaux { get; set; }

    public decimal Taux1 { get; set; }

    public DateOnly DateChangementTaux { get; set; }

    public int IdTypeCompte { get; set; }

    public virtual Typecompte IdTypeCompteNavigation { get; set; } = null!;
}
