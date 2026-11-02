namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PerfMgmtClaimReconciliationBehaviourWriterTests : TestBase
    {
        private const string ClaimCollectionCodeToInsert = "CollectionCode";
        private const string ClaimAllocGroupCodeToInsert = "AllocGroupCode";
        private const string TestClaimTypeCode = "Code";

        [TestInitialize]
        public void Initialise()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimType testClaimType = new ClaimType(TestClaimTypeCode, "name");
                ClaimCollection testClaimCollection = new ClaimCollection(ClaimCollectionCodeToInsert, TestClaimTypeCode, "1617", "AY");
                ClaimReconciliationAllocationGroup testReconciliationAllocationGroup = new ClaimReconciliationAllocationGroup(ClaimAllocGroupCodeToInsert, "GroupName");

                context.ClaimTypes.Add(testClaimType);
                context.ClaimCollections.Add(testClaimCollection);
                context.ClaimReconciliationAllocationGroups.Add(testReconciliationAllocationGroup);

                context.SaveChanges();
            }
        }

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                RemoveEntity(context.ClaimReconciliationBehaviours, new object[] { ClaimCollectionCodeToInsert, ClaimAllocGroupCodeToInsert });
                RemoveEntity(context.ClaimCollections, new object[] { ClaimCollectionCodeToInsert } );
                RemoveEntity(context.ClaimReconciliationAllocationGroups, new object[] { ClaimAllocGroupCodeToInsert });
                RemoveEntity(context.ClaimTypes, new object[] { TestClaimTypeCode });
                
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourSheetType_ShouldInsertIntoTableClaimReconciliationBehaviour()
        {
            //arrange
            DateTime publicationCloseDate = new DateTime(2017, 07, 04, 0, 0, 0, DateTimeKind.Utc);
            List<ClaimReconciliationBehaviourSheetType> testClaimReconciliationBehaviours = new List<ClaimReconciliationBehaviourSheetType>
            {
                new ClaimReconciliationBehaviourSheetType
                {
                    ClaimCollectionCode = ClaimCollectionCodeToInsert,
                    ClaimReconciliationAllocationGroupCode = ClaimAllocGroupCodeToInsert,
                    IsReconciliationPayable = true,
                    DoWeReconcileUnderDelivery = false,
                    DoWeReconcileOverDelivery = true,
                    OverDeliveryDeMinimis = 100m,
                    UnderDeliveryDeMinimis = -100m,
                    PublicationCloseDate = publicationCloseDate,
                    PolicyStatus = PolicyStatus.Approved,
                    UnderDeliveryTolerancePercentage = -3,
                    OverDeliveryLimitPercentage = 3
                }
            };
            
            // act
            PerfMgmtClaimReconciliationBehaviourWriter.WriteToPaaSDatabase(testClaimReconciliationBehaviours, WriterBehaviour.AddOrUpdate);

            // assert
            ClaimReconciliationBehaviourSheetType testSheetType = testClaimReconciliationBehaviours.First();
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationBehaviour claimReconciliationBehaviour =
                    context.ClaimReconciliationBehaviours.Find(ClaimCollectionCodeToInsert, ClaimAllocGroupCodeToInsert);

                Assert.IsNotNull(claimReconciliationBehaviour);
                Assert.IsTrue(claimReconciliationBehaviour.IsReconciliationPayable);
                Assert.IsFalse(claimReconciliationBehaviour.DoWeReconcileUnderDelivery);
                Assert.IsTrue(claimReconciliationBehaviour.DoWeReconcileOverDelivery);
                Assert.AreEqual(testSheetType.OverDeliveryDeMinimis, claimReconciliationBehaviour.OverDeliveryDeMinimis);
                Assert.AreEqual(testSheetType.UnderDeliveryDeMinimis, claimReconciliationBehaviour.UnderDeliveryDeMinimis);
                Assert.AreEqual(testSheetType.PublicationCloseDate, claimReconciliationBehaviour.PublicationCloseDate);
                Assert.AreEqual(testSheetType.UnderDeliveryTolerancePercentage, claimReconciliationBehaviour.UnderDeliveryTolerancePercentage);
                Assert.AreEqual(testSheetType.OverDeliveryLimitPercentage, claimReconciliationBehaviour.OverDeliveryLimitPercentage);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedClaimType_ExistingClaimType_IsUpdated_InPaasTable()
        {
            // arrange
            var updatedValue = 200m;

            //Setup data
            using (var context = new PerformanceManagementDbContext())
            {
                var originalTestClaimReconciliationBehaviours = CreateApprovedTestEntities();
                originalTestClaimReconciliationBehaviours.ForEach(crb =>
                {
                    context.ClaimReconciliationBehaviours.Add(TypeTransformer.Transform<ClaimReconciliationBehaviourSheetType, ClaimReconciliationBehaviour>(crb));
                });
                
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestClaimReconciliationBehaviours = CreateApprovedTestEntities();
            newTestClaimReconciliationBehaviours[0].OverDeliveryDeMinimis = 200m;

            // act
            PerfMgmtClaimReconciliationBehaviourWriter.WriteToPaaSDatabase(newTestClaimReconciliationBehaviours, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var updatedRecord = context.ClaimReconciliationBehaviours.Find(ClaimCollectionCodeToInsert, ClaimAllocGroupCodeToInsert);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(updatedValue, updatedRecord.OverDeliveryDeMinimis);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aClaimTypeToBeDeleted_TheClaimType_IsDeleted_InPaasTable()
        {
            // arrange
            var testClaimReconciliationBehaviours = CreateTestEntitiesToDelete();

            //Setup data to delete
            using (var context = new PerformanceManagementDbContext())
            {
                testClaimReconciliationBehaviours.ForEach(claimRecBehaviour =>
                {
                    context.ClaimReconciliationBehaviours.Add(TypeTransformer.Transform<ClaimReconciliationBehaviourSheetType, ClaimReconciliationBehaviour>(claimRecBehaviour));
                });
                
                context.SaveChanges();
            }

            // act
            PerfMgmtClaimReconciliationBehaviourWriter.WriteToPaaSDatabase(testClaimReconciliationBehaviours, WriterBehaviour.Delete);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var deletedRecord = context.ClaimReconciliationBehaviours.Find(ClaimCollectionCodeToInsert, ClaimAllocGroupCodeToInsert);
                Assert.IsNull(deletedRecord);
            }
        }

        private List<ClaimReconciliationBehaviourSheetType> CreateTestEntitiesToDelete()
        {
            return new List<ClaimReconciliationBehaviourSheetType>
            {
                new ClaimReconciliationBehaviourSheetType
                {
                    ClaimCollectionCode = ClaimCollectionCodeToInsert,
                    ClaimReconciliationAllocationGroupCode = ClaimAllocGroupCodeToInsert,
                    IsReconciliationPayable = true,
                    DoWeReconcileUnderDelivery = false,
                    DoWeReconcileOverDelivery = true,
                    OverDeliveryDeMinimis = 100m,
                    UnderDeliveryDeMinimis = -100m,
                    PolicyStatus = PolicyStatus.Removed
                }
            };
        }

        private static List<ClaimReconciliationBehaviourSheetType> CreateApprovedTestEntities(DateTime? publicationCloseDate = null)
        {
            // arrange
            return new List<ClaimReconciliationBehaviourSheetType>
            {
                new ClaimReconciliationBehaviourSheetType
                {
                    ClaimCollectionCode = ClaimCollectionCodeToInsert,
                    ClaimReconciliationAllocationGroupCode = ClaimAllocGroupCodeToInsert,
                    IsReconciliationPayable = true,
                    DoWeReconcileUnderDelivery = false,
                    DoWeReconcileOverDelivery = true,
                    OverDeliveryDeMinimis = 100m,
                    UnderDeliveryDeMinimis = -100m,
                    PublicationCloseDate = publicationCloseDate,
                    PolicyStatus = PolicyStatus.Approved
                }
            };
        }
    }
}
