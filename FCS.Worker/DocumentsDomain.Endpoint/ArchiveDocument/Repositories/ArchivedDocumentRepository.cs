namespace DocumentsDomain.Endpoint.ArchiveDocument.Repositories
{
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using System.Threading.Tasks;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ArchivedDocumentRepository : IArchivedDocumentRepository
    {
        private readonly ILogger _logger;

        public ArchivedDocumentRepository(ILogger logger)
        {
            _logger = logger;
        }

        public async Task Add(ArchivedDocument archivedDocument, ConnectionInfo connectionInfo)
        {
            const int violationOfPrimaryIndex = 2627;
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                context.ArchivedDocuments.Add(archivedDocument);
                try
                {
                    await context.SaveChangesAsync().ConfigureAwait(continueOnCapturedContext: false);
                }
                catch (DbUpdateException ex) when (ex.InnerException?.InnerException is SqlException exception &&
                                                   exception.Number == violationOfPrimaryIndex
                ) 
                {
                    // do nothing for a primary key exception, just log
                    _logger.LogInformation(1, $"ArchivedDocumentRepository - tried to add duplicate: {archivedDocument}");
                }
            }
        }
    }
}