namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload
{
    public class EnrichTransformAndPublishCommand
    {
        public string BatchId { get; set; }

        public byte[] DataLoadResultsDatabus { get; set; }
    }
}
