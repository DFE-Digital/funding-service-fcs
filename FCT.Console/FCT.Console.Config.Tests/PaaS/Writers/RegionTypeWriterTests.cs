namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class RegionTypeWriterTests
    {
        private const int TestRegionTypeCode = 9;
        private const string TestRegionTypeName = "TestRegionTypeName";

        [TestMethod, TestCategory("IntegrationTest")]
        public void RegionTypeWriter_ShouldInsertNewRowToPaaS()
        {
            // Arrange
            CleanUp();
            IList<RegionTypeSheetType> regionTypeSheets = new List<RegionTypeSheetType>()
            {
                CreateSheet(PolicyStatus.Approved)
            };

            // Act
            RegionTypeWriter.WriteToPaaSDatabase(regionTypeSheets, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                var foundRegionType = context.RegionTypes.Find(TestRegionTypeCode);
                Assert.IsNotNull(foundRegionType);
            }
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RegionTypeWriter_ShouldUpdateRowWhenKeyAlreadyExists()
        {
            // Arrange
            const string updatedRegionTypeName = "UpdatedRegionTypeName";
            CleanUp();
            CreateAndSaveRegionType();

            // Act
            IList<RegionTypeSheetType> regionTypeSheets = new List<RegionTypeSheetType>()
            {
                CreateSheet(PolicyStatus.Approved, updatedRegionTypeName)
            };
            RegionTypeWriter.WriteToPaaSDatabase(regionTypeSheets, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                var foundRegionType = context.RegionTypes.Find(TestRegionTypeCode);
                Assert.IsNotNull(foundRegionType, "RegionType entity was not found for the given RegionTypeCode");
                Assert.AreEqual(updatedRegionTypeName, foundRegionType.RegionTypeName,
                    "RegionTypeName field was not updated correctly");
            }
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RegionTypeWriter_ShouldDeleteForGivenKey()
        {
            // Arrange
            CleanUp();
            CreateAndSaveRegionType();
            IList<RegionTypeSheetType> regionTypeSheets = new List<RegionTypeSheetType>()
            {
                CreateSheet(PolicyStatus.Removed)
            };

            // Act
            RegionTypeWriter.WriteToPaaSDatabase(regionTypeSheets, WriterBehaviour.Delete);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                var foundRegionType = context.RegionTypes.Find(TestRegionTypeCode);
                Assert.IsNull(foundRegionType);
            }
        }

        private RegionTypeSheetType CreateSheet(PolicyStatus policyStatus, string testRegionTypeName = TestRegionTypeName)
        {
            RegionTypeSheetType regionTypeSheetsType = new RegionTypeSheetType()
            {
                RegionTypeCode = TestRegionTypeCode,
                RegionTypeName = testRegionTypeName,
                PolicyStatus = policyStatus
            };
            return regionTypeSheetsType;
        }

        private void CreateAndSaveRegionType()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.RegionTypes.Add(new RegionType(TestRegionTypeCode, TestRegionTypeName));
                context.SaveChanges();
            }
        }

        private void CleanUp()
        {
            using (var context = new ContractManagementDbContext())
            {
                RegionType foundRegionType = context.RegionTypes.Find(TestRegionTypeCode);
                if (foundRegionType != null)
                {
                    context.RegionTypes.Remove(foundRegionType);
                    context.SaveChanges();
                }
            }
        }
    }
}
