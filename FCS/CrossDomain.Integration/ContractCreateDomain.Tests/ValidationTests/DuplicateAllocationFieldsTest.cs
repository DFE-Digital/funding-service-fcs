//namespace ContractCreateDomain.Tests.ValidationTests
//{
//    using System.Linq;
//    using Castle.Core.Internal;
//    using Microsoft.VisualStudio.TestTools.UnitTesting;
//    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;

//    [TestClass]
//    public class DuplicateAllocationFieldsTest : ContractRequestValidationBase
//    {
//        private const string TestCategory = "UnitTest";
//        private DuplicateAllocationFields _validator;

//        [TestInitialize]
//        public void Startup()
//        {
//            _validator = new DuplicateAllocationFields();
//        }

//        [TestMethod, TestCategory(TestCategory)]
//        public void EnsureCorrelationIdsAreNotReturnedForDuplicateFieldsForNonEsfAllocations()
//        {
//            Contract.GetAllocations().ForEach(a => a.tenderSpecificationReference = "Duplicate");
//            Contract.GetAllocations().ForEach(a => a.lotReference = "DuplicateLot");
//            Contract.GetAllocations().ForEach(a => a.tenderAwardReference = "DuplicateAward");

//            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
//        }

//        [TestMethod, TestCategory(TestCategory)]
//        public void EnsureCorrelationIdsAreReturnedForDuplicateFieldsForEsfAllocations()
//        {
//            EsfContract.GetAllocations().ForEach(a => a.tenderSpecificationReference = "Duplicate");
//            EsfContract.GetAllocations().ForEach(a => a.lotReference = "DuplicateLot");
//            EsfContract.GetAllocations().ForEach(a => a.tenderAwardReference = "DuplicateAward");

//            var expectedErrorAllocationCorrelationIds = EsfContract.GetAllocations().Select(a => a.correlationId).ToList();

//            var errorList = _validator.GetFailuresForItem(EsfContract);

//            Assert.IsNotNull(errorList);
//            CollectionAssert.AreEquivalent(expectedErrorAllocationCorrelationIds, errorList.ToList());
//        }

//        [TestMethod, TestCategory(TestCategory)]
//        public void EnsureCorrelationIdsAreNotReturnedForDuplicateITTReferencesForNonEsfAllocations()
//        {
//            Contract.GetAllocations().ForEach(a => a.tenderSpecificationReference = "Duplicate");

//            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
//        }

//        [TestMethod, TestCategory(TestCategory)]
//        public void EnsureCorrelationIdsAreNotReturnedForDuplicateITTReferencesWithinEsfAllocations()
//        {
//            EsfContract.GetAllocations().ForEach(a => a.tenderSpecificationReference = "Duplicate");

//            Assert.IsFalse(_validator.GetFailuresForItem(EsfContract).Any());
//        }

//        [TestMethod, TestCategory(TestCategory)]
//        public void EnsureCorrelationIdsAreNotReturnedForDuplicateLotReferencesForNonEsfAllocations()
//        {
//            Contract.GetAllocations().ForEach(lr => lr.lotReference = "DuplicateLot");

//            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
//        }

//        [TestMethod, TestCategory(TestCategory)]
//        public void EnsureCorrelationIdsAreNotReturnedForDuplicateLotReferencesWithinEsfAllocations()
//        {
//            EsfContract.GetAllocations().ForEach(a => a.lotReference = "DuplicateLot");

//            Assert.IsFalse(_validator.GetFailuresForItem(EsfContract).Any());
//        }

//        [TestMethod, TestCategory(TestCategory)]
//        public void EnsureCorrelationIdsAreNotReturnedForADuplicateAwardReferenceForNonEsfAllocations()
//        {
//            Contract.GetAllocations().ForEach(a => a.tenderAwardReference = "DuplicateAward");

//            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
//        }

//        [TestMethod, TestCategory(TestCategory)]
//        public void EnsureCorrelationIdsAreNotReturnedForDuplicateAwardReferencesWithinEsfAllocations()
//        {
//            EsfContract.GetAllocations().ForEach(a => a.tenderAwardReference = "DuplicateAward");

//            Assert.IsFalse(_validator.GetFailuresForItem(EsfContract).Any());
//        }

//        [TestMethod, TestCategory(TestCategory)]
//        public void EnsureCorrelationIdsAreNotReturnedForNonDuplicateFieldsForNonEsfAllocations()
//        {
//            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
//        }

//        [TestMethod, TestCategory(TestCategory)]
//        public void EnsureCorrelationIdsAreNotReturnedForNonDuplicateFieldsWithinEsfAllocations()
//        {
//            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
//        }

//        //TODO: tests for contracts with duplicate fields, but only 1 esf allocation. check no correlation ids returned
//        //TODO: tests for duplicates in 2 allocs, not all
//        //TODO: tests for duplicates in 1 or 2 fields only
//        //TODO: tests for 1 field duplicated in 2 allocs, and a different field duplicated in different set of allocs
//        //TODO: tests for all fields null, 1 field populates & others null. check no correlation ids returned
//    }
//}
