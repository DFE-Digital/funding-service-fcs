namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto
{
    public class CollectionReturnWithPartitionKey : CollectionReturn
    {
        public CollectionReturnWithPartitionKey(string collectionReturnCode, string collectionType, string partitionKey): base(collectionReturnCode: collectionReturnCode, collectionType: collectionType)
        {
            PartionKey = partitionKey;
        }

        public string PartionKey { get; }
    }
}
