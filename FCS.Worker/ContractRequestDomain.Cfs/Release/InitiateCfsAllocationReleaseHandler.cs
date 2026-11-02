namespace ContractRequestDomain.Cfs.Release
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Common;
    using Dto;
    using Extensions;
    using Infrastructure;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class InitiateCfsAllocationReleaseHandler : IHandleMessages<InitiateCfsAllocationReleaseCommand>
    {
        private readonly ILogger _logger;
        private readonly IAllocationReleaseService _allocationReleaseService;
        private readonly IContractCfsAllocationStorage _contractCfsAllocationStorage;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public InitiateCfsAllocationReleaseHandler(
            ILogger logger,
            IAllocationReleaseService allocationReleaseService,
            IContractCfsAllocationStorage contractCfsAllocationStorage,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _allocationReleaseService = allocationReleaseService;
            _contractCfsAllocationStorage = contractCfsAllocationStorage;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(InitiateCfsAllocationReleaseCommand message, IMessageHandlerContext context)
        {
            // TODO: cater for "message lock lost" replay of this command in subsequent development

            _logger.LogInformation(ContractRequestCfsLoggingEvents.InitiateCfsAllocationReleaseCommandReceived, 
                $"START: InitiateCfsAllocationReleaseCommand received for {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            await _allocationReleaseService.ReleaseAllocations(
                fundingType: message.FundingType,
                fundingPeriod: message.FundingPeriod,
                contractGenerated: StoreContractAndSendOnwardCommand,
                connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            _logger.LogInformation(ContractRequestCfsLoggingEvents.InitiateCfsAllocationReleaseCommandProcessed,
                $"END: InitiateCfsAllocationReleaseCommand processed for {message}");

            Task StoreContractAndSendOnwardCommand(ContractCfsAllocation contractCfsAllocation)
            {
                StoreContract(contractCfsAllocation);

                SendOptions sendOptions = new SendOptions();
                sendOptions.RouteReplyTo("ContractManagement.Cfs.CreateContract");

                return context.Send(new DocumentGenerationCommand
                {
                    CorrelationId = Guid.NewGuid().ToString(),
                    CorporateContract = contractCfsAllocation.Contract.contracts.Single().ToCorporateContract(),
                    MasterContractNumber = contractCfsAllocation.Contract.contractNumber
                }, sendOptions);
            }
        }

        private void StoreContract(ContractCfsAllocation contractCfsAllocation)
        {
            ExtendedContractType childContract = contractCfsAllocation.Contract.contracts.First();
            string storageKey = _contractCfsAllocationStorage.GetKey(childContract.contractNumber, childContract.contractVersionNumber);

            _contractCfsAllocationStorage.UploadContract(storageKey, contractCfsAllocation);
        }
    }
}
