namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using DTOs;
    using System.Data.SqlClient;
    using Dapper;
    using System.Linq;
    using FCS.Worker.Common;


    public class DuplicateContractRepository : IDuplicateContractRepository
    {

        private readonly IFcsConfiguration _configuration;

        public DuplicateContractRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public IReadOnlyCollection<DuplicateContract> GetDuplicatedContracts()
        {

            var connectionString = _configuration["ConnectionStrings:OperationsDbContext"];

            using (var connection = new SqlConnection(connectionString))
            {
                const string sqlQuery = @"SELECT
                                              ContractNumber
                                             ,Version
                                             ,SubVersion
                                             ,NumDuplicateAllocations
                                             ,NumDuplicateContracts
                                        FROM Operations.DuplicateContract";

                return connection.Query<DuplicateContract>(sqlQuery).ToList();
            }           

        }

        public void RefreshDuplicatedContracts(IReadOnlyCollection<DuplicateContract> duplicatedContracts)
        {
            var connectionString = _configuration["ConnectionStrings:OperationsDbContext"];

            using (var connection = new SqlConnection(connectionString))
            {
                const string sqlDeleteAll = @"DELETE FROM Operations.DuplicateContract";
                connection.Execute(sqlDeleteAll);

                duplicatedContracts.ToList().ForEach(dc =>
                {
                    var sqlInsert =
                        $"INSERT INTO [Operations].[DuplicateContract] ([ContractNumber],[Version],[SubVersion],[NumDuplicateAllocations],[NumDuplicateContracts]) " +
                        $"VALUES (@ContractNumber, @Version, @SubVersion, @numDuplicateAllocations, @numDuplicateContracts)";

                    connection.Execute(sqlInsert, new { dc.ContractNumber, dc.Version, dc.SubVersion, dc.NumDuplicateAllocations, dc.NumDuplicateContracts });
                });
            }          

        }

    }
}