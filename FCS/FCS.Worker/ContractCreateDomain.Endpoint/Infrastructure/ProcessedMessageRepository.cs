namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ProcessedMessageRepository : IProcessedMessageRepository
    {
        public bool Add(string messageId, ConnectionInfo connectionInfo)
        {
            const int violationOfPrimaryKeyConstraint = 2627;

            try
            {
                using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
                {
                    context.ProcessedMessages.Add(new ProcessedMessage(messageId));
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
