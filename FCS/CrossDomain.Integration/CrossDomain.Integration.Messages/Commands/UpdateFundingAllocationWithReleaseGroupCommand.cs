namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class UpdateFundingAllocationWithReleaseGroupCommand
    {
        public string FundingId { get; set; }
        public int? ReleaseGroupId { get; set; }

        public override string ToString()
        {
            return $"FundingId: {FundingId}, ReleaseGroupId: {ReleaseGroupId}";
        }
    }
}
