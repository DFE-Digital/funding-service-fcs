namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Dapper;
    using PerformanceManagementDomain.DataStore;

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
                bool allowprofile = true;
                var result = context.FspDeliverableClaims.Where(fdc => fdc.FspCode == fspCode && fdc.AllowProfile == allowprofile).Select(fc => fc.DeliverableCode).ToList();

                return result.ToList();
            }
        }
    }
}
