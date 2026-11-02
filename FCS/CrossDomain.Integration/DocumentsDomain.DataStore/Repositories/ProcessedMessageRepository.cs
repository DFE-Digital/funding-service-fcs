namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using CrossDomain.Integration.Entities.Data;
    using Models;

    public class ProcessedMessageRepository : IProcessedMessageRepository
    {
        public bool Add(string messageId, string processingEndpoint, ConnectionInfo connectionInfo)
        {
            const int violationOfPrimaryKeyConstraint = 2627;

            try
            {
                using (var context = new DocumentsDomainDbContext(connectionInfo))
                {
                    context.ProcessedMessages.Add(new ProcessedMessage(messageId, processingEndpoint));
                    context.SaveChanges();
                }

                return true;
            }
            catch (DbUpdateException ex)
                when (ex.InnerException?.InnerException is SqlException && ((SqlException)ex.InnerException.InnerException).Number == violationOfPrimaryKeyConstraint)
            {
                return false;
            }
        }
    }
}
