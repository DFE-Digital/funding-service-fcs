namespace FundingAllocation.Endpoints.CreateFundingAllocationInCrm
{
    using System;
    using System.Threading.Tasks;
    using Repositories;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CreateFundingAllocationInCrmHandler : IHandleMessages<CreateFundingAllocationInCrmCommand>
    {
        private readonly ILogger _logger;
        private readonly ICrmFundingAllocationRepository _crmFundingAllocationRepository;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly IProcessedMessageRepository _processedMessageRepository;
        private readonly IReleaseGroupService _releaseGroupService;

        public CreateFundingAllocationInCrmHandler(
            ILogger logger,
            ICrmFundingAllocationRepository crmFundingAllocationRepository,
            IFundingAllocationRepository fundingAllocationRepository,
            IProcessedMessageRepository processedMessageRepository,
            IReleaseGroupService releaseGroupService)
        {
            _logger = logger;
            _crmFundingAllocationRepository = crmFundingAllocationRepository;
            _fundingAllocationRepository = fundingAllocationRepository;
            _processedMessageRepository = processedMessageRepository;
            _releaseGroupService = releaseGroupService;
        }

        public async Task Handle(CreateFundingAllocationInCrmCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.StartCreateFundingAllocationInCrmCommand, $"Received CreateFundingAllocationInCrmCommand for {message}");

            await _processedMessageRepository.Deduplicate(
                context.MessageId, EndpointConfig.Name, message.GetType().Name, message.FundingAllocation.FundingId);

            var foreignKeys = await _crmFundingAllocationRepository.GetForeignKeys(message.FundingAllocation);
            var fundingAllocation = message.FundingAllocation;

            var releaseGroupId = await _releaseGroupService.GetOrCreateReleaseGroup(
                fcsFundingType: fundingAllocation.FundingType,
                fcsPeriod: fundingAllocation.Period,
                fspGroupCode: fundingAllocation.FSPGroup,
                fcsContractType: fundingAllocation.ContractType,
                getCrmFundingAllocationFKs: () => Task.FromResult(foreignKeys));

            foreignKeys.ReleaseGroupId = releaseGroupId.CrmId.ToString();

            _logger.LogInformation(LoggingId.StartCreateFundingAllocationInCrmCommand,
                $"CreateFundingAllocationInCrmHandler for {message} - foreignKeys.ReleaseGroupId: {foreignKeys.ReleaseGroupId}");
            Guid crmEntityId = await _crmFundingAllocationRepository.AddFundingAllocation(fundingAllocation, foreignKeys);

            await _fundingAllocationRepository.AddCrmEntityIdToFundingAllocation(fundingAllocation.FundingId, crmEntityId);

            await context.Send(new UpdateFundingAllocationWithReleaseGroupCommand
            {
                FundingId = fundingAllocation.FundingId,
                ReleaseGroupId = releaseGroupId.PaaSId
            });

            await context.Send(new CheckForJobCompleteCommand
            {
                ReadId = message.ReadId
            });

            _logger.LogInformation(LoggingId.EndCreateFundingAllocationInCrmCommand, $"Processed CreateFundingAllocationInCrmCommand for {message}");
        }
    }
}
