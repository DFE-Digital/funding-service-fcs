namespace Datafix.Tests.Automation.Releases.R104
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;

    public class ResetSequencesForEsf : IApplyDataFix
    {
        public string Release => "R104";

        public int StoryNumber => 34862;

        public string Name => "ESF: Start contract numbering at ESF-5500 (34862) [Early Sep '21]";

        public int Order => 1;

        public void ApplyDataFix()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Execute("ALTER SEQUENCE [ContractManagement].[Contract_ESF_seq] RESTART WITH 5500");
                connection.Execute("ALTER SEQUENCE [ContractManagement].[Allocation_ESF201420_seq]  RESTART WITH 5500");
            }
        }
    }
}
