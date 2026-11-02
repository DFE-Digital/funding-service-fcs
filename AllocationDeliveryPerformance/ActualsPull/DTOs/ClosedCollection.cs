namespace ActualsPull.DTOs
{
    using System;

    public class ClosedCollection
    {
        public ClosedCollection(string collectionType, string collectionReturnCode, DateTime dateTime, int totalItems)
        {
            CollectionType = collectionType;
            CollectionReturnCode = collectionReturnCode;
            DateTime = dateTime;
            TotalItems = totalItems;
        }

        public string CollectionType { get;  }

        public string CollectionReturnCode { get; }

        public DateTime DateTime { get; }

        public int TotalItems { get; }
    }
}
