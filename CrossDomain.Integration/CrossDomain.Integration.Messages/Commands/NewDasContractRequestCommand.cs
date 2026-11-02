namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using Entities.ContractRequest;

    public class NewDasContractRequestCommand
    {
        public DasRequest DasRequest { get; set; }

        public long DasEngagementEventId { get; set; }
    }
}
