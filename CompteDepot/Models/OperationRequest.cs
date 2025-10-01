using System;

namespace CompteDepot.Models
{
    public class OperationRequest
    {
        public DateTime DateOperation { get; set; }
        public decimal Montant { get; set; }
        public required string NumeroCompte { get; set; }
    }
}
