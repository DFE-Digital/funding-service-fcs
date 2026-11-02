namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using Microsoft.WindowsAzure.Storage.Table;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    internal class ReportedActualGroup : TableEntity, IAzureEntity
    {
        public virtual string TableName
        {
            get { return "ReportedActualGroupStub"; }
        }

        public string EntityPartitionKey { get; set; }

        public string EntityRowKey
        {
            get { return RowCount.ToString("D8"); }
        }

        public int RowCount { get; set; }
    }
}
