namespace FundingAllocation.Endpoints.CreateProvidersIfNecessaryReply
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Collections.Generic;
    using DataStore.Model;
    using System;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

    public class CreateProvidersIfNecessaryReplyHandler : IHandleMessages<CreateProvidersIfNecessaryReply>
    {
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly ILogger _logger;
        private readonly ICreateProvidersIfNecessaryNotificationService _notificationService;

        public CreateProvidersIfNecessaryReplyHandler(IFundingAllocationRepository fundingAllocationRepository,
            ILogger logger,
            ICreateProvidersIfNecessaryNotificationService notificationService)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
            _logger = logger;
            _notificationService = notificationService;
        }

        public async Task Handle(CreateProvidersIfNecessaryReply message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.CreateProvidersIfNecessaryReplyCommandReceived, $"Received CreateProvidersIfNecessaryReplyCommand for {message}");

            if (message.PassedAllValidation) 
            {
                await PutFundingAllocationIntoContractControl(message.FundingId, context);
            }
            else if (!message.AllProvidersExist)
            {
                await ParkFundingAllocation(message.FundingId, FundingAllocationSubStatus.AwaitingProvider, context);
            }
            else if (message.IsPostReadProviderNotFoundCheck)
            {
                if (message.AllProvidersExist && !message.PassedConfigValidation)
                {
                    var subStatus =  (FundingAllocationSubStatus)Enum.Parse(typeof(FundingAllocationSubStatus), message.ParkedConfigSubStatus);
                    await ParkFundingAllocation(message.FundingId, subStatus, context);

                    await _notificationService
                        .NotifySlackRegardingProviderNotFoundChangedToConfigFailure(message.FundingId);
                }
            }

            if (!message.IsPostReadProviderNotFoundCheck)
            {
                await context.Send(new CheckForJobCompleteCommand
                {
                    ReadId = message.ReadId
                });
            }
            else
            {
                await SendCheckForMissingProvidersPostReadComplete(context, message.FundingId);
            }

            _logger.LogInformation(LoggingId.CreateProvidersIfNecessaryReplyCommandProcessed, $"Processed CreateProvidersIfNecessaryReplyCommand for {message}");
        }

        private async Task PutFundingAllocationIntoContractControl(string fundingId, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.CreateProvidersIfNecessaryReplyCommandResult, $"Processing funding id {fundingId}");

            await _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(new List<string> {fundingId},
                FundingAllocationStatus.NotSet, FundingAllocationSubStatus.NotSet);

            await context.Send(new IgnoreItemsOfNoInterestCommand
            {
                FundingAllocationIds = new List<string> {fundingId}
            });
        }

        private async Task ParkFundingAllocation(string fundingId, FundingAllocationSubStatus fundingAllocationSubStatus, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.CreateProvidersIfNecessaryReplyCommandResult, $"Parking funding id {fundingId}");

            await _fundingAllocationRepository.SetFundingAllocationsParkedSubStatus(
                new List<string> {fundingId},
                fundingAllocationSubStatus);
        }

        private async Task SendCheckForMissingProvidersPostReadComplete(IMessageHandlerContext context, string fundingId)
        {
            _logger.LogInformation(LoggingId.SendCheckForMissingProvidersPostReadCompleteCommand, 
                $"Sending CheckForMissingProvidersPostReadCompleteCommand. FundingId: {fundingId}");

            await context.Send(new CheckForMissingProvidersPostReadCompleteCommand());
        }
    }
}
