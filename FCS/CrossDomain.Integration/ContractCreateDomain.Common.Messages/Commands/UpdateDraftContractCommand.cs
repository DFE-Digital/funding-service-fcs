namespace SFA.FCT.ContractCreateDomain.Common.Messages.Commands
{
    using CrossDomain.Integration.Entities.CorporateContract;

    public class UpdateDraftContractCommand
    {
        public string ProcessId { get; set; }

        public contractType Contract { get; set; }
    }
}
