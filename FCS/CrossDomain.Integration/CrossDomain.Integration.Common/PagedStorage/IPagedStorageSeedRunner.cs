namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage
{
    public interface IPagedStorageSeedRunner<T>
    {
        void Execute(IPagedStorageSeed<T> pagedStorageSeed);

        void ExecuteBulkReseed(IPagedStorageSeed<T> seed);
    }
}
