namespace Operations.Web.Dtos
{
    using System;

    public class ClosedCollection
    {
        public string CollectionType { get; }
        public string CollectionReturnCode { get; }
        public DateTime ClosedTime { get; }
        public int TotalRowCount { get; }
        public int RetrievedRowCount { get; }
        public DateTime CreatedDate { get; }
        public int TotalRowsInTable { get; }


        public ClosedCollection(
            string collectionType,
            string collectionReturnCode,
            DateTime closedTime, 
            int totalRowCount,
            int retrievedRowCount,
            DateTime createdDate,
            int totalRowsInTable)
        {
            CollectionType = collectionType;
            CollectionReturnCode = collectionReturnCode;
            ClosedTime = closedTime;
            TotalRowCount = totalRowCount;
            RetrievedRowCount = retrievedRowCount;
            TotalRowsInTable = totalRowsInTable;
            CreatedDate = createdDate;
        }
    }
}