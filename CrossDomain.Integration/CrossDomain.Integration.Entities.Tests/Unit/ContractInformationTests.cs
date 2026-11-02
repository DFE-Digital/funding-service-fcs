namespace CrossDomain.Integration.Entities.Tests.Unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class ContractInformationTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractInformation_NumberPartOfContractNumber_ShouldReturnTheNumberPartOfContract()
        {
            // arrange
            int numberPart = 1234;
            ContractInformation contractInformation = new ContractInformation($"APPLEVY-{numberPart}", "SFA-5678", 1, 0, "12345678", ContractStatus.Approved, ContractSubStatus.Approved);

            // act
            var numberResult = contractInformation.NumberPartOfContractNumber;
            
            // assert
            Assert.AreEqual(numberPart, numberResult);
        }
    }
}
