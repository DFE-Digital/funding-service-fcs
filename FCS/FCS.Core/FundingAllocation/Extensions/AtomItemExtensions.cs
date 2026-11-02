namespace FundingAllocation.Extensions
{
    using System.Linq;
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public static class AtomItemExtensions
    {
        public static FundingAllocation ToFundingAllocation(this AtomItem atomItem, int readId)
        {
            return new FundingAllocation
            (
                atomItem.FundingId,
                atomItem.FundingVersion,
                atomItem.Period,
                atomItem.AllocationFundingStream,
                atomItem.Ukprn,
                atomItem.Value,
                atomItem.PageNumber,
                atomItem.PositionInPage,
                atomItem.ProviderFundingIds.Length,
                readId
            );
        }

        public static FundingAllocationDto ToFundingAllocationDto(this AtomItem atomItem)
        {
            return new FundingAllocationDto
            {
                FundingId = atomItem.FundingId,
                FundingVersion = atomItem.FundingVersion,
                Period = atomItem.Period,
                AllocationFundingStream = atomItem.AllocationFundingStream,
                UKPRN = atomItem.Ukprn,
                Value = atomItem.Value,
                ProviderFundingIds = atomItem.ProviderFundingIds.ToList()
            };
        }
    }
}
