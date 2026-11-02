namespace ContractManagement.DataStore.Repositories
{
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using Model;

    public class ProcessedMessageRepository : IProcessedMessageRepository
    {
        private readonly IContractManagementDbContext _dbContext;

        public ProcessedMessageRepository(IContractManagementDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public bool Add(string messageId)
        {
            const int violationOfPrimaryKeyConstraint = 2627;

            try
            {
                _dbContext.ProcessedMessages.Add(new ProcessedMessage(messageId));
                _dbContext.SaveChanges();

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
