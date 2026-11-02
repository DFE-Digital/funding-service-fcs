namespace ContractRequestDomain.Cfs.Feed.Services
{
    using Dtos;

    public interface IAllocationNotificationFeedReader
    {
        AtomPage GetAtomPage(int pageNumber);
    }
}
