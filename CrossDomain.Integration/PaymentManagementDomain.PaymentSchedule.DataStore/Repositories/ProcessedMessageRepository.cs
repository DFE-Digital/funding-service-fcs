namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using CrossDomain.Integration.Entities.Data;
    using Model;

    public class ProcessedMessageRepository : IProcessedMessageRepository
    {
        public bool Add(string messageId, ConnectionInfo connectionInfo)
        {
            const int violationOfPrimaryKeyConstraint = 2627;

            try
            {
                using (var context = new PaymentSchedulePolicyContext(connectionInfo.Connection, connectionInfo.Transaction))
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
