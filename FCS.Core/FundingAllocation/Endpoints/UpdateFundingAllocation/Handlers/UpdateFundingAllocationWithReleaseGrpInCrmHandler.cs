namespace FundingAllocation.Endpoints.UpdateFundingAllocation.Handlers
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UpdateFundingAllocationWithReleaseGrpInCrmHandler : IHandleMessages<UpdateFundingAllocationWithReleaseGrpInCrmCommand>
    {
        private readonly ILogger _logger;
        private readonly ICrmFundingAllocationRepository _crmFundingAllocationRepository;

        public UpdateFundingAllocationWithReleaseGrpInCrmHandler(ILogger logger, ICrmFundingAllocationRepository crmFundingAllocationRepository)
        {
            _logger = logger;
            _crmFundingAllocationRepository = crmFundingAllocationRepository;
        }

        public async Task Handle(UpdateFundingAllocationWithReleaseGrpInCrmCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.HoldFundingAllocationCommandReceived, $"Received UpdateFundingAllocationWithReleaseGrpInCrmCommand - {message}");

            await _crmFundingAllocationRepository.Update(message.CrmFundingId, message.CrmReleaseGrpId,
                sfa_FundingAllocationServiceResponse.ReleasefromHold);

            _logger.LogInformation(LoggingId.HoldFundingAllocationCommandProcessed, $"Processed UpdateFundingAllocationWithReleaseGrpInCrmCommand - {message}");
        }
    }
}
