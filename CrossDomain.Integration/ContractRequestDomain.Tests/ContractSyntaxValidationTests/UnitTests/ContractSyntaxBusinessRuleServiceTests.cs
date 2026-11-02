namespace ContractRequestDomain.Tests.ContractSyntaxValidationTests.UnitTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;

    [TestClass]
    public class ContractSyntaxBusinessRuleServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxBusinessRuleService_ShouldFundingTypePreventContractsWithTheSameUkprnForNewOrNewAmendmentIntent_ShouldReturnFalseWhenFundingTypeIsMain()
        {
            // arrange
            ContractSyntaxBusinessRuleService contractSyntaxBusinessRuleService = new ContractSyntaxBusinessRuleService();
            
            // act
            bool prevent = contractSyntaxBusinessRuleService.ShouldFundingTypePreventContractsWithTheSameUkprnForNewOrNewAmendmentIntent("MAIN");

            // assert
            Assert.AreEqual(false, prevent);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxBusinessRuleService_ShouldFundingTypePreventContractsWithTheSameUkprnForNewOrNewAmendmentIntent_ShouldReturnTrueWhenFundingTypeIsEsf()
        {
            // arrange
            ContractSyntaxBusinessRuleService contractSyntaxBusinessRuleService = new ContractSyntaxBusinessRuleService();

            // act
            bool prevent = contractSyntaxBusinessRuleService.ShouldFundingTypePreventContractsWithTheSameUkprnForNewOrNewAmendmentIntent("ESF");

            // assert
            Assert.AreEqual(true, prevent);
        }
    }
}
