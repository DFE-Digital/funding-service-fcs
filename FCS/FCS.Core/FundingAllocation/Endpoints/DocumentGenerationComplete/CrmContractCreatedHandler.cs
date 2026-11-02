namespace FundingAllocation.Endpoints.DocumentGenerationComplete
{
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore.Model;
    using FundingAllocation.Repositories;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using IContractRepository = Repositories.IContractRepository;

    public class CrmContractCreatedHandler : IHandleMessages<NewContractCreated>, IHandleMessages<ContractAmended>
    {
        private readonly ILogger _logger;
        private readonly ICrmFundingAllocationCommandRepository _crmFundingAllocationCommandRepository;
        private readonly IContractRepository _contractRepository;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;

        public CrmContractCreatedHandler(
            ILogger logger,
            ICrmFundingAllocationCommandRepository crmFundingAllocationCommandRepository,
            IContractRepository contractRepository,
            IFundingAllocationRepository fundingAllocationRepository)
        {
            _logger = logger;
            _crmFundingAllocationCommandRepository = crmFundingAllocationCommandRepository;
            _contractRepository = contractRepository;
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task Handle(NewContractCreated message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.NewContractCreatedReceived, $"Processing NewContractCreated: {message}");

            await HandleCrmContractVersionCreated(contractNumber: message.ChildContractNumber,
                version: message.ChildContractVersionNumber,
                subVersion: message.ChildContractSubVersionNumber,
                context);

            _logger.LogInformation(LoggingId.NewContractCreatedProcessed, $"Processed NewContractCreated: {message}");
        }

        public async Task Handle(ContractAmended message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.ContractAmendedReceived, $"Processing ContractAmended: {message}");

            await HandleCrmContractVersionCreated(contractNumber: message.ContractNumber,
                version: message.ContractVersionNumber,
                subVersion: message.ContractSubVersionNumber,
                context);

            _logger.LogInformation(LoggingId.ContractAmendedProcessed, $"Processed ContractAmended: {message}");
        }

        private async Task HandleCrmContractVersionCreated(string contractNumber, int version, int subVersion, IMessageHandlerContext context)
        {
            await _contractRepository.SetContractCreatedInCrmFlag(
                contractNumber: contractNumber,
                version: version,
                subVersion: subVersion);

            var fundingAllocationIdsForContract = await _contractRepository.GetFundingAllocationIdsForContract(
                contractNumber: contractNumber,
                version: version,
                subVersion: subVersion);

            // the funding allocations may have been queued so set them to null just in case
            await _fundingAllocationRepository.SetFundingAllocationStatusSubStatus(fundingAllocationIdsForContract,
                FundingAllocationStatus.NotSet, FundingAllocationSubStatus.NotSet);

            var crmUpdateTasks = fundingAllocationIdsForContract.Select(fundingAllocationId => _crmFundingAllocationCommandRepository.UpdateFundingAllocation(
                fundingId: fundingAllocationId,
                contractNumber: contractNumber,
                contractVersionNumber: version,
                sfa_FundingAllocationServiceResponse.Released));

            var sendTask = context.Send( CheckReleaseGroupsCanBeReleasedCommand.Create(fundingAllocationIds: fundingAllocationIdsForContract.ToArray()));
            
            await Task.WhenAll(crmUpdateTasks.Concat(new[] { sendTask }));
        }
    }
}
