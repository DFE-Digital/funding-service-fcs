namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
   
    [TestClass]
    public class NewIntententAmendmentTypeNullRuleTest : ContractRequestValidationBase
    {
         [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenNewContractHasNonNullAmendment()
         {
             Contract.contract.amendmentType = amendmentType.Variation;
             NewIntententAmendmentTypeNullRule rule = new NewIntententAmendmentTypeNullRule();

             Assert.IsTrue(rule.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageWhenNewContractHasNullAmendment()
        {
            Contract.contract.amendmentType = amendmentType.None;

            NewIntententAmendmentTypeNullRule rule = new NewIntententAmendmentTypeNullRule();

            Assert.IsFalse(rule.GetFailuresForItem(Contract).Any());
        }
    }
}
