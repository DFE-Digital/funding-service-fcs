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
    public class ContractAllocationEndDateBeforeContractStartDateRuleTests : ContractRequestValidationBase
    {
        private AllocationEndDateBeforeContractStartDateRule _validator;

        [TestInitialize]
        public void StartUp()
        {
            _validator = new AllocationEndDateBeforeContractStartDateRule();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureAnInvalidStartDateReturnsACorrelationId()
        {
            _contract.GetAllocations().First().endDate = _contract.contract.contracts.First().startDate.Value.AddDays(-50);
            Assert.IsTrue(_validator.GetFailuresForItem(_contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureAValidStartDateIsValidatedCorrectly()
        {
            Assert.IsFalse(_validator.GetFailuresForItem(_contract).Any());
        }

    }
}
