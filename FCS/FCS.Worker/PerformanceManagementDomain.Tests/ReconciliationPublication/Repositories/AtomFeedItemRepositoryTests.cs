namespace PerformanceManagementDomain.Tests.ReconciliationPublication.Repositories
{
    using System.Data.SqlClient;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationPublication.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using UnitTests.Common;

    [TestClass]
    public class AtomFeedItemRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AtomFeedItemCommandRepository_ShouldAddNewItem()
        {
            const int ukprn = 1234;
            const string allocationGroupName = "AGN";
            const string claimTypeName = "CTN";
            const string period = "1234";

            // Arrange
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                context.Database.ExecuteSqlCommand(
                    "DELETE FROM PerformanceManagement.AtomFeedItem WHERE Ukprn = @ukprn AND AllocationGroupName = @allocationGroupName AND ClaimTypeName = @claimTypeName AND Period = @period",
                    new SqlParameter("@ukprn", ukprn),
                    new SqlParameter("@allocationGroupName", allocationGroupName),
                    new SqlParameter("@claimTypeName", claimTypeName),
                    new SqlParameter("@period", period));
            }

            AtomFeedItem returnedAtomFeedItem;

            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                AtomFeedItemRepository commandRepository = new AtomFeedItemRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                AtomFeedItem atomFeedItem = new AtomFeedItem(AtomItemType.Published, ukprn, claimTypeName, allocationGroupName, period, "<XML></XML>");

                // Act
                commandRepository.Add(connectionInfo, atomFeedItem).Wait();
                returnedAtomFeedItem = commandRepository.GetByUkprnClaimTypeAllocationGroupAndPeriod(
                    connectionInfo, ukprn, claimTypeName, allocationGroupName, period).Result;
            }

            // Assert
            Assert.IsNotNull(returnedAtomFeedItem, "Performance Management Atom Feed Item was not stored");
            Assert.AreEqual(ukprn, returnedAtomFeedItem.Ukprn, "Returned Atom Item is not as expected");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AtomFeedItemQueryRepository_ShouldGetByUkprnClaimTypeAllocationGroupAndPeriod()
        {
            const int UkprnTest = -9;

            // arrange
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                context.AtomFeedItems.RemoveAll();
                context.AtomFeedItems.Add(new AtomFeedItem(AtomItemType.Published, UkprnTest, "some claim", "some allocation 1", "1617", "xml"));
                context.SaveChanges();
            }

            AtomFeedItem atomFeedItem;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                AtomFeedItemRepository repository = new AtomFeedItemRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                atomFeedItem = repository.GetByUkprnClaimTypeAllocationGroupAndPeriod(
                    connectionInfo, UkprnTest, "some claim", "some allocation 1", "1617").Result;
            }

            // assert
            Assert.IsNotNull(atomFeedItem);
        }
    }
}
