namespace Datafix.Tests.Automation.Releases.R106a
{
    using System.Configuration;
    using Infrastructure;

    public class ParkingAndDiscardedInfoSetLastDiscardedValue : IApplyDataFix
    {
        public string Release => "R106a";
        public int StoryNumber => 35267;
        public string Name => "Incorrect discarded date on the parked and discarded extract spreadsheet (35267)";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"UPDATE [FundingAllocation].[ParkingAndDiscardedInfo]
                                     SET [LastDiscarded] = [LastParked]";

                connection.Execute(sql);
            }
        }
    }
}