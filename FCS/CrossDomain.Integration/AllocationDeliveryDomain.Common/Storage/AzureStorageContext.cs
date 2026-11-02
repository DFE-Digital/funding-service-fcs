namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    public class AzureStorageContext : IAzureStorageContext
    {
        public string TableName
        {
            get { return "EnrichedReportedActual"; }
        }
    }
}
