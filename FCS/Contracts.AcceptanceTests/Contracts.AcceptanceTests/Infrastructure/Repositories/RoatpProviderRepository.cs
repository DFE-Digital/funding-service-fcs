namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using Dapper;

    public static class RoatpProviderRepository
    {
        public static void AddRange(IReadOnlyCollection<string> ukprns)
        {
            using (var context = new ContractManagementDbContext())
            {
                string ukprnsFormatted = string.Join(",", ukprns.Select(u => $"('{u}')"));

                context.Database.Connection.ExecuteScalar<int>("dbo.sp_RoatpProviderAddRange @ukprnsFormatted", new { ukprnsFormatted });
            }
        }

        public static void RemoveRange(IReadOnlyCollection<string> ukprns)
        {
            using (var context = new ContractManagementDbContext())
            {
                string ukprnsFormatted = string.Join(",", ukprns.Select(u => $"('{u}')"));

                context.Database.Connection.ExecuteScalar<int>("dbo.sp_RoatpProviderRemoveRange @ukprnsFormatted", new { ukprnsFormatted });
            }
        }
    }
}