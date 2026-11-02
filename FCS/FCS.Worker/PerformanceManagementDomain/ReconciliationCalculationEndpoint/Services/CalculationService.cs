namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using ClaimType = SFA.FCT.PerformanceManagementDomain.DataStore.Models.ClaimType;
    using FspDeliverableClaim = SFA.FCT.PerformanceManagementDomain.DataStore.Models.FspDeliverableClaim;
    using FundingClaim = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using Reconciliation = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using Allocation = SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;
    using System.Threading.Tasks;
    using DTOs;
    using Extensions;
    using PerformanceManagementDomain.Extensions;
    using Repositories;

    public class CalculationService : ICalculationService
    {
        private readonly Repositories.IClaimReconciliationBehaviourRepository _claimReconciliationBehaviourRepository;
        private readonly Repositories.IFspDeliverableClaimRepository _fspDeliverableClaimRepository;
        private readonly Repositories.IContractAllocationRepository _contractAllocationRepository;
        private readonly Repositories.IClaimReconciliationAllocationGroupRepository _claimReconciliationAllocationGroupRepository;
        private readonly Repositories.IClaimTypeRepository _claimTypeRepository;
        private readonly IDeliverableGroupAmountSummaryCreator _deliverableGroupAmountSummaryCreator;

        public CalculationService(
            Repositories.IClaimReconciliationBehaviourRepository claimReconciliationBehaviourRepository,
            Repositories.IFspDeliverableClaimRepository fspDeliverableClaimRepository,
            Repositories.IContractAllocationRepository contractAllocationRepository,
            Repositories.IClaimReconciliationAllocationGroupRepository claimReconciliationAllocationGroupRepository,
            Repositories.IClaimTypeRepository claimTypeRepository,
            IDeliverableGroupAmountSummaryCreator deliverableGroupAmountSummaryCreator)
        {
            _claimReconciliationBehaviourRepository = claimReconciliationBehaviourRepository;
            _fspDeliverableClaimRepository = fspDeliverableClaimRepository;
            _contractAllocationRepository = contractAllocationRepository;
            _claimReconciliationAllocationGroupRepository = claimReconciliationAllocationGroupRepository;
            _claimTypeRepository = claimTypeRepository;
            _deliverableGroupAmountSummaryCreator = deliverableGroupAmountSummaryCreator;
        }

        public async Task<FundingClaimReconciliation> Calculate(DebatchedFundingClaim debatchedFundingClaim, ConnectionInfo connectionInfo, decimal claimAdjustmentValue = 0, decimal? earningsBoostValue = 0)
        {
            var allocations = new List<Reconciliation.ContractAllocation>();
            foreach (var allocation in debatchedFundingClaim.ContractAllocations)
            {
                var contractAllocation = await CreateReconciliationAllocation(allocation, connectionInfo);
                allocations.Add(contractAllocation);
            }

            ClaimReconciliationBehaviour claimGroupBehaviour = await GetClaimGroupBehaviour(debatchedFundingClaim, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            AmountSummary fundingClaimGroupAmounts = allocations.CalculateAmountSummaryForClaimGroup(claimGroupBehaviour, claimAdjustmentValue, earningsBoostValue);

            allocations.ApportionProposedReconciliationToAllocations(fundingClaimGroupAmounts);

            allocations.ApportionAdjustedCappedClaimValueToAllocations(fundingClaimGroupAmounts.AdjustedCappedClaimValue);

            FundingClaimReconciliation reconciliation = await CreateFundingClaimReconciliation(debatchedFundingClaim,
                allocations, fundingClaimGroupAmounts, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            return reconciliation;
        }

        private async Task<FundingClaimReconciliation> CreateFundingClaimReconciliation(DebatchedFundingClaim debatchedFundingClaim,
            List<Reconciliation.ContractAllocation> allocations,
            AmountSummary amounts, ConnectionInfo connectionInfo)
        {
            ClaimReconciliationAllocationGroup reconciliationAllocationGroup =
                await _claimReconciliationAllocationGroupRepository.Find(debatchedFundingClaim.AllocationGroupCode, connectionInfo)
                    .ConfigureAwait(continueOnCapturedContext: false);

            ClaimType claimType = await _claimTypeRepository.FindByName(debatchedFundingClaim.ClaimTypeName.GetDescription(), connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            Allocation.ContractAllocation contractAllocation = 
                await _contractAllocationRepository.Find(allocations.First().ContractAllocationNumber, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            FundingClaimReconciliation reconciliation = new FundingClaimReconciliation
            {
                AllocationGroup = new AllocationGroup
                {
                    AllocationGroupCode = reconciliationAllocationGroup.ClaimReconciliationAllocationGroupCode,
                    AllocationGroupName = reconciliationAllocationGroup.GroupName
                },
                Period = new Period
                {
                    PeriodTypeCode = (Reconciliation.PeriodTypeCode)Enum.Parse(typeof(Reconciliation.PeriodTypeCode), debatchedFundingClaim.PeriodTypeCode.ToString()),
                    PeriodYear = debatchedFundingClaim.Period,
                    PeriodTypeName = (PeriodTypeName)Enum.Parse(typeof(PeriodTypeName), contractAllocation.Period.PeriodTypeName)
                },
                ClaimType = new Reconciliation.ClaimType
                {
                    ClaimTypeCode = claimType.ClaimTypeCode,
                    ClaimTypeName = claimType.Name
                },
                Contractor = new Reconciliation.Contractor
                {
                    OrganisationIdentifier = contractAllocation.Contractor.OrganisationIdentifier,
                    UKPRN = contractAllocation.Contractor.UKPRN,
                    LegalName = contractAllocation.Contractor.LegalName
                },
                ClaimVersionNumber = debatchedFundingClaim.VersionNumber,
                Status = ReconciliationStatus.Draft,
                StatusLastUpdatedDate = DateTime.Now,
                Amounts = amounts,
                ContractAllocations = allocations
            };
            return reconciliation;
        }

        private async Task<Reconciliation.ContractAllocation> CreateReconciliationAllocation(FundingClaim.ContractAllocation fundingClaimAllocation, ConnectionInfo connectionInfo)
        {
            Allocation.ContractAllocation contractAllocation = await _contractAllocationRepository.Find(
                    fundingClaimAllocation.ContractAllocationNumber, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            var reconciliationDeliverableLines = new List<ContractDeliverable>();
            foreach (var deliverableLine in fundingClaimAllocation.DeliverableLines)
            {
                var contractDeliverable = await CreateReconciliationDeliverable(deliverableLine, fundingClaimAllocation.FundingStreamPeriodCode, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);
                reconciliationDeliverableLines.Add(contractDeliverable);
            }

            Reconciliation.ContractAllocation allocation = new Reconciliation.ContractAllocation
            {
                FundingstreamPeriodCode = fundingClaimAllocation.FundingStreamPeriodCode,
                ContractAllocationNumber = fundingClaimAllocation.ContractAllocationNumber,
                ContractDeliverables = reconciliationDeliverableLines,
                Amounts = await CalculateAllocationPlannedAndCappedAmounts(fundingClaimAllocation.FundingStreamPeriodCode,
                    reconciliationDeliverableLines,
                    fundingClaimAllocation.DeliverableLines,
                    contractAllocation.Contractor.UKPRN,
                    fundingClaimAllocation.PlannedValueAggregation,
                    connectionInfo).ConfigureAwait(continueOnCapturedContext: false),
                Contract = CreateContractInformation(contractAllocation.Contract, contractAllocation.FundingType),
                AllocationStartDate = contractAllocation.StartDate,
                AllocationEndDate = contractAllocation.EndDate.GetValueOrDefault()
            };

            return allocation;
        }

        private static Contract CreateContractInformation(Allocation.Contract contract, Allocation.FundingType fundingType)
        {
            return new Contract
            {
                ContractNumber = contract.ContractNumber,
                ContractApprovalDate = contract.ApprovalDate,
                ContractVersionNumber = contract.VersionNumber,
                ContractSubVersionNumber = contract.SubVersionNumber,
                FundingType = new FundingType
                {
                    FundingTypeCode = fundingType.FundingTypeCode,
                    FundingTypeName = fundingType.FundingTypeName
                }
            };
        }

        private async Task<AmountSummary> CalculateAllocationPlannedAndCappedAmounts(
            string fundingStreamPeriodCode,
            List<ContractDeliverable> reconciliationDeliverableLines,
            List<DeliverableLine> claimDeliverableLines,
            int ukprn,
            decimal? plannedValueForAllocation,
            ConnectionInfo connectionInfo)
        {
            Dictionary<string, List<FspDeliverableClaim>> deliverableGroups = await GroupAllocationDeliverables(
                    fundingStreamPeriodCode,connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            List<AmountSummary> delGroupAmountSummaries = new List<AmountSummary>();

            foreach (var delGroup in deliverableGroups)
            {
                AmountSummary delGroupAmountsSummary = await CalculateDeliverableGroupAmountSummary(
                    claimDeliverableGroupCode: delGroup.Key,
                    delGroupDeliverables: delGroup.Value,
                    reconciliationDeliverableLines: reconciliationDeliverableLines,
                    claimDeliverableLines: claimDeliverableLines,
                    ukprn: ukprn,
                    fspCode: fundingStreamPeriodCode,
                    connectionInfo: connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

                delGroupAmountSummaries.Add(delGroupAmountsSummary);
            }

            return new AmountSummary
            {
                PlannedValue = plannedValueForAllocation,
                ClaimedValue = delGroupAmountSummaries.Sum(dgs => dgs.ClaimedValue),
                CappedClaimedValue = delGroupAmountSummaries.Sum(dgs => dgs.CappedClaimedValue),
            };
        }

        private async Task<AmountSummary> CalculateDeliverableGroupAmountSummary(
            string claimDeliverableGroupCode,
            List<FspDeliverableClaim> delGroupDeliverables,
            List<ContractDeliverable> reconciliationDeliverableLines,
            List<DeliverableLine> claimDeliverableLines,
            int ukprn,
            string fspCode,
            ConnectionInfo connectionInfo)
        {
            // identify the deliverable group
            ClaimReconciliationDeliverableGroup deliverableGroup =
                delGroupDeliverables
                    .First(d => d.ClaimReconciliationDeliverableGroupCode == claimDeliverableGroupCode)
                    .ClaimReconciliationDeliverableGroup;

            // identify the reconciliation deliverables within the deliverable group
            List<ContractDeliverable> reconciliationDeliverablesInGroup =
                reconciliationDeliverableLines
                    .Where(d => delGroupDeliverables.Any(dg => dg.DeliverableCode == d.Deliverable.DeliverableCode))
                    .ToList();

            // identify the claim deliverables in the matched reconciliation deliverables
            List<DeliverableLine> matchingClaimDeliverables =
                claimDeliverableLines
                    .Where(cdl => reconciliationDeliverablesInGroup.Exists(x => x.Deliverable.DeliverableCode == cdl.DeliverableCode))
                    .ToList();

            var deliverableCodeInfos =
                await _fspDeliverableClaimRepository.GetDeliverableCodeInfos(fspCode, connectionInfo);

            decimal sumOfParentDeliverablePlannedValue = _fspDeliverableClaimRepository.GetSumOfParentDeliverablesPlannedValueForGroup(
                matchingClaimDeliverables,
                deliverableCodeInfos);
            
            AmountSummary delGroupAmountsSummary = await _deliverableGroupAmountSummaryCreator.CalculateAndCreateAmountSummary(
                parentDeliverablePlannedValue: sumOfParentDeliverablePlannedValue,
                totalClaimValueForGroup: reconciliationDeliverablesInGroup.Sum(d => d.Amounts.ClaimedValue),
                totalPlannedValueForGroup: matchingClaimDeliverables.Sum(d => d.PlannedValue.GetValueOrDefault()),
                shouldCapToProfile: deliverableGroup.CapClaimToProfile,
                delGroupCode: deliverableGroup.ClaimReconciliationDeliverableGroupCode,
                ukprn: ukprn,
                connectionInfo: connectionInfo).ConfigureAwait(continueOnCapturedContext: false); 

            return delGroupAmountsSummary;
        }

        private async Task<Dictionary<string, List<FspDeliverableClaim>>> GroupAllocationDeliverables(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<FspDeliverableClaim> fspDeliverables = await _fspDeliverableClaimRepository
                .GetFspDeliverablesIncludingClaimDeliverableGroup(fundingStreamPeriodCode, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            return fspDeliverables.GroupBy(x => x.ClaimReconciliationDeliverableGroupCode)
                .ToDictionary(group => group.Key, group => group.ToList());
        }

        private async Task<ClaimReconciliationBehaviour> GetClaimGroupBehaviour(DebatchedFundingClaim debatchedFundingClaim, ConnectionInfo connectionInfo)
        {
            string claimCollectionCode = $"{debatchedFundingClaim.Period}-{debatchedFundingClaim.ClaimTypeName}";

            return await _claimReconciliationBehaviourRepository
                .Find(claimCollectionCode, debatchedFundingClaim.AllocationGroupCode, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);
        }

        private async Task<ContractDeliverable> CreateReconciliationDeliverable(DeliverableLine fundingClaimDeliverableLine, string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            int deliverableCode = fundingClaimDeliverableLine.DeliverableCode;
            string deliverableName = await _fspDeliverableClaimRepository.GetDeliverableName(deliverableCode,
                    fundingStreamPeriodCode, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            decimal claimedValue = fundingClaimDeliverableLine.TotalDelivery.GetValueOrDefault();

            return new ContractDeliverable
            {
                Deliverable = new Deliverable
                {
                    DeliverableCode = deliverableCode,
                    DeliverableName = deliverableName
                },
                Amounts = new AmountSummary
                {
                    PlannedValue = fundingClaimDeliverableLine.PlannedValue.GetValueOrDefault(),
                    ClaimedValue = claimedValue,
                    CappedClaimedValue = claimedValue
                }
            };
        }
    }
}