namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto
{
    using System.Collections.Generic;

    public class AllocationGrpWithCollectionReturns
    {
        public AllocationGrpWithCollectionReturns(string fundingStreamPeriodCode, string orgId, string uopCode, IReadOnlyCollection<CollectionReturnWithPartitionKey> collectionReturns)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            OrgId = orgId;
            UopCode = uopCode;
            CollectionReturns = collectionReturns;
        }

        public string FundingStreamPeriodCode { get; }

        public string OrgId { get; }

        public string UopCode { get; }

        public IReadOnlyCollection<CollectionReturnWithPartitionKey> CollectionReturns { get; }
    }
}
