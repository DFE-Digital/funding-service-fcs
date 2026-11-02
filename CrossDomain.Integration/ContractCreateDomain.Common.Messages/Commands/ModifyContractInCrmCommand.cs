namespace SFA.FCT.ContractCreateDomain.Common.Messages.Commands
{
    using CrossDomain.Integration.Entities.CorporateContract;

    public class ModifyContractInCrmCommand
    {
        public string CorrelationId { get; set; }

        public string BatchId { get; set; }

        public ExtendedContractType Contract { get; set; }
    }
}
