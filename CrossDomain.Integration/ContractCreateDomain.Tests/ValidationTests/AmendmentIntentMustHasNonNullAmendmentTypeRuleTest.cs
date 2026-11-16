namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class AmendmentIntentMustHasNonNullAmendmentTypeRuleTest : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageForMasterContractWhenNewAmendmentIntentHasNoneAmendmentType()
        {
            Contract.contract.CRMIntent = Intent.Amendment;
            Contract.contract.amendmentType = amendmentType.None;
            var rule = new AmendmentIntentMustHasNonNullAmendmentTypeRule();
            Assert.IsTrue(rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageForMasterContractWhenNewAmendmentIntentHasNotificationAmendmentType()
        {
            Contract.contract.CRMIntent = Intent.Amendment;
            Contract.contract.amendmentType = amendmentType.Notification;
            var rule = new AmendmentIntentMustHasNonNullAmendmentTypeRule();
            Assert.IsFalse(rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageForContractWhenNewAmendmentIntentHasNoneAmendmentType()
        {
            var firstContract = Contract.contract.contracts.First();
            firstContract.CRMIntent = Intent.Amendment;
            firstContract.amendmentType = amendmentType.None;
            var rule = new AmendmentIntentMustHasNonNullAmendmentTypeRule();
            Assert.IsTrue(rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageForContractWhenNewAmendmentIntentHasNotificationAmendmentType()
        {
            var firstContract = Contract.contract.contracts.First();
            firstContract.CRMIntent = Intent.Amendment;
            firstContract.amendmentType = amendmentType.Notification;
            var rule = new AmendmentIntentMustHasNonNullAmendmentTypeRule();
            Assert.IsFalse(rule.GetFailuresForItem(Contract).Any());
        }
    }
}