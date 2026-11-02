namespace Operations.Web.Dtos
{
    using System.Collections.Generic;

    public class ParkedAllocationDetails
    {
        public ParkedAllocationDetails(IReadOnlyCollection<ParkedFundingAllocationsSubStatusInfo> subStatusInfos, IReadOnlyCollection<AwaitingProviderInfo> awaitingProviderInfos, IReadOnlyCollection<AwaitingFundingLineInfo> awaitingFundingLineInfos, IReadOnlyCollection<AwaitingContractTypeInfo> awaitingContractTypeInfos, IReadOnlyCollection<AwaitingFundingAllocationInfo> awaitingFundingAllocationInfos, IReadOnlyCollection<ProviderTypeSubtypeInfo> unknownProviderTypeSubtypeInfos)
        {
            SubStatusInfos = subStatusInfos;
            AwaitingProviderInfos = awaitingProviderInfos;
            AwaitingFundingLineInfos = awaitingFundingLineInfos;
            AwaitingContractTypeInfos = awaitingContractTypeInfos;
            AwaitingFundingAllocationInfos = awaitingFundingAllocationInfos;
            UnknownProviderTypeSubtypeInfos = unknownProviderTypeSubtypeInfos;
        }

        public IReadOnlyCollection<ParkedFundingAllocationsSubStatusInfo> SubStatusInfos { get; }
        public IReadOnlyCollection<AwaitingProviderInfo> AwaitingProviderInfos { get; }
        public IReadOnlyCollection<AwaitingFundingLineInfo> AwaitingFundingLineInfos { get; }
        public IReadOnlyCollection<AwaitingContractTypeInfo> AwaitingContractTypeInfos { get; }
        public IReadOnlyCollection<AwaitingFundingAllocationInfo> AwaitingFundingAllocationInfos { get; }
        public IReadOnlyCollection<ProviderTypeSubtypeInfo> UnknownProviderTypeSubtypeInfos { get; }
    }
}