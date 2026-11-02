namespace SFA.FCT.ContractRequestDomain.DataStore.Repositories
{
    using System;
    using System.Data.Entity.Infrastructure;
    using System.Linq;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class FileWatcherLockResourceRepository : IFileWatcherLockResourceRepository
    {
        public bool CanAcquireLock(ConnectionInfo connectionInfo)
        {
            const int timeToWaitForLockSeconds = 2;
            try
            {
                using (var context = new ContractRequestDbContext(connectionInfo.Connection))
                {
                    context.Database.UseTransaction(connectionInfo.Transaction);
                   
                        context.Database.CommandTimeout = timeToWaitForLockSeconds;
                        DbRawSqlQuery<FileWatcherLockResource> query = context.Database.SqlQuery<FileWatcherLockResource>(
                            sql: @"SELECT *
                FROM [ContractRequest].[FileWatcherLockResource] WITH (ROWLOCK, XLOCK)
                where identifier = 'Lock'");

                        query.ToList();

                        return true;
                }
            }
            catch (Exception e)
                when (e.Message.Contains("Execution Timeout Expired"))
            {
                return false;
            }
        }

        public ConnectionInfo GetTransactionedConnectionInfo()
        {
            var context = new ContractRequestDbContext();
            var tx = context.Database.BeginTransaction();

            return new ConnectionInfo(tx.UnderlyingTransaction, context.Database.Connection);
        }
    }
}
