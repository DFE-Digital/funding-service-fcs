namespace ContractManagementDomain.Endpoint.ContractApproved.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ApprovedContractPopulateCacheService : IApprovedContractPopulateCacheService
    {
        private readonly IApprovedContractRepository _approvedContractRepository;
        private readonly IFundingTypeFundingPeriodRepository _fundingTypeFundingPeriodRepository;

        public ApprovedContractPopulateCacheService(
            IApprovedContractRepository approvedContractRepository,
            IFundingTypeFundingPeriodRepository fundingTypeFundingPeriodRepository)
        {
            _approvedContractRepository = approvedContractRepository;
            _fundingTypeFundingPeriodRepository = fundingTypeFundingPeriodRepository;
        }

        public async Task UpdateApprovedContractCache(Contract corporateContract, string masterContractNumber, ConnectionInfo connectionInfo)
        {
            foreach (contractType childContract in corporateContract.contracts)
            {
                await UpdateApprovedContractCacheForChildContract(childContract, masterContractNumber, connectionInfo)
                    .ConfigureAwait(false);
            }
        }

        private async Task UpdateApprovedContractCacheForChildContract(contractType childContract, string masterContractNumber, ConnectionInfo connectionInfo)
        {
            FundingTypeFundingPeriod fundingTypeFundingPeriod = await _fundingTypeFundingPeriodRepository.Get(
                childContract.fundingType.fundingTypeCode,
                childContract.GetFundingPeriod(),
                connectionInfo).ConfigureAwait(false);

            ApprovedContract approvedContract = CreateApprovedContract(
                childContract,
                masterContractNumber,
                fundingTypeFundingPeriod.IncludeAllContractsOnSummaryOfFunding,
                connectionInfo);

            await _approvedContractRepository.Add(approvedContract, connectionInfo)
                .ConfigureAwait(false);
        }

        private ApprovedContract CreateApprovedContract(
            contractType contract,
            string masterContractNumber,
            bool includeAllContractsOnSummaryOfFunding,
            ConnectionInfo connectionInfo)
        {
            return new ApprovedContract(
                contract.contractNumber,
                contract.contractVersionNumber,
                contract.contractSubVersionNumber,
                contract.fundingType.fundingTypeCode,
                contract.GetFundingPeriod(),
                contract.contractor.ukprn,
                contract.contractor.organisationIdentifier,
                masterContractNumber,
                contract.startDate.Value,
                contract.endDate)
            {
                ApprovedContractAllocations = contract.contractAllocations
                    .Select(a => CreateApprovedContractAllocation(a, includeAllContractsOnSummaryOfFunding, connectionInfo))
                    .ToList()
            };
        }

        private ApprovedContractAllocation CreateApprovedContractAllocation(
            contractAllocationsContractAllocation corporateAllocation,
            bool shouldPopulateFinancialEnvelopes,
            ConnectionInfo connectionInfo)
        {
            var profileDeliverables =
                _approvedContractRepository.GetLegalDeliverableCodesForFsp(
                    corporateAllocation.fundingStreamPeriodCode, connectionInfo);

            IReadOnlyCollection<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriodsWithPlannedValue =
                corporateAllocation.GetAllDeliverables()
                    .Where(d => profileDeliverables.Contains(d.deliverable.deliverableCode))
                    .SelectMany(d => d.contractDeliverablePeriods)
                    .Where(dp => dp.plannedValue != 0)
                    .ToList();

            int allocationStartYear = corporateAllocation.startDate.Year;
            int allocationEndYear = 0; // the levy won't have an end date but they also will have shouldPopulateFinancialEnvelopes set to false
            if (shouldPopulateFinancialEnvelopes)
            { 
                allocationEndYear = corporateAllocation.endDate.Value.Year;
            }
            
            return new ApprovedContractAllocation
            {
                ContractAllocationNumber = corporateAllocation.contractAllocationNumber,
                DeliveryOrganisationUkprn = GetUkprnFromDeliveryOrganisation(corporateAllocation),
                DeliveryOrganisationId = corporateAllocation.DeliveryOrganisationDetail?.organisationIdentifier,
                TotalPlannedValue = deliverablePeriodsWithPlannedValue.Sum(dp => dp.plannedValue),
                PlannedValueEnvelope1 = shouldPopulateFinancialEnvelopes ? deliverablePeriodsWithPlannedValue.GetFirstEnvelope(allocationStartYear) : (decimal?)null,
                PlannedValueEnvelope2 = shouldPopulateFinancialEnvelopes ? deliverablePeriodsWithPlannedValue.GetSecondEnvelope(allocationEndYear) : (decimal?)null,
                FundingStreamPeriodCode = corporateAllocation.fundingStreamPeriodCode,
                ApprovedContractDeliverables = corporateAllocation.GetAllDeliverables()
                    .Where(d => profileDeliverables.Contains(d.deliverable.deliverableCode))
                    .Select(d => CreateApprovedContractDeliverable(
                        corporateAllocation.contractAllocationNumber,
                        allocationStartYear,
                        allocationEndYear,
                        shouldPopulateFinancialEnvelopes,
                        d))
                    .ToList()
            };
        }

        private static ApprovedContractDeliverable CreateApprovedContractDeliverable(
            string allocationNumber,
            int allocationStartYear,
            int allocationEndYear,
            bool shouldPopulateFinancialEnvelopes,
            contractDeliverablesTypeContractDeliverable contractDeliverable)
        {
            var totalPlannedValue = contractDeliverable.contractDeliverablePeriods.Sum(dp => dp.plannedValue);
            var envelope1 = shouldPopulateFinancialEnvelopes
                ? contractDeliverable.contractDeliverablePeriods.GetFirstEnvelope(allocationStartYear)
                : (decimal?) null;
            var envelope2 = shouldPopulateFinancialEnvelopes
                ? contractDeliverable.contractDeliverablePeriods.GetSecondEnvelope(allocationEndYear)
                : (decimal?)null;

            return new ApprovedContractDeliverable(allocationNumber, contractDeliverable.deliverable.deliverableCode, totalPlannedValue, envelope1, envelope2);
        }

        private static int? GetUkprnFromDeliveryOrganisation(contractAllocationsContractAllocation contractAllocationsContractAllocation)
        {
            if (contractAllocationsContractAllocation.HasDeliveryOrganisation())
            {
                return contractAllocationsContractAllocation.DeliveryOrganisationDetail.ukprn;
            }

            return null;
        }
    }
}