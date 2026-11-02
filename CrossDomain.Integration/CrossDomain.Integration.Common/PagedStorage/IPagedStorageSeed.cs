namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage
{
    using System.Collections.Generic;

    public interface IPagedStorageSeed<T>
    {
        int LoggingId { get; }

        IEnumerable<T> GetDataEnumerable();

        string GetEntityString(T entity);
    }
}
