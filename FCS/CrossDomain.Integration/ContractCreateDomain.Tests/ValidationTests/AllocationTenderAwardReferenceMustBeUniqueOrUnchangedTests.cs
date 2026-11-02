namespace ContractCreateDomain.Tests.ValidationTests
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;

    [TestClass]
    public class AllocationTenderAwardReferenceMustBeUniqueOrUnchangedTests : ContractRequestValidationBase
    {
        private AllocationTenderAwardReferenceMustBeUniqueOrUnchanged _rule;

        [TestInitialize]
        public void Setup()
        {
            var matchingTenderAwardReferences = new List<MatchingTenderAwardReferenceItem>()
            {
                new MatchingTenderAwardReferenceItem("CONTRACT1", "AR1", "TAR1"),
                new MatchingTenderAwardReferenceItem("CONTRACT2", "AR2", "TAR2"),
                new MatchingTenderAwardReferenceItem("CONTRACT3", "AR3", "TAR3")
            };

            _rule = new AllocationTenderAwardReferenceMustBeUniqueOrUnchanged(matchingTenderAwardReferences);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_TAR_MustBeUniqueOrUnchanged_GetFailuresForItem_NonESF_TARIsNull_IsValid()
        {
            Assert.AreEqual(0, _rule.GetFailuresForItem(Contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_TAR_MustBeUniqueOrUnchanged_GetFailuresForItem_NonESF_TARIsNotNull_IsInvalid()
        {
            Contract.contract.contracts[0].contractAllocations[0].tenderAwardReference = "TAR1";
            var expectedAllocationCorrelationId = Contract.contract.contracts[0].contractAllocations[0].correlationId;

            var failedAllocationCorrelationIds = _rule.GetFailuresForItem(Contract).ToList();

            Assert.IsNotNull(failedAllocationCorrelationIds);
            Assert.AreEqual(1, failedAllocationCorrelationIds.Count());
            Assert.AreEqual(expectedAllocationCorrelationId, failedAllocationCorrelationIds.First());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_TAR_MustBeUniqueOrUnchanged_GetFailuresForItem_ESF_TARIsUnique_IsValid()
        {
            EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.tenderAwardReference = Guid.NewGuid().ToString()));

            Assert.AreEqual(0, _rule.GetFailuresForItem(EsfContract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_TAR_MustBeUniqueOrUnchanged_GetFailuresForItem_ESF_TARUnchanged_IsValid()
        {
            EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.tenderAwardReference = Guid.NewGuid().ToString()));
            EsfContract.contract.contracts[0].contractAllocations[0].contractAllocationNumber = "AR1";
            EsfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = "TAR1";

            var failures = _rule.GetFailuresForItem(EsfContract).ToList();

            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_TAR_MustBeUniqueOrUnchanged_GetFailuresForItem_ESF_TARAlreadyExists_IsInValid()
        {
            EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.tenderAwardReference = Guid.NewGuid().ToString()));
            EsfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = "TAR1";
            var expectedAllocationCorrelationId = EsfContract.contract.contracts[0].contractAllocations[0].correlationId;

            var failures = _rule.GetFailuresForItem(EsfContract).ToList();

            Assert.IsNotNull(failures);
            Assert.AreEqual(1, failures.Count());
            Assert.AreEqual(expectedAllocationCorrelationId, failures.First());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_TAR_MustBeUniqueOrUnchanged_GetFailuresForItem_ESF_TARIsNull_IsInValid()
        {
            EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.tenderAwardReference = Guid.NewGuid().ToString()));
            EsfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = null;
            var expectedAllocationCorrelationId = EsfContract.contract.contracts[0].contractAllocations[0].correlationId;

            var failures = _rule.GetFailuresForItem(EsfContract).ToList();

            Assert.IsNotNull(failures);
            Assert.AreEqual(1, failures.Count());
            Assert.AreEqual(expectedAllocationCorrelationId, failures.First());
        }
    }
}
