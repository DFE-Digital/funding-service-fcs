namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.Operations.Integrity.Repositories;
    using Dapper;

    [TestClass]
    public class ClosedCollectionRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ClosedCollectionRepository_GetLastClosedTime_ShouldReturnLatestClosedTimeForACollectionType()
        {
            // arrange

            var date = RemoveMillisecondsFromDateTime(DateTime.Today);
            var testDateTime = date.AddHours(-1);
            const string randomCollectionType = "CollTypeRandom";
            const string testCollectionType = "CollTypeIntegTest";

            ClearDownAllClosedCollectionsHavingCollectionType(testCollectionType);
            ClearDownAllClosedCollectionsHavingCollectionType(randomCollectionType);

            CreateClosedCollection(testCollectionType, "100", date.AddMonths(-3));
            CreateClosedCollection(testCollectionType, "120", date.AddMonths(-2));
            CreateClosedCollection(testCollectionType, "130", date.AddMonths(-1));
            CreateClosedCollection(testCollectionType, "140", testDateTime);

            CreateClosedCollection(randomCollectionType, "900", date.AddYears(1));

            var repository = new ClosedCollectionRepository(new LocalConfig());

            // act
            var assertDateTime = repository.GetLastClosedTime(testCollectionType);

            // assert
            Assert.AreEqual(testDateTime, assertDateTime);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ClosedCollectionRepository_GetLatestCollectionCodeForCollectionType_ShouldReturnLatestCollectionCodeForCollectionType()
        {
            // arrange
            var date = RemoveMillisecondsFromDateTime(DateTime.Today);
            var testReturnCode = 500;
            const string randomCollectionType = "CollTypeRandom";
            const string testCollectionType = "CollTypeIntegTest";

            ClearDownAllClosedCollectionsHavingCollectionType(testCollectionType);
            ClearDownAllClosedCollectionsHavingCollectionType(randomCollectionType);

            CreateClosedCollection(testCollectionType, (testReturnCode - 30).ToString(), date.AddMonths(-3));
            CreateClosedCollection(testCollectionType, (testReturnCode - 20).ToString(), date.AddMonths(-2));
            CreateClosedCollection(testCollectionType, (testReturnCode - 10).ToString(), date.AddMonths(-1));
            CreateClosedCollection(testCollectionType, testReturnCode.ToString(), date.AddHours(-1));

            CreateClosedCollection(randomCollectionType, "900", date.AddYears(1));

            var repository = new ClosedCollectionRepository(new LocalConfig());

            // act
            var assertReturnCode = repository.GetLatestCollectionCodeForCollectionType(testCollectionType);

            // assert
            Assert.AreEqual(testReturnCode.ToString(), assertReturnCode);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ClosedCollectionRepository_IsCollectionReturnPresent_ShouldReturnTrue()
        {
            // arrange
            var date = RemoveMillisecondsFromDateTime(DateTime.Today);
            var testReturnCode = 500;
            const string randomCollectionType = "CollTypeRandom";
            const string testCollectionType = "CollTypeIntegTest";

            ClearDownAllClosedCollectionsHavingCollectionType(testCollectionType);
            ClearDownAllClosedCollectionsHavingCollectionType(randomCollectionType);

            CreateClosedCollection(testCollectionType, (testReturnCode - 30).ToString(), date.AddMonths(-3));
            CreateClosedCollection(testCollectionType, (testReturnCode - 20).ToString(), date.AddMonths(-2));
            CreateClosedCollection(testCollectionType, (testReturnCode - 10).ToString(), date.AddMonths(-1));
            CreateClosedCollection(testCollectionType, testReturnCode.ToString(), date.AddHours(-1));

            CreateClosedCollection(randomCollectionType, "900", date.AddYears(1));

            var repository = new ClosedCollectionRepository(new LocalConfig());

            // act
            var assertIsCollectionReturnPresent = repository.IsCollectionReturnPresent(testCollectionType, testReturnCode.ToString());

            // assert
            Assert.IsTrue(assertIsCollectionReturnPresent);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ClosedCollectionRepository_IsCollectionReturnPresent_ShouldReturnFalse()
        {
            // arrange
            const int testReturnCode = 500;
            const string randomCollectionType = "CollTypeRandom";
            const string testCollectionType = "CollTypeIntegTest";

            ClearDownAllClosedCollectionsHavingCollectionType(testCollectionType);
            ClearDownAllClosedCollectionsHavingCollectionType(randomCollectionType);

            var repository = new ClosedCollectionRepository(new LocalConfig());

            // act
            var assertIsCollectionReturnPresent = repository.IsCollectionReturnPresent(testCollectionType, testReturnCode.ToString());

            // assert
            Assert.IsFalse(assertIsCollectionReturnPresent);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ClosedCollectionRepository_WasCollectionPulledInTheLast6Hours_ShouldReturnTrue()
        {
            // arrange
            var date = RemoveMillisecondsFromDateTime(DateTime.UtcNow);
            var lessThanSixHoursAgo = date.AddHours(-5.9);
            const string collectionType = "APPS";
            const string collectionReturnCode = "APPS14";

            ClearDownAllClosedCollectionsHavingCollectionType(collectionType);
            CreateClosedCollection(collectionType, collectionReturnCode, date.AddDays(-2));
            UpdateClosedCollectionCreatedDate(collectionType, collectionReturnCode, lessThanSixHoursAgo);

            var repository = new ClosedCollectionRepository(new LocalConfig());

            // act
            var assertDidItHappenInTheLast6Hours = repository.WasCollectionPulledInTheLast6Hours(collectionType);

            // assert
            Assert.IsTrue(assertDidItHappenInTheLast6Hours);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ClosedCollectionRepository_WasCollectionPulledInTheLast6Hours_ShouldReturnFalse()
        {
            // arrange
            var date = RemoveMillisecondsFromDateTime(DateTime.UtcNow);
            var moreThanSixHoursAgo = date.AddHours(-6.1);
            const string collectionType = "APPS";
            const string collectionReturnCode = "APPS14";

            ClearDownAllClosedCollectionsHavingCollectionType(collectionType);
            CreateClosedCollection(collectionType, collectionReturnCode, date.AddDays(-2));
            UpdateClosedCollectionCreatedDate(collectionType, collectionReturnCode, moreThanSixHoursAgo);

            var repository = new ClosedCollectionRepository(new LocalConfig());

            // act
            var assertDidItHappenInTheLast6Hours = repository.WasCollectionPulledInTheLast6Hours(collectionType);

            // assert
            Assert.IsFalse(assertDidItHappenInTheLast6Hours);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedCollectionRepository_HasCollectionBeenPulledWithinDuration_ShouldReturnTrueIfCreatedDateWithinDuration()
        {
            // arrange
            var date = RemoveMillisecondsFromDateTime(DateTime.UtcNow);
            const string collectionType = "APPS";
            const string collectionReturnCode = "APPS21";

            ClearDownAllClosedCollectionsHavingCollectionType(collectionType);
            CreateClosedCollection(collectionType, collectionReturnCode, date.AddHours(-11));

            var repository = new ClosedCollectionRepository(new LocalConfig());

            // act
            var hasCollectionBeenPulled = repository.HasCollectionBeenPulledWithinDuration(collectionType, TimeSpan.FromHours(12));

            // assert
            Assert.IsTrue(hasCollectionBeenPulled);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedCollectionRepository_HasCollectionBeenPulledWithinDuration_ShouldReturnFalseIfCreatedDateEarlier()
        {
            // arrange
            var date = RemoveMillisecondsFromDateTime(DateTime.UtcNow);
            const string collectionType = "APPS";
            const string collectionReturnCode = "APPS21";

            ClearDownAllClosedCollectionsHavingCollectionType(collectionType);
            CreateClosedCollection(collectionType, collectionReturnCode, date.AddHours(-13));

            var repository = new ClosedCollectionRepository(new LocalConfig());

            // act
            var hasCollectionBeenPulled = repository.HasCollectionBeenPulledWithinDuration(collectionType, TimeSpan.FromHours(12));

            // assert
            Assert.IsFalse(hasCollectionBeenPulled);
        }

        private static void ClearDownAllClosedCollectionsHavingCollectionType(string collectionType)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.ClosedCollections
                    .Where(cc => cc.CollectionType == collectionType).ToList()
                    .ForEach(cc => context.ClosedCollections.Remove(cc));

                context.SaveChanges();
            }
        }

        private static void UpdateClosedCollectionCreatedDate(string collectionType, string collectionReturnCode, DateTime createDate)
        {
            const string sql = @"  
                    UPDATE MonitoringDeliverables.ClosedCollection 
                    SET CreatedDate = @createDate
                    WHERE CollectionType = @collectionType
                    AND CollectionReturnCode = @collectionReturnCode";

            using (var sqlConnection = new MonitoringDeliverablesDbContext().Database.Connection)
            {
                sqlConnection.Execute(sql, new { collectionType, collectionReturnCode, createDate });
            }
        }

        private static void CreateClosedCollection(string collectionType, string collectionReturnCode, DateTime createdDate)
        {
            const string sql = @"  
                    insert into MonitoringDeliverables.ClosedCollection 
                    ([CollectionType]
                      ,[CollectionReturnCode]
                      ,[ClosedTime]
                      ,[TotalRowCount]
                      ,[RetrievedRowCount]
                      ,[CreatedDate])
                    VALUES (@collectionType, @collectionReturnCode, @createdDate, 1, 0, @createdDate)";

            using (var sqlConnection = new MonitoringDeliverablesDbContext().Database.Connection)
            {
                sqlConnection.Execute(sql, new { collectionType, collectionReturnCode, createdDate });
            }
        }

        private static DateTime RemoveMillisecondsFromDateTime(DateTime dateTime)
        {
            return new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, dateTime.Hour, dateTime.Minute, dateTime.Second);
        }
    }
}