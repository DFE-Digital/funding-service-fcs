namespace SFA.FCT.CrossDomain.Integration.Events
{
    public class BulkUploadCompleteEvent
    {
        public BulkUploadCompleteEvent(string batchId)
        {
            BatchId = batchId;
        }

        public string BatchId { get; }

        public override string ToString() => $"BatchId: {BatchId}";
    }
}
