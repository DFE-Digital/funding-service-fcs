namespace ContractCreateDomain.Integration.ContractRequest
{
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;

    public class PerformDeliverableEnrichmentHandler : IHandleMessages<PerformDeliverableEnrichmentCommand>
    {
        public IContractDeliverableEnricher ContractDeliverableEnricher { get; set; }

        public IBus Bus { get; set; }
        
        public void Handle(PerformDeliverableEnrichmentCommand message)
        {
            // Enrich the contract with required deliverables
            ContractDeliverableEnricher.Enrich(message.Contract);
            var replyMessage = new DeliverableEnrichmentComplete
            {
                Contract = message.Contract
            };
            Bus.Reply(replyMessage);
        }
    }
}
