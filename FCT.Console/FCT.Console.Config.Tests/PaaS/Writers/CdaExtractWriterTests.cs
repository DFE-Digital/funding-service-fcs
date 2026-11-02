using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using FCT.Console.Config.ExcelTypes;
using System.Collections.Generic;
using ContractManagement.DataStore;
using ContractManagement.DataStore.Model;
using System.Linq;
using MoreLinq;
using FCT.Console.Config.Synchronizers.Writers.PAAS;
using FCT.Console.Config.Synchronizers.Writers;

namespace FCT.Console.Config.Tests.PaaS.Writers
{
    [TestClass]
    public class CdaExtractWriterTests
    {
        private const string TestExtractName = "TEST EXTRACT NAME";
        private static readonly DateTime? TestReportingCloseDate = new DateTime(2017, 06, 20, 0, 0, 0, DateTimeKind.Utc);
        private const bool TestArchiveClosedContracts = true;

        [TestInitialize, TestCleanup]
        public void Cleanup()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.CdaExtracts
                    .Where(r => r.ExtractName == TestExtractName)
                    .ForEach(ti => context.CdaExtracts.Remove(ti));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractWriter_NewItem_ShouldCreateApprovedEntriesInPaas()
        {
            // arrange
            List<CdaExtractSheetType> newCdaExtract = CreateApprovedTestEntitiesToCreate(TestExtractName, TestArchiveClosedContracts, TestReportingCloseDate);

            // act
            CdaExtractWriter.WriteToPaaSDatabase(newCdaExtract, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new ContractManagementDbContext())
            {
                CdaExtract cdaExtract = context.CdaExtracts.Find(TestExtractName);
                Assert.IsNotNull(cdaExtract,"New entry was not created");
                Assert.AreEqual(TestArchiveClosedContracts, cdaExtract.ArchiveClosedContracts, "Incorrect Archive Closed Contracts in created entry");
                Assert.AreEqual(TestReportingCloseDate, cdaExtract.ReportingCloseDate, "Incorrect Reporting Close Date in created entry");
            }
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractWriter_RemoveItem_ShouldRemoveApprovedEntriesInPaas()
        {
            // arrange
            List<CdaExtractSheetType> newCdaExtract = CreateApprovedTestEntitiesToCreate(TestExtractName, TestArchiveClosedContracts, TestReportingCloseDate);
            CdaExtractWriter.WriteToPaaSDatabase(newCdaExtract, WriterBehaviour.AddOrUpdate);

            List<CdaExtractSheetType> toDeleteCdaExtract =
                new List<CdaExtractSheetType>
                {
                    new CdaExtractSheetType
                    {
                        ExtractName = TestExtractName,
                        ArchiveClosedContracts = TestArchiveClosedContracts,
                        ReportingCloseDate = TestReportingCloseDate,
                        PolicyStatus = PolicyStatus.Removed
                    }
                };

            // act
            CdaExtractWriter.WriteToPaaSDatabase(toDeleteCdaExtract, WriterBehaviour.Delete);

            // assert
            using (var context = new ContractManagementDbContext())
            {
                IEnumerable<CdaExtract> actual = context.CdaExtracts.Where(r => r.ExtractName == TestExtractName);
                Assert.IsFalse(actual.Any(), $"{actual.Count()} entries were not removed");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractWriter_NewDraftItem_ShouldNotCreateDraftEntriesInPaas()
        {
            // arrange
            List<CdaExtractSheetType> draftCdaExtract =
                new List<CdaExtractSheetType>
                {
                    new CdaExtractSheetType
                    {
                        ExtractName = TestExtractName,
                        ArchiveClosedContracts = TestArchiveClosedContracts,
                        ReportingCloseDate = TestReportingCloseDate,
                        PolicyStatus = PolicyStatus.Draft
                    }
                };


            // act
            CdaExtractWriter.WriteToPaaSDatabase(draftCdaExtract, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new ContractManagementDbContext())
            {
                IEnumerable<CdaExtract> actual =
                    context.CdaExtracts.Where(r => r.ExtractName == TestExtractName);

                Assert.IsFalse(actual.Any(), $"{actual.Count()} entries were erroneously added");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractWriter_AmendItem_ShouldAmendExistingApprovedEntriesInPaas()
        {
            // arrange
            DateTime? updateReportingCloseDate = new DateTime(2017, 07, 01, 0, 0, 0, DateTimeKind.Utc);

            List<CdaExtractSheetType> newCdaExtract = CreateApprovedTestEntitiesToCreate(TestExtractName, TestArchiveClosedContracts, TestReportingCloseDate);
            CdaExtractWriter.WriteToPaaSDatabase(newCdaExtract, WriterBehaviour.AddOrUpdate);

            List<CdaExtractSheetType> amendCdaExtract = CreateApprovedTestEntitiesToCreate(TestExtractName, TestArchiveClosedContracts, updateReportingCloseDate);

            // act
            CdaExtractWriter.WriteToPaaSDatabase(amendCdaExtract, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new ContractManagementDbContext())
            {
                CdaExtract cdaExtract = context.CdaExtracts.Find(TestExtractName);
                Assert.IsNotNull(cdaExtract, "");
                Assert.AreEqual(updateReportingCloseDate, cdaExtract.ReportingCloseDate, "Incorrect Reporting Close Date in amended entry");
            }
        }

        private static List<CdaExtractSheetType> CreateApprovedTestEntitiesToCreate(string extractName, bool archiveClosedContracts, DateTime? reportingCloseDate = null)
        {
            return new List<CdaExtractSheetType>
            {
                new CdaExtractSheetType
                {
                    ExtractName = extractName,
                    ArchiveClosedContracts = archiveClosedContracts,
                    ReportingCloseDate = reportingCloseDate,
                    PolicyStatus = PolicyStatus.Approved
                }
            };
        }
    }
}
