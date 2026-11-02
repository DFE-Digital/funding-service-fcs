namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload
{
    using NServiceBus;

    public class BulkUploadSagaData : ContainSagaData
    {
        public virtual string BatchId { get; set; }

        public virtual string FileName { get; set; }

        public virtual string Timestamp { get; set; }
    }
}
