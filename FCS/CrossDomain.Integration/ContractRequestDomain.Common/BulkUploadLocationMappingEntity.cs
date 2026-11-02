namespace SFA.FCT.ContractRequestDomain.Common
{
    using Microsoft.WindowsAzure.Storage.Table;

    public class BulkUploadLocationMappingEntity : TableEntity
    {
        public byte[] LocationMapping { get; set; }
    }
}
