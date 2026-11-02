namespace PerformanceManagementDomain.XrmEndpoint.Repositories
{
    using Microsoft.Xrm.Sdk;
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using System.Linq;
    using System.Collections.Concurrent;
    using System.Collections.Generic;

    public class FundingClaimReconciliationCommandRepository : IFundingClaimReconciliationCommandRepository
    {
        private readonly IOrganizationService _organizationService;

        private static readonly ConcurrentDictionary<string, sfa_period> PeriodConcurrentDictionary = new ConcurrentDictionary<string, sfa_period>();
        private static readonly ConcurrentDictionary<string, sfa_claimtype> ClaimTypeConcurrentDictionary = new ConcurrentDictionary<string, sfa_claimtype>();
        private static readonly ConcurrentDictionary<string, sfa_claimreconallocgroup> AllocGroupConcurrentDictionary = new ConcurrentDictionary<string, sfa_claimreconallocgroup>();

        public FundingClaimReconciliationCommandRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public Guid CreateFundingClaimReconciliation(FundingClaimReconciliation fundingClaimReconciliation)
        {
            Guid newFundingClaimReconciliationId = Guid.NewGuid();
            sfa_period fundingPeriod = GetFundingPeriod(fundingClaimReconciliation.Period);
            sfa_claimtype claimType = GetClaimType(fundingClaimReconciliation.ClaimType);
            sfa_claimreconallocgroup claimReconAllocGroup = GetAllocationGroup(fundingClaimReconciliation.AllocationGroup);
            Account provider = GetProviderFromCrm(fundingClaimReconciliation.Contractor.OrganisationIdentifier);

            var crmFundingClaimReconciliation = new sfa_fundingclaimreconciliation
            {
                sfa_fundingclaimreconciliationId = newFundingClaimReconciliationId,
                sfa_name = $"{fundingPeriod.sfa_Period}_{claimType.sfa_name}_{claimReconAllocGroup.sfa_name}_{provider.sfa_UKPRN}",
                sfa_AllocationGroupId = claimReconAllocGroup.ToEntityReference(),
                sfa_ClaimTypeId = claimType.ToEntityReference(),
                sfa_FundingPeriodId = fundingPeriod.ToEntityReference(),
                sfa_ProviderId = provider.ToEntityReference(),
                sfa_PlannedValue = fundingClaimReconciliation.Amounts.PlannedValue,
                sfa_CappedClaimedValue = fundingClaimReconciliation.Amounts.CappedClaimedValue,
                sfa_adjustedcappedclaimedvalue = fundingClaimReconciliation.Amounts.AdjustedCappedClaimValue,
                sfa_ClaimedValue = fundingClaimReconciliation.Amounts.ClaimedValue,
                sfa_ProposedReconciliationValue = fundingClaimReconciliation.Amounts.ProposedReconciliationValue,
                sfa_ReconciliationValue = fundingClaimReconciliation.Amounts.ReconciliationValue,
                sfa_ClaimVersionNumber = fundingClaimReconciliation.ClaimVersionNumber,
                SFA_EarningsBoostValue = fundingClaimReconciliation.Amounts.EarningsBoostValue,
                sfa_StatusCodeEnum = sfa_sfastatuscode.Draft,
                sfa_StatusLastUpdatedDate = DateTime.UtcNow,
                sfa_ukprn = provider.sfa_UKPRN
            };

            crmFundingClaimReconciliation.sfa_sfa_fundingclaimreconciliation_sfa_fcrall = CreateFundingClaimAllocations(crmFundingClaimReconciliation, fundingClaimReconciliation.ContractAllocations);

            return _organizationService.Create(crmFundingClaimReconciliation);
        }

        public void SetStatusOfFundingClaimReconciliationToPublished(Guid fundingClaimReconciliationId, DateTime publishedDate)
        {
            _organizationService.Update(new sfa_fundingclaimreconciliation()
            {
                Id = fundingClaimReconciliationId,
                sfa_servicestatusEnum = sfa_FCRServiceStatus.PublishSuccessful,
                sfa_StatusLastUpdatedDate = publishedDate
            });
        }

        public void SetStatusOfFundingClaimReconciliationToManuallyPublished(Guid fundingClaimReconciliationId, DateTime publishedDate)
        {
            _organizationService.Update(new sfa_fundingclaimreconciliation
            {
                Id = fundingClaimReconciliationId,
                sfa_servicestatusEnum = sfa_FCRServiceStatus.ManuallyPublished,
                sfa_StatusLastUpdatedDate = publishedDate
            });
        }

        public void SetStatusOfFundingClaimReconciliationToPublishFailed(Guid fundingClaimReconciliationId, DateTime dateOccurred, string reasonForFailure)
        {
            _organizationService.Update(new sfa_fundingclaimreconciliation()
            {
                Id = fundingClaimReconciliationId,
                sfa_servicestatusEnum = sfa_FCRServiceStatus.PublishFailed,
                sfa_StatusLastUpdatedDate = dateOccurred,
                sfa_serviceresponse = reasonForFailure
            });
        }

        private IEnumerable<sfa_fcrallocation> CreateFundingClaimAllocations(sfa_fundingclaimreconciliation fundingClaimReconciliation, IList<ContractAllocation> contractAllocations)
        {
            var fcrAllocationList = new List<sfa_fcrallocation>();

            foreach (var allocation in contractAllocations)
            {
                sfa_fcrallocation fcrAllocation = new sfa_fcrallocation
                {
                    sfa_PlannedValue = allocation.Amounts.PlannedValue,
                    sfa_CappedClaimedValue = allocation.Amounts.CappedClaimedValue,
                    sfa_ClaimedValue = allocation.Amounts.ClaimedValue,
                    sfa_ContractAllocationId = GetContractAllocation(allocation),
                    sfa_fcrallocationId = Guid.NewGuid(),
                    sfa_FundingClaimReconciliationId = fundingClaimReconciliation.ToEntityReference(),
                    sfa_name = allocation.ContractAllocationNumber,
                    sfa_ProposedReconciliationValue = allocation.Amounts.ProposedReconciliationValue,
                    sfa_ReconciliationValue = allocation.Amounts.ProposedReconciliationValue,
                    sfa_adjustedcappedclaimedvalue = allocation.Amounts.AdjustedCappedClaimValue,
                    SFA_EarningsBoostValue = allocation.Amounts.EarningsBoostValue,
                    sfa_ukprn = fundingClaimReconciliation.sfa_ukprn
                };

                fcrAllocation.sfa_sfa_fcrallocation_sfa_fcrallocationdelive = CreateFcrAllocationDeliverables(fcrAllocation, allocation.ContractDeliverables, allocation.FundingstreamPeriodCode);

                fcrAllocationList.Add(fcrAllocation);
            }

            return fcrAllocationList;
        }

        private IEnumerable<sfa_fcrallocationdeliverable> CreateFcrAllocationDeliverables(sfa_fcrallocation parentFcrAllocation, IList<ContractDeliverable> fcrAllocationDeliverables, string fundingStreamPeriodCode)
        {
            return fcrAllocationDeliverables.Select(deliverable => new sfa_fcrallocationdeliverable
            {
                sfa_name = deliverable.Deliverable.DeliverableName,
                sfa_fcrallocationdeliverableId = Guid.NewGuid(),
                sfa_FCRAllocationId = parentFcrAllocation.ToEntityReference(),
                sfa_PlannedValue = deliverable.Amounts.PlannedValue,
                sfa_ClaimedValue = deliverable.Amounts.ClaimedValue,
                sfa_DeliverableId = GetFundingStreamDeliverable(deliverable.Deliverable.DeliverableCode,
                fundingStreamPeriodCode).ToEntityReference(),
            });
        }

        private sfa_deliverable GetFundingStreamDeliverable(int deliverableCode, string fundingStreamPeriodCode)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                sfa_fundingstreamperiod fundingStreamPeriod = GetFundingStreamPeriod(fundingStreamPeriodCode);
                var deliverable = (from fs in xrmServiceContext.sfa_fundingstreamSet
                                   join d in xrmServiceContext.sfa_deliverableSet
                                   on fs.Id equals d.sfa_FundingStreamId.Id
                                   where d.sfa_DeliverableCode == deliverableCode
                                   && fs.sfa_fundingstreamId == fundingStreamPeriod.sfa_FundingStreamCodeId.Id
                                   select d).Single();

                deliverable.Id = deliverable.sfa_deliverableId.Value;
                return deliverable;
            }
        }

        private sfa_fundingstreamperiod GetFundingStreamPeriod(string fundingStreamPeriodCode)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (from fsp in xrmServiceContext.sfa_fundingstreamperiodSet
                        where fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                        select fsp).Single();
            }
        }

        private EntityReference GetContractAllocation(ContractAllocation contractAllocation)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (from alloc in xrmServiceContext.sfa_contractallocationSet
                        join contract in xrmServiceContext.sfa_contractSet
                        on alloc.sfa_ContractId.Id equals contract.Id
                        where alloc.sfa_contractallocationnumber == contractAllocation.ContractAllocationNumber
                        && contract.sfa_Version == contractAllocation.Contract.ContractVersionNumber
                        && contract.sfa_SubVersion == contractAllocation.Contract.ContractSubVersionNumber
                        select alloc).Single().ToEntityReference();
            }
        }

        private Account GetProviderFromCrm(string organisationId)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return xrmServiceContext.AccountSet.Single(a => a.sfa_OrganisationID == organisationId);
            }
        }

        private sfa_claimtype GetClaimType(ClaimType claimType)
        {
            return ClaimTypeConcurrentDictionary.GetOrAdd(claimType.ClaimTypeCode, GetClaimTypeFromCrm);
        }

        private sfa_claimtype GetClaimTypeFromCrm(string claimTypeCode)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (from ct in xrmServiceContext.sfa_claimtypeSet
                        where ct.sfa_ClaimTypeCode == claimTypeCode
                        select ct).Single();
            }
        }

        private sfa_period GetFundingPeriod(Period period)
        {
            var periodName = period.PeriodTypeCode + period.PeriodYear;
            return PeriodConcurrentDictionary.GetOrAdd(periodName, GetFundingPeriodFromCrm);
        }

        private sfa_period GetFundingPeriodFromCrm(string periodName)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (from p in xrmServiceContext.sfa_periodSet
                        where p.sfa_periodname == periodName
                        select p).Single();
            }
        }

        private sfa_claimreconallocgroup GetAllocationGroup(AllocationGroup allocationGroup)
        {
            return AllocGroupConcurrentDictionary.GetOrAdd(allocationGroup.AllocationGroupCode, GetAllocationGroupFromCrm);
        }

        private sfa_claimreconallocgroup GetAllocationGroupFromCrm(string allocationGroupCode)
        {
            using (var xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return (from ag in xrmServiceContext.sfa_claimreconallocgroupSet
                        where ag.sfa_AllocationGroupCode == allocationGroupCode
                        select ag).Single();
            }
        }
    }
}