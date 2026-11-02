namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class FspGroupWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FspGroupWriter_ShouldWriteNewRows()
        {
            // arrange
            const string fspGroupCode = "XX Code";

            RemoveRowForFspGroupCode(fspGroupCode);

            List<FspGroupSheetType> rows = new List<FspGroupSheetType>
            {
                new FspGroupSheetType
                {
                    FSPGroupCode = fspGroupCode,
                    ContractDocumentDisplayName = "D name",
                    DisplayOrder = 10,
                    PolicyStatus = PolicyStatus.Approved
                }
            };

            // act
            FspGroupWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                var retrievedModel = context.FSPGroups.SingleOrDefault(g => g.FSPGroupCode == fspGroupCode);
                Assert.IsNotNull(retrievedModel, "The row has not been inserted");  
                Assert.AreEqual(rows[0].ContractDocumentDisplayName, retrievedModel.ContractDocumentDisplayName, "ContractDocumentDisplayName not correct");
                Assert.AreEqual(rows[0].DisplayOrder, retrievedModel.DisplayOrder, "DisplayOrder not correct");
            }
            RemoveRowForFspGroupCode(fspGroupCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FspGroupWriter_ShouldUpdateExistingRows()
        {
            // arrange
            const string fspGroupCode = "XX Code";

            RemoveRowForFspGroupCode(fspGroupCode);

            using (var context = new DocumentsDomainDbContext())
            {
                context.FSPGroups.Add(new FSPGroup(fspGroupCode, "some name", 101));

                context.SaveChanges();
            }

            List<FspGroupSheetType> rows = new List<FspGroupSheetType>
            {
                new FspGroupSheetType
                {
                    FSPGroupCode = fspGroupCode,
                    ContractDocumentDisplayName = "D name",
                    DisplayOrder = 10,
                    PolicyStatus = PolicyStatus.Approved
                }
            };

            // act
            FspGroupWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                var retrievedModel = context.FSPGroups.SingleOrDefault(g => g.FSPGroupCode == fspGroupCode);
                Assert.IsNotNull(retrievedModel, "The row should be present");
                Assert.AreEqual(rows[0].ContractDocumentDisplayName, retrievedModel.ContractDocumentDisplayName, "ContractDocumentDisplayName not correct");
                Assert.AreEqual(rows[0].DisplayOrder, retrievedModel.DisplayOrder, "DisplayOrder not correct");
            }
            RemoveRowForFspGroupCode(fspGroupCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FspGroupWriter_ShouldRemoveExistingRows()
        {
            // arrange
            const string fspGroupCode = "XX Code";

            RemoveRowForFspGroupCode(fspGroupCode);

            using (var context = new DocumentsDomainDbContext())
            {
                context.FSPGroups.Add(new FSPGroup(fspGroupCode, "some name", 101));

                context.SaveChanges();
            }

            List<FspGroupSheetType> rows = new List<FspGroupSheetType>
            {
                new FspGroupSheetType
                {
                    FSPGroupCode = fspGroupCode,
                    ContractDocumentDisplayName = "D name",
                    DisplayOrder = 10,
                    PolicyStatus = PolicyStatus.Removed
                }
            };

            // act
            FspGroupWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                var retrievedModel = context.FSPGroups.SingleOrDefault(g => g.FSPGroupCode == fspGroupCode);
                Assert.IsNull(retrievedModel, "The row should not be present");
            }
        }

        private void RemoveRowForFspGroupCode(string fspGroupCode)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FSPGroups.Where(g => g.FSPGroupCode == fspGroupCode)
                    .ToList()
                    .ForEach(g => context.FSPGroups.Remove(g));

                context.SaveChanges();
            }
        }
    }
}
