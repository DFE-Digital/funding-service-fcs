namespace DocumentsDomain.Endpoint.ArchiveDocument.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using System.Threading.Tasks;

    public interface IArchivedDocumentRepository 
    {
        Task Add(ArchivedDocument archivedDocument, ConnectionInfo connectionInfo);
    }
}