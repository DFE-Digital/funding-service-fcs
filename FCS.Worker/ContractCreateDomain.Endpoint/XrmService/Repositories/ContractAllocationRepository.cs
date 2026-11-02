namespace ContractCreateDomain.Endpoint.XrmService.Repositories
{
    using System;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class ContractAllocationRepository : IContractAllocationCommandRepository
    {
        private readonly IOrganizationService _organizationService;

        public ContractAllocationRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public void DeleteAllocation(Guid allocationId)
        {
            try
            {
                _organizationService.Delete(sfa_contractallocation.EntityLogicalName, allocationId);
            }
            catch (Exception ex)
                when (ex.Message.ToLowerInvariant().Contains("found"))
            {
            }
        }
    }
}
