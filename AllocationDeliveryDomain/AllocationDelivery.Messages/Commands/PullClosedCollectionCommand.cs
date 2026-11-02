namespace AllocationDelivery.Messages.Commands
{
    using DTOs;

    public class PullClosedCollectionCommand
    {
        public ClosedCollection ClosedCollection { get; set; }

        public static PullClosedCollectionCommand Create(ClosedCollection closedCollection)
        {
            return new PullClosedCollectionCommand
            {
                ClosedCollection = closedCollection
            };
        }

        public override string ToString()
        {
            return ClosedCollection.ToString();
        }
    }
}
