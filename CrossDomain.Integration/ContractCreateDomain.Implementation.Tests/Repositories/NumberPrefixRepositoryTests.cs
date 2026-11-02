namespace ContractCreateDomain.Implementation.Tests.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;

    [TestClass]
    public class NumberPrefixRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void NumberPrefixRepository_ShouldReturnMasterContractPrefixFromFundingType()
        {
            // arrange
            NumberPrefixRepository numberPrefixRepository = new NumberPrefixRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            string masterContractPrefix = numberPrefixRepository.GetMasterContractPrefix("AGE");
            
            // assert
            Assert.AreEqual("DFE", masterContractPrefix);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void NumberPrefixRepository_ShouldReturnContractPrefixFromFundingType()
        {
            // arrange
            NumberPrefixRepository numberPrefixRepository = new NumberPrefixRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            string contractPrefix = numberPrefixRepository.GetContractPrefix("AGE");

            // assert
            Assert.AreEqual("EMPAGE", contractPrefix);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void NumberPrefixRepository_ShouldReturnAllocationPrefixFromFundingStreamPeriod()
        {
            // arrange
            NumberPrefixRepository numberPrefixRepository = new NumberPrefixRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            string contractPrefix = numberPrefixRepository.GetAllocationPrefix("AGE1718");

            // assert
            Assert.AreEqual("AGE", contractPrefix);
        }
    }
}
