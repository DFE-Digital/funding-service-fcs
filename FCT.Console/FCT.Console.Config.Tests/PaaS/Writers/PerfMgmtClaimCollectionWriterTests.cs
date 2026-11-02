namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PerfMgmtClaimCollectionWriterTests : TestBase
    {
        private readonly ClaimCollection _claimCollectionToInsert = new ClaimCollection("CCC", "CTC", "1516", "PT");
        private readonly ClaimType _claimTypeToInsert = new ClaimType("CTC", "ClaimTypeName");

        [TestInitialize]
        public void Initialise()
        {
            // Create Claim Type
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimTypes.Add(_claimTypeToInsert);
                context.SaveChanges();
            }
        }

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                RemoveEntity(context.ClaimCollections, new object[] { _claimCollectionToInsert.ClaimCollectionCode});
                RemoveEntity(context.ClaimTypes, new object[] {_claimTypeToInsert.ClaimTypeCode});

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewClaimCollection_NewClaimCollection_IsInserted_InPaasTable()
        {
            //arrange
            List<ClaimCollectionsSheetType> testClaimCollection = CreateApprovedTestClaimCollections();

            // act
            PerfMgmtClaimCollectionWriter.WriteToPaaSDatabase(testClaimCollection, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                Assert.IsNotNull(context.ClaimCollections.Find(_claimCollectionToInsert.ClaimCollectionCode));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedClaimCollection_ExistingClaimCollection_IsUpdated_InPaasTable()
        {
            // arrange
            string updatedPeriodValue = "1617";

            //Setup data
            using (var context = new PerformanceManagementDbContext())
            {
                var originalTestClaimCollection = CreateApprovedTestClaimCollections();
                originalTestClaimCollection.ForEach(cc =>
                {
                    context.ClaimCollections.Add(TypeTransformer.Transform<ClaimCollectionsSheetType, ClaimCollection>(cc));
                });
                
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestClaimCollection = CreateApprovedTestClaimCollections();
            newTestClaimCollection[0].Period = updatedPeriodValue;

            // act
            PerfMgmtClaimCollectionWriter.WriteToPaaSDatabase(newTestClaimCollection, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var updatedRecord = context.ClaimCollections.Find(_claimCollectionToInsert.ClaimCollectionCode);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(updatedPeriodValue, updatedRecord.Period);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aClaimCollectionToBeDeleted_TheClaimCollection_IsDeleted_InPaasTable()
        {
            // arrange
            var testClaimCollection = CreateTestClaimCollectionToDelete();

            //Setup data to delete
            using (var context = new PerformanceManagementDbContext())
            {
                testClaimCollection.ForEach(claimCollection =>
                {
                    context.ClaimCollections.Add(TypeTransformer.Transform<ClaimCollectionsSheetType, ClaimCollection>(claimCollection));
                });
                
                context.SaveChanges();
            }

            // act
            PerfMgmtClaimCollectionWriter.WriteToPaaSDatabase(testClaimCollection, WriterBehaviour.Delete);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var deletedRecord = context.ClaimCollections.Find(_claimCollectionToInsert.ClaimCollectionCode);
                Assert.IsNull(deletedRecord);
            }
        }

        private List<ClaimCollectionsSheetType> CreateTestClaimCollectionToDelete()
        {
            return new List<ClaimCollectionsSheetType>
            {
                new ClaimCollectionsSheetType
                {
                    ClaimCollectionCode = _claimCollectionToInsert.ClaimCollectionCode,
                    ClaimTypeCode = _claimCollectionToInsert.ClaimTypeCode,
                    Period = _claimCollectionToInsert.Period,
                    PeriodType = _claimCollectionToInsert.PeriodType,
                    PolicyStatus = PolicyStatus.Removed
                }
            };
        }

        private List<ClaimCollectionsSheetType> CreateApprovedTestClaimCollections()
        {
            // arrange
            return new List<ClaimCollectionsSheetType>
            {
                new ClaimCollectionsSheetType
                {
                    ClaimCollectionCode = _claimCollectionToInsert.ClaimCollectionCode,
                    ClaimTypeCode = _claimCollectionToInsert.ClaimTypeCode,
                    Period = _claimCollectionToInsert.Period,
                    PeriodType = _claimCollectionToInsert.PeriodType,
                    PolicyStatus = PolicyStatus.Approved
                }
            };
        }
    }
}
