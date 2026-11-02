namespace ContractRequestDomain.Cfs.Xrm.Repositories
{
    using System.Collections.Generic;
    using ContractRequestDomain.Cfs.Common.Dtos;
    using ContractRequestDomain.Cfs.Xrm.Extensions;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class AllocationRepository : IAllocationRepository
    {
        private readonly IOrganizationService _organizationService;
        private readonly LookupRepository _lookupRepository;
        public static readonly Relationship AllocationToAllocationPeriodRelationship = new Relationship("sfa_sfa_allocation_sfa_allocationperiod_allocation");

        public AllocationRepository(IOrganizationService organizationService, LookupRepository lookupRepository)
        {
            _organizationService = organizationService;
            _lookupRepository = lookupRepository;
        }

        public void CreateAllocationAndPeriods(Allocation allocation)
        {
            sfa_allocation crmAllocation = allocation.ToCrmAllocation();

            crmAllocation.sfa_provider = _lookupRepository.GetOrgEntityReference(allocation.Ukprn.ToString());
            crmAllocation.sfa_fundingtype = _lookupRepository.GetFundingTypeEntityReference(allocation.FundingTypeCode);
            crmAllocation.sfa_fundingstreamperiod = _lookupRepository.GetFundingStreamPeriodEntityReference(allocation.FundingStreamPeriodCode);
            crmAllocation.sfa_fundingperiod = _lookupRepository.GetFundingPeriodEntityReference(allocation.FundingPeriod);
            crmAllocation.sfa_deliverable = _lookupRepository.GetDeliverableEntityReference(allocation.FundingStreamPeriodCode, allocation.DeliverableCode);

            var crmAllocationperiods = CreateAllocationPeriods(allocation.AllocationPeriods);

            var allocationPeriodRelationship = AllocationToAllocationPeriodRelationship;
            crmAllocation.RelatedEntities.Add(allocationPeriodRelationship, crmAllocationperiods);

            _organizationService.Create(crmAllocation);
        }

        private static EntityCollection CreateAllocationPeriods(List<AllocationPeriod> allocationPeriods)
        {
            var crmAllocationperiods = new EntityCollection
            {
                EntityName = sfa_allocationperiod.EntityLogicalName
            };

            allocationPeriods.ForEach(ap =>
                crmAllocationperiods.Entities.Add(ap.ToCrmAllocationPeriod())
            );

            return crmAllocationperiods;
        }
    }
}
