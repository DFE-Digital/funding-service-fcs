namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class NewContractsMustNotHaveContractNumbersRuleTests : ContractRequestValidationBase
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NewContractsMustNotHaveContractNumbersRule_ShouldGenerateFailuresForNewIntentWithContractNumber()
        {
            // arrange
            this.Contract.contract.contracts.ForEach(c =>
            {
                c.CRMIntent = Intent.New;
                c.contractNumber = "Some Contract Number";
            });

            NewContractsMustNotHaveContractNumbersRule rule = new NewContractsMustNotHaveContractNumbersRule();
            
            // act
            IEnumerable<string> errors = rule.GetFailuresForItem(this.Contract);

            // assert
            Assert.IsTrue(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NewContractsMustNotHaveContractNumbersRule_ShouldGenerateFailuresForNewAmendmentIntentWithContractNumber()
        {
            // arrange
            this.Contract.contract.contracts.ForEach(c =>
            {
                c.CRMIntent = Intent.NewAmendment;
                c.contractNumber = "Some Contract Number";
            });

            NewContractsMustNotHaveContractNumbersRule rule = new NewContractsMustNotHaveContractNumbersRule();

            // act
            IEnumerable<string> errors = rule.GetFailuresForItem(this.Contract);

            // assert
            Assert.IsTrue(errors.Any());
        }
    }
}
