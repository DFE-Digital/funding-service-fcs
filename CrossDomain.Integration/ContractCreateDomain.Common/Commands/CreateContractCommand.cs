namespace SFA.FCT.ContractCreateDomain.Common.Commands
{
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class CreateContractCommand : ICommand
    {
        public contractRequestType ContractRequest { get; set; }
    }
}
