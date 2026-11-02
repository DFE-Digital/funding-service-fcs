namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class NewIntentWithInactiveOrganisationRuleTest : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageForNewIntentWhenTheOrgIsInvalid()
        {
            Contract.contract.contractor.organisationStatus = "Dissolved";
            Contract.contract.contracts[0].contractor.organisationStatus = "Dissolved";
            NewIntentWithInactiveOrganisationRule validator = new NewIntentWithInactiveOrganisationRule();
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageForNewIntentWhenTheOrgActive()
        {
            Contract.contract.contractor.organisationStatus = "Active";
            Contract.contract.contracts[0].contractor.organisationStatus = "Active";
            NewIntentWithInactiveOrganisationRule validator = new NewIntentWithInactiveOrganisationRule();
            Assert.IsFalse(validator.GetFailuresForItem(Contract).Any());
        }
    }
}
