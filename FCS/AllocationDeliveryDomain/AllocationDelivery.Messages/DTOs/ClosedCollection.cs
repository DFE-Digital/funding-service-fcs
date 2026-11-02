namespace AllocationDelivery.Messages.DTOs
{
    using System;
    public class ClosedCollection
    {
        public string CollectionType { get; set; }

        public string CollectionReturnCode { get; set; }

        public DateTime ClosedTime { get; set; }

        public int TotalRowCount { get; set; }

        public override string ToString() =>
            $"CollectionType: {CollectionType}, CollectionReturnCode: {CollectionReturnCode}, ClosedTime: {ClosedTime}, TotalRowCount: {TotalRowCount}";

        public override bool Equals(object obj)
        {
            if (obj is ClosedCollection other)
            {
                return CollectionType == other.CollectionType && CollectionReturnCode == other.CollectionReturnCode;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return CollectionType.GetHashCode() ^ CollectionReturnCode.GetHashCode();
        }
    }
}
