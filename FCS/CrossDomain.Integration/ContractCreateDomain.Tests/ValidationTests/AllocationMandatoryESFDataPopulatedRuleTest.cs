namespace ContractCreateDomain.Tests.ValidationTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using System.Linq;

    /// <summary>
    /// Summary description for ManadatoryESFDataPopulatedRuleTest
    /// </summary>
    [TestClass]
    public class AllocationMandatoryESFDataPopulatedRuleTest : ContractRequestValidationBase
    {
        AllocationMandatoryESFDataPopulatedRule rule = new AllocationMandatoryESFDataPopulatedRule();

        [TestMethod, TestCategory("UnitTest")]
        public void AllManadatoryDataPopulatedForEsf_ValidationPassedTest()
        {
            // Arrange
            // Act
            var failures = rule.GetFailuresForItem(EsfContract);

            // Assert
            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingTenderSpecReference_ForEsf_CausesValidationToFailTest()
        {
            // Arrange
            EsfContract.contract.contracts[0].contractAllocations[0].tenderSpecificationReference = null;

            // Act
            var failures = rule.GetFailuresForItem(EsfContract);

            // Assert
            Assert.AreEqual(1, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingTenderAwardReference_ForEsf_CausesValidationToFailTest()
        {
            // Arrange
            EsfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = string.Empty;

            // Act
            var failures = rule.GetFailuresForItem(EsfContract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(EsfContract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingAllocationDescription_ForEsf_CausesValidationToFailTest()
        {
            // Arrange
            EsfContract.contract.contracts[0].contractAllocations[0].description = " ";

            // Act
            var failures = rule.GetFailuresForItem(EsfContract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(EsfContract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingInvestmentPriority_ForEsf_CausesValidationToFailTest()
        {
            // Arrange
            EsfContract.contract.contracts[0].contractAllocations[0].investmentPriority = null;

            // Act
            var failures = rule.GetFailuresForItem(EsfContract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(EsfContract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingAgreementNumber_ForEsf_CausesValidationToFailTest()
        {
            // Arrange
            EsfContract.contract.contracts[0].contractAllocations[0].agreementNumber = null;

            // Act
            var failures = rule.GetFailuresForItem(EsfContract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(EsfContract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingSpecificationTitle_ForEsf_CausesValidationToFailTest()
        {
            // Arrange
            EsfContract.contract.contracts[0].contractAllocations[0].specificationTitle = null;

            // Act
            var failures = rule.GetFailuresForItem(EsfContract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(EsfContract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);

        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingRegionType_ForEsf_CausesValidationToFailTest()
        {
            // Arrange
            EsfContract.contract.contracts[0].contractAllocations[0].regionType = null;

            // Act
            var failures = rule.GetFailuresForItem(EsfContract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(EsfContract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulePassesForNonEsfFundingStream_AllEsfMandatoryFieldsNull()
        {
            // Arrange

            // Act
            var failures = rule.GetFailuresForItem(Contract);

            // Assert
            Assert.AreEqual(0, failures.Count());
        }

        // Non ESF
        [TestMethod, TestCategory("UnitTest")]
        public void MissingTenderSpecReference_ForNonEsf_CausesValidationToFailTest()
        {
            // Arrange
            Contract.contract.contracts[0].contractAllocations[0].tenderSpecificationReference = "TestData";

            // Act
            var failures = rule.GetFailuresForItem(Contract);

            // Assert
            Assert.AreEqual(1, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingTenderAwardReference_ForNonEsf_CausesValidationToFailTest()
        {
            // Arrange
            Contract.contract.contracts[0].contractAllocations[0].tenderAwardReference = "TestData";

            // Act
            var failures = rule.GetFailuresForItem(Contract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(Contract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingInvestmentPriority_ForNonEsf_CausesValidationToFailTest()
        {
            // Arrange
            Contract.contract.contracts[0].contractAllocations[0].investmentPriority = "TestData";

            // Act
            var failures = rule.GetFailuresForItem(Contract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(Contract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingAgreementNumber_ForNonEsf_CausesValidationToFailTest()
        {
            // Arrange
            Contract.contract.contracts[0].contractAllocations[0].agreementNumber = "TestData";

            // Act
            var failures = rule.GetFailuresForItem(Contract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(Contract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingSpecificationTitle_ForNonEsf_CausesValidationToFailTest()
        {
            // Arrange
            Contract.contract.contracts[0].contractAllocations[0].specificationTitle = "TestData";

            // Act
            var failures = rule.GetFailuresForItem(Contract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(Contract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);

        }

        [TestMethod, TestCategory("UnitTest")]
        public void MissingRegionType_ForNonEsf_CausesValidationToFailTest()
        {
            // Arrange
            Contract.contract.contracts[0].contractAllocations[0].regionType = "TestData";

            // Act
            var failures = rule.GetFailuresForItem(Contract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(Contract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);
        }
    }
}
