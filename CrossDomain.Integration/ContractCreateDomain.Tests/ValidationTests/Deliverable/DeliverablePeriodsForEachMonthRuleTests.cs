namespace ContractCreateDomain.Tests.ValidationTests.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class DeliverablePeriodsForEachMonthRuleTests : ContractRequestValidationBase
    {
        private DeliverablePeriodForEachMonthRule _rule;

        [TestInitialize]
        public void Startup()
        {
            _rule = new DeliverablePeriodForEachMonthRule();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodsForEachMonthRuleTests_ShouldEnsureAValidDeliverableContainingTheCorrectNumberOfPeriodsPassesValidation()
        {
            Assert.IsFalse(_rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodForEachMonthRule_ShouldEnsureAValidDeliverableContainingAMissingPeriodFailsValidation()
        {
            Contract.GetDeliverables().First().contractDeliverablePeriods.RemoveAt(0);
            Assert.IsTrue(_rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodForEachMonthRule_ShouldEnsureAValidDeliverableContainingAPeriodForAnIncorrectDateFailsValidation()
        {
            var allocation = Contract.GetAllocations().First();

            allocation.contractDeliverables.First().contractDeliverablePeriods.First().period =
                allocation.startDate.Value.AddMonths(-1).Month;
            
            Assert.IsTrue(_rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePeriodForEachMonthRule_ShouldPassWhenGivenValidEfaContractWithDeliveryOrganisations()
        {
            // arrange
            contractRequestType efaContract = GetUpdateDraftEfaContract();

            // act
            IEnumerable<string> failures = _rule.GetFailuresForItem(efaContract);

            // assert
            Assert.IsFalse(failures.Any());
        }
    }
}
