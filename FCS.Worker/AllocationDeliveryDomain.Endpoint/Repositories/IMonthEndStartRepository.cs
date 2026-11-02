namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System.Data;
    using System.Threading.Tasks;

    public interface IMonthEndStartRepository
    {
        Task CreateNewMonthEndEntry(IDbConnection connection, IDbTransaction transaction);
    }
}