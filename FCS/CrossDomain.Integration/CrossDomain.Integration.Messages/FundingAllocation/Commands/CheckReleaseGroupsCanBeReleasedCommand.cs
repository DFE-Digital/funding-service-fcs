namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using System;
    using System.Linq;
    using Extensions;

    public class CheckReleaseGroupsCanBeReleasedCommand
    {
        public CheckReleaseGroupsCanBeReleasedCommand(string[] fundingAllocationIds, int? releaseGroupId)
        {
            FundingAllocationIds = fundingAllocationIds ?? Array.Empty<string>();
            ReleaseGroupId = releaseGroupId;
            if (FundingAllocationIds.Any() && releaseGroupId.HasValue)
            {
                throw new ArgumentException("We cannot use fundingAllocations and a release grp id here");
            }
        }

        public static CheckReleaseGroupsCanBeReleasedCommand Create(string[] fundingAllocationIds)
        {
           return new CheckReleaseGroupsCanBeReleasedCommand(fundingAllocationIds, null);
        }

        public static CheckReleaseGroupsCanBeReleasedCommand Create(int releaseGroupId)
        {
            return new CheckReleaseGroupsCanBeReleasedCommand(Array.Empty<string>(), releaseGroupId);
        }

        public string[] FundingAllocationIds { get; }

        public int? ReleaseGroupId { get; }

        public override string ToString()
        {
            return $"FundingAllocationIds: {string.Join(", ", FundingAllocationIds.GetValueOrEmpty())}, ReleaseGroupId: {ReleaseGroupId}";
        }
    }
}
