namespace FundingAllocation.Endpoints.CheckForReadComplete
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public interface ICheckForReadCompleteFundingAllocationRepository
    {
        Task<int> GetNumParkedNotAwaitingOutcome(int readId);

        Task<int> SetToDiscardedSupersededWhereParked(IReadOnlyCollection<string> fundingNamesToDiscard,
            int readIdToIgnore);

        Task UpdateParkingInfoForDiscarded(IReadOnlyCollection<string> fundingNamesToDiscard, int readIdToIgnore,
            DateTime now);
    }
}