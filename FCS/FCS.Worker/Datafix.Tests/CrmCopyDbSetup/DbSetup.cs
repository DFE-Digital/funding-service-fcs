namespace Datafix.Tests.CrmCopyDbSetup
{
    using System.Configuration;
    using System.IO;
    using System.Reflection;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class DbSetup
    {
        [TestMethod, TestCategory("CrmCopyDbSetup")]
        public void DbSetup_DeployStoredProcAndIndexesIntoDb()
        {
            DeployStoredProcedure();

            DeployIndexes();

            DeployUsers();

            DeployGrant();

            DeployRoles();
        }

        private static void DeployStoredProcedure()
        {
            const string storedProcResource = "Datafix.Tests.CrmCopyDbSetup.Resources.cda_sp.txt";

            RunCodeFromFileIntoDb(storedProcResource);
        }

        private static void DeployIndexes()
        {
            const string indexes = "Datafix.Tests.CrmCopyDbSetup.Resources.indexes.txt";

            RunCodeFromFileIntoDb(indexes);
        }

        private static void DeployUsers()
        {
            const string users = "Datafix.Tests.CrmCopyDbSetup.Resources.users.txt";

            RunCodeFromFileIntoDb(users);
        }

        private static void DeployGrant()
        {
            const string grants = "Datafix.Tests.CrmCopyDbSetup.Resources.grants.txt";

            RunCodeFromFileIntoDb(grants);
        }

        private static void DeployRoles()
        {
            const string roles = "Datafix.Tests.CrmCopyDbSetup.Resources.roles.txt";

            RunCodeFromFileIntoDb(roles);
        }

        private static void RunCodeFromFileIntoDb(string fileName)
        {
            int thirtyMinutes = 60 * 30;
            string connectionString = ConfigurationManager.ConnectionStrings["CrmDatabaseConnectionString"].ConnectionString;

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
