namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using DataStore.Model;
    using Dapper;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.DataStore;

    public class ClosedCollectionRepository : IClosedCollectionRepository
    {
        public IReadOnlyCollection<ClosedCollection> GetClosedCollections()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                var result = from cc in context.ClosedCollections
                             select cc;
               return result.ToList();
            }
        }

        private static string ConnectionString => ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;
    }
}