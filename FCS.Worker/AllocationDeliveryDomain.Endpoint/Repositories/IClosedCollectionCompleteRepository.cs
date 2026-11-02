namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System.Threading.Tasks;
    using System.Data;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    public interface IClosedCollectionCompleteRepository
    {
        Task<int> UpdateRowToCompletedIfNoOneElseHas(
            IDbConnection connection,
            IDbTransaction transaction,
            string collectionType, string collectionReturnCode,
            int rowsRetrieved);

        Task<ClosedCollection> Get(
            IDbConnection connection,
            IDbTransaction transaction,
            string collectionType, string collectionReturnCode);
    }
}
