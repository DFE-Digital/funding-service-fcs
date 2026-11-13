namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    extern alias CSICommon;
    using System.IO;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractRequestDomain.Common;
    using CSICommon::SFA.FCT.CrossDomain.Integration.Common.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    [TestClass]
    public class DeliverablePeriodDeliverableDescriptionValidationRuleTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AValidFile_WithMatchingDeliverablePeriodDeliverableDescriptionsAndAllocations_PassesValidation()
        {
            // arrange
            dataLoadResults data = GetBulkImportData();
            DeliverablePeriodDeliverableDescriptionMustMatch rule = new DeliverablePeriodDeliverableDescriptionMustMatch();

            // assert
            Assert.IsFalse(rule.GetFailuresForItem(data).Any(), "Failures were returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AnInvalidFile_WithNonMatchingDeliverablePeriodDeliverableDescriptionsInSameAllocation_FailsValidation()
        {
            // arrange
            DeliverablePeriodDeliverableDescriptionMustMatch rule = new DeliverablePeriodDeliverableDescriptionMustMatch();
            dataLoadResults data = GetBulkImportData();
            
            var file = new ContractBulkUpload(data);

            file.ContractDeliverableSheet.row
                .First().cell
                .Single(c => c.columnName == ContractBulkUpload.DeliverableDescription)
                .Value = "Invalid";

            // act
            var failures = rule.GetFailuresForItem(data);

            // assert
            Assert.IsTrue(failures.Any(), "No failures were returned");
            Assert.AreEqual(12, failures.Count, "12 failures were not returned");
            Assert.IsTrue(failures.All(f => f.Value == ErrorMessages.DeliverablePeriodDeliverableDescriptionsDoNotMatch), "Incorrect error messages returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodDeliverableDescriptionMustMatch_ShouldPassValidation_WhenNonMatchingDeliverablePeriodDeliverableDescriptionsAndNonMatchingAllocationNumbers()
        {
            // arrange
            DeliverablePeriodDeliverableDescriptionMustMatch rule = new DeliverablePeriodDeliverableDescriptionMustMatch();
            var data = GetBulkImportData();

            var file = new ContractBulkUpload(data);

            file.ContractDeliverableSheet.row
                .First().cell
                .Single(c => c.columnName == ContractBulkUpload.DeliverableDescription)
                .Value = "Different";
            file.ContractDeliverableSheet.row
                .First().cell
                .Single(c => c.columnName == ContractBulkUpload.AllocationNumber)
                .Value = "DiffAlloc";

            // act
            var failures = rule.GetFailuresForItem(data);

            // assert
            Assert.IsFalse(failures.Any(), "Failures were returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodDeliverableDescriptionMustMatch_ShouldPassValidation_WhenMatchingDeliverablePeriodDeliverableDescriptionsAndNonMatchingAllocationNumbers()
        {
            // arrange
            DeliverablePeriodDeliverableDescriptionMustMatch rule = new DeliverablePeriodDeliverableDescriptionMustMatch();
            var data = GetBulkImportData();

            var file = new ContractBulkUpload(data);

            file.ContractDeliverableSheet.row
                .First().cell
                .Single(c => c.columnName == ContractBulkUpload.AllocationNumber)
                .Value = "DiffAlloc";

            // assert
            Assert.IsFalse(rule.GetFailuresForItem(data).Any(), "Failures were returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodDeliverableDescriptionMustMatch_ShouldPassValidation_WhenNonMatchingDeliverablePeriodDeliverableDescriptionsAndNullAllocationNumbersAndNonMatchingFundingStream()
        {
            // arrange
            DeliverablePeriodDeliverableDescriptionMustMatch rule = new DeliverablePeriodDeliverableDescriptionMustMatch();
            dataLoadResults data = GetBulkImportData();

            var file = new ContractBulkUpload(data);

            file.ContractDeliverableSheet.row
                .First().cell
                .Single(c => c.columnName == ContractBulkUpload.DeliverableDescription)
                .Value = "Different";
            file.ContractDeliverableSheet.row
                .First().cell
                .Single(c => c.columnName == ContractBulkUpload.FundingStreamCode)
                .Value = "DiffFS";

            // act
            var failures = rule.GetFailuresForItem(data);

            // assert
            Assert.IsFalse(failures.Any(), "Failures were returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodDeliverableDescriptionMustMatch_ShouldFailValidation_WhenFileContainsDeliverablesWithDifferentDescsForSameAlloc()
        {
            // arrange
            DeliverablePeriodDeliverableDescriptionMustMatch rule = new DeliverablePeriodDeliverableDescriptionMustMatch();
            dataLoadResults data = GetBulkImportDataThatShouldFail();
           
            // act
            var failures = rule.GetFailuresForItem(data);

            // assert
            Assert.IsTrue(failures.Any(), "Failures aren't any failures");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodDeliverableDescriptionMustMatch_ShouldPassValidation_WhenFileContainsDeliverablesWithDifferentDescsOnDifferentAllocs()
        {
            // arrange
            DeliverablePeriodDeliverableDescriptionMustMatch rule = new DeliverablePeriodDeliverableDescriptionMustMatch();
            dataLoadResults data = GetBulkImportDataThatShouldPass();

            // act
            var failures = rule.GetFailuresForItem(data);

            // assert
            Assert.IsTrue(failures.Empty(), "There are failures");
        }

        private dataLoadResults GetBulkImportData()
        {
            byte[] fileData = TestUtils.ResourceToByteArray("ContractRequestDomain.Tests", @"Resources.DeliverablePeriodDeliverableDescription BulkImport.xlsx");
            ExcelFileParser parser = new ExcelFileParser();
            using (MemoryStream stream = new MemoryStream(fileData))
            {
                return parser.ReadFile(stream, "TestFile.xlsx");
            }
        }

        private dataLoadResults GetBulkImportDataThatShouldFail()
        {
            byte[] fileData = TestUtils.ResourceToByteArray("ContractRequestDomain.Tests", @"Resources.MAIN AY 1516 14052015130000 BulkAmendmentValidationDBR009Fail.xlsx");
            ExcelFileParser parser = new ExcelFileParser();
            using (MemoryStream stream = new MemoryStream(fileData))
            {
                return parser.ReadFile(stream, "TestFile.xlsx");
            }
        }

        private dataLoadResults GetBulkImportDataThatShouldPass()
        {
            byte[] fileData = TestUtils.ResourceToByteArray("ContractRequestDomain.Tests", @"Resources.MAIN AY 1516 14052015130000 BulkAmendmentValidationDBR009Pass.xlsx");
            ExcelFileParser parser = new ExcelFileParser();
            using (MemoryStream stream = new MemoryStream(fileData))
            {
                return parser.ReadFile(stream, "TestFile.xlsx");
            }
        }
    }
}
