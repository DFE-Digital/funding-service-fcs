namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class NoExistingContractRuleTest : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractExistsForNaturalKeyWhenValidatingRevisedNewIntent()
        {
            Contract.contract.contracts.ForEach(c => c.IsContractNumberWithMatchingUKPRNPeriodAndFundingTypePresentInCrm = true);
            NoExistingContractRule rule = new NoExistingContractRule();
            Assert.IsFalse(rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractDoesntExistsForNaturalKeyWhenValidatingRevisedNewIntent()
        {
            Contract.contract.contracts.ForEach(c => c.IsContractNumberWithMatchingUKPRNPeriodAndFundingTypePresentInCrm = false);
            NoExistingContractRule rule = new NoExistingContractRule();
            Assert.IsTrue(rule.GetFailuresForItem(Contract).Any());
        }
    }
}
