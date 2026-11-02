namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.DTOs;

    [TestClass]
    public class SummarisedActualRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SummarisedActualRepository_GetSummarisedActualOrgFspGroupKeys_ShouldReturnGetSummarisedActualOrgFspGroupKeys()
        {
            // arrange
            const string randomCollectionType = "CollTypeRandom";

            const string testCollectionType = "CollTypeIntegTest";
            const string testOrgId = "OrgId";
            const string testFsp = "fsp";
            const string testUopcode = "Uopcode";

            // setup closedCollections
            ClearDownAllClosedCollectionsHavingCollectionType(testCollectionType);
            ClearDownAllClosedCollectionsHavingCollectionType(randomCollectionType);

            CreateClosedCollection(testCollectionType, "100", DateTime.Today.AddMonths(-3));
            CreateClosedCollection(testCollectionType, "200", DateTime.Today.AddMonths(-3));
            CreateClosedCollection(randomCollectionType, "900", DateTime.Today.AddYears(1));

            // setup SummarisedActuals
            ClearDownAllSummarisedActualsHavingCollectionType(testCollectionType);
            ClearDownAllSummarisedActualsHavingCollectionType(randomCollectionType);

            CreateSummarisedActual(testCollectionType, "100", testOrgId + "_01", testFsp, testUopcode);
            CreateSummarisedActual(testCollectionType, "100", testOrgId + "_02", testFsp, testUopcode);
            CreateSummarisedActual(testCollectionType, "100", testOrgId + "_03", testFsp, testUopcode);
            CreateSummarisedActual(testCollectionType, "100", testOrgId + "_04", testFsp, testUopcode);
            CreateSummarisedActual(testCollectionType, "100", testOrgId + "_05", testFsp, testUopcode);

            CreateSummarisedActual(testCollectionType, "200", testOrgId + "_06", testFsp, testUopcode);

            CreateSummarisedActual(randomCollectionType, "900", "randomOrgId", "randomFsp", "randomUopcode");

            var repository = new SummarisedActualRepository(new LocalConfig());

            // act
            var AssertSummarisedActualOrgFspGroupKeys = repository.GetSummarisedActualOrgFspGroupKeys(testCollectionType, "100");

            // assert
            Assert.AreEqual(5, AssertSummarisedActualOrgFspGroupKeys.Count);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void SummarisedActualRepository_GetSummarisedActuals_ShouldReturnGetSummarisedActualOrgFspGroupKeys()
        {
            // arrange
            const string randomCollectionType = "CollTypeRandom";

            const string testCollectionType = "CollTypeIntegTest";
            const string testOrgId = "OrgId";
            const string testFsp = "fsp";
            const string testUopcode = "Uopcode";

            // setup closedCollections
            ClearDownAllClosedCollectionsHavingCollectionType(testCollectionType);
            ClearDownAllClosedCollectionsHavingCollectionType(randomCollectionType);

            CreateClosedCollection(testCollectionType, "100", DateTime.Today.AddMonths(-3));
            CreateClosedCollection(testCollectionType, "200", DateTime.Today.AddMonths(-3));
            CreateClosedCollection(randomCollectionType, "900", DateTime.Today.AddYears(1));

            // setup SummarisedActuals
            ClearDownAllSummarisedActualsHavingCollectionType(testCollectionType);
            ClearDownAllSummarisedActualsHavingCollectionType(randomCollectionType);

            CreateSummarisedActual(testCollectionType, "100", testOrgId + "_01", testFsp, testUopcode);
            CreateSummarisedActual(testCollectionType, "100", testOrgId + "_02", testFsp, testUopcode);
            CreateSummarisedActual(testCollectionType, "100", testOrgId + "_03", testFsp, testUopcode);
            CreateSummarisedActual(testCollectionType, "100", testOrgId + "_04", testFsp, testUopcode);
            CreateSummarisedActual(testCollectionType, "100", testOrgId + "_05", testFsp, testUopcode);

            CreateSummarisedActual(testCollectionType, "200", testOrgId + "_06", testFsp, testUopcode);

            CreateSummarisedActual(randomCollectionType, "900", "randomOrgId", "randomFsp", "randomUopcode");

            var repository = new SummarisedActualRepository(new LocalConfig());

            var summarisedActualOrgFspGroupKey = new SummarisedActualOrgFspGroupKey(testCollectionType, "100", testOrgId + "_01", testFsp, testUopcode);

            // act
            var assertSummarisedActualOrgFspGroupKeys = repository.GetSummarisedActuals(summarisedActualOrgFspGroupKey);

            // assert
            Assert.IsNotNull(assertSummarisedActualOrgFspGroupKeys);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SummarisedActualRepository_GetSummarisedActuals_WhenUopCodeIsNull_ShouldReturnResults()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;
            
            const string collectionType = "TEST";
            const string collectionReturnCode = "TEST01";
            const string organisationId = "ORG0000001";
            const string fundingStreamPeriodCode = "TEST2020";
            const string uopCode = null;

            // arrange
            using (var sqlConnection = new SqlConnection(connectionString))
            {
                sqlConnection.Execute(
                    "DELETE FROM MonitoringDeliverables.ClosedCollection WHERE CollectionType = @collectionType",
                    new {collectionType});
                sqlConnection.Execute(
                    "INSERT INTO MonitoringDeliverables.ClosedCollection (CollectionType, CollectionReturnCode, ClosedTime, TotalRowCount, RetrievedRowCount) VALUES (@collectionType, @collectionReturnCode, GETUTCDATE(), 1000, 1000)",
                    new {collectionType, collectionReturnCode});
                sqlConnection.Execute(
                    "INSERT INTO MonitoringDeliverables.SummarisedActual (CollectionType, CollectionReturnCode, OrganisationId, FundingStreamPeriodCode, UopCode, Period, DeliverableCode, ContractAllocationNumber, ActualVolume, ActualValue, DataCollectionsId) VALUES (@collectionType, @collectionReturnCode, @organisationId, @fundingStreamPeriodCode, @uopCode, 202006, 1, 'TEST-1234', 1, 1, 1234)",
                    new { collectionType, collectionReturnCode, organisationId, fundingStreamPeriodCode, uopCode });
            }

            var repository = new SummarisedActualRepository(new LocalConfig());

            // act
            IReadOnlyCollection<SummarisedActual> actuals
                = repository.GetSummarisedActuals(new SummarisedActualOrgFspGroupKey(collectionType, collectionReturnCode, organisationId, fundingStreamPeriodCode, uopCode));

            // assert
            Assert.AreEqual(1, actuals.Count, "Did not retrieve expected actuals");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SummarisedActualRepository_GetSummarisedActuals_WhenUopCodeIsNotNull_ShouldReturnResults()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;

            const string collectionType = "TEST";
            const string collectionReturnCode = "TEST01";
            const string organisationId = "ORG0000001";
            const string fundingStreamPeriodCode = "TEST2020";
            const string uopCode = "1234";

            // arrange
            using (var sqlConnection = new SqlConnection(connectionString))
            {
                sqlConnection.Execute(
                    "DELETE FROM MonitoringDeliverables.ClosedCollection WHERE CollectionType = @collectionType",
                    new { collectionType });
                sqlConnection.Execute(
                    "INSERT INTO MonitoringDeliverables.ClosedCollection (CollectionType, CollectionReturnCode, ClosedTime, TotalRowCount, RetrievedRowCount) VALUES (@collectionType, @collectionReturnCode, GETUTCDATE(), 1000, 1000)",
                    new { collectionType, collectionReturnCode });
                sqlConnection.Execute(
                    "INSERT INTO MonitoringDeliverables.SummarisedActual (CollectionType, CollectionReturnCode, OrganisationId, FundingStreamPeriodCode, UopCode, Period, DeliverableCode, ContractAllocationNumber, ActualVolume, ActualValue, DataCollectionsId) VALUES (@collectionType, @collectionReturnCode, @organisationId, @fundingStreamPeriodCode, @uopCode, 202006, 1, 'TEST-1234', 1, 1, 1234)",
                    new { collectionType, collectionReturnCode, organisationId, fundingStreamPeriodCode, uopCode });
            }

            var repository = new SummarisedActualRepository(new LocalConfig());

            // act
            IReadOnlyCollection<SummarisedActual> actuals
                = repository.GetSummarisedActuals(new SummarisedActualOrgFspGroupKey(collectionType, collectionReturnCode, organisationId, fundingStreamPeriodCode, uopCode));

            // assert
            Assert.AreEqual(1, actuals.Count, "Did not retrieve expected actuals");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SummarisedActualRepository_GetSummarisedActualsForCollectionTypeAndReturnCode_ShouldReturnResults()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;

            const string collectionType = "TEST";
            const string collectionReturnCode = "TEST01";
            const string organisationId = "ORG0000001";
            const string fundingStreamPeriodCode = "TEST2020";
            const string uopCode = "1234";

            // arrange
            using (var sqlConnection = new SqlConnection(connectionString))
            {
                sqlConnection.Execute(
                    "DELETE FROM MonitoringDeliverables.ClosedCollection WHERE CollectionType = @collectionType",
                    new { collectionType });
                sqlConnection.Execute(
                    "INSERT INTO MonitoringDeliverables.ClosedCollection (CollectionType, CollectionReturnCode, ClosedTime, TotalRowCount, RetrievedRowCount) VALUES (@collectionType, @collectionReturnCode, GETUTCDATE(), 1000, 1000)",
                    new { collectionType, collectionReturnCode });
                sqlConnection.Execute(
                    "INSERT INTO MonitoringDeliverables.SummarisedActual (CollectionType, CollectionReturnCode, OrganisationId, FundingStreamPeriodCode, UopCode, Period, DeliverableCode, ContractAllocationNumber, ActualVolume, ActualValue, DataCollectionsId) VALUES (@collectionType, @collectionReturnCode, @organisationId, @fundingStreamPeriodCode, @uopCode, 202006, 1, 'TEST-1234', 1, 1, 1234)",
                    new { collectionType, collectionReturnCode, organisationId, fundingStreamPeriodCode, uopCode });
            }

            var repository = new SummarisedActualRepository(new LocalConfig());

            // act
            var actuals = repository.GetSummarisedActualsForCollectionTypeAndReturnCode(collectionType, collectionReturnCode);

            // assert
            Assert.AreEqual(1, actuals.Count, "Did not retrieve expected actuals");
        }

        private static void CreateSummarisedActual(string collectionType, string collectionReturnCode, string organisationId, string fundingStreamPeriodCode, string uopCode)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.SummarisedActuals.Add(
                    new SummarisedActual
                    {
                        CollectionType = collectionType,
                        CollectionReturnCode = collectionReturnCode,
                        OrganisationId = organisationId,
                        FundingStreamPeriodCode = fundingStreamPeriodCode,
                        UopCode = uopCode
                    });
                context.SaveChanges();
            }
        }

        private static void ClearDownAllSummarisedActualsHavingCollectionType(string collectionType)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.SummarisedActuals
                    .Where(sa => sa.CollectionType == collectionType).ToList()
                    .ForEach(sa => context.SummarisedActuals.Remove(sa));

                context.SaveChanges();
            }
        }

        private static void CreateClosedCollection(string collectionType, string collectionReturnCode, DateTime dateTime)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.ClosedCollections.Add(
                    new ClosedCollection(collectionType, collectionReturnCode, dateTime, 999));

                context.SaveChanges();
            }
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
    }
}