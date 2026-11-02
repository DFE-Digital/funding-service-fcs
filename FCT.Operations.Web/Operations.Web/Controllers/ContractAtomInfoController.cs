namespace Operations.Web.Controllers
{
    using System.Threading.Tasks;
    using System.Web.Http;
    using Filters;
    using Repositories;

    [RoutePrefix("fcs-contract-atom-info")]
    public class ContractAtomInfoController : ApiController
    {
        private readonly IContractAtomFeedQueryRepository _contractAtomFeedQueryRepository;

        public ContractAtomInfoController(IContractAtomFeedQueryRepository contractAtomFeedQueryRepository)
        {
            _contractAtomFeedQueryRepository = contractAtomFeedQueryRepository;
        }

        [HttpGet, Route]
        public async Task<IHttpActionResult> GetContracts(string contractNumber)
        {
            var contracts = await _contractAtomFeedQueryRepository.GetContracts(contractNumber)
                .ConfigureAwait(false);
            
            return Ok(contracts);
        }

        [HttpGet, Route("{id}")]
        public async Task<IHttpActionResult> GetContractXml(int id)
        {
            var xml = await _contractAtomFeedQueryRepository.GetXmlForContract(id)
                .ConfigureAwait(false);

            return Ok(xml);
        }
    }
}