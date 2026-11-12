namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO
{
    using AllocationDeliveryDomain.Common.Storage;
    using Azure;
    //using Microsoft.WindowsAzure.Storage.Table;
    using Azure.Data.Tables;
    using System;

    public class ReportedActualGroup : ITableEntity, IAzureEntity
    {

        public string PartitionKey { get; set; }

        public string RowKey { get; set; }

        public DateTimeOffset? Timestamp { get; set; }

        public ETag ETag { get; set; }

        public virtual string TableName => "ReportedActualGroupStub";

        public string EntityPartitionKey { get; set; }

        public string EntityRowKey => RowCount.ToString("D8");

        public int RowCount { get; set; }
    }
}
