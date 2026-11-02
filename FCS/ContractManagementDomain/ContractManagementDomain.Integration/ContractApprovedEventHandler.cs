namespace ContractManagementDomain.Integration
{
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Events;
    using SFA.FCT.ContractManagementService.Common.Persistence;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractApprovedEventHandler : IHandleMessages<ContractApprovedEvent>
    {
        private readonly ILogger _logger;
        private readonly IApprovedContractRepository _approvedContractRepository;

        public ContractApprovedEventHandler(ILogger logger, IApprovedContractRepository approvedContractRepository)
        {
            _logger = logger;
            _approvedContractRepository = approvedContractRepository;
        }

        public void Handle(ContractApprovedEvent message)
        {
            var corporateContract = message.CorporateContract;

            _logger.LogInformation(
                ContractManagementLoggingEvents.ContractApprovedEventReceivedForPagedContractStorage,
                "Approved Contract {0}, version {1}",
                corporateContract.contractNumber,
                corporateContract.contractVersionNumber);

            _approvedContractRepository.Add(corporateContract);
        }
    }
}
