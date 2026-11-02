namespace ContractManagementDomain.Termination.Xrm.Repositories
{
    using System;
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

        public void OverwriteNullEndDateWithTerminationDate(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                var contractWithNullEndDateIdAndTerminationDate =
                    (from c in xrmServiceContext.sfa_contractSet
                     where c.sfa_number == contractNumber && c.sfa_Version == versionNumber &&
                               c.sfa_SubVersion == subVersionNumber && c.sfa_EndDate == null
                     select new { Id = c.sfa_contractId, TerminationDate = c.sfa_terminationdate })
                    .SingleOrDefault();

                if (contractWithNullEndDateIdAndTerminationDate?.Id != null)
                {
                    sfa_contract contract = new sfa_contract
                    {
                        Id = contractWithNullEndDateIdAndTerminationDate.Id.Value,
                        sfa_EndDate = contractWithNullEndDateIdAndTerminationDate.TerminationDate
                    };

                    _organizationService.Update(contract);
                }
            }
        }

        public void OverwriteNullAllocationEndDatesWithTerminationDates(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                var contractAllocationIdsWithNullEndDate =
                    (from c in xrmServiceContext.sfa_contractSet
                     join a in xrmServiceContext.sfa_contractallocationSet
                         on c.sfa_contractId equals a.sfa_ContractId.Id
                     where c.sfa_number == contractNumber && c.sfa_Version == versionNumber &&
                           c.sfa_SubVersion == subVersionNumber && a.sfa_enddate == null
                     select new { Id = a.sfa_contractallocationId, TerminationDate = a.sfa_terminationdate })
                    .ToList();

                contractAllocationIdsWithNullEndDate
                    .Select(alloc =>
                        new sfa_contractallocation
                        {
                            Id = alloc.Id.Value,
                            sfa_enddate = alloc.TerminationDate
                        })
                    .ToList()
                    .ForEach(a => _organizationService.Update(a));
            }
        }

        public void UpdateServiceResponseOnContract(string contractNumber, int version, int subVersion, sfa_serviceresponse serviceresponse)
        {
            sfa_contract contract = new sfa_contract
            {
                Id = GetContractId(contractNumber, version, subVersion),
                sfa_ServiceResponse = new OptionSetValue((int)serviceresponse)
            };

            _organizationService.Update(contract);
        }

        private Guid GetContractId(string contractNumber, int version, int subVersion)
        {
            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                return xrmServiceContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == version && c.sfa_SubVersion == subVersion)
                    .Select(c => c.Id)
                    .Single();
            }
        }

    }
}