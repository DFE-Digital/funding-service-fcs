namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    public class ReinstateFundingAllocationInCrmCommand
    {
        public ReinstateFundingAllocationInCrmCommand(string fundingAllocationCrmEntityId, string releaseGroupCrmEntityId)
        {
            FundingAllocationCrmEntityId = fundingAllocationCrmEntityId;
            ReleaseGroupCrmEntityId = releaseGroupCrmEntityId;
        }

        public string FundingAllocationCrmEntityId { get; }

        public string ReleaseGroupCrmEntityId { get; }

        public override string ToString() => $"FundingAllocationCrmEntityId: {FundingAllocationCrmEntityId}, " +
                                             $"ReleaseGroupCrmEntityId: {ReleaseGroupCrmEntityId}";
    }
}