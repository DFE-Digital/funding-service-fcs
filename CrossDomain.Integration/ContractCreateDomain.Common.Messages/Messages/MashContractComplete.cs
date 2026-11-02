namespace SFA.FCT.ContractCreateDomain.Common.Messages.Messages
{
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class MashContractComplete
    {
        public contractRequestType ContractRequest { get; set; }
    }
}
