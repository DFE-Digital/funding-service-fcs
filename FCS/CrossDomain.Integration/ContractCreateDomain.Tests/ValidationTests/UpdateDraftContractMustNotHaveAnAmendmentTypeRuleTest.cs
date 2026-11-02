namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class UpdateDraftContractMustNotHaveAnAmendmentTypeRuleTest : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageForMasterContractWhenUpdateDraftContractIntentHasNoneAmendmentType()
        {
            Contract.contract.CRMIntent = intent.UpdateDraft;
            Contract.contract.amendmentType = amendmentType.None;
            var rule = new UpdateDraftContractMustNotHaveAnAmendmentTypeRule();
            Assert.IsFalse(rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageForMasterContractWhenUpdateDraftContractIntentHasNotificationAmendmentType()
        {
            Contract.contract.CRMIntent = intent.UpdateDraft;
            Contract.contract.amendmentType = amendmentType.Notification;
            var rule = new UpdateDraftContractMustNotHaveAnAmendmentTypeRule();
            Assert.IsTrue(rule.GetFailuresForItem(Contract).Any());
        }

         [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageForMasterContractWhenUpdateDraftContractntentHasVariationAmendmentType()
        {
            Contract.contract.CRMIntent = intent.UpdateDraft;
            Contract.contract.amendmentType = amendmentType.Variation;
            var rule = new UpdateDraftContractMustNotHaveAnAmendmentTypeRule();
            Assert.IsTrue(rule.GetFailuresForItem(Contract).Any());
        }
    }
}