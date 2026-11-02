namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class ClosedCollection
    {
        public ClosedCollection(string collectionType, string collectionReturnCode, DateTime closedTime, int totalRowCount)
        {
            CollectionType = collectionType;
            CollectionReturnCode = collectionReturnCode;
            ClosedTime = closedTime;
            TotalRowCount = totalRowCount;
        }

        public ClosedCollection()
        {
        }

        [Key, Column(Order = 1)]
        [StringLength(20)]
        public string CollectionType { get; private set; }

        [Key, Column(Order = 2)]
        [StringLength(20)]
        public string CollectionReturnCode { get; private set; }

        public DateTime ClosedTime { get; private set; }

        public int TotalRowCount { get; private set; }

        public int? RetrievedRowCount { get; set; }

        public bool IsComplete()
        {
            return TotalRowCount == RetrievedRowCount;
        }
    }
}
