namespace FundingAllocation.Services
{
    using System.Threading.Tasks;
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using Extensions;
    using Repositories;

    public class FundingIdService : IFundingIdService
    {
        private readonly IFundingAllocationRepository _fundingAllocationRepository;

        public FundingIdService(IFundingAllocationRepository fundingAllocationRepository)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task<(IReadOnlyCollection<string> lastestFundingIds, IReadOnlyCollection<string> supersededFundingIds)> GetFundingIdsForLatestVersions(int readId)
        {
            var fundingIds = await _fundingAllocationRepository.GetFundingIdsForReadId(readId);

            var fundingIdInfos = fundingIds.Select(fi => fi.ToFundingIdInfo());

            var fundingNameGroups = fundingIdInfos.GroupBy(fii => fii.FundingIdName)
                .Select(grp =>
                    {
                        var orderedFundingIdsInGrp = grp.OrderByDescending(fii => fii.FundingIdVersion)
                            .Select(fii => fii.FundingId).ToArray();
                        return new
                        {
                            Latest = orderedFundingIdsInGrp[0],
                            Superseded = orderedFundingIdsInGrp[1..]
                        };
                    })
                .ToList();

            return (
                lastestFundingIds: fundingNameGroups.Select(g => g.Latest).ToList(),
                supersededFundingIds: fundingNameGroups.SelectMany(g => g.Superseded).ToList());
        }

        public async Task<IReadOnlyCollection<string>> GetProviderNotFoundToBeSuperseded()
        {
            var providerNotFoundFundingIds =
                await _fundingAllocationRepository.GetFundingIdsWithStatusAndSubStatus(FundingAllocationStatus.Parked,
                    FundingAllocationSubStatus.AwaitingProvider);

            var fundingIdInfos = providerNotFoundFundingIds.Select(fi => fi.ToFundingIdInfo()).ToList();

            return fundingIdInfos.GroupBy(fii => fii.FundingIdName)
                .SelectMany(grp =>
                {
                    return grp.OrderByDescending(fi => fi.FundingIdVersion).Select(fi => fi.FundingId).ToArray()[1..];
                }).ToList();
        }
    }
}