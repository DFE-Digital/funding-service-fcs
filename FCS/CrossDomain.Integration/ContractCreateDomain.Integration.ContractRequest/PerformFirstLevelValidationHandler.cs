namespace ContractCreateDomain.Integration.ContractRequest
{
    using System.Linq;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;

    public class PerformFirstLevelValidationHandler : IHandleMessages<PerformFirstLevelValidationCommand>
    {
        private readonly IValidator _validator;
        private readonly IContractOperationRules _contractOperationRules;

        public PerformFirstLevelValidationHandler(IValidator validator, IContractOperationRules contractOperationRules)
        {
            _validator = validator;
            _contractOperationRules = contractOperationRules;
        }

        public IBus Bus { get; set; }

        public void Handle(PerformFirstLevelValidationCommand message)
        {
            var rules = _contractOperationRules.GetUpdateDraftContractFirstLevelRules(message.ContractRequest);

            _validator.Validate(message.ContractRequest, rules);

            if (!message.ContractRequest.errorInfo.Any())
            {
                var replyMessage = new FirstLevelValidationSuccess
                {
                    ContractRequest = message.ContractRequest
                };
                Bus.Reply(replyMessage);
            }
            else
            {
                var replyMessage = new UpdateDraftContractUnsuccessful
                {
                    ContractRequest = message.ContractRequest
                };
                Bus.Reply(replyMessage);
            }
        }
    }
}
