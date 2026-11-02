namespace FundingAllocation.Endpoints.IgnoreItemsOfNoInterest
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using CreateProvidersIfNecessaryReply.Services;
    using DataStore.Model;
    using Extensions;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class IgnoreItemsOfNoInterestHandler : IHandleMessages<IgnoreItemsOfNoInterestCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingLineFilterService _fundingLineFilterService;
        private readonly ICfsToFcsCodeMappingService _cfsToFcsCodeMappingService;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;

        public IgnoreItemsOfNoInterestHandler(
            ILogger logger,
            IFundingLineFilterService fundingLineFilterService,
            ICfsToFcsCodeMappingService cfsToFcsCodeMappingService, IFundingAllocationRepository fundingAllocationRepository)
        {
            _logger = logger;
            _fundingLineFilterService = fundingLineFilterService;
            _cfsToFcsCodeMappingService = cfsToFcsCodeMappingService;
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task Handle(IgnoreItemsOfNoInterestCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.IgnoreItemsOfNoInterestCommandReceived, $"Received IgnoreItemsOfNoInterestCommand for {message}");

            var fundingAllocations =
                await _fundingAllocationRepository.GetFundingAllocations(message.FundingAllocationIds);

            var commands = new List<CreateFundingAllocationInCrmCommand>();
            foreach (var fundingAllocation in fundingAllocations)
            {
                await _fundingLineFilterService.FilterOutZeroValuedOfNoInterestLines(fundingAllocation);

                if (fundingAllocation.HasLinesOfInterest)
                {
                    var contractItemsMapping = await _cfsToFcsCodeMappingService.GetContractItemsMappingResult(
                        fundingAllocation.GetContractItemsMappingInput());

                    var fundingAllocationDto = fundingAllocation.ToDto(contractItemsMapping);

                    commands.Add(new CreateFundingAllocationInCrmCommand
                    {
                        FundingAllocation = fundingAllocationDto,
                        ReadId = fundingAllocation.ReadId
                    });
                }
            }

            var fundingIdsWithNoLinesOfInterest = fundingAllocations.Where(fa => !fa.HasLinesOfInterest)
                .Select(fa => fa.FundingId)
                .ToList();

            await fundingIdsWithNoLinesOfInterest.IfAnyThenOneAtATimeAsync(
                ids => _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(fundingIdsWithNoLinesOfInterest,
                    FundingAllocationStatus.Discarded, FundingAllocationSubStatus.NonMaterial),

                ids => _fundingAllocationRepository.InsertOrUpdateParkingInfoLastDiscarded(fundingIdsWithNoLinesOfInterest, DateTime.Now)
            );

            var sendTasks = commands.Select(context.Send);

            await Task.WhenAll(sendTasks);
            
            // if we aren't putting anything in CRM we still need to check for job complete
            if (commands.IsEmpty())
            {
                await context.Send(new CheckForJobCompleteCommand
                {
                    ReadId = fundingAllocations.Select(fa => fa.ReadId).FirstOrDefault()
                });
            }

            _logger.LogInformation(LoggingId.IgnoreItemsOfNoInterestCommandProcessed, $"Processed IgnoreItemsOfNoInterestCommand for {message}");
        }
    }
}
