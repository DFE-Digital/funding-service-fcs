using System;
using System.Linq;
using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

namespace ContractCreateDomain.Tests.ValidationTests
{
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    [TestClass]
    public class StartAndEndDatesMustNotBeTheSameRuleTest : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenDatesEqualOnMaster()
        {
            Contract.contract.startDate = Contract.contract.endDate;
            StartAndEndDatesMustNotBeTheSameContractRule contractRule = new StartAndEndDatesMustNotBeTheSameContractRule();
            Assert.IsTrue(contractRule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageWhenDatesNotEqualOnMaster()
        {
            Contract.contract.endDate = DateTime.Now.AddYears(1);
            Contract.contract.startDate = DateTime.Now;
            StartAndEndDatesMustNotBeTheSameContractRule contractRule = new StartAndEndDatesMustNotBeTheSameContractRule();
            Assert.IsFalse(contractRule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenDatesEqualOnContract()
        {
            var contract = Contract.contract.contracts.First();
            contract.startDate = contract.endDate;
            StartAndEndDatesMustNotBeTheSameContractRule contractRule = new StartAndEndDatesMustNotBeTheSameContractRule();
            Assert.IsTrue(contractRule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageWhenDatesNotEqualOnContract()
        {
            var master = Contract.contract;
            master.startDate = DateTime.Now;
            master.endDate = DateTime.Now.AddYears(1);
            var contract = Contract.contract.contracts.First();
            contract.startDate = DateTime.Now;
            contract.endDate = DateTime.Now.AddYears(1);
            StartAndEndDatesMustNotBeTheSameContractRule contractRule = new StartAndEndDatesMustNotBeTheSameContractRule();
            Assert.IsFalse(contractRule.GetFailuresForItem(Contract).Any());
        }
    }
}
