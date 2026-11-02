namespace FundingAllocation.Endpoints.UpdateFundingAllocation.Handlers
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;

    public class ReinstateFundingAllocationInCrmHandler : IHandleMessages<ReinstateFundingAllocationInCrmCommand>
    {
        private readonly ILogger _logger;
        private readonly ICrmFundingAllocationRepository _crmFundingAllocationRepository;

        public ReinstateFundingAllocationInCrmHandler(ILogger logger, ICrmFundingAllocationRepository crmFundingAllocationRepository)
        {
            _logger = logger;
            _crmFundingAllocationRepository = crmFundingAllocationRepository;
        }

        public async Task Handle(ReinstateFundingAllocationInCrmCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.ReinstateFundingAllocationInCrmCommandReceived, $"Received ReinstateFundingAllocationInCrmCommand: {message}");

            await _crmFundingAllocationRepository.Update(message.FundingAllocationCrmEntityId,
                message.ReleaseGroupCrmEntityId,
                sfa_FundingAllocationServiceResponse.ReinstateAwaitingRelease);

            _logger.LogInformation(LoggingId.ReinstateFundingAllocationInCrmCommandProcessed, $"Processed ReinstateFundingAllocationInCrmCommand: {message}");
        }
    }
}