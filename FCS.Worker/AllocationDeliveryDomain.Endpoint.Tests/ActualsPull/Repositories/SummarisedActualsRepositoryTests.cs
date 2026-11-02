namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPull.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using AllocationDelivery.Messages.DTOs;
    using Dapper;
    using Endpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using UnitTests.Common;
    using ClosedCollection = SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model.ClosedCollection;

    [TestClass]
    public class SummarisedActualsRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SummarisedActualsRepository_ShouldAdd()
        {
            // arrange
            const string collectionType = "CT";
            const string collectionReturnCode = "CRC";
            DateTime now = DateTime.Now;
            ClearAllSummarisedActuals();
            ClearClosedCollections();
            InsertClosedCollection(collectionType, collectionReturnCode, now);

            SummarisedActualsRepository repository = new SummarisedActualsRepository();
            SummarisedActual summarisedActual = new SummarisedActual
            {

                CollectionType = collectionType,
                Period = 202004,
                DeliverableCode = 1,
                CollectionReturnCode = collectionReturnCode,
                ActualValue = 1,
                ActualVolume = 2,
                ContractAllocationNumber = "CA",
                DataCollectionsId = 12,
                FundingStreamPeriodCode = "FSP",
                OrganisationId = "123",
                UopCode = "UOP"
            };

            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Open();

                // act
                repository.AddActuals(new List<SummarisedActual> { summarisedActual }, new ConnectionInfo(null, connection))
                    .Wait();
            }

            // assert
            var retrieved = GetSummarisedActual(summarisedActual.ContractAllocationNumber);
            Assert.AreEqual(summarisedActual.ContractAllocationNumber, retrieved.ContractAllocationNumber, "The contract allocation number is not correct");
            Assert.AreEqual(summarisedActual.ActualValue, retrieved.ActualValue, "The ActualValue is not correct");
            Assert.AreEqual(summarisedActual.ActualVolume, retrieved.ActualVolume, "The ActualVolume is not correct");
            Assert.AreEqual(summarisedActual.CollectionReturnCode, retrieved.CollectionReturnCode, "The CollectionReturnCode is not correct");
            Assert.AreEqual(summarisedActual.CollectionType, retrieved.CollectionType, "The CollectionType is not correct");
            Assert.AreEqual(summarisedActual.DataCollectionsId, retrieved.DataCollectionsId, "The DataCollectionsId is not correct");
            Assert.AreEqual(summarisedActual.DeliverableCode, retrieved.DeliverableCode, "The DeliverableCode is not correct");
            Assert.AreEqual(summarisedActual.FundingStreamPeriodCode, retrieved.FundingStreamPeriodCode, "The FundingStreamPeriodCode is not correct");
            Assert.AreEqual(summarisedActual.OrganisationId, retrieved.OrganisationId, "The OrganisationId is not correct");
            Assert.AreEqual(summarisedActual.Period, retrieved.Period, "The Period is not correct");
            Assert.AreEqual(summarisedActual.UopCode, retrieved.UopCode, "The UopCode is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SummarisedActualsRepository_AddActuals_ShouldWorkWithNullableValues()
        {
            // arrange
            const string collectionType = "CT";
            const string collectionReturnCode = "CRC";
            DateTime now = DateTime.Now;
            ClearAllSummarisedActuals();
            ClearClosedCollections();
            InsertClosedCollection(collectionType, collectionReturnCode, now);

            SummarisedActualsRepository repository = new SummarisedActualsRepository();
            SummarisedActual summarisedActual = new SummarisedActual
            {

                CollectionType = collectionType,
                Period = 202004,
                DeliverableCode = 1,
                CollectionReturnCode = collectionReturnCode,
                ActualValue = 1,
                ActualVolume = null,
                ContractAllocationNumber = "CA",
                DataCollectionsId = null,
                FundingStreamPeriodCode = "FSP",
                OrganisationId = "123",
                UopCode = null
            };

            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Open();

                // act
                repository.AddActuals(new List<SummarisedActual> { summarisedActual }, new ConnectionInfo(null, connection))
                    .Wait();
            }

            // assert
            var retrieved = GetSummarisedActual(summarisedActual.ContractAllocationNumber);
            Assert.AreEqual(summarisedActual.ContractAllocationNumber, retrieved.ContractAllocationNumber, "The contract allocation number is not correct");
            Assert.AreEqual(summarisedActual.ActualValue, retrieved.ActualValue, "The ActualValue is not correct");
            Assert.AreEqual(summarisedActual.ActualVolume, retrieved.ActualVolume, "The ActualVolume is not correct");
            Assert.AreEqual(summarisedActual.CollectionReturnCode, retrieved.CollectionReturnCode, "The CollectionReturnCode is not correct");
            Assert.AreEqual(summarisedActual.CollectionType, retrieved.CollectionType, "The CollectionType is not correct");
            Assert.AreEqual(summarisedActual.DataCollectionsId, retrieved.DataCollectionsId, "The DataCollectionsId is not correct");
            Assert.AreEqual(summarisedActual.DeliverableCode, retrieved.DeliverableCode, "The DeliverableCode is not correct");
            Assert.AreEqual(summarisedActual.FundingStreamPeriodCode, retrieved.FundingStreamPeriodCode, "The FundingStreamPeriodCode is not correct");
            Assert.AreEqual(summarisedActual.OrganisationId, retrieved.OrganisationId, "The OrganisationId is not correct");
            Assert.AreEqual(summarisedActual.Period, retrieved.Period, "The Period is not correct");
            Assert.AreEqual(summarisedActual.UopCode, retrieved.UopCode, "The UopCode is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SummarisedActualsRepository_ShouldAddManyRows_InAReasonableTime()
        {
            // arrange
            const string collectionType = "CT";
            const string collectionReturnCode = "CRC";
            DateTime now = DateTime.Now;
            ClearAllSummarisedActuals();
            ClearClosedCollections();
            InsertClosedCollection(collectionType, collectionReturnCode, now);

            SummarisedActualsRepository repository = new SummarisedActualsRepository();
            var summarisedActuals = Enumerable.Range(1, 10000).Select(i =>
            {
                return new SummarisedActual
                {

                    CollectionType = collectionType,
                    Period = 202004,
                    DeliverableCode = i,
                    CollectionReturnCode = collectionReturnCode,
                    ClosedCollection = new ClosedCollection(collectionType, collectionReturnCode, now, 10),
                    ActualValue = 1,
                    ActualVolume = 2,
                    ContractAllocationNumber = "CA",
                    DataCollectionsId = 12,
                    FundingStreamPeriodCode = "FSP",
                    OrganisationId = "123",
                    UopCode = "UOP"
                };
            }).ToList();

            DateTime start = DateTime.Now;
            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Open();

                // act
                repository.AddActuals(summarisedActuals, new ConnectionInfo(null, connection))
                    .Wait();
            }

            DateTime end = DateTime.Now;
            // assert
            var timeTake = (end - start).TotalSeconds;
            Assert.IsTrue(timeTake < 30, $"Time taken in seconds :{timeTake}");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SummarisedActualsRepository_ShouldGetCountForCollectionReturn()
        {
            // arrange
            const string collectionType = "CT";
            const string collectionReturnCode = "CRC";
            const int numRows = 123;
            DateTime now = DateTime.Now;
            ClearAllSummarisedActuals();
            ClearClosedCollections();
            InsertClosedCollection(collectionType, collectionReturnCode, now);

            SummarisedActualsRepository repository = new SummarisedActualsRepository();
            var summarisedActuals = Enumerable.Range(1, numRows).Select(i =>
            {
                return new SummarisedActual
                {

                    CollectionType = collectionType,
                    Period = 202004,
                    DeliverableCode = i,
                    CollectionReturnCode = collectionReturnCode,
                    ClosedCollection = new ClosedCollection(collectionType, collectionReturnCode, now, 10),
                    ActualValue = 1,
                    ActualVolume = 2,
                    ContractAllocationNumber = "CA",
                    DataCollectionsId = 12,
                    FundingStreamPeriodCode = "FSP",
                    OrganisationId = "123",
                    UopCode = "UOP"
                };
            }).ToList();

            DateTime start = DateTime.Now;
            summarisedActuals.ForEach(sa =>
            {
                repository.AddActual(sa, new ConnectionInfo(null, new SqlConnection(ConnectionString)))
                    .Wait();
            });
            // act
            int numRowsCount = repository.GetCountForCollectionReturn(collectionType, collectionReturnCode,
                new ConnectionInfo(null, new SqlConnection(ConnectionString))).Result;

            // assert
            Assert.AreEqual(numRows, numRowsCount);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SummarisedActualsRepository_ShouldGetGetOrgFspGroups()
        {
            // arrange
            const string collectionType = "CT";
            const string collectionReturnCode = "CRC";
            const int numRows = 201;
            DateTime now = DateTime.Now;
            ClearAllSummarisedActuals();
            ClearClosedCollections();
            InsertClosedCollection(collectionType, collectionReturnCode, now);

            SummarisedActualsRepository repository = new SummarisedActualsRepository();
            var summarisedActuals = Enumerable.Range(1, numRows).Select(i =>
            {
                var decimalGroup = i / 10;

                return new SummarisedActual
                {

                    CollectionType = collectionType,
                    Period = 202004,
                    DeliverableCode = i,
                    CollectionReturnCode = collectionReturnCode,
                    ClosedCollection = new ClosedCollection(collectionType, collectionReturnCode, now, 10),
                    ActualValue = 1,
                    ActualVolume = 2,
                    ContractAllocationNumber = "CA",
                    DataCollectionsId = 12,
                    FundingStreamPeriodCode = $"FSP{decimalGroup}",
                    OrganisationId = (i == 2) ? $"111{decimalGroup}" : $"123{decimalGroup}", // make second one not have change org code, therefore a different group
                    UopCode = (i == 1) ? null : "UOP" // make first one not have UOP code, therefore a different group
                };
            }).ToList();

            DateTime start = DateTime.Now;
            summarisedActuals.ForEach(sa =>
            {
                repository.AddActual(sa, new ConnectionInfo(null, new SqlConnection(ConnectionString)))
                    .Wait();
            });
            // act
            var groups = repository.GetOrgFspGroups(collectionType, collectionReturnCode,
                new ConnectionInfo(null, new SqlConnection(ConnectionString))).Result;

            // assert
            Assert.AreEqual(23, groups.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SummarisedActualsRepository_ShouldGetSummarisedActuals()
        {
            // arrange
            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                context.ClosedCollections.RemoveWhere(cc => cc.CollectionType == "APPS");
                context.SaveChanges();

                context.ClosedCollections.Add(new ClosedCollection("APPS", "APPS01", DateTime.UtcNow, 100000));
                context.ClosedCollections.Add(new ClosedCollection("APPS", "APPS02", DateTime.UtcNow, 100000));
                context.SummarisedActuals.Add(new SummarisedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UopCode = "UOP1",
                    DeliverableCode = 1,
                    Period = 202001,
                    ActualVolume = 0,
                    ActualValue = 100
                });
                context.SummarisedActuals.Add(new SummarisedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS02",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UopCode = "UOP1",
                    DeliverableCode = 1,
                    Period = 202001,
                    ActualVolume = 0,
                    ActualValue = 100
                });
                context.SummarisedActuals.Add(new SummarisedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS02",
                    OrganisationId = "ORG1",
                    FundingStreamPeriodCode = "FSP1",
                    UopCode = "UOP1",
                    DeliverableCode = 1,
                    Period = 202002,
                    ActualVolume = 0,
                    ActualValue = 101
                });
                context.SaveChanges();
            }

            using (MonitoringDeliverablesDbContext context = new MonitoringDeliverablesDbContext())
            {
                SummarisedActualsRepository repository = new SummarisedActualsRepository();
                SummarisedActualOrgFspGroupKey groupKey = new SummarisedActualOrgFspGroupKey
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS02",
                    FundingStreamPeriodCode = "FSP1",
                    OrganisationId = "ORG1",
                    UopCode = "UOP1"
                };
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // act
                IReadOnlyCollection<SummarisedActual> returnedSummarisedActuals = repository.GetSummarisedActuals(groupKey, connectionInfo).Result;

                // assert
                Assert.AreEqual(2, returnedSummarisedActuals.Count, "Unexpected number of rows returned");
                Assert.IsTrue(returnedSummarisedActuals.All(sa => sa.CollectionType == "APPS"), "Unexpected rows returned");
                Assert.IsTrue(returnedSummarisedActuals.All(sa => sa.CollectionReturnCode == "APPS02"), "Unexpected rows returned");
                Assert.IsTrue(returnedSummarisedActuals.All(sa => sa.OrganisationId == "ORG1"), "Unexpected rows returned");
                Assert.IsTrue(returnedSummarisedActuals.All(sa => sa.FundingStreamPeriodCode == "FSP1"), "Unexpected rows returned");
                Assert.IsTrue(returnedSummarisedActuals.All(sa => sa.UopCode == "UOP1"), "Unexpected rows returned");
            }
        }

        private void ClearAllSummarisedActuals()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"DELETE 
                    FROM [MonitoringDeliverables].[SummarisedActual]";

                connection.Execute(sql);
            }
        }

        private void ClearClosedCollections()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"DELETE 
                    FROM [MonitoringDeliverables].[ClosedCollection]";

                connection.Execute(sql);
            }
        }

        private void InsertClosedCollection(string collectionType, string collectionReturnCode, DateTime closedTime)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"insert into [MonitoringDeliverables].[ClosedCollection]
                    (CollectionType, CollectionReturnCode, ClosedTime, TotalRowCount, RetrievedRowCount)
                    values (@collectionType, @collectionReturnCode, @closedTime, 0, 0)";

                connection.Execute(sql, new { collectionType, collectionReturnCode, closedTime });
            }
        }

        private SummarisedActual GetSummarisedActual(string allocationNumber)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"select * from [MonitoringDeliverables].[SummarisedActual]
                        where [ContractAllocationNumber] = @allocationNumber";

                return connection.QuerySingle<SummarisedActual>(sql, new { allocationNumber });
            }
        }

        private string ConnectionString =>
            ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;
    }
}
