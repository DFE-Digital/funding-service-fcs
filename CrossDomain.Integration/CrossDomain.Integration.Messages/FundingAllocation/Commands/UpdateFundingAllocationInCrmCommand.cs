namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using Entities.Xrm.OptionSets;

    public class UpdateFundingAllocationInCrmCommand
    {
        public UpdateFundingAllocationInCrmCommand(string fundingId, string releaseGroupId, sfa_FundingAllocationServiceResponse serviceResponse)
        {
            FundingId = fundingId;
            ReleaseGroupId = releaseGroupId;
            ServiceResponse = serviceResponse;
        }

        public string FundingId { get; }
        public string ReleaseGroupId { get; }
        public sfa_FundingAllocationServiceResponse ServiceResponse { get;}

        public override string ToString() => $"FundingId: {FundingId}, ReleaseGroupId: {ReleaseGroupId}, ServiceResponse: {ServiceResponse}";
    }
}
