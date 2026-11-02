namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dto;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public interface IFundingNotificationApi
    {
        Task<CfsLatestPageData> GetLatestPageData();

        Task<IReadOnlyCollection<AtomItem>> GetPage(int pageNumber);

        Task<ProviderFundingAllocationApiDto> GetProviderFundingAllocation(string providerFundingId);
    }
}