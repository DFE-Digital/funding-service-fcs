namespace ActualsPull.Repositories
{
    using System;
    using System.Data;
    using System.Threading.Tasks;

    public interface IClosedCollectionRepository
    {
        Task<DateTime> GetLatestClosedDateTime(IDbConnection connection, IDbTransaction transaction);
    }
}