namespace Datafix.Tests.Tests.R101
{
    using Datafix.Tests.Automation.Releases.R101;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class SeedFundingAllocationTablesTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SeedFundingAllocationTables_ShouldCreateRows()
        {
            SeedFundingAllocationTables seed = new SeedFundingAllocationTables();

            seed.ApplyDataFix();
        }
    }
}