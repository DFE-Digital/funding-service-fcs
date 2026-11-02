namespace ContractCreateDomain.Integration.ContractRequest
{
    using NServiceBus;
    using NServiceBus.Saga;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;

    public class PerformSecondLevelValidationHandler : IHandleMessages<PerformSecondLevelValidationCommand>
    {
        private readonly IContractOperationRules _contractOperationRules;
        private readonly IValidator _validator;

        public PerformSecondLevelValidationHandler(IValidator validator, IContractOperationRules contractOperationRules)
        {
            _validator = validator;
            _contractOperationRules = contractOperationRules;
        }

        public IBus Bus { get; set; }

        public void Handle(PerformSecondLevelValidationCommand message)
        {
            var contractRequest = message.ContractRequest;

            // Get rules using reference data
            var rules = _contractOperationRules
                .GetUpdateDraftContractSecondLevelRules(
                    message.ContractTypes,
                    message.ContractRequest.FundingConfiguration,
                    message.LepCodes,
                    message.UopCodes,
                    message.DeliverableStructures);

            // Perform validation
            // Check successful
            if (_validator.Validate(contractRequest, rules)) 
            {
                Bus.Reply(new SecondLevelValidationSuccess());
            }
            else
            {
                var replyMessage = new UpdateDraftContractUnsuccessful
                {
                    ContractRequest = contractRequest,
                    Error = null
                };
                Bus.Reply(replyMessage);
            }
        }
    }
}
