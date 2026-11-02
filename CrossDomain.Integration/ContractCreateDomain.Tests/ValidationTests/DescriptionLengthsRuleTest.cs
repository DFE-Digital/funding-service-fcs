using System.Linq;
using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;

namespace ContractCreateDomain.Tests.ValidationTests
{
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    [TestClass]
    public class DescriptionLengthsRuleTest : ContractRequestValidationBase
    {
        public const string OneHundredAndOneCharacters = "im8v4GmrhhX9Cb8eCj4bExCOXxvTuG893tqBBA0KNoe37RytVhfGB7xRxjFMgJmjop8XLcxXDHErrpmLnHGxi9VJepf8mkOgVQwwf";

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldPassValidationWhenMasterDescriptionIsValid()
        {
            // make sure that the legal name is not set
            Contract.contract.description = "Hello";
            DescriptionLengthsRule validator = new DescriptionLengthsRule();
            Assert.IsTrue(validator.Validate(Contract));
            Assert.IsFalse(Contract.errorInfo.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenMasterDescriptionInvalid()
        {
            // make sure that the legal name is not set
            Contract.contract.description = OneHundredAndOneCharacters;
            DescriptionLengthsRule validator = new DescriptionLengthsRule();
            Assert.IsFalse(validator.Validate(Contract));
            Assert.IsTrue(Contract.errorInfo.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenContractDescriptionInvalid()
        {
            // make sure that the legal name is not set
            Contract.contract.contracts.First().description = OneHundredAndOneCharacters;
            DescriptionLengthsRule validator = new DescriptionLengthsRule();
            Assert.IsFalse(validator.Validate(Contract));
            Assert.IsTrue(Contract.errorInfo.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenAllocationDescriptionInvalid()
        {
            // make sure that the legal name is not set
            Contract.contract.contracts.First(c => c.contractAllocations.Count > 0).contractAllocations.First().description = OneHundredAndOneCharacters;
            DescriptionLengthsRule validator = new DescriptionLengthsRule();
            Assert.IsFalse(validator.Validate(Contract));
            Assert.IsTrue(Contract.errorInfo.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldCreateErrorMessageWhenDeliverableDescriptionInvalid()
        {
            // make sure that the legal name is not set
            Contract.contract.contracts.First(c => c.contractAllocations.Count > 0).contractAllocations.First(a =>a.contractDeliverables.Any()).description = OneHundredAndOneCharacters;
            DescriptionLengthsRule validator = new DescriptionLengthsRule();
            Assert.IsFalse(validator.Validate(Contract));
            Assert.IsTrue(Contract.errorInfo.Any());
        }

    }
}
