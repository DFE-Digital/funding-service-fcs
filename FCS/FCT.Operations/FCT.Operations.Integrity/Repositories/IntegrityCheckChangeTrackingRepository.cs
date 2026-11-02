namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Data.SqlClient;
    using Dapper;
    using FCS.Worker.Common;

    public class IntegrityCheckChangeTrackingRepository : IIntegrityCheckChangeTrackingRepository
    {
        private readonly IFcsConfiguration _configuration;

        public IntegrityCheckChangeTrackingRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public long GetCurrentVersion(string name)
        {
            using (var connection = new SqlConnection(_configuration["ConnectionStrings:OperationsDbContext"]))
            {
                long? currentVersion = connection.ExecuteScalar<long?>("SELECT CurrentVersion FROM Operations.IntegrityCheckChangeTracking WHERE Name = @name",
                    new { name });

                return currentVersion ?? 0;
            }
        }

        public void Update(string name, long currentVersion)
        {
            using (var connection = new SqlConnection(_configuration["ConnectionStrings:OperationsDbContext"]))
            {
                connection.Execute("UPDATE Operations.IntegrityCheckChangeTracking SET CurrentVersion = @currentVersion WHERE Name = @name",
                    new {name, currentVersion });
            }
        }
    }
}