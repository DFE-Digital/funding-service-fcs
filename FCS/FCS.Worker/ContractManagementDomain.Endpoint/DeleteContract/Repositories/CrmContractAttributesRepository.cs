namespace ContractManagementDomain.Endpoint.DeleteContract.Repositories
{
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmContractAttributesRepository : ICrmContractAttributesRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmContractAttributesRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public ContractAttributes GetAttributesForContract(string contractNumber, int version)
        {
            using (var context = new XrmServiceContext(_organizationService))
            {
                return (from c in context.sfa_contractSet
                    join o in context.AccountSet on c.sfa_ProviderName.Id equals o.AccountId.Value
                    join ft in context.sfa_fundingtypeSet on c.sfa_FundingType.Id equals ft.Id
                    join p in context.sfa_periodSet on c.sfa_PeriodId.Id equals p.sfa_periodId.Value
                    where c.sfa_number == contractNumber && c.sfa_Version == version
                    select new ContractAttributes(o.sfa_UKPRN, ft.sfa_fundingtypecode, p.sfa_Period)).First();
            }
        }
    }
}
