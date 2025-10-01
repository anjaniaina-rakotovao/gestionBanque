using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using CompteDepot.Data;
using CompteDepot.Models;

namespace CompteDepot.Services
{
    public class CompteDepotService
    {
        private readonly ApplicationDbContext _context;

        public CompteDepotService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<Typeoperation>> GetRetraitEtDepotTypes()
        {
            return await _context.Typeoperations
                .Where(t => t.CodeOperation == "RETRAIT" || t.CodeOperation == "DEPOT")
                .ToListAsync();
        }


        public async Task DepotDate(DateTime dateOperation, decimal montant, string numeroCompte)
        {
            var compte = await _context.Comptes
                .FirstOrDefaultAsync(c => c.NumeroCompte == numeroCompte);

            if (compte == null)
                throw new Exception("Compte introuvable");

            var typeOperation = await _context.Typeoperations
                .FirstOrDefaultAsync(t => t.CodeOperation == "DEPOT");

            if (typeOperation == null)
                throw new Exception("Type d'opération 'DEPOT' introuvable");

            var operation = new Operation
            {
                Montant = montant,
                DateOperation = DateOnly.FromDateTime(dateOperation),
                IdCompte = compte.IdCompte,
                IdTypeOperation = typeOperation.IdTypeOperation
            };

            await _context.Operations.AddAsync(operation);
            await _context.SaveChangesAsync();
        }

        public async Task<decimal> InteretsDate(string numeroCompte, DateTime date)
        {
            var compte = await _context.Comptes
                .Include(c => c.IdTypeCompteNavigation)
                .FirstOrDefaultAsync(c => c.NumeroCompte == numeroCompte);

            if (compte == null)
                throw new Exception("Compte introuvable");

            var tauxAnnuel = await _context.Tauxes
                .Where(t => t.IdTypeCompte == compte.IdTypeCompte)
                .OrderByDescending(t => t.DateChangementTaux)
                .Select(t => t.Taux1)
                .FirstOrDefaultAsync();

            decimal solde = 0;
            decimal interetsTotaux = 0;

            var operations = await _context.Operations
                .Include(o => o.IdTypeOperationNavigation)
                .Where(o => o.IdCompte == compte.IdCompte && o.DateOperation <= DateOnly.FromDateTime(date))
                .OrderBy(o => o.DateOperation)
                .ToListAsync();

            DateTime dateCourante = operations.Any()
                ? operations.First().DateOperation.ToDateTime(TimeOnly.MinValue)
                : date;

            foreach (var op in operations)
            {
                var opDate = op.DateOperation.ToDateTime(TimeOnly.MinValue);

                int jours = (opDate - dateCourante).Days;
                if (jours > 0)
                {
                    interetsTotaux += solde * (tauxAnnuel / 100m) * (jours / 365m);
                }

                if (op.IdTypeOperationNavigation.CodeOperation == "DEPOT")
                    solde += op.Montant;
                else if (op.IdTypeOperationNavigation.CodeOperation == "RETRAIT")
                    solde -= op.Montant;

                dateCourante = opDate;
            }

            int joursRestants = (date - dateCourante).Days;
            if (joursRestants > 0)
            {
                interetsTotaux += solde * (tauxAnnuel / 100m) * (joursRestants / 365m);
            }

            return interetsTotaux;
        }

        public async Task<decimal> SoldeDateAvecInterets(string numeroCompte, DateTime date)
        {
            var compte = await _context.Comptes
                .Include(c => c.IdTypeCompteNavigation)
                .FirstOrDefaultAsync(c => c.NumeroCompte == numeroCompte);

            if (compte == null)
                throw new Exception("Compte introuvable");

            var tauxAnnuel = await _context.Tauxes
                .Where(t => t.IdTypeCompte == compte.IdTypeCompte)
                .OrderByDescending(t => t.DateChangementTaux)
                .Select(t => t.Taux1)
                .FirstOrDefaultAsync();

            decimal solde = 0;
            decimal interetsTotaux = 0;

            var operations = await _context.Operations
                .Include(o => o.IdTypeOperationNavigation)
                .Where(o => o.IdCompte == compte.IdCompte && o.DateOperation <= DateOnly.FromDateTime(date))
                .OrderBy(o => o.DateOperation)
                .ToListAsync();

            DateTime dateCourante = operations.Any()
                ? operations.First().DateOperation.ToDateTime(TimeOnly.MinValue)
                : date;

            foreach (var op in operations)
            {
                var opDate = op.DateOperation.ToDateTime(TimeOnly.MinValue);

                int jours = (opDate - dateCourante).Days;
                if (jours > 0)
                {
                    interetsTotaux += solde * (tauxAnnuel / 100m) * (jours / 365m);
                }

                if (op.IdTypeOperationNavigation.CodeOperation == "DEPOT")
                    solde += op.Montant;
                else if (op.IdTypeOperationNavigation.CodeOperation == "RETRAIT")
                    solde -= op.Montant;

                dateCourante = opDate;
            }

            int joursRestants = (date - dateCourante).Days;
            if (joursRestants > 0)
            {
                interetsTotaux += solde * (tauxAnnuel / 100m) * (joursRestants / 365m);
            }

            return solde + interetsTotaux;
        }

        public async Task<decimal> SoldeDate(string numeroCompte, DateTime date)
        {
            var compte = await _context.Comptes
                .FirstOrDefaultAsync(c => c.NumeroCompte == numeroCompte);

            if (compte == null)
                throw new Exception("Compte introuvable");

            decimal solde = 0;

            var operations = await _context.Operations
                .Include(o => o.IdTypeOperationNavigation)
                .Where(o => o.IdCompte == compte.IdCompte && o.DateOperation <= DateOnly.FromDateTime(date))
                .OrderBy(o => o.DateOperation)
                .ToListAsync();

            foreach (var op in operations)
            {
                if (op.IdTypeOperationNavigation.CodeOperation == "DEPOT")
                    solde += op.Montant;
                else if (op.IdTypeOperationNavigation.CodeOperation == "RETRAIT")
                    solde -= op.Montant;
            }

            return solde;
        }


        public async Task RetraitDate(string numeroCompte, decimal montant, DateTime dateOperation)
        {
            var compte = await _context.Comptes
                .FirstOrDefaultAsync(c => c.NumeroCompte == numeroCompte);

            if (compte == null)
                throw new Exception("Compte introuvable");

            decimal solde = await SoldeDateAvecInterets(numeroCompte, dateOperation);
            if (montant > solde / 2)
                throw new Exception("Solde insuffisant pour effectuer le retrait(vous ne pouvez pas retirer plus de la moitié)");

            var typeOperation = await _context.Typeoperations
                .FirstOrDefaultAsync(t => t.CodeOperation == "RETRAIT");

            if (typeOperation == null)
                throw new Exception("Type d'opération 'RETRAIT' introuvable");

            var operation = new Operation
            {
                Montant = montant,
                DateOperation = DateOnly.FromDateTime(dateOperation),
                IdCompte = compte.IdCompte,
                IdTypeOperation = typeOperation.IdTypeOperation
            };

            await _context.Operations.AddAsync(operation);
            await _context.SaveChangesAsync();
        }

        public async Task<decimal> CalculInterets(string numeroCompte, DateTime dateDebut, DateTime dateFin)
        {
            var compte = await _context.Comptes
                .Include(c => c.IdTypeCompteNavigation)
                .FirstOrDefaultAsync(c => c.NumeroCompte == numeroCompte);

            if (compte == null)
                throw new Exception("Compte introuvable");

            var tauxAnnuel = await _context.Tauxes
                .Where(t => t.IdTypeCompte == compte.IdTypeCompte)
                .OrderByDescending(t => t.DateChangementTaux)
                .Select(t => t.Taux1)
                .FirstOrDefaultAsync();

            decimal interetsTotaux = 0;

            var operations = await _context.Operations
                .Include(o => o.IdTypeOperationNavigation)
                .Where(o => o.IdCompte == compte.IdCompte && o.DateOperation >= DateOnly.FromDateTime(dateDebut) && o.DateOperation <= DateOnly.FromDateTime(dateFin))
                .OrderBy(o => o.DateOperation)
                .ToListAsync();

            decimal soldeCourant = await SoldeDate(numeroCompte, dateDebut);
            DateTime dateCourante = dateDebut;

            foreach (var op in operations)
            {
                DateTime opDate = op.DateOperation.ToDateTime(TimeOnly.MinValue);

                int jours = (opDate - dateCourante).Days;
                if (jours > 0)
                {
                    interetsTotaux += soldeCourant * (tauxAnnuel / 100m) * (jours / 365m);
                }

                if (op.IdTypeOperationNavigation.CodeOperation == "DEPOT")
                    soldeCourant += op.Montant;
                else if (op.IdTypeOperationNavigation.CodeOperation == "RETRAIT")
                    soldeCourant -= op.Montant;

                dateCourante = opDate;
            }

            int joursRestants = (dateFin - dateCourante).Days;
            if (joursRestants > 0)
            {
                interetsTotaux += soldeCourant * (tauxAnnuel / 100m) * (joursRestants / 365m);
            }

            return interetsTotaux;
        }

    }
}
