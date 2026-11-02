namespace AllocationDeliveryDomain.Endpoint.Services
{
    using System.Collections.Generic;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto;

    public class FspsWithCollectionReturnsEvaluator
    {
        public IReadOnlyCollection<FspWithCollectionReturns> GetFundingStreamPeriodsWithCompleteCollections()
        {
            // if we have any then get the azure table ActualsCollectionTypeSummary data

            // get the config table (doesn't have a name yet), the one which holds the mapping between FSP and collections

            // identify the FSPs that have all there collection.

            // 

            return null;
        }
    }

    //public class FspWithCollectionReturns
    //{ 
    //    public FspWithCollectionReturns(string fspCode, IReadOnlyCollection<CollectionReturn> collectionReturns)
    //    {
    //        FspCode = fspCode;
    //        CollectionReturns = collectionReturns;
    //    }

    //    public string FspCode { get; }

    //    public IReadOnlyCollection<CollectionReturn> CollectionReturns { get; }
    //}

    //public class CollectionReturn
    //{
    //    public CollectionReturn(string collectionReturnCode, string collectionType)
    //    {
    //        CollectionReturnCode = collectionReturnCode;
    //        CollectionType = collectionType;
    //    }

    //    public string CollectionReturnCode { get; }

    //    public string CollectionType { get; }
    //}
}
