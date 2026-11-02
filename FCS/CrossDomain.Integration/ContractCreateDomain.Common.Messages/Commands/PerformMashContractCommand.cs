namespace SFA.FCT.ContractCreateDomain.Common.Messages.Commands
{
    using CrossDomain.Integration.Entities.ContractRequest;

    public class PerformMashContractCommand
    {
        public contractType Contract { get; set; }
        
        public contractRequestType ContractRequest { get; set; }
    }
}
