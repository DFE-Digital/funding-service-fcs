namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0.Extensions;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Logging;
    using CorporateSchema = CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._3_0;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;

    public class FundingClaimAllocationFilter : IFundingClaimAllocationFilter
    {
        private readonly IClaimReconciliationAllocationGroupFspRepository _claimReconciliationAllocationGroupFspRepository;
        private readonly ILogger _logger;

        public FundingClaimAllocationFilter(IClaimReconciliationAllocationGroupFspRepository claimReconciliationAllocationGroupFspRepository,
            ILogger logger)
        {
            _claimReconciliationAllocationGroupFspRepository = claimReconciliationAllocationGroupFspRepository;
            _logger = logger;
        }

        public void RemoveInvalidAllocations(CorporateSchema.FundingClaim fundingClaim)
        {
            fundingClaim.FundingClaimAllAttrs.ForEach(attr =>
                {
                    attr.ContractAllocations = attr.ContractAllocations.Where(IsAllocationValid).ToList();
                });
        }

        private bool IsAllocationValid(CorporateSchema.ContractAllocationAllAttrsCT allocation)
        {
            bool isValid = _claimReconciliationAllocationGroupFspRepository.IsFundingStreamPeriodValid(allocation.GetFspCode());

            if (!isValid)
            {
                _logger.LogInformation(
                    PerformanceManagementLoggingId.FundingClaimAllocationRejected,
                    $"A Funding Claim Allocation with FSP: {allocation.GetFspCode()} has been rejected");
            }

            return isValid;
        }
    }
}
