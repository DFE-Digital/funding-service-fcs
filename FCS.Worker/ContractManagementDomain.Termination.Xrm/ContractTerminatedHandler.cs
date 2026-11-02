namespace ContractManagementDomain.Termination.Xrm
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractTerminatedHandler : IHandleMessages<ContractTerminatedEvent>
    {
        private readonly ILogger _logger;
        private readonly ICrmContractRepository _crmContractRepository;

        public ContractTerminatedHandler(ILogger logger, ICrmContractRepository crmContractRepository)
        {
            _logger = logger;
            _crmContractRepository = crmContractRepository;
        }

        public Task Handle(ContractTerminatedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                ContractManagementLoggingEvents.ContractTerminatedEventReceived,
                $"START: ContractTerminatedEvent for {message} received");

            _crmContractRepository.OverwriteNullEndDateWithTerminationDate(
                message.ContractNumber,
                message.VersionNumber, 
                message.SubVersionNumber);

            _crmContractRepository.OverwriteNullAllocationEndDatesWithTerminationDates(
                message.ContractNumber,
                message.VersionNumber,
                message.SubVersionNumber);

            _crmContractRepository.UpdateServiceResponseOnContract(
                contractNumber: message.ContractNumber,
                version: message.VersionNumber,
                subVersion: message.SubVersionNumber,
                serviceresponse: sfa_serviceresponse.TerminationSuccessful);

            _logger.LogInformation(
                ContractManagementLoggingEvents.ContractTerminatedEventProcessed,
                $"END: ContractTerminatedEvent for {message} processed");

            return Task.FromResult(0);
        }
    }
}