namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;

    [TestClass]
    public class RevisedNewIntentContractNumberExistsRuleTest : ContractRequestValidationBase
    {
        private RevisedNewContractNumberMustExistRule _validator;

        [TestInitialize]
        public void Startup()
        {
            _validator = new RevisedNewContractNumberMustExistRule();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnsureContractHasExistingWithdrawnContractNumberForRevisedNew()
        {
            // Arrange
            var contract = Contract.contract.contracts.First();

            contract.CRMIntent = intent.RevisedNew;
            contract.IsWithdrawnContractWithContractNumberPresentInCrm = true;

            // Act & Assert
            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDoesNotHaveExistingWithdrawnContractNumberForRevisedNew()
        {
            // Arrange
            var contract = Contract.contract.contracts.First();

            contract.CRMIntent = intent.RevisedNew;
            contract.IsWithdrawnContractWithContractNumberPresentInCrm = false;

            // Act
            IEnumerable<string> errors = _validator.GetFailuresForItem(Contract);

            // Assert
            Assert.IsTrue(errors.Any());
        }
    }
}
