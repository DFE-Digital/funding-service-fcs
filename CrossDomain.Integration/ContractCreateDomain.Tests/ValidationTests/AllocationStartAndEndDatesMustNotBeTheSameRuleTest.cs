using System;
using System.Linq;
using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

namespace ContractCreateDomain.Tests.ValidationTests
{
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    [TestClass]
    public class AllocationStartAndEndDatesMustNotBeTheSameRuleTest : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenDatesEqualOnAllocation()
        {
           var allocation = Contract.GetAllocations().FirstOrDefault();
           allocation.endDate = allocation.startDate;
           AllocationStartAndEndDatesMustNotBeTheSameRule contractRule = new AllocationStartAndEndDatesMustNotBeTheSameRule();
           Assert.IsTrue(contractRule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageWhenDatesNotEqualOnAllocation()
        {
            var allocation = Contract.GetAllocations().FirstOrDefault();
            allocation.endDate = allocation.startDate.Value.AddDays(1);
            AllocationStartAndEndDatesMustNotBeTheSameRule contractRule = new AllocationStartAndEndDatesMustNotBeTheSameRule();
            Assert.IsFalse(contractRule.GetFailuresForItem(Contract).Any());
        }
    }
}
