namespace ContractManagementDomain.Termination.Handlers
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class SetContractTerminationToCompleteInCrmHandler : IHandleMessages<SetContractTerminationToCompleteInCrmCommand>
    {
        private readonly ICrmContractRepository _crmContractRepository;
        private readonly ILogger _logger;

        public SetContractTerminationToCompleteInCrmHandler(ICrmContractRepository crmContractRepository, ILogger logger)
        {
            _crmContractRepository = crmContractRepository;
            _logger = logger;
        }

        public Task Handle(SetContractTerminationToCompleteInCrmCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementLoggingEvents.SetContractTerminationToCompleteCommandReceived, $"SetContractTerminationToCompleteInCrmCommand for {message} received");

            sfa_serviceresponse serviceResponse = (sfa_serviceresponse)Enum.Parse(typeof(sfa_serviceresponse), message.RequiredCrmServiceResponse.ToString());

            _crmContractRepository.UpdateServiceResponseOnContract(
                message.ContractNumber,
                message.VersionNumber,
                message.SubVersionNumber,
                serviceResponse);

            _logger.LogInformation(ContractManagementLoggingEvents.SetContractTerminationToCompleteCommandProcessed, $"SetContractTerminationToCompleteInCrmCommand for {message} processed");

            return Task.FromResult(0);
        }
    }
}
