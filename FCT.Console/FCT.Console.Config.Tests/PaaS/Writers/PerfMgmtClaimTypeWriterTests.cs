namespace FCT.Console.Config.Tests.PaaS.Writers
{
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
    public class PerfMgmtClaimTypeWriterTests : TestBase
    {
        private const string ClaimTypeCodeToInsert = "CTC";
        private const string ClaimTypeNameToInsert = "ClaimTypeNameToInsert";

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var claimTypesToRemove = new List<ClaimType>
                {
                    context.ClaimTypes.Find(ClaimTypeCodeToInsert)
                };

                foreach (var ct in claimTypesToRemove.Where(ct => ct != null))
                {
                    context.ClaimTypes.Remove(ct);
                }

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewClaimType_NewClaimType_IsInserted_InPaasTable()
        {
            //arrange
            List<ClaimTypeSheetType> testClaimTypes = CreateApprovedTestClaimTypes();

            // act
            PerfMgmtClaimTypeWriter.WriteToPaaSDatabase(testClaimTypes, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                Assert.IsNotNull(context.ClaimTypes.Find(ClaimTypeCodeToInsert));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedClaimType_ExistingClaimType_IsUpdated_InPaasTable()
        {
            // arrange
            var updatedValue = "UpdatedNameToInsert";

            //Setup data
            using (var context = new PerformanceManagementDbContext())
            {
                var originalTestClaimTypes = CreateApprovedTestClaimTypes();
                originalTestClaimTypes.ForEach(ct =>
                {
                    context.ClaimTypes.Add(TypeTransformer.Transform<ClaimTypeSheetType, ClaimType>(ct));
                });
                
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestClaimTypes = CreateApprovedTestClaimTypes();
            newTestClaimTypes[0].Name = updatedValue;

            // act
            PerfMgmtClaimTypeWriter.WriteToPaaSDatabase(newTestClaimTypes, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var updatedRecord = context.ClaimTypes.Find(ClaimTypeCodeToInsert);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(updatedValue, updatedRecord.Name);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aClaimTypeToBeDeleted_TheClaimType_IsDeleted_InPaasTable()
        {
            // arrange
            var testClaimTypes = CreateTestClaimTypesToDelete();

            //Setup data to delete
            using (var context = new PerformanceManagementDbContext())
            {
                testClaimTypes.ForEach(claimType =>
                {
                    context.ClaimTypes.Add(TypeTransformer.Transform<ClaimTypeSheetType, ClaimType>(claimType));
                });
                
                context.SaveChanges();
            }

            // act
            PerfMgmtClaimTypeWriter.WriteToPaaSDatabase(testClaimTypes, WriterBehaviour.Delete);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var deletedRecord = context.ClaimTypes.Find(ClaimTypeCodeToInsert);
                Assert.IsNull(deletedRecord);
            }
        }

        private List<ClaimTypeSheetType> CreateTestClaimTypesToDelete()
        {
            return new List<ClaimTypeSheetType>
            {
                new ClaimTypeSheetType
                {
                    ClaimTypeCode = ClaimTypeCodeToInsert,
                    Name = ClaimTypeNameToInsert,
                    PolicyStatus = PolicyStatus.Removed
                }
            };
        }

        private static List<ClaimTypeSheetType> CreateApprovedTestClaimTypes()
        {
            // arrange
            return new List<ClaimTypeSheetType>
            {
                new ClaimTypeSheetType
                {
                    ClaimTypeCode = ClaimTypeCodeToInsert,
                    Name = ClaimTypeNameToInsert,
                    PolicyStatus = PolicyStatus.Approved
                }
            };
        }
    }
}
