namespace AllocationDelivery.Messages.Commands
{
    public class PullClosedCollectionPageCommand
    {
        public string CollectionType { get; set; }

        public string CollectionReturnCode { get; set; }

        public int PageNumber { get; set; }

        public int PageSize { get; set; }

        public override string ToString()
        {
            return
                $"CollectionType: {CollectionType}, CollectionReturnCode: {CollectionReturnCode}, PageNumber: {PageNumber}";
        }
    }
}
