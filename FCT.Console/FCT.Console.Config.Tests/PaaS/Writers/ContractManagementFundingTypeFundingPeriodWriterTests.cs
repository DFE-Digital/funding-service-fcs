namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System;
    using System.Globalization;
    using System.Collections.Generic;
    using Config.Transformers;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using UnitTests.Common;

    [TestClass]
    public class ContractManagementFundingTypeFundingPeriodWriterTests : TestBase
    {
        private const string FundingTypeCodeToInsert = "FundingTypeCodeToInsert";
        private const string FundingPeriodNameToInsert = "FundingPeriodNameToInsert";
        private const string TestTemplateName = "Test_TN";

        private readonly DateTime _testContractingActivityCloseDateTime = DateTime.ParseExact("17/05/2017 00:00:00", "dd/MM/yyyy hh:mm:ss",
            CultureInfo.InvariantCulture);

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodItems.RemoveByKey(FundingTypeCodeToInsert, FundingPeriodNameToInsert);

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewFundingTypePeriod_NewFundingTypePeriod_IsInserted_InPaasTable()
        {
            //arrange
            List<FundingTypePeriodSheetType> testFundingTypeFundingPeriods = CreateApprovedTestFundingTypeFundingPeriods();

            // act
            ContractManagementFundingTypeFundingPeriodWriter.WriteToPaaSDatabase(testFundingTypeFundingPeriods, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new ContractManagementDbContext())
            {
                FundingTypeFundingPeriod recordInserted =
                    context.FundingTypeFundingPeriodItems.Find(FundingTypeCodeToInsert, FundingPeriodNameToInsert);

                Assert.IsNotNull(recordInserted);
                Assert.AreEqual(TestTemplateName, recordInserted.TemplateName);
                Assert.AreEqual("Manual", recordInserted.ApprovalType);
                Assert.AreEqual(true, recordInserted.SkipCaseloadAssignment);
                Assert.AreEqual(true, recordInserted.SkipDocumentMerge);
                Assert.AreEqual(true, recordInserted.SkipReviewAndInternalApproval);
                Assert.AreEqual(true, recordInserted.DocumentsRequired);
                Assert.AreEqual(true, recordInserted.AreContractsOpenEnded);
                Assert.AreEqual(_testContractingActivityCloseDateTime, recordInserted.ContractingActivityCloseDate.GetValueOrDefault());
                Assert.IsTrue(recordInserted.AllowNewAmendment);
                Assert.IsTrue(recordInserted.IncludeAllContractsOnSummaryOfFunding);
                Assert.AreEqual("AmendmentTemplate", recordInserted.AmendmentTemplate);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedFundingTypePeriod_ExistingFundingTypePeriod_IsUpdated_InPaasTable()
        {
            // arrange
            var updatedValue = "Electronic";

            //Setup data
            using (var context = new ContractManagementDbContext())
            {
                var originalTestFundingTypeFundingPeriods = CreateApprovedTestFundingTypeFundingPeriods();
                context.FundingTypeFundingPeriodItems.Add(TypeTransformer.Transform<FundingTypePeriodSheetType, FundingTypeFundingPeriod>(originalTestFundingTypeFundingPeriods[0]));
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestFundingStreams = CreateApprovedTestFundingTypeFundingPeriods();
            newTestFundingStreams[0].ApprovalType = updatedValue;
            newTestFundingStreams[0].SkipCaseloadAssignment = false;
            newTestFundingStreams[0].SkipReviewAndInternalApproval = false;
            newTestFundingStreams[0].AreContractsOpenEnded = false;
            newTestFundingStreams[0].AllowNewAmendment = false;
            newTestFundingStreams[0].IncludeAllContractsOnSummaryOfFunding = false;

            // act
            ContractManagementFundingTypeFundingPeriodWriter.WriteToPaaSDatabase(newTestFundingStreams, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new ContractManagementDbContext())
            {
                var updatedRecord = context.FundingTypeFundingPeriodItems.Find(FundingTypeCodeToInsert, FundingPeriodNameToInsert);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(updatedValue, updatedRecord.ApprovalType);
                Assert.AreEqual(false, updatedRecord.SkipCaseloadAssignment);
                Assert.AreEqual(false, updatedRecord.SkipReviewAndInternalApproval);
                Assert.AreEqual(false, updatedRecord.AreContractsOpenEnded);
                Assert.AreEqual(TestTemplateName, updatedRecord.TemplateName);
                Assert.IsFalse(updatedRecord.AllowNewAmendment);
                Assert.IsFalse(updatedRecord.IncludeAllContractsOnSummaryOfFunding);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aFundingStreamToBeDeleted_TheFundingStream_IsDeleted_InPaasTable()
        {
            // arrange
            var testFundingTypeFundingPeriods = CreateApprovedTestFundingTypeFundingPeriods();
            testFundingTypeFundingPeriods[0].PolicyStatus = PolicyStatus.Removed;
            //Setup data to delete
            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodItems.Add(TypeTransformer.Transform<FundingTypePeriodSheetType, FundingTypeFundingPeriod>(testFundingTypeFundingPeriods[0]));
                context.SaveChanges();
            }

            // act
            ContractManagementFundingTypeFundingPeriodWriter.WriteToPaaSDatabase(testFundingTypeFundingPeriods, WriterBehaviour.Delete);

            // assert
            using (var context = new ContractManagementDbContext())
            {
                var deletedRecord = context.FundingTypeFundingPeriodItems.Find(FundingTypeCodeToInsert, FundingPeriodNameToInsert);
                Assert.IsNull(deletedRecord);
            }
        }

        private  List<FundingTypePeriodSheetType> CreateApprovedTestFundingTypeFundingPeriods()
        {
            // arrange
            return new List<FundingTypePeriodSheetType>
            {
                new FundingTypePeriodSheetType
                {
                    FundingTypeCode = FundingTypeCodeToInsert,
                    FundingPeriod = FundingPeriodNameToInsert,
                    ApprovalType = "Manual",
                    SkipCaseloadAssignment = true,
                    SkipReviewAndInternalApproval = true,
                    DocumentsRequired = true,
                    SkipDocumentMerge = true,
                    PolicyStatus = PolicyStatus.Approved,
                    TemplateName = TestTemplateName,
                    ContractingActivityCloseDate = _testContractingActivityCloseDateTime,
                    AreContractsOpenEnded = true,
                    AllowNewAmendment = true,
                    IncludeAllContractsOnSummaryOfFunding = true,
                    AmendmentTemplate = "AmendmentTemplate"
                }
            };
        }
    }
}
