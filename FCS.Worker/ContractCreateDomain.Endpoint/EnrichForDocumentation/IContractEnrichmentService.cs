namespace ContractCreateDomain.Endpoint.EnrichForDocumentation
{
    using System;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IContractEnrichmentService
    {
        Task EnrichContractWithOrganisationData(Contract corporateContract,
            string masterContractNumber,
            ConnectionInfo connectionInfo,
            Func<int, organisation> getOrganisation);
    }
}