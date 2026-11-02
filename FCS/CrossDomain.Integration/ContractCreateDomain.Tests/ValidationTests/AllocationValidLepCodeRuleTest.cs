namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using System.Collections.Generic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AllocationValidLepCodeRuleTest : ContractRequestValidationBase
    {
        private AllocationValidLepCodeRule _rule;
        private const string VALIDESFLEPCODE = "E37001";

        [TestInitialize]
        public void Setup()
        {
            var validLepCodes = new List<string> {VALIDESFLEPCODE, "E37002", "E37003", "E37004", "E37005"};

            _rule = new AllocationValidLepCodeRule(validLepCodes);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_NonESF_LEPCodeIsNull()
        {
            Assert.AreEqual(0, _rule.GetFailuresForItem(Contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_NonESF_LEPCodeIsNotNull()
        {
            Contract.contract.contracts[0].contractAllocations[0].LEPCode = "fail";
            var expectedAllocationCorrelationId = Contract.contract.contracts[0].contractAllocations[0].correlationId;

            var failedAllocationCorrelationIds = _rule.GetFailuresForItem(Contract);

            Assert.IsNotNull(failedAllocationCorrelationIds);
            Assert.AreEqual(1, failedAllocationCorrelationIds.Count());
            Assert.AreEqual(expectedAllocationCorrelationId, failedAllocationCorrelationIds.First());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_ESF_LEPCodeIsValid()
        {
            EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.LEPCode = VALIDESFLEPCODE));
            
            Assert.AreEqual(0, _rule.GetFailuresForItem(EsfContract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_ESF_InvalidLEPCode()
        {
            EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.LEPCode = VALIDESFLEPCODE));
            EsfContract.contract.contracts[0].contractAllocations[0].LEPCode = "fail";
            var expectedAllocationCorrelationId = EsfContract.contract.contracts[0].contractAllocations[0].correlationId;

            var failures = _rule.GetFailuresForItem(EsfContract).ToList();

            Assert.IsNotNull(failures);
            Assert.AreEqual(1, failures.Count());
            Assert.AreEqual(expectedAllocationCorrelationId, failures.First());
        }
    }
}
