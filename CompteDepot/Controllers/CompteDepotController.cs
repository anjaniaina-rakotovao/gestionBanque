using Microsoft.AspNetCore.Mvc;
using CompteDepot.Services;
using CompteDepot.Models;
using System;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace CompteDepot.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompteDepotController : ControllerBase
    {
        private readonly CompteDepotService _compteDepotService;

        public CompteDepotController(CompteDepotService compteDepotService)
        {
            _compteDepotService = compteDepotService;
        }

        // GET: api/CompteDepot/TypesRetraitDepot
        [HttpGet("TypesRetraitDepot")]
        public async Task<ActionResult<List<Typeoperation>>> GetRetraitEtDepotTypes()
        {
            var types = await _compteDepotService.GetRetraitEtDepotTypes();
            if (types == null || types.Count == 0)
                return NotFound("Aucun type d'opération RETRAIT ou DEPOT trouvé.");

            return Ok(types);
        }

        // POST: api/CompteDepot/Depot
        [HttpPost("Depot")]
        public async Task<IActionResult> DepotDate([FromBody] OperationRequest request)
        {
            try
            {
                await _compteDepotService.DepotDate(request.DateOperation, request.Montant, request.NumeroCompte);
                return Ok("Dépôt effectué avec succès.");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // POST: api/CompteDepot/Retrait
        [HttpPost("Retrait")]
        public async Task<IActionResult> RetraitDate([FromBody] OperationRequest request)
        {
            try
            {
                await _compteDepotService.RetraitDate(request.NumeroCompte, request.Montant, request.DateOperation);
                return Ok("Retrait effectué avec succès.");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // GET: api/CompteDepot/SoldeAvecInterets
        [HttpGet("SoldeAvecInterets")]
        public async Task<ActionResult<decimal>> SoldeDateAvecInterets(string numeroCompte, DateTime date)
        {
            try
            {
                var solde = await _compteDepotService.SoldeDateAvecInterets(numeroCompte, date);
                return Ok(solde);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // GET: api/CompteDepot/Interets
        [HttpGet("Interets")]
        public async Task<ActionResult<decimal>> InteretsDate(string numeroCompte, DateTime date)
        {
            try
            {
                var interets = await _compteDepotService.InteretsDate(numeroCompte, date);
                return Ok(interets);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // GET: api/CompteDepot/CalculInterets
        [HttpGet("CalculInterets")]
        public async Task<ActionResult<decimal>> CalculInterets(string numeroCompte, DateTime dateDebut, DateTime dateFin)
        {
            try
            {
                var interets = await _compteDepotService.CalculInterets(numeroCompte, dateDebut, dateFin);
                return Ok(interets);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }

}
