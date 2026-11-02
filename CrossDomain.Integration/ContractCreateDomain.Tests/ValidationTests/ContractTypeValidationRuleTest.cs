namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
   
    [TestClass]
    public class ContractTypeValidationRuleTest : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenContractTypeIsInvalid()
        {
            Contract.contract.contracts[0].contractType1 = "dodgy contract type";
            List<string> contractTypes = new List<string>();
            contractTypes.Add("valid contract type");
            ContractTypeValidationRule validator = new ContractTypeValidationRule(contractTypes);
            Assert.IsTrue(validator.GetFailuresForItem(Contract).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotCreateErrorMessageWhenContractTypeIsInvalid()
        {
            Contract.contract.contracts[0].contractType1 = "valid contract TYPE";
            List<string> contractTypes = new List<string>();
            contractTypes.Add("valid contract type");
            ContractTypeValidationRule validator = new ContractTypeValidationRule(contractTypes);
            Assert.IsFalse(validator.GetFailuresForItem(Contract).Any());
        }
    }
}
