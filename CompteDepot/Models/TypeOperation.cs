using System;
using System.Collections.Generic;

namespace CompteDepot.Models;

public partial class Typeoperation
{
    public int IdTypeOperation { get; set; }

    public string CodeOperation { get; set; } = null!;

    public string? Description { get; set; }

    public virtual ICollection<Operation> Operations { get; set; } = new List<Operation>();
}
