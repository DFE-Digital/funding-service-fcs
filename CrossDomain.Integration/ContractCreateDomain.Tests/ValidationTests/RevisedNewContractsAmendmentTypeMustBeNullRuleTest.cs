namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class RevisedNewContractsAmendmentTypeMustBeNullRuleTest : ContractRequestValidationBase
    {
        private RevisedNewContractsAmendmentTypeMustBeNullRule _validator;

        [TestInitialize]
        public void Setup()
        {
            _validator = new RevisedNewContractsAmendmentTypeMustBeNullRule();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenRevisedNewContractHasNonNullAmendment()
        {
            Contract.contract.amendmentType = amendmentType.Variation;
            Contract.contract.CRMIntent = Intent.RevisedNew;

            Assert.IsTrue(_validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageWhenRevisedNewContractHasNullAmendment()
        {
            Contract.contract.amendmentType = amendmentType.None;
            Contract.contract.CRMIntent = Intent.RevisedNew;

            Assert.IsFalse(_validator.GetFailuresForItem(Contract).Any());
        }
    }
}
