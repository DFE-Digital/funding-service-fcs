namespace ContractCreateDomain.IncrementContractVersionEndpoint.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class AllocationNumberRepository : IAllocationNumberRepository
    {
        private readonly IOrganizationService _organizationService;

        public AllocationNumberRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public string GetAllocationNumberPrefix(string fundingStreamPeriodCode)
        {
            using (var context = new XrmServiceContext(_organizationService))
            {
                return (from fsp in context.sfa_fundingstreamperiodSet
                    where fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                    select fsp.sfa_AllocationReferencePrefix).Single();
            }
        }

        private string UpdateAndGetContractAllocationNumber(Guid ContractNumberEntityId)
        {
            OrganizationRequest executeGenerateContractNumber = new OrganizationRequest("sfa_GenerateContractNumber");
            executeGenerateContractNumber.Parameters["Target"] = new EntityReference("sfa_contractnumber", ContractNumberEntityId);

            var results = _organizationService.Execute(executeGenerateContractNumber);

            return results.Results["NextContractNumber"].ToString();
        }

        private class ContractNumberInfo
        {
            public ContractNumberInfo(string allocationReferencePrefix, Guid contractNumberEntityId)
            {
                AllocationReferencePrefix = allocationReferencePrefix;
                ContractNumberEntityId = contractNumberEntityId;
            }

            public string AllocationReferencePrefix { get; }

            public Guid ContractNumberEntityId { get; }
        }
    }
}