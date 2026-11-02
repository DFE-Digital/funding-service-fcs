namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IAmendmentTypeServiceChecks
    {
        Task<bool> DoAllAmendmentsRequireSigning(string fundingTypeCode, string fundingPeriodCode);

        Task<bool> IsUpdateDraftAmendmentAndLatestVersionIsVariation(string latestVersionAmendmentType, ContractIntent contractIntent);

        Task<bool> IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract(
            ContractIntent contractIntent,
            IReadOnlyCollection<FundingAllocation> updateFundingAllocations,
            IReadOnlyCollection<FundingAllocation> lastApprovedFundingAllocations);

        Task<bool> IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(IReadOnlyCollection<FundingAllocation> updateFundingAllocations, IReadOnlyCollection<FundingAllocation> lastApprovedFundingAllocations);
        Task<bool> DoAmendmentTypeToNotificationOnExpiredContract(string fundingTypeCode, string fundingPeriodCode);
    }
}