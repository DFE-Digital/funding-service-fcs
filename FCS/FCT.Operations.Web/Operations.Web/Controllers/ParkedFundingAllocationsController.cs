namespace Operations.Web.Controllers
{
    using System.Web.Http;
    using System.Threading.Tasks;
    using Dtos;
    using Repositories;

    [RoutePrefix("parked-funding-allocations")]
    public class ParkedFundingAllocationsController : ApiController
    {
        private readonly IParkedFundingAllocationRepository _parkedFundingAllocationRepository;

        public ParkedFundingAllocationsController(IParkedFundingAllocationRepository parkedFundingAllocationRepository)
        {
            _parkedFundingAllocationRepository = parkedFundingAllocationRepository;
        }

        [HttpGet, Route("substatus-counts")]
        public async Task<IHttpActionResult> GetParkedAllocationsSubStatusCounts()
        {
            var parkedAllocationsSubStatusCounts = await _parkedFundingAllocationRepository.GetSubStatusCounts();

            return Ok(parkedAllocationsSubStatusCounts);
        }

        [HttpGet, Route("detail")]
        public async Task<IHttpActionResult> GetParkedAllocationDetails()
        {
            var parkedAllocationsSubStatusCounts = await _parkedFundingAllocationRepository.GetSubStatusCounts();
            var awaitingProviderDetails = await _parkedFundingAllocationRepository.GetAwaitingProviderDetails();
            var awaitingFundingLineDetails = await _parkedFundingAllocationRepository.GetAwaitingFundingLineDetails();
            var awaitingContractTypeDetails = await _parkedFundingAllocationRepository.GetAwaitingContractTypeDetails();
            var awaitingFundingAllocationDetails = await _parkedFundingAllocationRepository.GetAwaitingFundingAllocationDetails();
            var unknownProviderTypeSubtypeDetails = await _parkedFundingAllocationRepository.GetUnknownProviderTypeSubtypeDetails();

            ParkedAllocationDetails parkedAllocationDetails = new ParkedAllocationDetails(
                parkedAllocationsSubStatusCounts, awaitingProviderDetails, awaitingFundingLineDetails,
                awaitingContractTypeDetails, awaitingFundingAllocationDetails, unknownProviderTypeSubtypeDetails);
            
            return Ok(parkedAllocationDetails);
        }
    }
}