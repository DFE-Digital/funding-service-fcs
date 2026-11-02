namespace Datafix.Tests.Automation.Releases.R101
{
    public class SeedFundingAllocationTables : RunSqlFileIntoDb, IApplyDataFix
    {
        public string Release => "R101";
        public int StoryNumber => 33901;
        public string Name => "Seed Funding Allocation Tables";
        public int Order => 1;
        public void ApplyDataFix()
        {
            const string paymentTimetableSql = "Datafix.Tests.Resources.R101.SeedFundingAllocationTables.sql";

            RunCodeFromFileIntoDb(paymentTimetableSql);
        }
    }
}