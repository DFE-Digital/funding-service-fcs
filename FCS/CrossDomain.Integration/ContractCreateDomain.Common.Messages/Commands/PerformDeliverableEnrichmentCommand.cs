namespace SFA.FCT.ContractCreateDomain.Common.Messages.Commands
{
    using CrossDomain.Integration.Entities.CorporateContract;

    public class PerformDeliverableEnrichmentCommand
    {
        public ExtendedContractType Contract { get; set; }
    }
}
