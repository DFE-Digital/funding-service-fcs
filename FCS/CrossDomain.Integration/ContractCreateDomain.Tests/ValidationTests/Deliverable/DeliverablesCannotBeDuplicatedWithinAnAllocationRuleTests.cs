namespace ContractCreateDomain.Tests.ValidationTests.Deliverable
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.Deliverable;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule DBR-003
    /// </summary>
    [TestClass]
    public class DeliverablesCannotBeDuplicatedWithinAnAllocationRuleTests : ContractRequestValidationBase
    {
        private DeliverablesCannotBeDuplicatedWithinAnAllocationRule _rule;

        [TestInitialize]
        public void Startup()
        {
            _rule = new DeliverablesCannotBeDuplicatedWithinAnAllocationRule();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablesCannotBeDuplicatedWithinAnAllocationRule_ShouldEnsureAValidDeliverableWithNoDuplicatesPassesValidation()
        {
            Assert.IsFalse(_rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablesCannotBeDuplicatedWithinAnAllocationRule_ShouldEnsureAValidDeliverableWithDuplicatesFailsValidation()
        {
            var allocation = Contract.GetAllocations().First();
            allocation.contractDeliverables.Add(allocation.contractDeliverables.First());
            Assert.IsTrue(_rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablesCannotBeDuplicatedWithinAnAllocationRule_ShouldPassWhenGivenValidEfaContractWithDeliveryOrganisations()
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
