namespace SFA.FCT.Operations.Maintenance.Endpoint.Repositories
{
    using System;
    using System.Threading.Tasks;
    using Dapper;
    using System.Data.SqlClient;
    using FCS.Worker.Common;

    public class ProcessedMessageDeleteRepository : IProcessedMessageDeleteRepository
    {
        private readonly IFcsConfiguration _configuration;

        public ProcessedMessageDeleteRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task HousekeepProcessedMessageTable(string schemaName, DateTime removeOlderThanDate)
        {
            var sql = $"delete from {schemaName}.ProcessedMessage where CreatedDate < @removeOlderThanDate";
            await ExecuteSql(sql, new { removeOlderThanDate }).ConfigureAwait(continueOnCapturedContext: false);
        }

        private async Task ExecuteSql(string sql, object parameter)
        {
            var connectionString = _configuration["ConnectionStrings:NServiceBus/Persistence"];
            const int timeoutInSeconds = 900; // 15 minutes

            using (var connection = new SqlConnection(connectionString))
            {
                await connection.ExecuteAsync(sql, parameter, commandTimeout: timeoutInSeconds).ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}