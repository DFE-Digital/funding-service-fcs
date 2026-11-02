namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using FundingClaim = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim;
    using System.Threading.Tasks;
    using IFspDeliverableClaimRepository = Repositories.IFspDeliverableClaimRepository;

    public class FundingClaimEnrichmentService : IFundingClaimEnrichmentService
    {
        private readonly Repositories.IContractAllocationDeliverableRepository _contractAllocationDeliverableRepository;
        private readonly IPolicyDeliverableRepository _policyDeliverableRepository;
        private readonly IFspDeliverableClaimRepository _fspDeliverableClaimRepository;
        private readonly IParentDeliverableResolver _parentDeliverableResolver;

        public FundingClaimEnrichmentService(
            Repositories.IContractAllocationDeliverableRepository contractAllocationDeliverableRepository,
            IPolicyDeliverableRepository policyDeliverableRepository,
            IFspDeliverableClaimRepository fspDeliverableClaimRepository,
            IParentDeliverableResolver parentDeliverableResolver)
        {
            _contractAllocationDeliverableRepository = contractAllocationDeliverableRepository;
            _policyDeliverableRepository = policyDeliverableRepository;
            _fspDeliverableClaimRepository = fspDeliverableClaimRepository;
            _parentDeliverableResolver = parentDeliverableResolver;
        }

        public async Task Enrich(FundingClaim fundingClaim, ConnectionInfo connectionInfo)
        {
            foreach (var allocation in fundingClaim.ContractAllocations)
            { 
                await EnrichAllocation(allocation, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);
            }
        }

        private async Task EnrichAllocation(ContractAllocation contractAllocation, ConnectionInfo connectionInfo)
        {
            // get all the deliverables with their planned value for this allocation
            IReadOnlyCollection<ContractAllocationDeliverable> allocationDeliverables = await _contractAllocationDeliverableRepository
                .FindByAllocationNumber(contractAllocation.ContractAllocationNumber, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            // get all policy deliverables for the FSP
            var policyDeliverables = await _policyDeliverableRepository.GetPolicyDeliverables(
                    contractAllocation.FundingStreamPeriodCode, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            // get all claim group deliverables for the FSP
            IReadOnlyCollection<FspDeliverableClaim> allClaimGroupDeliverablesForFsp =  
                await _fspDeliverableClaimRepository.GetFspDeliverablesIncludingClaimDeliverableGroup(
                        contractAllocation.FundingStreamPeriodCode,
                        connectionInfo)
                    .ConfigureAwait(continueOnCapturedContext: false); 

            // project to a collection of enhanced DTOs with parent deliverable information
            IReadOnlyCollection<EnhancedDeliverableLine> enhancedDeliverables =
                contractAllocation.DeliverableLines
                    .Select(d =>
                    {
                        int claimGroupParentDeliverableCode = _parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(
                            d.DeliverableCode,
                            policyDeliverables,
                            allClaimGroupDeliverablesForFsp);

                        return new EnhancedDeliverableLine(d.DeliverableCode, claimGroupParentDeliverableCode, d);
                    })
                    .ToList(); ;

            contractAllocation.PlannedValueAggregation = await GetPlannedValueForAllocation(allocationDeliverables, contractAllocation.FundingStreamPeriodCode, connectionInfo);

            // update the Planned Value for each deliverable
            enhancedDeliverables.ToList().ForEach(ed => EnrichDeliverableLine(
                allocationDeliverables.SingleOrDefault(ad => ad.DeliverableCode == ed.DeliverableCode),
                allocationDeliverables.SingleOrDefault(ad => ad.DeliverableCode == ed.ParentDeliverableCode),
                ed));
        }

        private async Task<decimal?> GetPlannedValueForAllocation(IReadOnlyCollection<ContractAllocationDeliverable> allocationDeliverables, string fspCode, ConnectionInfo connectionInfo)
        {
            var profileDeliverableCodes = await _fspDeliverableClaimRepository.GetProfileDeliverableCodes(fspCode, connectionInfo);

            var total = allocationDeliverables.Where(ad => profileDeliverableCodes.Contains(ad.DeliverableCode))
                .Sum(ad => ad.PlannedValue);

            return total;
        }

        private ISet<int> GetDistinctDeliverableCodes(IReadOnlyCollection<EnhancedDeliverableLine> enhancedDeliverables)
        {
            ISet<int> deliverableCodes = GetDistinctDeliverableCodesForThoseWithoutAParent(enhancedDeliverables);
            ISet<int> distinctDeliverableCodesForThoseWhoAreParents = GetDistinctParentDeliverableCodes(enhancedDeliverables);

            deliverableCodes.UnionWith(distinctDeliverableCodesForThoseWhoAreParents);

            return deliverableCodes;
        }

        private ISet<int> GetDistinctDeliverableCodesForThoseWithoutAParent(
            IReadOnlyCollection<EnhancedDeliverableLine> enhancedDeliverables)
        {
            return new HashSet<int>(enhancedDeliverables.Where(ed => ed.ParentDeliverableCode == null)
                    .Select(ed => ed.DeliverableCode));
        }

        private ISet<int> GetDistinctParentDeliverableCodes(
            IReadOnlyCollection<EnhancedDeliverableLine> enhancedDeliverables)
        {
            return new HashSet<int>(enhancedDeliverables.Where(
                    ed => ed.ParentDeliverableCode.HasValue)
                .GroupBy(ed => ed.ParentDeliverableCode)
                .Select(g => g.Key.Value));
        }

        private static void EnrichDeliverableLine(ContractAllocationDeliverable allocationDeliverable, ContractAllocationDeliverable parentAllocationDeliverable, EnhancedDeliverableLine enhancedDeliverableLine)
        {
            enhancedDeliverableLine.DeliverableLine.PlannedValue = allocationDeliverable?.PlannedValue;
            enhancedDeliverableLine.DeliverableLine.ParentPlannedValue = parentAllocationDeliverable?.PlannedValue;
        }

        private class EnhancedDeliverableLine
        {
            public EnhancedDeliverableLine(int deliverableCode, int? parentDeliverableCode, DeliverableLine deliverableLine)
            {
                DeliverableCode = deliverableCode;
                ParentDeliverableCode = parentDeliverableCode;
                DeliverableLine = deliverableLine;
            }

            public int DeliverableCode { get; }

            public int? ParentDeliverableCode { get; }

            public DeliverableLine DeliverableLine { get; }
        }
    }
}