namespace Datafix.Tests.Automation.Releases
{
    using System.Configuration;
    using System.IO;
    using System.Reflection;
    using CrmCopyDbSetup;
    using Infrastructure;

    public class RunSqlFileIntoDb
    {
        protected static void RunCodeFromFileIntoDb(string fileName)
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
