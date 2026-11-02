namespace SFA.FCT.ContractCreateDomain.Common.Messages.Commands
{
    using CrossDomain.Integration.Entities.ContractRequest;

    public class PerformFirstLevelValidationCommand
    {
        public contractRequestType ContractRequest { get; set; }
    }
}
