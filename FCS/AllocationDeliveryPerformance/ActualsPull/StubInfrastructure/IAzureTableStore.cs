namespace ActualsPull.StubInfrastructure
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Microsoft.WindowsAzure.Storage.Table;

    public interface IAzureTableStore
    {
        Task<bool> CreateTableIfNotExists(string tableName);

        Task<IReadOnlyCollection<T>> GetAllRows<T>(string tablename) where T : class, ITableEntity, new();
    }
}
