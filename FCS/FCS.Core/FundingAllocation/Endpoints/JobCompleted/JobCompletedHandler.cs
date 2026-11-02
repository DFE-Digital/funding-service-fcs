namespace FundingAllocation.Endpoints.JobCompleted
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore.Model;
    using Extensions;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class JobCompletedHandler : IHandleMessages<JobCompletedCommand>
    {
        private readonly IJobCompleteRepository _jobCompleteRepository;
        private readonly IFundingIdService _fundingIdService;
        private readonly IValidationOrchestrator _validationOrchestrator;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly ILogger _logger;

        public JobCompletedHandler(
            IJobCompleteRepository jobCompleteRepository,
            IFundingIdService fundingIdService,
            IValidationOrchestrator validationOrchestrator,
            ILogger logger,
            IFundingAllocationRepository fundingAllocationRepository)
        {
            _jobCompleteRepository = jobCompleteRepository;
            _fundingIdService = fundingIdService;
            _validationOrchestrator = validationOrchestrator;
            _logger = logger;
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task Handle(JobCompletedCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.JobCompletedCommandReceived, $"Received JobCompletedCommand {message}");

            await _jobCompleteRepository.SetJobComplete(message.ReadId);
            _logger.LogInformation(LoggingId.JobCompletedCommandReceived, $"Received JobCompletedCommand {message} - after set job");
            var fundingIdsFoundToBeSuperseded = await _fundingIdService.GetProviderNotFoundToBeSuperseded();
            await _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(
                fundingIdsFoundToBeSuperseded, FundingAllocationStatus.Discarded,
                FundingAllocationSubStatus.Superseded);
            _logger.LogInformation(LoggingId.JobCompletedCommandReceived, $"Received JobCompletedCommand {message} - after set status");

            await _fundingAllocationRepository.InsertOrUpdateParkingInfoLastDiscarded(fundingIdsFoundToBeSuperseded, DateTime.Now);

            _logger.LogInformation(LoggingId.JobCompletedCommandReceived, $"Received JobCompletedCommand {message} - after parking info");
            var providerNotFoundFundingIds = await _fundingAllocationRepository.GetAllFundingIdsAwaitingProviderNotInCurrentRead(message.ReadId);

            var createProvidersIfNecessary = await _validationOrchestrator.ValidateAndProcessProviderNotFound(providerNotFoundFundingIds);

            var sendOptions = new SendOptions();
            sendOptions.RouteReplyTo(CreateProvidersIfNecessaryReply.EndpointConfig.Name);

            await SetStatusSubStatusToParkedPendingAwaitingProvider(createProvidersIfNecessary);
            
            var createProvidersIfNecessaryCommands = createProvidersIfNecessary
                .Select(c => context.Send(c, sendOptions)).ToList();
            if (createProvidersIfNecessaryCommands.IsEmpty())
            {
                await context.Send(new CreateFundingAllocationExtractCommand());
            }

            await Task.WhenAll(createProvidersIfNecessaryCommands);

            _logger.LogInformation(LoggingId.JobCompletedCommandProcessed, $"Processed JobCompletedCommand {message}");
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
