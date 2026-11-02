namespace FctServices.Storage
{
    using System.Collections.Generic;
    using Microsoft.WindowsAzure.Storage.Table;

    public interface IAzureTableStore
    {
        void CreateTable(string tableName);

        void CreateRow<T>(string tablename, T entity) where T : class, ITableEntity, new();

        void CreateRows<T>(string tablename, IEnumerable<T> entities) where T : class, ITableEntity, new();

        void ReplaceRow<T>(string tablename, T entity) where T : class, ITableEntity, new();

        void DeleteRow(string tablename, string partitionKey, string rowKey);

        void DeleteRows(string tablename, string partitionKey);

        IEnumerable<T> GetRows<T>(string tablename, string partitionKey) where T : class, ITableEntity, new();

        IEnumerable<T> GetRows<T>(string tablename) where T : class, ITableEntity, new();

        T GetRow<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new();

        TableResult GetResult<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new();

        CloudTable GetTable(string tablename);

        void DeleteTable(string tableName);

        void InsertOrReplace<T>(string tablename, T entity) where T : class, ITableEntity, new();
    }
}
