namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Collections.Generic;
    using DTOs;
    using System.Data.SqlClient;
    using Dapper;
    using System.Linq;
    using FCS.Worker.Common;

    public class CrmDuplicateContractRepository : ICrmDuplicateContractRepository
    {
        private readonly IFcsConfiguration _configuration;

        public CrmDuplicateContractRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public IReadOnlyCollection<DuplicateContract> GetDuplicatedContracts()
        {
            var connectionString = _configuration["ConnectionStrings:CrmDatabaseConnectionString"];

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<DuplicateContract>("dbo.sp_GetDuplicatedContracts").ToList();
            }
        }
    }
}