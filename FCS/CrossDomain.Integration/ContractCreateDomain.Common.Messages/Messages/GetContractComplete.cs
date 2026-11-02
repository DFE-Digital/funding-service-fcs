namespace SFA.FCT.ContractCreateDomain.Common.Messages.Messages
{
    using CrossDomain.Integration.Entities.ContractRequest;
    
    public class GetContractComplete 
    {
        public string ProcessId { get; set; }

        public contractType Contract { get; set; }
    }
}
