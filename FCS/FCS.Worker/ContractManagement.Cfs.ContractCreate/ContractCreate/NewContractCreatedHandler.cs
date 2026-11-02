namespace ContractManagement.Cfs.ContractCreate
{
    using System;
    using System.Threading.Tasks;
    using Cfs.Repositories;
    using ContractManagement.Cfs.ContractCreate.Repositories;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class NewContractCreatedHandler : IHandleMessages<NewContractCreated>
    {
        private readonly ILogger _logger;
        private readonly IContractRepository _contractRepository;
        private readonly IContractCfsAllocationRetrievalService _contractCfsAllocationRetrievalService;
        private readonly IAllocationRepository _allocationRepository;

        public NewContractCreatedHandler(ILogger logger, IContractRepository contractRepository,
            IContractCfsAllocationRetrievalService contractCfsAllocationRetrievalService,
            IAllocationRepository allocationRepository)
        {
            _logger = logger;
            _contractRepository = contractRepository;
            _contractCfsAllocationRetrievalService = contractCfsAllocationRetrievalService;
            _allocationRepository = allocationRepository;
        }

        public Task Handle(NewContractCreated message, IMessageHandlerContext context)
        {
            _logger.LogInformation(ContractManagementCfsLoggingEvents.NewContractCreatedReceived,
                $"START: NewContractCreated received for {message}");

            var childContractEntityReference = _contractRepository.GetChildContractEntityReference(message.CrmMasterContractId);

            string storageKey = _contractCfsAllocationRetrievalService.GetKey(message.ChildContractNumber, message.ChildContractVersionNumber);
            Guid cfsAllocationId = _contractCfsAllocationRetrievalService.GetContractCfsAllocation(storageKey).CfsAllocationId;

            _allocationRepository.ReleaseAllocation(cfsAllocationId, childContractEntityReference);

            _logger.LogInformation(ContractManagementCfsLoggingEvents.NewContractCreatedProcessed,
                $"END: NewContractCreated processed for {message}");

            return Task.FromResult(0);
        }
    }
}