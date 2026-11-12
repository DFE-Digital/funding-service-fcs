namespace ContractCreateDomain.Tests.ValidationTests 
{
    using System.Linq;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class NewIntentConsistentRuleTest : ContractRequestValidationBase
    {
         [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenNewIntentOnMasterButNotOnContract()
        {
            // make sure that the legal name is not set
            Contract.contract.CRMIntent = ContractRequest.Intent.New;
            Contract.contract.contracts.First().CRMIntent = ContractRequest.Intent.UpdateDraft;

            NewIntentConsistentRule validator = new NewIntentConsistentRule();
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenRevisedNewIntentOnMasterButNotOnContract()
        {
            Contract.contract.CRMIntent = ContractRequest.Intent.RevisedNew;
            Contract.contract.contracts[0].CRMIntent = ContractRequest.Intent.UpdateDraft;

            NewIntentConsistentRule validator = new NewIntentConsistentRule();
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }
    }
}
