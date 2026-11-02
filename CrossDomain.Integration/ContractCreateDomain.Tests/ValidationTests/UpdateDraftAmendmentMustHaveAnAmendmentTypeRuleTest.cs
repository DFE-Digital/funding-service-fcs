namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class UpdateDraftAmendmentMustHaveAnAmendmentTypeRuleTest : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageForMasterContractWhenUpdateDraftContractAmendmentIntentHasNoneAmendmentType()
        {
            Contract.contract.CRMIntent = intent.UpdateDraftAmendment;
            Contract.contract.amendmentType = amendmentType.None;
            var rule = new UpdateDraftAmendmentMustHaveAnAmendmentTypeRule();
            Assert.IsTrue(rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageForMasterContractWhenUpdateDraftContractAmendmentIntentHasNotificationAmendmentType()
        {
            Contract.contract.CRMIntent = intent.UpdateDraftAmendment;
            Contract.contract.amendmentType = amendmentType.Notification;
            var rule = new UpdateDraftAmendmentMustHaveAnAmendmentTypeRule();
            Assert.IsFalse(rule.GetFailuresForItem(Contract).Any());
        }

         [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageForMasterContractWhenUpdateDraftContractAmendmentIntentHasVariationAmendmentType()
        {
            Contract.contract.CRMIntent = intent.UpdateDraftAmendment;
            Contract.contract.amendmentType = amendmentType.Variation;
            var rule = new UpdateDraftAmendmentMustHaveAnAmendmentTypeRule();
            Assert.IsFalse(rule.GetFailuresForItem(Contract).Any());
        }
    }
}