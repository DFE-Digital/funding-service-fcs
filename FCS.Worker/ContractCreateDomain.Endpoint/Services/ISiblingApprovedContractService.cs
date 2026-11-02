namespace ContractCreateDomain.Endpoint.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISiblingApprovedContractService
    {
        Task<IReadOnlyCollection<ApprovedContractInfo>> GetSiblingApprovedContractsForDocumentGeneration(string masterContractNumber, string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo);

        Task<IReadOnlyCollection<ApprovedContractInfo>> GetSiblingApprovedContractsForDocumentGeneration(string masterContractNumber, string currentContractNumber, string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo);
    }
}
