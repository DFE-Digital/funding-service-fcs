namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;

    [TestClass]
    public class RevisedNewIntentNoNonWithdrawnContractsAllowedRuleTest : ContractRequestValidationBase
    {
        private RevisedNewNoNonWithdrawnContractsAllowed _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new RevisedNewNoNonWithdrawnContractsAllowed();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureContractHasNoExistingApprovedContractForRevisedNew()
        {
            var contract = Contract.contract.contracts.First();

            contract.CRMIntent = intent.RevisedNew;
            contract.IsNonWithdrawnOrSupersededDraftContractWithContractNumberPresentInCrm = false;

            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDoesHaveExistingApprovedContractForRevisedNew()
        {
            var contract = Contract.contract.contracts.First();

            contract.CRMIntent = intent.RevisedNew;
            contract.IsNonWithdrawnOrSupersededDraftContractWithContractNumberPresentInCrm = true;

            IEnumerable<string> errors = _validator.GetFailuresForItem(Contract);

            Assert.IsTrue(errors.Any());
        }
    }
}
