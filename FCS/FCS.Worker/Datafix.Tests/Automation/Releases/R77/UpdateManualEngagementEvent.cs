namespace Datafix.Tests.Automation.Releases.R77
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;

    public class UpdateManualEngagementEvent //: IApplyDataFix this need to run in a later release
    {
        public string Release => "R77";
        public int StoryNumber => 27341;
        public string Name => "Update the latest manual eventId with the eventId from Dave";
        public int Order => 2;
        public void ApplyDataFix()
        {
            UpdateDasEventId(currentId: -181, newEventId: 33160);
        }

        private static void UpdateDasEventId(int currentId, int newEventId)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"update [ContractManagement].[EngagementEvent]
                                  set EventId = @newEventId
                                  where EventId = @currentId";

                connection.Execute(sql, new { currentId, newEventId });
            }
        }
    }
}
