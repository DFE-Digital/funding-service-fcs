namespace ContractRequestDomain.DataStore.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class FileWatcherLockResourceRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FileWatcherLockResourceRepository_CanAcquireLock_ShouldReturnFalseIfAnotherContextHasTheLock()
        {
            using (var context = new ContractRequestDbContext())
            {
                using (var tx = context.Database.BeginTransaction())
                {
                    FileWatcherLockResourceRepository repository = new FileWatcherLockResourceRepository();

                    //context.Database.ExecuteSqlCommand(@"
                    //SELECT *
                    //    FROM[ContractRequest].[FileWatcherLockResource] WITH(ROWLOCK, XLOCK)
                    //where identifier = 'Lock'");
                   
                    bool canAcquire = repository.CanAcquireLock(new ConnectionInfo(tx.UnderlyingTransaction,
                        context.Database.Connection));

                    Assert.IsFalse(canAcquire);
                     
                }
            }
        }
    }
}
