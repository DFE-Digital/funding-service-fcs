namespace Operations.Web.Services
{
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using System;
    using System.Threading.Tasks;

    public class DasRequestService : IDasRequestService
    {
        private readonly IFundingTypeFundingPeriodRepository _fundingTypeFundingPeriodRepository;

        public DasRequestService(IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository)
        {
            _fundingTypeFundingPeriodRepository = fundingTypeFundingPeriodRepository;
        }

        public async Task<DasRequest> SetupDasRequest(string ukprn, int eventId)
        {
            return await TransformToDasRequest(ukprn, eventId).ConfigureAwait(continueOnCapturedContext: false);
        }

        private async Task<DasRequest> TransformToDasRequest(string ukprn, int eventId)
        {
            const string levyFundingType = "LEVY";

            var levyDefaultContractStartDate = await _fundingTypeFundingPeriodRepository.GetLevyDefaultContractStartDate()
                .ConfigureAwait(continueOnCapturedContext: false);

            return new DasRequest
            {
                FundingType = levyFundingType,
                StartDate = DateTime.SpecifyKind(levyDefaultContractStartDate, DateTimeKind.Utc),
                Ukprn = int.Parse(ukprn),
                DasEngagementEventId = eventId
            };
        }
    }
}