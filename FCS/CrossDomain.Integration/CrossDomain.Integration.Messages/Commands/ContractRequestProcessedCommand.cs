namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    using Entities.ContractRequest;

    public class ContractRequestProcessedCommand
    {
        public contractRequestType ContractRequest { get; set; }
    }
}
