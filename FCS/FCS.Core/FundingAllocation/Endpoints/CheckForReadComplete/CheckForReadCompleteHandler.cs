namespace FundingAllocation.Endpoints.CheckForReadComplete
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore.Model;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class CheckForReadCompleteHandler : IHandleMessages<CheckForReadCompleteCommand>
    {
        private readonly ILogger _logger;
        private readonly IFeedReadRepository _readRepository;
        private readonly IFundingIdService _fundingIdService;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly IValidationOrchestrator _validationOrchestrator;

        public CheckForReadCompleteHandler(
            ILogger logger,
            IFeedReadRepository readRepository,
            IFundingIdService fundingIdService,
            IFundingAllocationRepository fundingAllocationRepository,
            IValidationOrchestrator validationOrchestrator)
        {
            _logger = logger;
            _readRepository = readRepository;
            _fundingIdService = fundingIdService;
            _fundingAllocationRepository = fundingAllocationRepository;
            _validationOrchestrator = validationOrchestrator;
        }

        public async Task Handle(CheckForReadCompleteCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.CheckForReadCompleteCommandReceived, $"Received CheckForReadCompleteCommand for {message}");

            var readCompleteResult = await _readRepository.IsReadComplete(message.FundingAllocationId);
            if (readCompleteResult.IsComplete && await _readRepository.SetToCompleteIfNotAlready(readCompleteResult.ReadId))
            {
                var fundingIds = await _fundingIdService.GetFundingIdsForLatestVersions(readCompleteResult.ReadId);
                
                var validationResult = await _validationOrchestrator.ValidateAndProcess(fundingIds.lastestFundingIds,
                    readCompleteResult.ReadId);

                var sendOptions = new SendOptions();
                sendOptions.RouteReplyTo(CreateProvidersIfNecessaryReply.EndpointConfig.Name);

            //    await SetStatusSubStatusToParkedPendingAwaitingProvider(validationResult.createProvidersIfNecessaryCommands);

                var createProvidersIfNecessaryCommands = validationResult.createProvidersIfNecessaryCommands
                    .Select(c => context.Send(c, sendOptions));

                await Task.WhenAll(createProvidersIfNecessaryCommands);

                await _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(
                    fundingIds.supersededFundingIds, FundingAllocationStatus.Discarded,
                    FundingAllocationSubStatus.Superseded);

                await _fundingAllocationRepository.InsertOrUpdateParkingInfoLastDiscarded(
                    fundingIds.supersededFundingIds, DateTime.Now);

                var sendBatchToBeDiscardedTasks = validationResult.setBatchToDiscardedCommands
                    .Select(context.SendLocal);

                await Task.WhenAll(sendBatchToBeDiscardedTasks);

                await context.Send(new CheckForJobCompleteCommand
                {
                    ReadId = readCompleteResult.ReadId
                });
            }

            _logger.LogInformation(LoggingId.CheckForReadCompleteCommandProcessed, $"Processed CheckForReadCompleteCommand for {message}, result :{readCompleteResult}");
        }

        private async Task SetStatusSubStatusToParkedPendingAwaitingProvider(IEnumerable<CreateProvidersIfNecessaryCommand> createProvidersIfNecessaryCommands)
        {
            var providerCheckNeededFundingIds = createProvidersIfNecessaryCommands.Select(c => c.FundingId).ToList();

            await _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(providerCheckNeededFundingIds, 
                FundingAllocationStatus.ParkedPending,
                FundingAllocationSubStatus.ProviderCheck);
        }
    }
}
