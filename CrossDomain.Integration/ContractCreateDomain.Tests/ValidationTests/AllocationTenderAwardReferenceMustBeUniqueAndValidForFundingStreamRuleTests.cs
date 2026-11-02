namespace ContractCreateDomain.Tests.ValidationTests
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRuleTests : ContractRequestValidationBase
    {
        private const string ExistingContractNumber = "EXISTING_CONTRACT-1";
        private const string ExistingTenderAwardReference = "EXISTING_TAR-1";
        private contractRequestType _esfContract;
        private contractRequestType _nonEsfContract;
        private AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule _rule;

        [TestInitialize]
        public void Setup()
        {
            _esfContract = EsfContract;
            _nonEsfContract = Contract;

            _rule = new AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule(matchingTenderAwardReferenceItems: new List<MatchingTenderAwardReferenceItem>
            {
                new MatchingTenderAwardReferenceItem(ExistingContractNumber, "EXISTING_ALLOCATION_1", ExistingTenderAwardReference),
                new MatchingTenderAwardReferenceItem("EXISTING_CONTRACT_2", "EXISTING_ALLOCATION_2",  "EXISTING_TAR-2"),
                new MatchingTenderAwardReferenceItem("EXISTING_CONTRACT_3", "EXISTING_ALLOCATION_3",  "EXISTING_TAR-3")
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule_ShouldNotReturnFailuresForNonEsfAllocationWhenTenderAwardReferenceIsNull()
        {
            // arrange
            _nonEsfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = null;

            // act
            IEnumerable<string> failures = _rule.GetFailuresForItem(_nonEsfContract);

            // assert
            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule_ShouldNotReturnFailuresForNonEsfAllocationWhenTenderAwardReferenceIsWhiteSpace()
        {
            // arrange
            _nonEsfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = " ";

            // act
            IEnumerable<string> failures = _rule.GetFailuresForItem(_nonEsfContract);

            // assert
            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule_ShouldNotReturnFailuresForNonEsfAllocationWhenTenderAwardReferenceIsEmptyString()
        {
            // arrange
            _nonEsfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = string.Empty;

            // act
            IEnumerable<string> failures = _rule.GetFailuresForItem(_nonEsfContract);

            // assert
            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule_ShouldReturnFailuresForNonEsfAllocationWhenTenderAwardReferenceIsNotNullOrWhiteSpace()
        {
            // arrange
            _nonEsfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = "TEST";
            string expectedAllocationCorrelationId = _nonEsfContract.contract.contracts[0].contractAllocations[0].correlationId;

            // act
            List<string> failures = _rule.GetFailuresForItem(_nonEsfContract).ToList();

            // assert
            Assert.AreEqual(1, failures.Count());
            Assert.AreEqual(expectedAllocationCorrelationId, failures.First());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule_ShouldNotReturnFailuresForEsfAllocationWhenTenderAwardReferenceIsUnique()
        {
            // arrange
            _esfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.tenderAwardReference = Guid.NewGuid().ToString()));

            // act
            IEnumerable<string> failures = _rule.GetFailuresForItem(_nonEsfContract);

            // assert
            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule_ShouldReturnFailuresForEsfAllocationWhenTenderAwardReferenceAlreadyExists()
        {
            // arrange
            _esfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.tenderAwardReference = Guid.NewGuid().ToString()));
            _esfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = ExistingTenderAwardReference;
            string expectedAllocationCorrelationId = _esfContract.contract.contracts[0].contractAllocations[0].correlationId;

            // act
            List<string> failures = _rule.GetFailuresForItem(_esfContract).ToList();

            // assert
            Assert.AreEqual(1, failures.Count());
            Assert.AreEqual(expectedAllocationCorrelationId, failures.First());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule_ShouldReturnFailuresForEsfAllocationWhenTenderAwardReferenceIsNull()
        {
            // arrange
            _esfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.tenderAwardReference = Guid.NewGuid().ToString()));
            _esfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = null;
            string expectedAllocationCorrelationId = _esfContract.contract.contracts[0].contractAllocations[0].correlationId;

            // act
            List<string> failures = _rule.GetFailuresForItem(_esfContract).ToList();

            // assert
            Assert.IsNotNull(failures);
            Assert.AreEqual(1, failures.Count());
            Assert.AreEqual(expectedAllocationCorrelationId, failures.First());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule_ShouldReturnFailuresForEsfAllocationWhenTenderAwardReferenceIsWhiteSpace()
        {
            // arrange
            _esfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.tenderAwardReference = Guid.NewGuid().ToString()));
            _esfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = " ";
            string expectedAllocationCorrelationId = _esfContract.contract.contracts[0].contractAllocations[0].correlationId;

            // act
            List<string> failures = _rule.GetFailuresForItem(_esfContract).ToList();

            // assert
            Assert.IsNotNull(failures);
            Assert.AreEqual(1, failures.Count());
            Assert.AreEqual(expectedAllocationCorrelationId, failures.First());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule_ShouldReturnFailuresForEsfAllocationWhenTenderAwardReferenceIsEmptyString()
        {
            // arrange
            _esfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.tenderAwardReference = Guid.NewGuid().ToString()));
            _esfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = string.Empty;
            string expectedAllocationCorrelationId = _esfContract.contract.contracts[0].contractAllocations[0].correlationId;

            // act
            List<string> failures = _rule.GetFailuresForItem(_esfContract).ToList();

            // assert
            Assert.AreEqual(1, failures.Count());
            Assert.AreEqual(expectedAllocationCorrelationId, failures.First());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule_ShouldNotReturnFailuresWhenMatchingTenderAwardReferenceIsUsedByExistingContractBeingUpdated()
        {
            // arrange
            _esfContract.contract.contracts[0].contractNumber = ExistingContractNumber;
            _esfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = ExistingTenderAwardReference;

            // act
            IEnumerable<string> failures = _rule.GetFailuresForItem(_esfContract);

            // assert
            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationTenderAwardReferenceMustBeUniqueAndValidForFundingStreamRule_ShouldReturnFailuresWhenMatchingTenderAwardReferenceIsUsedByUnrelatedExistingContract()
        {
            // arrange
            _esfContract.contract.contracts[0].contractAllocations[0].contractAllocationNumber = "TEST";
            _esfContract.contract.contracts[0].contractAllocations[0].tenderAwardReference = ExistingTenderAwardReference;
            string expectedAllocationCorrelationId = _esfContract.contract.contracts[0].contractAllocations[0].correlationId;

            // act
            List<string> failures = _rule.GetFailuresForItem(_esfContract).ToList();

            // assert
            Assert.AreEqual(1, failures.Count());
            Assert.AreEqual(expectedAllocationCorrelationId, failures.First());
        }
    }
}
