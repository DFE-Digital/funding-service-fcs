namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    public interface IAzureEntity
    {
        string TableName { get; }

        string EntityPartitionKey { get; }
        
        string EntityRowKey { get; }
    }
}
