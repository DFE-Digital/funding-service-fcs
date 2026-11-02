namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System;
    using System.Data;
    using System.Threading.Tasks;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    public interface IClosedCollectionRepository
    {
        Task<DateTime> GetLatestClosedDateTime(IDbConnection connection, IDbTransaction transaction);

        Task CreateClosedCollection(IDbConnection connection, IDbTransaction transaction,
            ClosedCollection closedCollection);
    }
}
