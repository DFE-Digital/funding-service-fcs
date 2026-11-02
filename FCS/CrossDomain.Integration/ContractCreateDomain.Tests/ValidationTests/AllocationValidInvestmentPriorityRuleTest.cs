namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using System.Collections.Generic;
    using System.Xml.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using UnitTests.Common;
    using System;

    [TestClass]
    public class AllocationValidInvestmentPriorityRuleTest : ContractRequestValidationBase
    {
        private AllocationValidInvestmentPriorityRule _rule;
        private static readonly List<string> ValidPriorities = new List<string>
        {
            "1.1 Access to employment for jobseekers/ the inactive",
            "1.2 Sustainable integration of young people",
            "1.3 Youth Employment Initiative (YEI)",
            "1.4 Active Inclusion",
            "1.5 CLLD",
            "2.1 Enhancing equal access to lifelong learning",
            "2.2 Improving labour market relevance of education/ training systems",
        };

        [TestInitialize]
        public void Setup()
        {
            _rule = new AllocationValidInvestmentPriorityRule(ValidPriorities);
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_NonESF_ValidPriorities()
        {
           Contract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.investmentPriority = null));

            Assert.AreEqual<int>(0, _rule.GetFailuresForItem(Contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_NonESF_InValidPriorities()
        {
            Contract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.investmentPriority = null));
            Contract.contract.contracts[0].contractAllocations[0].investmentPriority = "fail";
            Assert.AreEqual<int>(1, _rule.GetFailuresForItem(Contract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_ESF_ValidPriorities()
        {
           EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.investmentPriority = ValidPriorities[new Random().Next(0, ValidPriorities.Count)]));
            
            Assert.AreEqual<int>(0, _rule.GetFailuresForItem(EsfContract).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_ESF_InvalidPriorities()
        {
            EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.investmentPriority = ValidPriorities[new Random().Next(0, ValidPriorities.Count)]));
            EsfContract.contract.contracts[0].contractAllocations[0].investmentPriority = "fail";

            List<string> failures = _rule.GetFailuresForItem(EsfContract).ToList();
            Assert.AreEqual<int>(1, failures.Count());
            Assert.IsTrue(failures.Contains(EsfContract.contract.contracts[0].contractAllocations[0].correlationId));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GetFailuresForItem_ESF_NullPriority()
        {
            EsfContract.contract.contracts.ForEach(ca => ca.contractAllocations.ForEach(a => a.investmentPriority = ValidPriorities[new Random().Next(0, ValidPriorities.Count)]));
            EsfContract.contract.contracts[0].contractAllocations[0].investmentPriority = null;

            List<string> failures = _rule.GetFailuresForItem(EsfContract).ToList();
            Assert.AreEqual<int>(1, failures.Count());
            Assert.IsTrue(failures.Contains(EsfContract.contract.contracts[0].contractAllocations[0].correlationId));
        }
    }
}
