namespace FundingAllocation.Endpoints.EnrichProviderFunding.Services
{
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore.Model;
    using Extensions;
    using FundingAllocation.Services;
    using Repositories;

    public class ProviderService : IProviderService
    {
        private readonly IFundingNotificationApi _fundingNotificationApi;
        private readonly IProviderFundingAllocationRepository _providerFundingAllocationRepository;
        private readonly IProviderFundingRepository _providerFundingRepository;

        public ProviderService(IFundingNotificationApi fundingNotificationApi, IProviderFundingAllocationRepository providerFundingAllocationRepository, IProviderFundingRepository providerFundingRepository)
        {
            _fundingNotificationApi = fundingNotificationApi;
            _providerFundingAllocationRepository = providerFundingAllocationRepository;
            _providerFundingRepository = providerFundingRepository;
        }

        public async Task CreateProviderFundingAllocation(string fundingId, string providerFundingId)
        {
            if (false == await _providerFundingRepository.IsProviderFundingInDb(providerFundingId))
            {
                var providerFundingDto = await _fundingNotificationApi.GetProviderFundingAllocation(providerFundingId);
                
                providerFundingDto.FundingAllocationLines = providerFundingDto.FundingAllocationLines.Where(
                    fal => fal.IsValid()).ToArray();

                await _providerFundingRepository.Create(providerFundingDto.ToProviderFunding());
            }
            
            await _providerFundingAllocationRepository.Create(
                new ProviderFundingAllocation(providerFundingId, fundingId));
        }
    }
}
