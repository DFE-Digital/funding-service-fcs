namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using System.Collections.Generic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AllocationValidSpecificationRuleTest : ContractRequestValidationBase
    {
        private AllocationValidSpecificationTitleRule _rule;
        private const string VALIDESFSPECTITLECODE = "IAG";

        [TestInitialize]
        public void Setup()
        {
            var validSpecificationTitles = new List<string>
            {
                "NEET",
                VALIDESFSPECTITLECODE,
                "Community Grants",
                "SSU",
                "SSW Skills",
                "SSW Retraining for Employment",
                "SSW Apprenticeship Services",
                "SSR",
                "IET"
            };

            _rule = new AllocationValidSpecificationTitleRule(validSpecificationTitles);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_NonESF_SpecificationTitleIsNull()
        {
            Assert.AreEqual(0, _rule.GetFailuresForItem(Contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_NonESF_SpecificationTitleIsNotNull()
        {
            Contract.contract.contracts[0].contractAllocations[0].specificationTitle = "fail";
            Assert.AreEqual(1, _rule.GetFailuresForItem(Contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_ESF_SpecificationIsValid()
        {
            EsfContract.contract.contracts.ForEach(
                ca => ca.contractAllocations.ForEach(a => a.specificationTitle = VALIDESFSPECTITLECODE));

            Assert.AreEqual(0, _rule.GetFailuresForItem(EsfContract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_ESF_InvalidSpecificationTitleCode()
        {
            EsfContract.contract.contracts.ForEach(
                ca => ca.contractAllocations.ForEach(a => a.specificationTitle = VALIDESFSPECTITLECODE));
            EsfContract.contract.contracts[0].contractAllocations[0].specificationTitle = "fail";

            List<string> failures = _rule.GetFailuresForItem(EsfContract).ToList();
            Assert.AreEqual(1, failures.Count());
            Assert.IsTrue(failures.Contains(EsfContract.contract.contracts[0].contractAllocations[0].correlationId));
        }
    }
}
