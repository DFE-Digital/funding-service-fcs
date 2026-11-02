namespace Datafix.Tests
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;

    public class UpdateDeliverablePaymentFixes //: IApplyDataFix
    {
        public string Release => "R68C";
        public int StoryNumber => 27274;
        public string Name => "Update PeriodTypeCode to CalendarMonth (CM) which is 2";
        public int Order => 1;

        public void ApplyDataFix()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"update [PaymentSchedule].[DeliverablePayment] set PeriodTypeCode = 2 where PeriodTypeCode = 0;";

                connection.Execute(sql);
            }
        }
    }
}
