namespace Datafix.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Infrastructure;

    public static class PerformanceManagementFundingClaimContractAllocationRepository
    {
        public static IReadOnlyCollection<(string contractAllocationNumber, string allocationId)> GetAllocationsWithMissingDeliverable(string fspCode, int missingDeliverableCode)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnectionWithRetry(connectionString))
            {
                const string sql = @"SELECT a.ContractAllocationNumber, a.Id
                                    from [PerformanceManagement].[FundingClaim] fc, [PerformanceManagement].[FundingClaimContractAllocation] a
                                    WHERE  NOT EXISTS (SELECT 1 
                                    FROM  [PerformanceManagement].[FundingClaimDeliverable] d
                                    WHERE  d.ContractAllocationId = a.Id
				                    and d.DeliverableCode = @missingDeliverableCode)
				                    and a.FundingStreamPeriodCode = @fspCode
				                    and fc.Id = a.FundingClaimId";

                var rows = connection.Query<dynamic>(sql, param: new
                {
                    fspCode,
                    missingDeliverableCode
                }).ToList();

                return rows.Select(r => ((string)r.ContractAllocationNumber, (string)r.Id.ToString())).ToList();
            }
        }
    }
}
