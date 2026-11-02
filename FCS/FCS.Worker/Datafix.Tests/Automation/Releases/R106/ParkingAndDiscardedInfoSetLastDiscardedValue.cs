namespace Datafix.Tests.Automation.Releases.R106
{
    using System.Configuration;
    using Infrastructure;

    public class ParkingAndDiscardedInfoSetLastDiscardedValue
    {
        public string Release => "R106";
        public int StoryNumber => 35132;
        public string Name => "ParkingAndDiscardedInfo table. Set LastDiscarded Value (35212)";
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