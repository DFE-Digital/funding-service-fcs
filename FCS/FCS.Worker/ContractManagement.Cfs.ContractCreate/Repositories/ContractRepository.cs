namespace ContractManagement.Cfs.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class ContractRepository : IContractRepository
    {
        private readonly IOrganizationService _organizationService;

        public ContractRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public EntityReference GetChildContractEntityReference(Guid masterContractId)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                var childContractId = xrmContext.sfa_contractSet.Single(c => c.sfa_ParentContractId.Id == masterContractId).Id;
                return new EntityReference(sfa_contract.EntityLogicalName, childContractId);
            }
        }
    }
}