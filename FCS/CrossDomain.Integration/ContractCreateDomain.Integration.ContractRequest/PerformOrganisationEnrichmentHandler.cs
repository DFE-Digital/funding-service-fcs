namespace ContractCreateDomain.Integration.ContractRequest
{
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;

    public class PerformOrganisationEnrichmentHandler : IHandleMessages<PerformOrganisationEnrichmentCommand>
    {
        public IBus Bus { get; set; }

        public IOrganisationMessageEnricher OrganisationMessageEnricher { get; set; }

        public void Handle(PerformOrganisationEnrichmentCommand message)
        {
            OrganisationMessageEnricher.Enrich(message.ContractRequest);
            var replyMessage = new OrganisationEnrichmentComplete
            {
                ContractRequest = message.ContractRequest
            };
            Bus.Reply(replyMessage);
        }
    }
}
