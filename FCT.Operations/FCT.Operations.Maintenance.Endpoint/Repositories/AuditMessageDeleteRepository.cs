namespace SFA.FCT.Operations.Maintenance.Endpoint.Repositories
{
    using System;
    using System.Threading.Tasks;
    using Dapper;
    using System.Data.SqlClient;
    using FCS.Worker.Common;

    public class AuditMessageDeleteRepository : IAuditMessageDeleteRepository
    {
        private readonly IFcsConfiguration _configuration;

        public AuditMessageDeleteRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task HousekeepAuditMessageTable(DateTime removeOlderThanDate)
        {
            var p = new DynamicParameters();
            p.Add("@p0", removeOlderThanDate);
            var connectionString = _configuration["ConnectionStrings:OperationsDbContext"];
            const int timeoutInSeconds = 3200; // 60 minutes
            using (var connection = new SqlConnection(connectionString))
            {
                await connection.ExecuteAsync("EXEC DeleteAuditDataBatchwise @p0",
                                                                         p,
                                                                         commandTimeout: timeoutInSeconds).ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}