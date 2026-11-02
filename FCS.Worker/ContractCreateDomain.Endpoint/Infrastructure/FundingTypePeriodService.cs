namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class FundingTypePeriodService : IFundingTypePeriodService
    {
        public void EnrichContract(ExtendedContractType extendedContract, FundingTypeFundingPeriod fundingTypeFundingPeriod)
        {
            var firstContract = extendedContract.contracts.First();

            firstContract.SkipCaseloadAssignment = fundingTypeFundingPeriod.SkipCaseloadAssignment;
            firstContract.SkipReviewAndInternalApproval = fundingTypeFundingPeriod.SkipReviewAndInternalApproval;
            firstContract.DocumentationRequired = fundingTypeFundingPeriod.DocumentsRequired;
            firstContract.SkipDocumentMerge = fundingTypeFundingPeriod.SkipDocumentMerge;
        }
    }
}
