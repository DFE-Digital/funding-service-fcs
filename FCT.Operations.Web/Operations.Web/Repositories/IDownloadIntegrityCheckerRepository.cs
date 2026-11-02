namespace Operations.Web.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;

    public interface IDownloadIntegrityCheckerRepository
    {
        Task<IReadOnlyCollection<DownloadIntegrityCheckerCollection>> GetClosedCollectionsDesc();
        Task<byte[]> GetAttachmentAsync(string fileName);


    }
}