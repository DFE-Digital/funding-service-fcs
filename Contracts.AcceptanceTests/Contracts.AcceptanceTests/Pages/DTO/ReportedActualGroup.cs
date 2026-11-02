namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO
{
    using AllocationDeliveryDomain.Common.Storage;
    using Microsoft.WindowsAzure.Storage.Table;

    public class ReportedActualGroup : TableEntity, IAzureEntity
    {
        public virtual string TableName => "ReportedActualGroupStub";

        public string EntityPartitionKey { get; set; }

        public string EntityRowKey => RowCount.ToString("D8");

        public int RowCount { get; set; }
    }
}
