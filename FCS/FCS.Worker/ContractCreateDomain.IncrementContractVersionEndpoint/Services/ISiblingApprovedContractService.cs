namespace ContractCreateDomain.IncrementContractVersionEndpoint.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISiblingApprovedContractService
    {
        Task<List<ApprovedContractInfo>> GetSiblingApprovedContractsForDocumentGeneration(
            string masterContractNumber, string currentContractNumber, string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo);
    }
}