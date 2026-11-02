namespace ContractCreateDomain.Tests.ValidationTests
{ 
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// Summary description for ManadatoryESFDataPopulatedRuleTest
    /// </summary>
    [TestClass]
    public class AllocationValidRegionTypeRuleTests : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_NonESF_RegionTypeCodeIsNull_IsValid()
        {
            // Act
            var rule = new AllocationValidRegionTypeRule(new List<string>());
            var failures = rule.GetFailuresForItem(Contract);

            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_NonESF_RegionTypeCodeIsNotNull_IsInValid()
        {
            // Arrange
            var rule = new AllocationValidRegionTypeRule(new List<string>());
            EsfContract.contract.contracts[0].contractAllocations[0].regionType = "NotNull";

            // Act
            var failures = rule.GetFailuresForItem(Contract);

            // Assert
            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_ESF_RegionTypeIsValid()
        {
            // Arrange
            var validRegionTypes = new List<string> { Guid.NewGuid().ToString(), Guid.NewGuid().ToString() };
            EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.regionType = validRegionTypes[0]));

            // Act
            var rule = new AllocationValidRegionTypeRule(validRegionTypes);
            var failures = rule.GetFailuresForItem(EsfContract);

            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_ESF_RegionTypeIsInValid()
        {
            // Arrange
            var validRegionTypes = new List<string> { Guid.NewGuid().ToString(), Guid.NewGuid().ToString() };
            EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.regionType = validRegionTypes[0]));
            EsfContract.contract.contracts[0].contractAllocations[0].regionType = "Fake region";
            
            // Act
            var rule = new AllocationValidRegionTypeRule(validRegionTypes);
            var failures = rule.GetFailuresForItem(EsfContract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(EsfContract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_ESF_RegionTypeIsNull_IsInValid()
        {
            // Arrange
            var validRegionTypes = new List<string> { Guid.NewGuid().ToString(), Guid.NewGuid().ToString() };
            EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.regionType = validRegionTypes[0]));
            EsfContract.contract.contracts[0].contractAllocations[0].regionType = null;

            // Act
            var rule = new AllocationValidRegionTypeRule(validRegionTypes);
            var failures = rule.GetFailuresForItem(EsfContract).ToList();

            // Assert
            Assert.AreEqual(1, failures.Count);
            Assert.AreEqual(EsfContract.contract.contracts[0].contractAllocations[0].correlationId, failures[0]);
        }
    }
}
