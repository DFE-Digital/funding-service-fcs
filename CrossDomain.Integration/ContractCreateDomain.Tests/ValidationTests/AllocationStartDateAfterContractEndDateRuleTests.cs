using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;

namespace ContractCreateDomain.Tests.ValidationTests
{
    [TestClass]
    public class AllocationStartDateAfterContractEndDateRuleTests : ContractRequestValidationBase
    {
        private AllocationStartDateAfterContractEndDateRule _validator;

        [TestInitialize]
        public void StartUp()
        {
            _validator = new AllocationStartDateAfterContractEndDateRule();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureAnInvalidStartDateReturnsACorrelationId()
        {
            Contract.GetAllocations().First().startDate = Contract.contract.contracts.First().endDate.Value.AddDays(50);
            Assert.IsTrue(_validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureAValidStartDateIsValidatedCorrectly()
        {
            Contract.GetAllocations().First().startDate = Contract.contract.contracts.First().endDate.Value.AddDays(-1);
            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }

    }
}
