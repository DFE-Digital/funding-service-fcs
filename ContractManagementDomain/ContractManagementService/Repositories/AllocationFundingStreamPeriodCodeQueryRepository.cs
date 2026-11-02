using SFA.FCS.Worker.Common;
using SFA.FCT.CrossDomain.Integration.Common.Repositories;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace ContractManagementService.Repositories
{
    public class AllocationFundingStreamPeriodCodeQueryRepository(
        IFcsConfiguration configuration,
        IDapperQueryExecutor queryExecutor)
        : IAllocationFundingStreamPeriodCodeQueryRepository
    {
        private string ConnectionString => configuration["ConnectionStrings:AllocationDeliveryDBContext"];

        private const string SqlQuery = @"
                SELECT DISTINCT alc.FspCode AS FspCode
                    FROM [FundingAllocation].[AllocationLineConfig] AS alc
                    INNER JOIN [FundingAllocation].[AllocationFundingStreamConfig] AS afs 
                        ON alc.FundingStreamCode = afs.AllocationFundingStreamCode AND alc.PeriodId = afs.AllocationPeriodId 
                    WHERE 
                            afs.AllocationFundingStreamCode IN @allocationFundingStreamCodes
                        AND afs.AllocationPeriodId = @allocationPeriodCode
                ORDER BY FspCode";

        public async Task<IReadOnlyCollection<string>> GetFundingStreamPeriodCodesAsync(
            IReadOnlyCollection<string> allocationFundingStreamCodes,
            string allocationPeriodCode)
        {
            await using var connection = new SqlConnection(ConnectionString);

            var codes = await queryExecutor.QueryAsync<string>(
                connection,
                SqlQuery,
                new { allocationFundingStreamCodes, allocationPeriodCode });

            return codes.ToList();
        }
    }
}
