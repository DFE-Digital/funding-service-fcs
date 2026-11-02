namespace SFA.FCT.ContractRequestDomain.Common
{
    using Microsoft.WindowsAzure.Storage.Table;

    /// <summary>
    /// Partition key is the batch id
    /// Row key is the correlation id
    /// </summary>
    public class BulkUploadProcessingEntity : TableEntity
    {
        public bool Complete { get; set; }

        /// <summary>
        /// This holds zipped bytes
        /// </summary>
        public byte[] ContractRequestResult { get; set; }
    }
}
