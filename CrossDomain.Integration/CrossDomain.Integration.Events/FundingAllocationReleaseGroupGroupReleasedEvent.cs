namespace SFA.FCT.CrossDomain.Integration.Events
{
    public class FundingAllocationReleaseGroupGroupReleasedEvent
    {
        public FundingAllocationReleaseGroupGroupReleasedEvent(int releaseGroupGroupId)
        {
            ReleaseGroupGroupId = releaseGroupGroupId;
        }

        public int ReleaseGroupGroupId { get; set; }


        public override string ToString()
        {
            return $"ReleaseGroupGroupId: {ReleaseGroupGroupId}";
        }
    }
}