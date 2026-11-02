namespace ContractCreateDomain.Tests.ValidationTests.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule DBR-005
    /// </summary>
    [TestClass]
    public class DeliverableYearAndPeriodCombinationRuleTests : ContractRequestValidationBase
    {
        private DeliverableYearAndPeriodCombinationRule _rule;

        [TestInitialize]
        public void Startup()
        {
            _rule = new DeliverableYearAndPeriodCombinationRule();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableYearAndPeriodCombinationRule_ShouldEnsureADeliverableWithValidYearsAndPeriodsPassesValidation()
        {
            Assert.IsFalse(_rule.GetFailuresForItem(Contract).Any());
        }


        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableYearAndPeriodCombinationRule_ShouldEnsureADeliverableWithInvalidPeriodFailsValidation()
        {
            var allocation = Contract.GetAllocations().First();

            allocation.contractDeliverables.First().contractDeliverablePeriods.First().period =
                allocation.startDate.Value.Month - 1;

            Assert.IsTrue(_rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableYearAndPeriodCombinationRule_ShouldEnsureADeliverableWithInvalidYearFailsValidation()
        {
            var allocation = Contract.GetAllocations().First();
            
            allocation.contractDeliverables.First().contractDeliverablePeriods.First().year =
                    allocation.startDate.Value.Year + 500;

            Assert.IsTrue(_rule.GetFailuresForItem(Contract).Any());
        }


        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableYearAndPeriodCombinationRule_ShouldPassWhenGivenValidEfaContractWithDeliveryOrganisations()
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
