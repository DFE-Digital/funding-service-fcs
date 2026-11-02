namespace Datafix.Tests.Tests
{
    using System.Collections.Generic;
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingAllocationContractRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingAllocationContractRepository_SetFundingAllocationsToPublished()
        {
            FundingAllocationContractRepository.SetFundingAllocationsToPublished(new List<string>{ "1619-AS-2122-Contract-Provider-10017651-1_1" });
        }
    }
}
