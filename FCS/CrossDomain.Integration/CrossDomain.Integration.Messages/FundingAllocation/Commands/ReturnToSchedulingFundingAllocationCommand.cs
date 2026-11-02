namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using Entities.Xrm.OptionSets;

    public class ReturnToSchedulingFundingAllocationCommand
    {
        public ReturnToSchedulingFundingAllocationCommand(string fundingId, string crmEntityId, sfa_FundingAllocationServiceResponse serviceResponse)
        {
            FundingId = fundingId;
            CrmEntityId = crmEntityId;
            ServiceResponse = serviceResponse;
        }

        public string FundingId { get; }
        public string CrmEntityId { get; }
        public sfa_FundingAllocationServiceResponse ServiceResponse { get; }

        public override string ToString() => $"FundingId: {FundingId}, CrmEntityId: {CrmEntityId}, ServiceResponse: {ServiceResponse}";
    }
}