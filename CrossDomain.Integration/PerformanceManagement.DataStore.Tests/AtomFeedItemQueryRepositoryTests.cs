namespace PerformanceManagement.DataStore.Tests
{
    using System.Data.SqlClient;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories.Atom;
    using UnitTests.Common;

    [TestClass]
    public class AtomFeedItemQueryRepositoryTests
    {
        const int UkprnTest = -9;

        [TestInitialize, TestCleanup]
        public void ClearData()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.AtomFeedItems.RemoveAll();
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AtomFeedItemQueryRepository_ShouldGetNextPageNumberAsNull_WhenTheNextPageIsTheLatest()
        {
            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                for (int i = 0; i < 21; i++)
                {
                    context.AtomFeedItems.Add(new AtomFeedItem(AtomItemType.Published, UkprnTest, "some claim",
                    $"some allocation {i}", "1617", "xml"));
                }
                
                context.SaveChanges();
            }

            SqlConnection connection = new SqlConnection(new PerformanceManagementDbContext().Database.Connection.ConnectionString);
            // act
            int? nextPageNumber = null;
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
                AtomFeedItemQueryRepository repository = new AtomFeedItemQueryRepository(connection);
                // the page number is zero based
                nextPageNumber = repository.GetNextPageNumber(1);
            }

            // assert
            Assert.AreEqual(null, nextPageNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AtomFeedItemQueryRepository_ShouldGetNextPageNumberAsANumber_WhenTheNextPageIsNotTheLatest()
        {
            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                for (int i = 0; i < 21; i++)
                {
                    context.AtomFeedItems.Add(new AtomFeedItem(AtomItemType.Published, UkprnTest, "some claim",
                    $"some allocation {i}", "1617", "xml"));
                }

                context.SaveChanges();
            }
            SqlConnection connection = new SqlConnection(new PerformanceManagementDbContext().Database.Connection.ConnectionString);
            // act
            int? nextPageNumber = null;
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
                AtomFeedItemQueryRepository repository = new AtomFeedItemQueryRepository(connection);
                // the page number is zero based
                nextPageNumber = repository.GetNextPageNumber(0);
            }

            // assert
            Assert.AreEqual(1, nextPageNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AtomFeedItemQueryRepository_ShouldGetPreviousPageNumberAsCorrectNumber_WhenOneIsAvailable()
        {
            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                for (int i = 0; i < 21; i++)
                {
                    context.AtomFeedItems.Add(new AtomFeedItem(AtomItemType.Published, UkprnTest, "some claim",
                    $"some allocation {i}", "1617", "xml"));
                }

                context.SaveChanges();
            }

            SqlConnection connection = new SqlConnection(new PerformanceManagementDbContext().Database.Connection.ConnectionString);
            // act
            int? previousPageNumber = null;
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
                AtomFeedItemQueryRepository repository = new AtomFeedItemQueryRepository(connection);
                // the page number is zero based
                previousPageNumber = repository.GetPreviousPageNumber(1);
            }

            // assert
            Assert.AreEqual(0, previousPageNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AtomFeedItemQueryRepository_ShouldGetPreviousPageNumberAsnull_WhenOneIsNotAvailable()
        {
            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                for (int i = 0; i < 21; i++)
                {
                    context.AtomFeedItems.Add(new AtomFeedItem(AtomItemType.Published, UkprnTest, "some claim",
                    $"some allocation {i}", "1617", "xml"));
                }

                context.SaveChanges();
            }
            SqlConnection connection = new SqlConnection(new PerformanceManagementDbContext().Database.Connection.ConnectionString);
            // act
            int? previousPageNumber = null;
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
                AtomFeedItemQueryRepository repository = new AtomFeedItemQueryRepository(connection);
                // the page number is zero based
                previousPageNumber = repository.GetPreviousPageNumber(0);
            }

            // assert
            Assert.AreEqual(null, previousPageNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AtomFeedItemQueryRepository_ShouldGetEntitiesForPage_WhenWeHaveAFullPageOfRows()
        {
            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                for (int i = 0; i < 21; i++)
                {
                    context.AtomFeedItems.Add(new AtomFeedItem(AtomItemType.Published, UkprnTest, "some claim",
                    $"some allocation {i}", "1617", "xml"));
                }

                context.SaveChanges();
            }
            SqlConnection connection = new SqlConnection(new PerformanceManagementDbContext().Database.Connection.ConnectionString);

            // act
            StoragePage<AtomFeedItem> storagePage = null;
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
                AtomFeedItemQueryRepository repository = new AtomFeedItemQueryRepository(connection);
                // the page number is zero based
                storagePage = repository.GetEntitiesForPage(0);
            }

            // assert
            Assert.AreEqual(10, storagePage.Rows.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AtomFeedItemQueryRepository_GetEntitiesForLatestPage_ShouldGetExpectedNumberOfEntitiesWhenTheLastPageIsPartiallyFull()
        {
            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                for (int i = 0; i < 21; i++)
                {
                    context.AtomFeedItems.Add(new AtomFeedItem(AtomItemType.Published, UkprnTest, "some claim",
                    $"some allocation {i}", "1617", "xml"));
                }

                context.SaveChanges();
            }
            SqlConnection connection = new SqlConnection(new PerformanceManagementDbContext().Database.Connection.ConnectionString);
            // act
            StoragePage<AtomFeedItem> storagePage = null;
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
                AtomFeedItemQueryRepository repository = new AtomFeedItemQueryRepository(connection);

                storagePage = repository.GetEntitiesForLatestPage();
            }

            // assert
            Assert.AreEqual(1, storagePage.Rows.Count, "Incorrect number of entities returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AtomFeedItemQueryRepository_GetEntitiesForLatestPage_ShouldGetTenEntitiesForLatestPageWhenTotalEntityCountIsDivisibleByTen()
        {
            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                for (int i = 0; i < 20; i++)
                {
                    context.AtomFeedItems.Add(new AtomFeedItem(AtomItemType.Published, UkprnTest, "some claim",
                    $"some allocation {i}", "1617", "xml"));
                }

                context.SaveChanges();
            }
            SqlConnection connection = new SqlConnection(new PerformanceManagementDbContext().Database.Connection.ConnectionString);
            // act
            StoragePage<AtomFeedItem> storagePage = null;
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
                AtomFeedItemQueryRepository repository = new AtomFeedItemQueryRepository(connection);
                
                storagePage = repository.GetEntitiesForLatestPage();
            }

            // assert
            Assert.AreEqual(10, storagePage.Rows.Count, "Incorrect number of entities returned.");
        }
    }
}
