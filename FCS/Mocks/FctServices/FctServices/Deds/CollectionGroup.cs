namespace FctServices.Deds
{
    public class CollectionGroup
    {
        public CollectionGroup(string collectionType, string collectionReturnCode)
        {
            CollectionType = collectionType;
            CollectionReturnCode = collectionReturnCode;
        }

        public string CollectionType { get; private set; }

        public string CollectionReturnCode { get; private set; }
    }
}