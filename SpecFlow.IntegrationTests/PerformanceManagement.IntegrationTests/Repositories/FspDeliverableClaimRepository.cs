namespace PerformanceManagement.IntegrationTests.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Dapper;
    using SFA.FCT.PerformanceManagementDomain.DataStore;

    public static class FspDeliverableClaimRepository
    {
        private static IDictionary<string, IReadOnlyCollection<int>> ProfileDeliverablesForFsp = new Dictionary<string, IReadOnlyCollection<int>>();

        public static IReadOnlyCollection<int> GetProfileDeliverableCodes(string fspCode)
        {
            if (!ProfileDeliverablesForFsp.ContainsKey(fspCode))
            {
                ProfileDeliverablesForFsp.Add(fspCode, GetFromDb(fspCode));
            }

            return ProfileDeliverablesForFsp[fspCode];
        }

        private static IReadOnlyCollection<int> GetFromDb(string fspCode)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                const string sql = @"SELECT [DeliverableCode]
                FROM[PerformanceManagement].[FspDeliverableClaim]
                where FspCode = @fspCode
                and allowProfile = 1";

                return context.Database.Connection.Query<int>(sql: sql, param: new { fspCode }).ToList();
            }
        }
    }
}
