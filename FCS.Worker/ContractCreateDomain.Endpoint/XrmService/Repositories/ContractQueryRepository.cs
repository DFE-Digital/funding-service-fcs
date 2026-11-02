namespace ContractCreateDomain.Endpoint.XrmService.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DTOs;
    using Microsoft.Xrm.Sdk;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class ContractQueryRepository : IContractQueryRepository
    {
        private readonly IOrganizationService _organizationService;

        public ContractQueryRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public Option<CrmContractInfo> GetContractInfo(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                var contractInfo = xrmServiceContext.sfa_contractSet.Where(c =>
                        c.sfa_number == contractNumber && c.sfa_Version == versionNumber &&
                        c.sfa_SubVersion == subVersionNumber).Select(c => new {Id = c.sfa_contractId.Value, c.sfa_number})
                    .SingleOrDefault();

                if (contractInfo == null)
                {
                    return new Option<CrmContractInfo>();
                }
            
                var allocationNumbers = xrmServiceContext.sfa_contractallocationSet.Where(a => a.sfa_ContractId.Id == contractInfo.Id)
                    .Select(a => a.sfa_contractallocationnumber).ToList();

                return new CrmContractInfo(contractInfo.Id, contractInfo.sfa_number,
                    allocationNumbers.Select(a => new CrmAllocationInfo(a)).ToList()).Some();
            }
        }

        public IReadOnlyCollection<Guid> GetAllocationIds(
            string contractNumber,
            int versionNumber,
            int subVersionNumber,
            string allocationNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {

                return (from c in xrmServiceContext.sfa_contractSet
                        join a in xrmServiceContext.sfa_contractallocationSet
                            on c.sfa_contractId.Value equals a.sfa_ContractId.Id
                        where c.sfa_number == contractNumber && c.sfa_Version == versionNumber &&
                              c.sfa_SubVersion == subVersionNumber &&
                              a.sfa_contractallocationnumber == allocationNumber

                        select a.sfa_contractallocationId.Value)
                    .ToList();
            }
        }
    }
}
