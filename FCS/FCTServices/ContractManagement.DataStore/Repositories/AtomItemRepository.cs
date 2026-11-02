namespace ContractManagement.DataStore.Repositories
{
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using Exceptions;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public abstract class AtomItemRepository : AtomItemQueryRepository, IAtomItemRepository
    {
        protected readonly IContractManagementDbContext _context;

        protected AtomItemRepository(IContractManagementDbContext contractManagementDbContext)
            : base(new SqlConnection(contractManagementDbContext.Connection.ConnectionString))
        {
            _context = contractManagementDbContext;
        }

        public void Add(AtomFeedItem atomFeedItem)
        {
            try
            {
                _context.AtomFeedItems.Add(atomFeedItem);
                _context.SaveChanges();
            }
            catch (DbUpdateException ex) when (ex.InnerException?.InnerException is SqlException && ((SqlException)ex.InnerException.InnerException).Number == 2601) // Handle duplicate key exception
            {
                var exceptionToThrow = new SqlDuplicateKeyStorageException(ex);
                throw exceptionToThrow;
            }
        }

        public void Add(AtomFeedItem atomFeedItem, ConnectionInfo connectionInfo)
        {
            
                try
                { 
                    var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction);
                    context.AtomFeedItems.Add(atomFeedItem);
                    context.SaveChanges();
                }
                catch (DbUpdateException ex) when (ex.InnerException?.InnerException is SqlException && ((SqlException)ex.InnerException.InnerException).Number == 2601) // Handle duplicate key exception
                {
                    var exceptionToThrow = new SqlDuplicateKeyStorageException(ex);
                    throw exceptionToThrow;
                }
        }
    }
}
