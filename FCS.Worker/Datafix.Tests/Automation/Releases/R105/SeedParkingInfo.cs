namespace Datafix.Tests.Automation.Releases.R105
{
    using System.Configuration;
    using Infrastructure;

    public class SeedParkingInfo : IApplyDataFix
    {
        public string Release => "R105";
        public int StoryNumber => 33814;
        public string Name => "Release R105 - populate missing ParkingInfo rows";
        public int Order => 1;

        public void ApplyDataFix()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"INSERT INTO [FundingAllocation].[ParkingInfo] ([FundingAllocationId], [LastParked])
                                     SELECT [FundingId], [CreatedDate] FROM [FundingAllocation].[FundingAllocation]
                                        WHERE STATUS IN ('Parked', 'Discarded')
                                        AND [FundingId] NOT IN (SELECT FundingAllocationId FROM [FundingAllocation].[ParkingInfo])";

                connection.Execute(sql);
            }
        }
    }
}