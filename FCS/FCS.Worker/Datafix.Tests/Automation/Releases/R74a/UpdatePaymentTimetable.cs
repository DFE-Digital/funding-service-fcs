namespace Datafix.Tests.Automation.Releases.R74a
{
    using System.Configuration;
    using System.IO;
    using System.Reflection;
    using CrmCopyDbSetup;
    using Infrastructure;

    public class UpdatePaymentTimetable : IApplyDataFix
    {
        public string Release => "R74a";
        public int StoryNumber => 28293;
        public string Name => "Delay Apps census dates for payment period 201910";
        public int Order => 2;
        public void ApplyDataFix()
        {
            const string paymentTimetableSql = "Datafix.Tests.Resources.R74a.update_payment_timetable_r74a.sql";

            RunCodeFromFileIntoDb(paymentTimetableSql);
        }

        private static void RunCodeFromFileIntoDb(string fileName)
        {
            int thirtyMinutes = 60 * 30;
            string connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                string sql = GetSqlScriptFromResource(fileName);

                connection.Execute(sql, commandTimeout: thirtyMinutes);
            }
        }

        private static string GetSqlScriptFromResource(string sqlResourceName)
        {
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(sqlResourceName))
            using (StreamReader reader = new StreamReader(stream))
            {
                return reader.ReadToEnd();
            }
        }
    }
}
