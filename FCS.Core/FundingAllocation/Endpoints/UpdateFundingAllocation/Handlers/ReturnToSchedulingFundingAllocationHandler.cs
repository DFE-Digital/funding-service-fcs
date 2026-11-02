namespace FundingAllocation.Endpoints.UpdateFundingAllocation.Handlers
{
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ReturnToSchedulingFundingAllocationHandler : IHandleMessages<ReturnToSchedulingFundingAllocationCommand>
    {
        private readonly ILogger _logger;
        private readonly IFundingAllocationRepository _fundingAllocationRepository;

        public ReturnToSchedulingFundingAllocationHandler(
            ILogger logger,
            IFundingAllocationRepository fundingAllocationRepository)
        {
            _logger = logger;
            _fundingAllocationRepository = fundingAllocationRepository;
        }

        public async Task Handle(ReturnToSchedulingFundingAllocationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.ReturnToSchedulingFundingAllocationCommandReceived, $"Received ReturnToSchedulingFundingAllocationCommand - {message}");

            bool isInReleaseGroup = await _fundingAllocationRepository.IsFundingAllocationInReleaseGroup(message.FundingId);

            if (isInReleaseGroup)
            {
                await _fundingAllocationRepository.SetToReturnedToScheduling(message.FundingId);

                await context.SendLocal(new ReturnToSchedulingInCrmCommand(crmEntityId: message.CrmEntityId, serviceResponse: message.ServiceResponse));
            }

            _logger.LogInformation(LoggingId.ReturnToSchedulingFundingAllocationCommandProcessed, $"Processed ReturnToSchedulingFundingAllocationCommand - {message}, was in release grp: {isInReleaseGroup}");
        }
    }
}