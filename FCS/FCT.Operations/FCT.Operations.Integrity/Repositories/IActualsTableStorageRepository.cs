namespace SFA.FCT.Operations.Integrity.Repositories
{
    public interface IActualsTableStorageRepository
    {
        string GetLastCollectionCodeForCollectionType(string collectionType);
    }
}
