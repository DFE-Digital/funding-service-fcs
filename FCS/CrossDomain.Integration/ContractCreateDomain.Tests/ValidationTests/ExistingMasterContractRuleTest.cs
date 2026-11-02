namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    [TestClass]
    public class ExistingMasterContractRuleTest : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenContractIsExisting()
        {
            _contract.contract.IsPresentInCrm = true;
            ExistingMasterContractRule rule = new ExistingMasterContractRule();
            Assert.IsTrue(rule.GetFailuresForItem(_contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageWhenContractIsNotExisting()
        {
            _contract.contract.IsPresentInCrm = false;
            ExistingMasterContractRule rule = new ExistingMasterContractRule();
            Assert.IsFalse(rule.GetFailuresForItem(_contract).Any());
        }
    }
}
