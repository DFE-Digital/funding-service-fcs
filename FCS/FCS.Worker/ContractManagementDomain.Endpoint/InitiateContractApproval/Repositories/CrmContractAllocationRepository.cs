namespace ContractManagementDomain.Endpoint.InitiateContractApproval.Repositories
{
    using System;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmContractAllocationRepository : ICrmContractAllocationRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmContractAllocationRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public void UpdateStartDate(Guid allocationId, DateTime startDateTime)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                Id = allocationId,
                sfa_startdate = startDateTime,
                EntityState = EntityState.Changed
            };

            _organizationService.Update(allocation);
        }
    }
}
