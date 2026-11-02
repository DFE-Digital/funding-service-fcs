namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto
{
    public class CollectionReturn
    {
        public CollectionReturn(string collectionReturnCode, string collectionType)
        {
            CollectionReturnCode = collectionReturnCode;
            CollectionType = collectionType;
        }

        public string CollectionReturnCode { get; }

        public string CollectionType { get; }

        public override bool Equals(object obj)
        {
            if (obj is CollectionReturn other)
            {
                return this.CollectionType == other.CollectionType &&
                       this.CollectionReturnCode == other.CollectionReturnCode;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return CollectionReturnCode.GetHashCode() ^ CollectionType.GetHashCode();
        }
    }
}