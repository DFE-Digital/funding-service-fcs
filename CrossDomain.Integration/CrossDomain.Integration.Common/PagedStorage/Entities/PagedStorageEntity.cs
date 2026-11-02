namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Entities
{
    using Microsoft.WindowsAzure.Storage.Table;

    public class PagedStorageEntity : TableEntity
    {
        public byte[] ContentBytes { get; set; }

        public int PageNumberOnceCommitted { get; set; }
    }
}