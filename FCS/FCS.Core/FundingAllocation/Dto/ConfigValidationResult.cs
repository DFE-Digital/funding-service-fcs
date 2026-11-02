namespace FundingAllocation.Dto
{
    using System.Collections.Generic;
    using Extensions;

    public class ConfigValidationResult
    {
        public ConfigValidationResult(
            IReadOnlyCollection<string> awaitingFundingAllocationConfigFundingIds,
            IReadOnlyCollection<string> awaitingContractTypeConfigFundingIds,
            IReadOnlyCollection<string> awaitingFundingLineCodeFundingIds,
            IReadOnlyCollection<string> passedValidationFundingIds)
        {
            AwaitingFundingAllocationConfigFundingIds = awaitingFundingAllocationConfigFundingIds;
            AwaitingContractTypeConfigFundingIds = awaitingContractTypeConfigFundingIds;
            AwaitingFundingLineCodeFundingIds = awaitingFundingLineCodeFundingIds;
            PassedValidationFundingIds = passedValidationFundingIds;
        }

        public IReadOnlyCollection<string> AwaitingFundingAllocationConfigFundingIds { get; }
        public IReadOnlyCollection<string> AwaitingContractTypeConfigFundingIds { get; }
        public IReadOnlyCollection<string> AwaitingFundingLineCodeFundingIds { get; }
        public IReadOnlyCollection<string> PassedValidationFundingIds { get; }

        public override string ToString()
        {
            return $"AwaitingFundingAllocationConfig: {AwaitingFundingAllocationConfigFundingIds.ToCsv()}, " +
                   $"AwaitingContractTypeConfig: {AwaitingContractTypeConfigFundingIds.ToCsv()}, " +
                   $"AwaitingFundingLineCodeFundingIds: {AwaitingFundingLineCodeFundingIds.ToCsv()}" +
                   $"Passed: {PassedValidationFundingIds.ToCsv()}";
        }
    }
}
