namespace ContractManagement.Cfs.ContractCreate.Repositories
{
    using System;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class AllocationRepository : IAllocationRepository
    {
        private readonly IOrganizationService _organizationService;

        public AllocationRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public void ReleaseAllocation(Guid allocationId, EntityReference contractEntityReference)
        {
            var allocation = new sfa_allocation
            {
                Id = allocationId,
                sfa_contract = contractEntityReference,
                sfa_serviceresponse = new OptionSetValue((int) sfa_AllocationServiceResponse.Released)
            };

            _organizationService.Update(allocation);
        }
    }
}