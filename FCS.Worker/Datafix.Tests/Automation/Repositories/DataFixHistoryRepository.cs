namespace Datafix.Tests.Automation.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Operations.DataStore.Model;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;

    public class DataFixHistoryRepository : IDataFixHistoryRepository
    {
        public async Task Add(DataFixHistory dataFixHistory)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"INSERT INTO [Operations].[DataFixHistory]
                                     ([Release], [StoryNumber], [Name])
                                     VALUES (UPPER(@Release), @StoryNumber, UPPER(@Name))";

                await connection.ExecuteAsync(sql, new
                {
                    dataFixHistory.Release,
                    dataFixHistory.StoryNumber,
                    dataFixHistory.Name
                }).ConfigureAwait(continueOnCapturedContext: false);
            }
        }

        public static IReadOnlyCollection<DataFixHistory> GetAll()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"SELECT [Release]
                                            ,[StoryNumber]
                                            ,[Name]
                                    FROM [Operations].[DataFixHistory]";

                return connection.Query<DataFixHistory>(sql).ToList();
            }
        }
    }
}