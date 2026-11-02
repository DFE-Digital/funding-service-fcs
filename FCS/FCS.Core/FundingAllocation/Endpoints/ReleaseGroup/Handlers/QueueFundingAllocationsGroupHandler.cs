namespace FundingAllocation.Endpoints.ReleaseGroup.Handlers
{
    using System.Threading.Tasks;
    using System.Linq;
    using DataStore.Model;
    using Extensions;
    using FundingAllocation.Repositories;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class QueueFundingAllocationsGroupHandler : IHandleMessages<QueueFundingAllocationsGroupCommand>
    {
        private readonly IFundingAllocationRepository _fundingAllocationRepository;
        private readonly ICrmFundingAllocationRepository _crmFundingAllocationRepository;
        private readonly ILogger _logger;
        private readonly IReleaseGroupFundingAllocationRepository _releaseGroupFundingAllocationRepository;
        private readonly IOverrideDateRepository _overrideDateRepository;
        private readonly IContractRepository _contractRepository;

        public QueueFundingAllocationsGroupHandler(IFundingAllocationRepository fundingAllocationRepository,
            ICrmFundingAllocationRepository crmFundingAllocationRepository, ILogger logger,
            IReleaseGroupFundingAllocationRepository releaseGroupFundingAllocationRepository,
            IOverrideDateRepository overrideDateRepository, IContractRepository contractRepository)
        {
            _fundingAllocationRepository = fundingAllocationRepository;
            _crmFundingAllocationRepository = crmFundingAllocationRepository;
            _logger = logger;
            _releaseGroupFundingAllocationRepository = releaseGroupFundingAllocationRepository;
            _overrideDateRepository = overrideDateRepository;
            _contractRepository = contractRepository;
        }
        
        public async Task Handle(QueueFundingAllocationsGroupCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.QueueFundingAllocationsGroupCommandReceived,
                $"QueueFundingAllocationsGroupCommand received: {message}");

            var contractNumber = message.CrmContractInfo.Number;
            var contractVersionNumber = message.CrmContractInfo.Version;
            var contractSubVersionNumber = message.CrmContractInfo.SubVersion;

            var createdContractId = await _contractRepository.CreateContractWithQueuedRelationshipOrReturnExistingId(
                contractNumber, contractVersionNumber, contractSubVersionNumber);

            await _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(
                message.FundingAllocationIds,
                FundingAllocationStatus.InRelease,
                FundingAllocationSubStatus.Queued);

            await _fundingAllocationRepository.SetContractId(message.FundingAllocationIds, createdContractId);

            var queuedOn = await _overrideDateRepository.GetDate();
            var fundingAllocationCrmIds = await _releaseGroupFundingAllocationRepository.GetFundingAllocationCrmIds(message.FundingAllocationIds);

            fundingAllocationCrmIds.ToList().ForEach(async fundingAllocationCrmId => 
                await _crmFundingAllocationRepository.SetToQueued(fundingAllocationCrmId.ToString(), contractNumber, queuedOn));

            var releaseGroupIds =
               await _releaseGroupFundingAllocationRepository.GetReleaseGroupIds(message.FundingAllocationIds);

            var sendTasks = releaseGroupIds.Select(id =>
                context.Send(CheckReleaseGroupsCanBeReleasedCommand.Create(releaseGroupId: id)));

            await Task.WhenAll(sendTasks);

            _logger.LogInformation(LoggingId.QueueFundingAllocationsGroupCommandProcessed,
                $"QueueFundingAllocationsGroupCommand processed: {message}, Release Group Ids: {releaseGroupIds.ToCsv()}");
        }
    }
}
