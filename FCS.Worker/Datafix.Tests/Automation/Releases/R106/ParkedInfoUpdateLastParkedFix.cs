namespace Datafix.Tests.Automation.Releases.R106
{
    using System.Configuration;
    using Infrastructure;

    public class ParkedInfoUpdateLastParkedFix : IApplyDataFix
    {
        public string Release => "R106";
        public int StoryNumber => 35132;
        public string Name => "Funding Allocation Discarded extract showing incorrect 'Park Status Last Updated' date' (35132)";
        public int Order => 2;

        public void ApplyDataFix()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string fundingId = "NMSS-AY-2122-Contracting-Provider-10040605-2_0";
                                         
                const string sql = @"UPDATE [FundingAllocation].[ParkingAndDiscardedInfo]
                                     SET LastDiscarded = CreatedDate
                                     WHERE [FundingAllocationId] = @fundingId";

                connection.Execute(sql, param:new {fundingId});
            }
        }
    }
}
