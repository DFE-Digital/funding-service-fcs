namespace Datafix.Tests.Tests.Repositories
{
    using System.Linq;
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingAllocationContractRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingAllocationContractRepository_GetContracts()
        {
            var contracts = FundingAllocationContractRepository.GetContracts();
            
            Assert.IsTrue(contracts.Any());
        }
    }
}
