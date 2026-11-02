namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using System.Collections.Generic;
    using Extensions;

    public class ResetReleaseGroupsBackToAwaitingReleaseCommand
    {
        public ResetReleaseGroupsBackToAwaitingReleaseCommand(IReadOnlyCollection<string> releaseGroupNames)
        {
            ReleaseGroupNames = releaseGroupNames;
        }

        public IReadOnlyCollection<string> ReleaseGroupNames { get; }

        public override string ToString() => ReleaseGroupNames.ToCsv();
    }
}
