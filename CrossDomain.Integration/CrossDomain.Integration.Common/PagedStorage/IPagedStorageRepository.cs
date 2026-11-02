namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage
{
    using System.Collections.Generic;

    public interface IPagedStorageRepository<T>
    {
        string TableName { get; set; }

        void Add(T entity);

        bool Any();

        StoragePage<T> GetEntitiesForPage(int page);

        StoragePage<T> GetEntitiesForLatestPage();

        void Reseed(IReadOnlyList<T> entities);
    }
}
