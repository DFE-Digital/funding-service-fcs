namespace SFA.FCT.CrossDomain.Integration.Common.Storage
{
    using System.Collections.Generic;
    // using Microsoft.WindowsAzure.Storage.Table;
    using Azure.Data.Tables;
    using Azure;

    public interface IAzureTableStore
    {
        void CreateTableIfNotExists(string tableName);

        void CreateRow<T>(string tablename, T entity) where T : class, ITableEntity, new();

        void CreateRows<T>(string tablename, IEnumerable<T> entities) where T : class, ITableEntity, new();

        void ReplaceRow<T>(string tablename, T entity) where T : class, ITableEntity, new();

        void DeleteRow(string tablename, string partitionKey, string rowKey);

        void DeleteRows(string tablename, string partitionKey);

        IEnumerable<T> GetRows<T>(string tablename, string partitionKey) where T : class, ITableEntity, new();

        IEnumerable<T> GetRows<T>(string tablename) where T : class, ITableEntity, new();

        T GetRow<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new();

        //TableResult GetResult<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new();
        Response<T> GetResult<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new();

        //CloudTable GetTable(string tablename);
        TableClient GetTable(string tablename);

        void DeleteTable(string tableName);

        void InsertOrReplace<T>(string tablename, T entity) where T : class, ITableEntity, new();

        void DeleteAllRows<T>(string tablename) where T : class, ITableEntity, new();
    }
}
