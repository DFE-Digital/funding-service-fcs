namespace FundingAllocation.Endpoints.GetFundingAllocationsPage
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dto;
    using Extensions;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class GetFundingAllocationsPageHandler : IHandleMessages<GetFundingAllocationsPageCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingNotificationApi _fundingNotificationApi;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly IFundingAllocationPageControlRepository _fundingAllocationPageControlRepository;

        public GetFundingAllocationsPageHandler(
            ILogger logger,
            IFundingNotificationApi fundingNotificationApi,
            IFundingAllocationRepository fundingAllocationRepository,
            IFundingAllocationPageControlRepository fundingAllocationPageControlRepository)
        {
            _logger = logger;
            _fundingNotificationApi = fundingNotificationApi;
            _fundingAllocationRepository = fundingAllocationRepository;
            _fundingAllocationPageControlRepository = fundingAllocationPageControlRepository;
        }

        public async Task Handle(GetFundingAllocationsPageCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.StartGetFundingAllocationsPageCommand, $"Processing GetFundingAllocationsPageCommand for {message}");

            IReadOnlyCollection<AtomItem> atomItems = message.AtomItems;
            if (atomItems.IsEmpty())
            {
                atomItems = await _fundingNotificationApi.GetPage(message.PageNumber);
            }
            
            var existingIdsForPage = await _fundingAllocationRepository.GetExistingIdsForPage(atomItems.Select(a => a.FundingId).ToList());

            var newAtomItems = atomItems
                .Where(ai => !existingIdsForPage.Contains(ai.FundingId))
                .ToList();

            var newFundingAllocations = newAtomItems
                .Select(ai => ai.ToFundingAllocation(message.ReadId))
                .ToList();

            await _fundingAllocationRepository.CreateFundingAllocations(newFundingAllocations);

            var sendCommandTasks = newAtomItems
                .Select(ai => new EnrichFundingAllocationCommand { FundingAllocation = ai.ToFundingAllocationDto() })
                .Select(context.Send)
                .ToList();

            await Task.WhenAll(sendCommandTasks);

            await _fundingAllocationPageControlRepository.SetLatestBookmark(message.ReadId, message.PageNumber, atomItems.Last().FundingId);

            _logger.LogInformation(LoggingId.EndGetFundingAllocationsPageCommand, $"Processed GetFundingAllocationsPageCommand for {message}");
        }
    }
}
