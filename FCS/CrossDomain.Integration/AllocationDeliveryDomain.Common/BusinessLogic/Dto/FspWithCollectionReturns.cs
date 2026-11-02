namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto
{
    using System.Collections.Generic;

    public class FspWithCollectionReturns
    {
        public FspWithCollectionReturns(string fspCode, IReadOnlyCollection<CollectionReturnWithPartitionKey> collectionReturns)
        {
            FspCode = fspCode;
            CollectionReturns = collectionReturns;
        }

        public string FspCode { get; }

        public IReadOnlyCollection<CollectionReturnWithPartitionKey> CollectionReturns { get; }
    }
}