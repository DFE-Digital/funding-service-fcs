namespace ContractCreateDomain.Endpoint.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISiblingContractCheckService
    {
        bool HasSiblingContractWithDraftStatus(string masterContractNumber, string contractNumber, string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo);
    }
}