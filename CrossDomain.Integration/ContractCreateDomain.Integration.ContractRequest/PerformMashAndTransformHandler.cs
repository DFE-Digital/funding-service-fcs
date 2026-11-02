namespace ContractCreateDomain.Integration.ContractRequest
{
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class PerformMashAndTransformHandler : 
        IHandleMessages<PerformMashContractCommand>,
        IHandleMessages<PerformTransformContractCommand>
    {
        public IBus Bus { get; set; }

        public IMasher ContractMasher { get; set; }

        public IContractRequestTransformer ContractRequestTransformer { get; set; }

        public void Handle(PerformMashContractCommand message)
        {
            // need to preserve correlation id and error info and funding configuration
            message.ContractRequest.contract = ContractMasher.Mash(
                message.Contract,
                message.ContractRequest.contract);

            var replyMessage = new MashContractComplete
            {
                ContractRequest = message.ContractRequest
            };
            Bus.Reply(replyMessage);
        }

        public void Handle(PerformTransformContractCommand message)
        {
            ExtendedContractType corpContract = ContractRequestTransformer
                .TransformToCorpContractType(message.ContractRequest);
            var replyMessage = new TransformContractComplete
            {
                Contract = corpContract
            };
            Bus.Reply(replyMessage);
        }
    }
}
