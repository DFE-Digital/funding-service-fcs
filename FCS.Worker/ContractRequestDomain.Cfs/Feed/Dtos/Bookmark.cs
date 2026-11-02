namespace ContractRequestDomain.Cfs.Feed.Dtos
{
    public class Bookmark
    {
        public Bookmark(string allocationId, int feedPageNumber)
        {
            AllocationId = allocationId;
            FeedPageNumber = feedPageNumber;
        }

        public string AllocationId { get; }

        public int FeedPageNumber { get; }

        public override string ToString()
        {
            return $"AllocationId: {AllocationId}, FeedPageNumber: {FeedPageNumber}";
        }
    }
}