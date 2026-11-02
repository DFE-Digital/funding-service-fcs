namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using UnitTests.Common;

    [TestClass]
    public class RoatpProviderRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void RoatpProviderRepository_ShouldDetermineIfProviderIsNotOnRoatp()
        {
            // arrange 
            const string ukprnToTest = "78901256";

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.RoatpProviders.RemoveWhere(p => p.Ukprn == ukprnToTest);
                context.SaveChanges();
            }

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IRoatpProviderRepository repository = new RoatpProviderRepository(context);

                // act & assert
                Assert.IsFalse(repository.IsProviderOnRoatp(ukprnToTest), "Repository incorrectly returned true (provider is on RoATP)");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RoatpProviderRepository_ShouldDetermineIfProviderIsOnRoatp()
        {
            // arrange 
            const string ukprnToTest = "78901256";

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                if (context.RoatpProviders.Find(ukprnToTest) == null)
                {
                    context.RoatpProviders.Add(new RoatpProvider(ukprnToTest));
                    context.SaveChanges();
                }
            }

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IRoatpProviderRepository repository = new RoatpProviderRepository(context);

                // act & assert
                Assert.IsTrue(repository.IsProviderOnRoatp(ukprnToTest), "Repository incorrectly returned false (provider is not on RoATP)");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RoatpProviderRepository_ReplaceRoatpCache_ShouldRemoveAllExistingEntriesAndAddAllNewEntries()
        {
            // arrange
            const int originalMin = 10000000;
            const int originalCount = 1000;
            const int newMin = 20000000;
            const int newCount = 1002;

            var originalProviders = Enumerable.Range(originalMin, originalCount).Select(i => i.ToString());
            var newProviders = Enumerable.Range(newMin, newCount).Select(i => i.ToString());

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IRoatpProviderRepository repository = new RoatpProviderRepository(context);
                repository.ReplaceRoatpCache(originalProviders);
            }

            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                Assert.AreEqual(originalCount, context.RoatpProviders.Count(), "The count of inserted UKPRNs before replace was incorrect");
                Assert.IsTrue(context.RoatpProviders.All(p => p.Ukprn.StartsWith("1000")), "There are UKPRNs that should have been deleted");
            }

            // act
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                IRoatpProviderRepository repository = new RoatpProviderRepository(context);
                repository.ReplaceRoatpCache(newProviders);
            }

            // assert
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                Assert.AreEqual(newCount, context.RoatpProviders.Count(), "The count of inserted UKPRNs after replace was incorrect");
                Assert.IsTrue(context.RoatpProviders.All(p => p.Ukprn.StartsWith("2000")), "There are UKPRNs that should have been deleted after replace");
            }
        }
    }
}