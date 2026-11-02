namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class HeldReportedActualGroupRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void HeldReportedActualGroupRepository_ShouldAdd()
        {
            // arrange
            const string key = "Test";
            ClearDownItem(key);

            // act
            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldReportedActualGroupRepository repository = new HeldReportedActualGroupRepository();

                repository.Add(new HeldReportedActualGroup(partitionKey: key,
                    fundingStreamPeriodCode: "fsp",
                    organisationIdentifier: "org",
                    uoPCode: "uop",
                    collectionType: "ct",
                    collectionReturnCode: "crc"), ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var heldReportedActualGroup = context.HeldReportedActualGroups.Find(key);

                Assert.IsNotNull(heldReportedActualGroup, "we have not added a row");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void HeldReportedActualGroupRepository_GetHeldFsps_ShouldGetUnprocessedGroupsOnly()
        {
            // arrange
            ClearDownAllItems();
            const string fspThatIsProcessed = "fsp3";

            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldReportedActualGroupRepository repository = new HeldReportedActualGroupRepository();

                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey1",
                    fundingStreamPeriodCode: "fsp",
                    organisationIdentifier: "org",
                    uoPCode: "uop",
                    collectionType: "ct",
                    collectionReturnCode: "crc"), ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey2",
                    fundingStreamPeriodCode: "fsp",
                    organisationIdentifier: "org1",
                    uoPCode: "uop",
                    collectionType: "ct2",
                    collectionReturnCode: "crc2"), ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey3",
                    fundingStreamPeriodCode: "fsp2",
                    organisationIdentifier: "org1",
                    uoPCode: "uop",
                    collectionType: "ct2",
                    collectionReturnCode: "crc2"), ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey4",
                    fundingStreamPeriodCode: "fsp2",
                    organisationIdentifier: "org1",
                    uoPCode: "uop",
                    collectionType: "ct3",
                    collectionReturnCode: "crc3"), ConnectionInfo.CreateFrom(context.Database.Connection));

                HeldReportedActualGroup h = new HeldReportedActualGroup(partitionKey: "TestKey5",
                    fundingStreamPeriodCode: fspThatIsProcessed,
                    organisationIdentifier: "org1",
                    uoPCode: "uop",
                    collectionType: "ct3",
                    collectionReturnCode: "crc3") {ProcessedDate = DateTime.Now};
                context.HeldReportedActualGroups.Add(h);

                context.SaveChanges();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldReportedActualGroupRepository repository = new HeldReportedActualGroupRepository();

                // act
                IReadOnlyCollection<AllocationGrpWithCollectionReturns> allocationGroups = repository.GetHeldAllocationGrps(new ConnectionInfo(null, context.Database.Connection));

                // assert
                Assert.AreEqual(3, allocationGroups.Count, "We have not got the correct number of FSPs");
                AllocationGrpWithCollectionReturns allocatWithMultipleCRs = allocationGroups
                    .Single(f => f.FundingStreamPeriodCode == "fsp2" && f.OrgId == "org1" && f.UopCode == "uop");
                Assert.AreEqual(2, allocatWithMultipleCRs.CollectionReturns.Count, "We have not got the correct number of collection returns for the FSP called fsp");
                Assert.IsFalse(allocationGroups.Any(f => f.FundingStreamPeriodCode == fspThatIsProcessed), "We have got an FSP that is processed, this is not correct");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void HeldReportedActualGroupRepository_SetHeldReportedActualGroupsToProcessed_ShouldSetProcessedDate()
        {
            // arrange
            ClearDownAllItems();

            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldReportedActualGroupRepository repository = new HeldReportedActualGroupRepository();

                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey1",
                    fundingStreamPeriodCode: "fsp",
                    organisationIdentifier: "org",
                    uoPCode: "uop",
                    collectionType: "ct",
                    collectionReturnCode: "crc"), ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey2",
                    fundingStreamPeriodCode: "fsp",
                    organisationIdentifier: "org1",
                    uoPCode: "uop",
                    collectionType: "ct2",
                    collectionReturnCode: "crc2"), ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey3",
                    fundingStreamPeriodCode: "fsp2",
                    organisationIdentifier: "org1",
                    uoPCode: "uop",
                    collectionType: "ct2",
                    collectionReturnCode: "crc2"), ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey4",
                    fundingStreamPeriodCode: "fsp2",
                    organisationIdentifier: "org1",
                    uoPCode: "uop",
                    collectionType: "ct3",
                    collectionReturnCode: "crc3"), ConnectionInfo.CreateFrom(context.Database.Connection));

                context.SaveChanges();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldReportedActualGroupRepository repository = new HeldReportedActualGroupRepository();

                // act
                repository.SetHeldReportedActualGroupsToProcessed(ConnectionInfo.CreateFrom(context.Database.Connection), new List<string> { "TestKey1", "TestKey2" });
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // assert
                var processedRows = context.HeldReportedActualGroups.Where(h => h.ProcessedDate != null)
                    .ToList();

                Assert.IsNotNull(processedRows.SingleOrDefault(p => p.PartitionKey == "TestKey1"), "The processed date is not set for TestKey1");
                Assert.IsNotNull(processedRows.SingleOrDefault(p => p.PartitionKey == "TestKey2"), "The processed date is not set for TestKey1");
                Assert.AreEqual(2, processedRows.Count, "There are more (or less) processed rows than expected");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void HeldReportedActualGroupRepository_SetHeldReportedActualGroupsToProcessed_ShouldSetProcessedDateOnLots()
        {
            // arrange
            ClearDownAllItems();

            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldReportedActualGroupRepository repository = new HeldReportedActualGroupRepository();

                Enumerable.Range(0, 50).ToList().ForEach(i =>
                {
                    repository.Add(new HeldReportedActualGroup(partitionKey: $"TestKey{i}",
                        fundingStreamPeriodCode: "fsp",
                        organisationIdentifier: $"org{i}",
                        uoPCode: "uop",
                        collectionType: "ct",
                        collectionReturnCode: "crc"), ConnectionInfo.CreateFrom(context.Database.Connection));
                });
              
                context.SaveChanges();
            }

            const int numberToSetAsProcessed = 25;
            var pks = Enumerable.Range(0, numberToSetAsProcessed).Select(i => $"TestKey{i}").ToList();
            
            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldReportedActualGroupRepository repository = new HeldReportedActualGroupRepository();

                // act
                repository.SetHeldReportedActualGroupsToProcessed(ConnectionInfo.CreateFrom(context.Database.Connection), pks);
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // assert
                var processedRows = context.HeldReportedActualGroups.Where(h => h.ProcessedDate != null)
                    .ToList();

                Assert.AreEqual(numberToSetAsProcessed, processedRows.Count, "There the number of processed rows is not expected");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void HeldReportedActualGroupRepository_GetSummarisedActualOrgFspGroupKeys_ShouldReturnRowsForProvidedPartitionKeys()
        {
            // arrange
            ClearDownAllItems();

            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldReportedActualGroupRepository repository = new HeldReportedActualGroupRepository();

                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey1",
                    fundingStreamPeriodCode: "fsp1",
                    organisationIdentifier: "org1",
                    uoPCode: "uop1",
                    collectionType: "ct1",
                    collectionReturnCode: "crc1"), ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey2",
                    fundingStreamPeriodCode: "fsp2",
                    organisationIdentifier: "org2",
                    uoPCode: "uop2",
                    collectionType: "ct2",
                    collectionReturnCode: "crc2"), ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey3",
                    fundingStreamPeriodCode: "fsp3",
                    organisationIdentifier: "org3",
                    uoPCode: "uop3",
                    collectionType: "ct3",
                    collectionReturnCode: "crc3"), ConnectionInfo.CreateFrom(context.Database.Connection));
                repository.Add(new HeldReportedActualGroup(partitionKey: "TestKey4",
                    fundingStreamPeriodCode: "fsp4",
                    organisationIdentifier: "org4",
                    uoPCode: "uop4",
                    collectionType: "ct4",
                    collectionReturnCode: "crc4"), ConnectionInfo.CreateFrom(context.Database.Connection));

                context.SaveChanges();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldReportedActualGroupRepository repository = new HeldReportedActualGroupRepository();

                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                var partitionKeys = new List<string> { "TestKey2", "TestKey3" };

                // act
                var assertGroupKeys = repository.GetSummarisedActualOrgFspGroupKeys(connectionInfo, partitionKeys);

                // assert
                Assert.AreEqual(2, assertGroupKeys.Count, "We have not got the correct number of group keys returned");

                var groupKey2 = assertGroupKeys.FirstOrDefault(gk => gk.FundingStreamPeriodCode == "fsp2");
                Assert.IsNotNull(groupKey2, "'partitionKey: TestKey2' was not returned");

                var groupKey3 = assertGroupKeys.FirstOrDefault(gk => gk.FundingStreamPeriodCode == "fsp3");
                Assert.IsNotNull(groupKey3, "'partitionKey: TestKey3' was not returned");
            }
        }

        private void ClearDownItem(string key)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.HeldReportedActualGroups.Where(h => h.PartitionKey == key).ToList()
                    .ForEach(h => context.HeldReportedActualGroups.Remove(h));

                context.SaveChanges();
            }
        }

        private void ClearDownAllItems()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.HeldReportedActualGroups.ToList()
                    .ForEach(h => context.HeldReportedActualGroups.Remove(h));

                context.SaveChanges();
            }
        }
    }
}
