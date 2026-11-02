namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using DataStore.Model;
    using Extensions;
    using FundingAllocation.Services;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;

    public class AmendmentTypeServiceChecks : IAmendmentTypeServiceChecks
    {
        private readonly IFundingTypeFundingPeriodRepository _fundingTypeFundingPeriodRepository;
        private readonly ICfsToFcsCodeMappingService _cfsToFcsCodeMappingService;

        public AmendmentTypeServiceChecks(
            IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository,
            ICfsToFcsCodeMappingService cfsToFcsCodeMappingService)
        {
            _fundingTypeFundingPeriodRepository = fundingTypeFundingPeriodRepository;
            _cfsToFcsCodeMappingService = cfsToFcsCodeMappingService;
        }

        public async Task<bool> DoAllAmendmentsRequireSigning(string fundingTypeCode, string fundingPeriodCode)
        {
            return await _fundingTypeFundingPeriodRepository.DoAllAmendmentsRequireSigning(fundingTypeCode, fundingPeriodCode);
        }

        public Task<bool> IsUpdateDraftAmendmentAndLatestVersionIsVariation(string latestVersionAmendmentType, ContractIntent contractIntent)
        {
            return Task.FromResult(contractIntent == ContractIntent.UpdateDraftAmendment && latestVersionAmendmentType == "Variation");
        }

        public async Task<bool> IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract(
            ContractIntent contractIntent,
            IReadOnlyCollection<FundingAllocation> updateFundingAllocations,
            IReadOnlyCollection<FundingAllocation> lastApprovedFundingAllocations)
        {
            if (contractIntent != ContractIntent.UpdateDraftAmendment)
            {
                return false;
            }

            var logicalAllocationsOnUpdate = await _cfsToFcsCodeMappingService.GetLogicalAllocations(updateFundingAllocations);
            var logicalAllocationsOnLastApproved = await _cfsToFcsCodeMappingService.GetLogicalAllocations(lastApprovedFundingAllocations);

            var areAllUpdateAllocationsOnLastApproved = logicalAllocationsOnUpdate.Any(u => !logicalAllocationsOnLastApproved.Contains(u));

            return areAllUpdateAllocationsOnLastApproved;
        }

        public Task<bool> IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
            IReadOnlyCollection<FundingAllocation> updateFundingAllocations, 
            IReadOnlyCollection<FundingAllocation> lastApprovedFundingAllocations)
        {
            var lastApprovedLines = lastApprovedFundingAllocations.GetFundingAllocationLines();
            var isAnyUpdateLineGreaterIfMatchingOrPositiveIfNot = updateFundingAllocations.GetFundingAllocationLines().Any(
                updateLine =>
                {
                    var matchingLine = lastApprovedLines.SingleOrDefault(lastApprovedLine =>
                        lastApprovedLine.FundingLineCode == updateLine.FundingLineCode &&
                        lastApprovedLine.GetProviderFundingName() == updateLine.GetProviderFundingName());

                    if (matchingLine != null)
                    {
                        return updateLine.IsFirstEnvelopeGreaterThan(matchingLine) ||
                               updateLine.IsSecondEnvelopeGreaterThan(matchingLine);
                    }

                    return updateLine.GetFirstEnvelope() > 0 || updateLine.GetSecondEnvelope() > 0;
                });

            return Task.FromResult(isAnyUpdateLineGreaterIfMatchingOrPositiveIfNot);
        }

        public async Task<bool> DoAmendmentTypeToNotificationOnExpiredContract(string fundingTypeCode, string fundingPeriodCode)
        {
            return await _fundingTypeFundingPeriodRepository.DoAmendmentTypeToNotificationOnExpiredContract(fundingTypeCode, fundingPeriodCode);
        }
    }
}