namespace Operations.Web.Dtos
{
    using System.Collections.Generic;

    public class ClosedCollectionResult
    {
        public ClosedCollectionResult(int totalRowsInTable, IReadOnlyCollection<ClosedCollection> closedCollections)
        {
            TotalRowsInTable = totalRowsInTable;
            ClosedCollections = closedCollections;
        }

        public int TotalRowsInTable { get; }
        public IReadOnlyCollection<ClosedCollection> ClosedCollections { get; }
    }
}