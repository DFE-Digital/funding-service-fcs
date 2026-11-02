namespace FundingAllocation.Endpoints.ContractWithdrawn
{
    using System.Linq;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Events;
    using System.Threading.Tasks;
    using Extensions;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

    public class ContractWithdrawnHandler : IHandleMessages<ContractWithdrawnEvent>
    {
        private readonly ILogger _logger;
        private readonly IContractRepository _repository;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;

        public ContractWithdrawnHandler(ILogger logger, IContractRepository repository, IFundingAllocationRepository fundingAllocationRepository)
        {
            _logger = logger;
            _repository = repository;
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task Handle(ContractWithdrawnEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.ContractWithdrawnEventReceived, $"Received ContractWithdrawnHandler ContractWithdrawnEvent for {message}");

            int numCommandsSent = 0;
            foreach (var childContract in message.CorporateContract.contracts)
            {
                var fundingAllocations = await _repository.GetFundingAllocationInfosInContractControl(
                    childContract.contractNumber,
                    childContract.contractVersionNumber);

                var commands = fundingAllocations.Select(fa =>
                        new ReturnToSchedulingFundingAllocationCommand(
                            fundingId: fa.FundingId,
                            crmEntityId: fa.CrmEntityId,
                            sfa_FundingAllocationServiceResponse.ContractWithdrawn))
                    .ToList();

                var sendTasks = commands.Select(context.Send).ToList();

                await Task.WhenAll(sendTasks);
                numCommandsSent += sendTasks.Count;

                var fundingIds = fundingAllocations.Select(fi => fi.FundingId).ToList();

                await fundingIds.IfAny(_fundingAllocationRepository.SetFundingAllocationsToPublished);
            }

            var contractIdentities = message.CorporateContract.contracts.Select(c =>
                new ContractIdentity(c.contractNumber, c.contractVersionNumber, c.contractSubVersionNumber)).ToList();

            await context.Send(new ReleaseQueuedFundingAllocationsForContractsCommand(contractIdentities));

            _logger.LogInformation(LoggingId.ContractWithdrawnEventProcessed, $"Processed ContractWithdrawnHandler ContractWithdrawnEvent for {message} - commands sent: {numCommandsSent}");
        }
    }
}