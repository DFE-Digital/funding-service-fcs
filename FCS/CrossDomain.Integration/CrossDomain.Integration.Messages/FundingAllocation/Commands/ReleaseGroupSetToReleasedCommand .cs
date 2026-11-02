namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    public class ReleaseGroupSetToReleasedCommand
    {
        public ReleaseGroupSetToReleasedCommand(string releaseGroupName)
        {
            ReleaseGroupName = releaseGroupName;
        }

        public ReleaseGroupSetToReleasedCommand()
        {
        }

        public string ReleaseGroupName { get; set; }

        public override string ToString()
        {
            return $"ReleaseGroupName: {ReleaseGroupName}";
        }
    }
}
