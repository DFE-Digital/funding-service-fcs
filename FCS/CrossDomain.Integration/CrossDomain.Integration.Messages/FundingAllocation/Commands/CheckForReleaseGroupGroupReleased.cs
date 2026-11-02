namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    public class CheckForReleaseGroupGroupReleased
    {
        public CheckForReleaseGroupGroupReleased(string releaseGroupName)
        {
            ReleaseGroupName = releaseGroupName;
        }

        public string ReleaseGroupName { get; }

        public override string ToString() => $"ReleaseGroupName: {ReleaseGroupName}";
    }
}
