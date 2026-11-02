using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;

namespace ContractCreateDomain.Tests.ValidationTests
{
    [TestClass]
    public class AllocationStartDateBeforeContractStartDateRuleTests : ContractRequestValidationBase
    {
        AllocationStartDateBeforeContractStartDateRule _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new AllocationStartDateBeforeContractStartDateRule();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureAnAllocationStartDateCannotBePriorToAContractStartDate()
        {
            Contract.GetAllocations().First().startDate = Contract.contract.contracts.First().startDate.Value.AddDays(-1);
            Assert.IsTrue(_validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureAValidAllocationStartDateIsValidatedCorrectly()
        {
            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }

    }
}
