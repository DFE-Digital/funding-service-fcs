namespace FundingAllocation.Endpoints.ReleaseGroup.Handlers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Extensions;
    using FundingAllocation.Repositories;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ReleaseQueuedFundingAllocationsForContractsHandler : IHandleMessages<ReleaseQueuedFundingAllocationsForContractsCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;

        public ReleaseQueuedFundingAllocationsForContractsHandler(IFundingAllocationRepository fundingAllocationRepository, ILogger logger)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
            _logger = logger;
        }

        public async Task Handle(ReleaseQueuedFundingAllocationsForContractsCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.ReleaseQueuedFundingAllocationsForContractsCommandReceived, $"Received ReleaseQueuedFundingAllocationsForContractsCommand for {message}");

            ISet<string> releaseGroupNames = new HashSet<string>();

            foreach (var contract in message.ContractIdentities)
            {
                var contractNumber = contract.ContractNumber;
                var releaseGroupNamesForContract =
                    await _fundingAllocationRepository.GetReleaseGroupsWithQueuedFundingAllocationsForContract(
                        contractNumber);

                releaseGroupNamesForContract.ToList().ForEach(rgName => releaseGroupNames.Add(rgName));
            }

            if (releaseGroupNames.Any())
            {
                await context.SendLocal(new FundingAllocationReleaseGroupCommand
                    {
                        ReleaseGroupNames = releaseGroupNames.ToList(),
                        OnlyQueuedFundingAllocations = true,
                        IgnoreContractIdentitiesWhenConsideringIntent = message.IgnoreContractIdentitiesWhenConsideringIntent,
                        EventSourceContractIdentities = message.ContractIdentities,
                        OverrideStatuses = message.GetOverrideStatuses()
                    });
            }

            _logger.LogInformation(LoggingId.ReleaseQueuedFundingAllocationsForContractsCommandProcessed, $"Processed ReleaseQueuedFundingAllocationsForContractsCommand for {message}, releaseGroupNames: {releaseGroupNames.ToCsv()}");
        }
    }
}
