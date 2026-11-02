namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class MonitoringDeliverablesHeldFspCollectionConfigWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesHeldFspCollectionConfigWriter_UpdateMonitoringDeliverablesHeldFspCollectionConfig()
        {
            // Arrange
            const int multipleCollectionGroupId = 999;
            const string fundingStreamPeriodCode = "fspCode";
            const string collectionType = "collType";
            const string collectionReturnCodeBefore = "Before";
            const string collectionReturnCodeUpdated = "Updated";

            RemoveItem(multipleCollectionGroupId, fundingStreamPeriodCode, collectionType);
            AddItem(multipleCollectionGroupId, fundingStreamPeriodCode, collectionType, collectionReturnCodeBefore);

            List<ActualsCollectionReturnsSheetType> monitoringDeliverablesHeldFspCollectionConfig = new List<ActualsCollectionReturnsSheetType>
            {
                 new ActualsCollectionReturnsSheetType
                 {
                     MultipleCollectionGroupId = multipleCollectionGroupId,
                     FundingStreamPeriodCode = fundingStreamPeriodCode,
                     CollectionType = collectionType,
                     CollectionReturnCode = collectionReturnCodeUpdated,
                     PolicyStatus = PolicyStatus.Approved
                 }
            };

            // Act
            MonitoringDeliverablesHeldFspCollectionConfigWriter.WriteToPaaSDatabase(monitoringDeliverablesHeldFspCollectionConfig, WriterBehaviour.AddOrUpdate);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // Assert
                var heldFspCollectionConfigOnDatabase = context.HeldFspCollectionConfigs
                    .SingleOrDefault(hfcg => hfcg.MultipleCollectionGroupId == multipleCollectionGroupId
                                             && hfcg.FundingStreamPeriodCode == fundingStreamPeriodCode
                                             && hfcg.CollectionType == collectionType);

                Assert.IsNotNull(heldFspCollectionConfigOnDatabase, "HeldFspCollectionConfig does not exist");
                Assert.AreEqual(heldFspCollectionConfigOnDatabase.CollectionReturnCode, collectionReturnCodeUpdated, "Collection ReturnCode was not updated correctly");
            }
            RemoveItem(multipleCollectionGroupId, fundingStreamPeriodCode, collectionType);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesHeldFspCollectionConfigWriter_NewMonitoringDeliverablesHeldFspCollectionConfig()
        {
            // Arrange
            const int multipleCollectionGroupId = 999;
            const string fundingStreamPeriodCode = "fspCode";
            const string collectionType = "collType";
            const string collectionReturnCode = "RetCode";

            RemoveItem(multipleCollectionGroupId, fundingStreamPeriodCode, collectionType);

            List<ActualsCollectionReturnsSheetType> updatedMonitoringDeliverablesHeldFspCollectionConfig = new List<ActualsCollectionReturnsSheetType>
            {
                 new ActualsCollectionReturnsSheetType
                 {
                     MultipleCollectionGroupId = multipleCollectionGroupId,
                     FundingStreamPeriodCode = fundingStreamPeriodCode,
                     CollectionType = collectionType,
                     CollectionReturnCode = collectionReturnCode,
                     PolicyStatus = PolicyStatus.Approved
                 }
            };

            // Act
            MonitoringDeliverablesHeldFspCollectionConfigWriter.WriteToPaaSDatabase(updatedMonitoringDeliverablesHeldFspCollectionConfig, WriterBehaviour.AddOrUpdate);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // Assert
                var heldFspCollectionConfigOnDatabase = context.HeldFspCollectionConfigs
                    .SingleOrDefault(hfcg => hfcg.MultipleCollectionGroupId == multipleCollectionGroupId
                                             && hfcg.FundingStreamPeriodCode == fundingStreamPeriodCode
                                             && hfcg.CollectionType == collectionType);

                Assert.IsNotNull(heldFspCollectionConfigOnDatabase, "HeldFspCollectionConfig was not added");
                Assert.AreEqual(heldFspCollectionConfigOnDatabase.CollectionReturnCode, collectionReturnCode, "Incorrect Collection ReturnCode");
            }
            RemoveItem(multipleCollectionGroupId, fundingStreamPeriodCode, collectionType);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonitoringDeliverablesHeldFspCollectionConfigWriter_DeleteMonitoringDeliverablesHeldFspCollectionConfig()
        {
            // Arrange
            const int multipleCollectionGroupId = 999;
            const string fundingStreamPeriodCode = "fspCode";
            const string collectionType = "collType";
            const string collectionReturnCode = "RetCode";
            
            RemoveItem(multipleCollectionGroupId, fundingStreamPeriodCode, collectionType);
            AddItem(multipleCollectionGroupId, fundingStreamPeriodCode, collectionType, collectionReturnCode);

            List<ActualsCollectionReturnsSheetType> monitoringDeliverablesHeldFspCollectionConfig = new List<ActualsCollectionReturnsSheetType>
            {
                 new ActualsCollectionReturnsSheetType
                 {
                     MultipleCollectionGroupId = multipleCollectionGroupId,
                     FundingStreamPeriodCode = fundingStreamPeriodCode,
                     CollectionType = collectionType,
                     CollectionReturnCode = collectionReturnCode,
                     PolicyStatus = PolicyStatus.Removed
                 }
            };

            // Act
            MonitoringDeliverablesHeldFspCollectionConfigWriter.WriteToPaaSDatabase(monitoringDeliverablesHeldFspCollectionConfig, WriterBehaviour.Delete);

            using (var context = new MonitoringDeliverablesDbContext())
            {
                // Assert
                var heldFspCollectionConfigOnDatabase = context.HeldFspCollectionConfigs
                    .SingleOrDefault(hfcg => hfcg.MultipleCollectionGroupId == multipleCollectionGroupId
                                             && hfcg.FundingStreamPeriodCode == fundingStreamPeriodCode
                                             && hfcg.CollectionType == collectionType);

                Assert.IsNull(heldFspCollectionConfigOnDatabase, "HeldFspCollectionConfig was not removed");
            }
            RemoveItem(multipleCollectionGroupId, fundingStreamPeriodCode, collectionType);
        }

        private static void RemoveItem(int multipleCollectionGroupId, string fundingStreamPeriodCode, string collectionType)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var heldFspCollectionConfigOnDatabase = context.HeldFspCollectionConfigs
                    .SingleOrDefault(hfcg => hfcg.MultipleCollectionGroupId == multipleCollectionGroupId
                                             && hfcg.FundingStreamPeriodCode == fundingStreamPeriodCode
                                             && hfcg.CollectionType == collectionType);

                if (heldFspCollectionConfigOnDatabase != null)
                {
                    context.HeldFspCollectionConfigs.Remove(heldFspCollectionConfigOnDatabase);
                    context.SaveChanges();
                }
            }
        }

        private static void AddItem(int multipleCollectionGroupId, string fundingStreamPeriodCode, string collectionType, string collectionReturnCodeBefore)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                HeldFspCollectionConfig monitoringDeliverablesHeldFspCollectionConfig = new HeldFspCollectionConfig
                    (multipleCollectionGroupId, fundingStreamPeriodCode, collectionType, collectionReturnCodeBefore);

                context.HeldFspCollectionConfigs.Add(monitoringDeliverablesHeldFspCollectionConfig);
                context.SaveChanges();
            }
        }
    }
}