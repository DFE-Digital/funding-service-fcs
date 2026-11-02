namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    using System.Collections.Generic;

    public interface IAzureRepository<T>
    {
        void AddRow(T entity);

        void AddRows(IEnumerable<T> entities);

        void AddRowOrUpdate(T entity);

        T GetRow(string partitionKey, string rowKey);

        IList<T> GetRows(string partitionKey);

        IList<T> GetRows();

        void ReplaceRow(T entity);

        void DeleteRows(string partitionKey);

        void Clear();

        void Clear(string partitionKey);
    }
}
