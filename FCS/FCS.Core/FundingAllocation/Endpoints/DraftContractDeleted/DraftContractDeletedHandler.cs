namespace FundingAllocation.Endpoints.DraftContractDeleted
{
    using System.Linq;
    using System.Threading.Tasks;
    using System.Collections.Generic;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

    public class DraftContractDeletedHandler : IHandleMessages<DraftContractDeletedEvent>
    {
        private readonly ILogger _logger;
        private readonly IContractRepository _contractRepository;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;

        public DraftContractDeletedHandler(
            ILogger logger,
            IContractRepository contractRepository,
            IFundingAllocationRepository fundingAllocationRepository)
        {
            _logger = logger;
            _contractRepository = contractRepository;
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task Handle(DraftContractDeletedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.DraftContractDeletedEventReceived, $"Received DraftContractDeletedHandler DraftContractDeletedEvent for {message}");

            var fundingAllocations = await _contractRepository.GetFundingAllocationInfosInContractControl(
                message.ContractNumber,
                message.VersionNumber);

            await _fundingAllocationRepository.RemoveContractFromFundingAllocations(fundingAllocations.Select(fa => fa.FundingId));
            
            await _contractRepository.DeleteContractIfOrphaned(message.ContractNumber, message.VersionNumber,
                message.SubVersionNumber);
            
            var commands = fundingAllocations.Select(fa =>
                new ReturnToSchedulingFundingAllocationCommand(fa.FundingId, fa.CrmEntityId, sfa_FundingAllocationServiceResponse.ContractDeleted)).ToList();

            var sendTasks = commands.Select(context.Send);

            await Task.WhenAll(sendTasks);

            var releaseQueuedFundingAllocationsForContractsCommand = 
                new ReleaseQueuedFundingAllocationsForContractsCommand(new List<ContractIdentity>{
                    new ContractIdentity(message.ContractNumber, message.VersionNumber, message.SubVersionNumber)});

            releaseQueuedFundingAllocationsForContractsCommand.IgnoreContractIdentitiesWhenConsideringIntent = true;

            await context.Send(releaseQueuedFundingAllocationsForContractsCommand);

            _logger.LogInformation(LoggingId.DraftContractDeletedEventProcessed, $"Processed DraftContractDeletedHandler DraftContractDeletedEvent for {message}");
        }
    }
}