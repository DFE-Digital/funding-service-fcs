namespace FundingAllocation.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DataStore.Model;
    using Dto;

    public interface IFundingAllocationRepository
    {
        Task<IReadOnlyCollection<string>> GetExistingIdsForPage(IReadOnlyCollection<string> fundingIdsOnFeed);

        Task CreateFundingAllocations(IEnumerable<FundingAllocation> fundingAllocations);

        Task<FundingAllocation> GetFundingAllocation(string fundingId);

        Task<IReadOnlyCollection<FundingAllocation>> GetFundingAllocations(IEnumerable<string> fundingIds);

        Task<FundingAllocation> GetFundingAllocationIncludingProviders(string fundingId);

        Task AddCrmEntityIdToFundingAllocation(string fundingId, Guid crmEntityId);

        Task UpdateReleaseGroupOnFundingAllocation(string fundingId, int? releaseGroupId);

        Task<IReadOnlyCollection<string>> GetReleaseGroupsThatCanNowBeSetToReleased(
            IReadOnlyCollection<string> fundingAllocationIds, int? releaseGroupId);

        Task<IReadOnlyCollection<string>> GetFundingIdsForReadId(int readId);
        Task<Guid?> GetFundingAllocationCrmId(string fundingId);
        Task<bool> IsFundingAllocationInReleaseGroup(string fundingId);
        Task SetToReturnedToScheduling(string fundingId);
        Task RemoveContractFromFundingAllocations(IEnumerable<string> fundingIds);

        Task<IReadOnlyCollection<string>> GetFundingAllocationNamesInContractControlWithoutOutcome(
            IEnumerable<string> fundingAllocationNames, int readIdToIgnore);

        Task<IReadOnlyCollection<FundingIdAndName>> GetLatestContractApprovedFundingAllocationIds(
            IEnumerable<string> fundingAllocationNames);

        Task<IReadOnlyCollection<string>> GetFundingIdsForFundingNamesAndStatus(
            IEnumerable<string> fundingAllocationNames, FundingAllocationStatus status);

        Task SetFundingAllocationStatusSubStatus(IEnumerable<string> fundingId, FundingAllocationStatus newStatus, FundingAllocationSubStatus newSubStatus);

        Task SetContractId(IEnumerable<string> fundingIds, int contractId);

        Task<IReadOnlyCollection<FundingAllocation>> GetFundingAllocationsIncludingProviders(IEnumerable<string> fundingIds);

        Task UpdateFundingAllocations(IEnumerable<string> fundingIds, int releaseGroupId,
            FundingAllocationStatus newStatus, FundingAllocationSubStatus newSubStatus);
        Task<IReadOnlyCollection<FundingAllocation>> GetFundingAllocationsIncludingProvidersAndLines(
            IEnumerable<string> fundingIds);

        Task SetFundingAllocationsParkedSubStatus(IReadOnlyCollection<string> fundingIds,
            FundingAllocationSubStatus newSubStatus);
        Task<IReadOnlyCollection<string>> GetAllParkedFundingIdsWithSubStatuses(
            params FundingAllocationSubStatus[] subStatuses);

        Task<IReadOnlyCollection<string>> GetAllFundingIdsAwaitingProviderNotInCurrentRead(int readId);

        Task<IReadOnlyCollection<string>> GetFundingIdsWithStatusAndSubStatus(FundingAllocationStatus status,
            FundingAllocationSubStatus subStatus);

        Task InsertOrUpdateParkingInfoLastDiscarded(IEnumerable<string> fundingIds, DateTime now);
        Task<IReadOnlyCollection<string>> GetReleaseGroupsWithQueuedFundingAllocationsForContract(
            string contractNumber);

        Task SetFundingAllocationsToPublished(IEnumerable<string> fundingIds);

        Task<IReadOnlyCollection<FundingAllocationLine>> GetLatestPublishedFundingLines(string fundingName,
            string fundingIdToIgnore);

        Task SetLinesToIsOfNoInterest(IEnumerable<(string providerFundingId, string fundingLineCode)> fundingLinePKs);

        Task<IReadOnlyCollection<FundingLineValue>> GetFundingLinePlannedValueForFundingAllocationIds(IEnumerable<string> fundingAllocationIds);
    }
}
