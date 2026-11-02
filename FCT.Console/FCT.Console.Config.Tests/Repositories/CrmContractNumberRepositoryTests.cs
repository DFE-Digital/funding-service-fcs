namespace FCT.Console.Config.Tests.Repositories
{
    using Config.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CrmContractNumberRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmContractNumberRepository_GetCurrentContractNumber_ShouldGetCurrentNumberForFundingType()
        {
            var mainNumber = CrmContractNumberRepository.GetCurrentContractNumber("MAIN");

            Assert.AreEqual(2374, mainNumber);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmContractNumberRepository_GetCurrentAllocationNumber_ShouldGetCurrentNumberForFundingStream()
        {
            var number = CrmContractNumberRepository.GetCurrentAllocationNumber("ALLBC");

            Assert.AreEqual(4429, number);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmContractNumberRepository_GetCurrentMasterContractNumber_ShouldGetCurrentNumberForAgency()
        {
            var number = CrmContractNumberRepository.GetCurrentMasterContractNumber("DFE");

            Assert.AreEqual(20355, number);
        }
    }
}
