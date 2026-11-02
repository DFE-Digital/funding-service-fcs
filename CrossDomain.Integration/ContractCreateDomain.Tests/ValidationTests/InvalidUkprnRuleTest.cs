using System.Linq;
using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;

namespace ContractCreateDomain.Tests.ValidationTests
{
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    [TestClass]
    public class InvalidUkprnRuleTest : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenUkprnInvalid()
        {
            // make sure that the legal name is not set
            Contract.contract.contractor.legalName = null;
            InvalidUkprnRule validator = new InvalidUkprnRule();
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }
    }
}
