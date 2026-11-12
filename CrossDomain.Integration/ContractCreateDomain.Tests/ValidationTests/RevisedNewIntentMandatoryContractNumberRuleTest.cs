namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;

    [TestClass]
    public class RevisedNewIntentMandatoryContractNumberRuleTest : ContractRequestValidationBase
    {
        private RevisedNewContractsMustHaveContractNumberRule _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new RevisedNewContractsMustHaveContractNumberRule();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureContractHasContractNumberForRevisedNew()
        {
            var contracts = Contract.contract.contracts.First();

            contracts.contractNumber = "ABC";
            contracts.CRMIntent = Intent.RevisedNew;

            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDoesNotHaveContractNumberForRevisedNew()
        {
            var contracts = Contract.contract.contracts.First();

            contracts.contractNumber = string.Empty;
            contracts.CRMIntent = Intent.RevisedNew;

            IEnumerable<string> errors = _validator.GetFailuresForItem(Contract);

            Assert.IsTrue(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RevisedNewContractsMustHaveContractNumberRule_ShouldFailWhenMasterContractNumberNotSet()
        {
            var contracts = Contract.contract.contracts.First();

            contracts.contractNumber = string.Empty;
            contracts.CRMIntent = Intent.RevisedNew;

            IEnumerable<string> errors = _validator.GetFailuresForItem(Contract);

            Assert.IsTrue(errors.Any());
        }
    }
}
