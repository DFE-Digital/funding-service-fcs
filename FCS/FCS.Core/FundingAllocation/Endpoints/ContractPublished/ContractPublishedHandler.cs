namespace FundingAllocation.Endpoints.ContractPublished
{
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ContractPublishedHandler : IHandleMessages<ContractPublishedEvent>
    {
        private readonly ILogger _logger;
        private readonly IContractRepository _contractRepository;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;

        public ContractPublishedHandler(ILogger logger, IContractRepository contractRepository, IFundingAllocationRepository fundingAllocationRepository)
        {
            _logger = logger;
            _contractRepository = contractRepository;
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task Handle(ContractPublishedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.ContractPublishedEventReceived, $"Received ContractPublishedEvent for {message}");
            foreach (var childContractIdentity in message.ChildContractIdentities)
            {
                var fundingInfos =
                    await _contractRepository.GetFundingAllocationInfosInContractControl(childContractIdentity.ContractNumber, childContractIdentity.VersionNumber);

                var fundingIds = fundingInfos.Select(fi => fi.FundingId).ToList();

                if (fundingIds.Any())
                {
                    await _fundingAllocationRepository.SetFundingAllocationsToPublished(fundingIds);
                }
            }

            _logger.LogInformation(LoggingId.ContractPublishedEventProcessed, $"Processed ContractPublishedEvent for {message}");
        }
    }
}
