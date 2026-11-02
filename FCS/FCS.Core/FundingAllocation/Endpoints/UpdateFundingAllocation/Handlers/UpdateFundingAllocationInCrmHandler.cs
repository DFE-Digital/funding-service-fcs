namespace FundingAllocation.Endpoints.UpdateFundingAllocation.Handlers
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class UpdateFundingAllocationInCrmHandler : IHandleMessages<UpdateFundingAllocationInCrmCommand>
    {
        private readonly ILogger _logger;
        private readonly ICrmFundingAllocationRepository _crmFundingAllocationRepository;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;

        public UpdateFundingAllocationInCrmHandler(
            ILogger logger,
            ICrmFundingAllocationRepository crmFundingAllocationRepository,
            IFundingAllocationRepository fundingAllocationRepository)
        {
            _logger = logger;
            _crmFundingAllocationRepository = crmFundingAllocationRepository;
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task Handle(UpdateFundingAllocationInCrmCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.UpdateFundingAllocationInCrmCommandReceived, $"Processing UpdateFundingAllocationInCrmCommand - {message}");

            Guid? crmId = await _fundingAllocationRepository.GetFundingAllocationCrmId(message.FundingId);

            await _crmFundingAllocationRepository.Update(crmFundingAllocationEntityId:crmId.ToString(),
                releaseGroupId:message.ReleaseGroupId,
                serviceResponse: message.ServiceResponse);

            _logger.LogInformation(LoggingId.UpdateFundingAllocationInCrmCommandProcessed, $"Processed UpdateFundingAllocationInCrmCommand - {message}");
        }
    }
}
