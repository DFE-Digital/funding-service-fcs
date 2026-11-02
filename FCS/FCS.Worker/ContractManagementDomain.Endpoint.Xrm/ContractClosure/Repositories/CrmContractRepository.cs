namespace ContractManagementDomain.Endpoint.Xrm.ContractClosure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmContractRepository : ICrmContractRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmContractRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public bool IsContractClosed(string contractNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return xrmServiceContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_ContractStatus.Value == (int)sfa_contractstatus.Closed)
                    .Select(c => c.Id)
                    .ToList()
                    .Any();
            }
        }

        public Guid GetContractId(string contractNumber, int version, int subVersion)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return xrmServiceContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == version && c.sfa_SubVersion == subVersion)
                    .Select(c => c.Id)
                    .Single();
            }
        }

        public IReadOnlyCollection<Guid> GetAllocationIdsForContract(string contractNumber, int version, int subVersion)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return
                    (from a in xrmServiceContext.sfa_contractallocationSet
                     join c in xrmServiceContext.sfa_contractSet on a.sfa_ContractId.Id equals c.Id
                     where c.sfa_number == contractNumber && c.sfa_Version == version && c.sfa_SubVersion == subVersion
                     select a.Id)
                    .ToList();
            }
        }

        public void UpdateContract(sfa_contract contract)
        {
            _organizationService.Update(contract);
        }
    }
}