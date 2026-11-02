namespace FCT.Operations.DataStore.Model
{
    using System;

    public class AvailableActualsCollection
    {
        private AvailableActualsCollection(){}

        public AvailableActualsCollection(string collectionType, string collectionReturnCode, DateTime closedDateTime, int totalItems)
        {
            CollectionType = collectionType;
            CollectionReturnCode = collectionReturnCode;
            ClosedDateTime = closedDateTime;
            TotalItems = totalItems;
        }

        public string CollectionType { get; }
        public string CollectionReturnCode { get; }
        public DateTime ClosedDateTime { get; }
        public int TotalItems { get; }
    }
}
