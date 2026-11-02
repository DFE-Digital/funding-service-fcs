namespace SFA.FCT.ContractManagementService.AtomFeed
{
    using CrossDomain.Integration.Common.Atom;

    public class AllocationFeedPageNumberMutator : IPageNumberMutator
    {
        public int MutatePageNumberIn(int pageNumber)
        {
            return pageNumber - 1;
        }

        public int MutatePageNumberOut(int pageNumber)
        {
            return pageNumber + 1;
        }
    }
}