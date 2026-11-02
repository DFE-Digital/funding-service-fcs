namespace ContractCreateDomain.Integration.ContractRequest
{
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;

    public class PerformContractValueAggregationHandler : IHandleMessages<PerformContractValueAggregationCommand>
    {
        public IBus Bus { get; set; }

        public IContractValueAggregator ContractValueAggregator { get; set; }

        public void Handle(PerformContractValueAggregationCommand message)
        {
            // aggregate the contract values from the deliverable periods up the tree to the parent nodes
            ContractValueAggregator.Aggregate(message.Contract);

            var replyMessage = new ContractValueAggregationComplete
            {
                Contract = message.Contract
            };
            Bus.Reply(replyMessage);
        }
    }
}
