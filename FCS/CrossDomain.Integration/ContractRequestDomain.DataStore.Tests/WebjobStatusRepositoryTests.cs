namespace ContractRequestDomain.DataStore.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class WebjobStatusRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FileWatcherLockResourceRepository_CanAcquireLock_ShouldReturnFalseIfAnotherContextHasTheLock()
        {
            using (var context = new ContractRequestDbContext())
            {
                WebjobStatusRepository webjobStatusRepository = new WebjobStatusRepository();
                var data = webjobStatusRepository.GetJobStatus("EngagmenetWatcherWebjob");

                Assert.IsTrue(data);
            }
        }
    }
}
