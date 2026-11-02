using SFA.FCT.Contracts.AcceptanceTests;

namespace SFA.FCT.Contracts.AcceptanceTests.Hooks
{
    using System;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using TechTalk.SpecFlow;
    using Utilities;
    
    [Binding]
    public class BeforeScenario
    {
        [BeforeScenario("AcceptanceTest")]
        public void BeforeAcceptanceTestScenario()
        {
           TestDbContextFactory.InitializeForTests();
            MonthEndHistoryRepository.StopMonthEnd();

            Xrm.TestFramework.OrganizationServiceFactory.Initialize(CrmConnectionFactory.GetConnection);
            ContractRequestFundingAllocationReleaseRepository.ClearDown();
        }
    }

    [Binding]
    public class BeforeScenarioCFS
    {
        [BeforeScenario("CFS")]
        public void BeforeAcceptanceTestScenario()
        {
            SFA.FCT.Contracts.AcceptanceTests.TestDbContextFactory.InitializeForTests();
            DateTime before = DateTime.Now;
            CfsConfig.ResetCfsConfigTables();

            DateTime after = DateTime.Now;
            var timeTaken = after - before;
            Console.WriteLine($"Time taken to reset CFS Config table {timeTaken.TotalSeconds}s");
            FundingAllocationFeedReadRepository.ClearAll();
        }
    }
}
