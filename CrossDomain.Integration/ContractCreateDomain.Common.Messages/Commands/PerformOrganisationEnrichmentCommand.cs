namespace SFA.FCT.ContractCreateDomain.Common.Messages.Commands
{
    using CrossDomain.Integration.Entities.ContractRequest;

    public class PerformOrganisationEnrichmentCommand
    {
        public contractRequestType ContractRequest { get; set; }
    }
}
