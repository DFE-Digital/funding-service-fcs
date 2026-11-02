namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands
{
    using Entities.Xrm.OptionSets;

    public class ReturnToSchedulingInCrmCommand
    {
        public ReturnToSchedulingInCrmCommand(string crmEntityId, sfa_FundingAllocationServiceResponse serviceResponse)
        {
            CrmEntityId = crmEntityId;
            ServiceResponse = serviceResponse;
        }

        public string CrmEntityId { get; }
        public sfa_FundingAllocationServiceResponse ServiceResponse { get; }

        public override string ToString() => $"CrmEntityId: {CrmEntityId}, ServiceResponse: {ServiceResponse}";
    }
}
