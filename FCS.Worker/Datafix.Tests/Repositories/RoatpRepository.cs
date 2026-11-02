namespace Datafix.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;

    internal class RoatpRepository
    {
        internal static IReadOnlyCollection<string> GetValidUkprns()
        {
            using (var context = new ContractManagementDbContext())
            {
                return context.RoatpProviders.Select(r => r.Ukprn).ToList();
            }
        }
    }
}
