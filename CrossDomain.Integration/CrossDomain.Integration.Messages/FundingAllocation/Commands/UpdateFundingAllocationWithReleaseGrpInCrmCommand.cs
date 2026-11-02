namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    public class UpdateFundingAllocationWithReleaseGrpInCrmCommand
    {
        public string CrmFundingId { get; set; }
        public string CrmReleaseGrpId { get; set; }

        public override string ToString() => $"CrmFundingId: {CrmFundingId}, CrmReleaseGrpId: {CrmReleaseGrpId}";
    }
}
