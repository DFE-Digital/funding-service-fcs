namespace ContractRequestDomain.Cfs.Feed.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;

    public static class AtomPageTransformer
    {
        public static IReadOnlyCollection<AllocationNotification> ToOrderedAllocationNotifications(AtomPage atomPage)
        {
            return atomPage.AtomEntry
                .Select(atomEntry => new AllocationNotification
                {
                    AllocationId = atomEntry.Id,
                    VersionNumber = atomEntry.Content.Allocation.AllocationVersionNumber,
                    Ukprn = atomEntry.Content.Allocation.Provider.UkPrn,
                    Status = ProcessingStatus.New,
                    FeedPageNumber = atomPage.GetPageNumber()
                })
                .Reverse()
                .ToList();
        }
    }
}
