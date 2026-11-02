namespace ContractManagementService.AtomFeed.EntryContent
{
    public interface IEntryContent<in T>
    {
        void SetRootProperty(T value);
    }
}
