namespace DocumentsDomain.Endpoint.ArchiveDocument.Services
{
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IPolicyQueryService
    {
        Task<bool> ShouldGenerateDocumentationForContract(contract corporateContract, ConnectionInfo connectionInfo);
    }
}
