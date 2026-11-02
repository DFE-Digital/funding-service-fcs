namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System.Collections.Generic;
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class GetAmendmentTypeInput
    {
        public GetAmendmentTypeInput(int contractingUkprn, string fundingTypeCode, string fundingPeriodCode, IEnumerable<string> fundingIds, IReadOnlyCollection<FundingAllocation> updateFundingAllocations, IReadOnlyCollection<FundingAllocation> lastApprovedFundingAllocations, ContractIntent contractIntent, string amendmentTypeOfLatestContract)
        {
            ContractingUkprn = contractingUkprn;
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
            FundingIds = fundingIds;
            UpdateFundingAllocations = updateFundingAllocations;
            LastApprovedFundingAllocations = lastApprovedFundingAllocations;
            ContractIntent = contractIntent;
            AmendmentTypeOfLatestContract = amendmentTypeOfLatestContract;
        }

        public int ContractingUkprn { get; }
        public string FundingTypeCode { get; }
        public string FundingPeriodCode { get; }
        public IEnumerable<string> FundingIds { get; }
        public IReadOnlyCollection<FundingAllocation> UpdateFundingAllocations { get; }
        public IReadOnlyCollection<FundingAllocation> LastApprovedFundingAllocations { get; }
        public ContractIntent ContractIntent { get; }
        public string AmendmentTypeOfLatestContract { get; }
    }
}