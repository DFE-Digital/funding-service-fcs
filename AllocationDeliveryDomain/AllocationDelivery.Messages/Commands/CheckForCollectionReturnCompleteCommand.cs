namespace AllocationDelivery.Messages.Commands
{
    public class CheckForCollectionReturnCompleteCommand
    {
        public string CollectionType { get; set; }

        public string CollectionReturnCode { get; set; }

        public override string ToString()
        {
            return $"CollectionType: {CollectionType}, CollectionReturnCode: {CollectionReturnCode}";
        }
    }
}
