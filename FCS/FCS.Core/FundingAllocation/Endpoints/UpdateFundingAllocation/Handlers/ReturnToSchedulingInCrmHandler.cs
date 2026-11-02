namespace FundingAllocation.Endpoints.UpdateFundingAllocation.Handlers
{
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ReturnToSchedulingInCrmHandler : IHandleMessages<ReturnToSchedulingInCrmCommand>
    {
        private readonly ILogger _logger;
        private readonly ICrmUpdateFundingAllocationRepository _crmReturnToSchedulingRepository;

        public ReturnToSchedulingInCrmHandler(
            ILogger logger,
            ICrmUpdateFundingAllocationRepository crmReturnToSchedulingRepository)
        {
            _logger = logger;
            _crmReturnToSchedulingRepository = crmReturnToSchedulingRepository;
        }

        public async Task Handle(ReturnToSchedulingInCrmCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingId.ReturnToSchedulingInCrmCommandReceived, $"Received ReturnToSchedulingInCrmCommand: {message}");

            await _crmReturnToSchedulingRepository.ReturnToScheduling(crmFundingAllocationEntityId: message.CrmEntityId,
                serviceResponse: message.ServiceResponse);

            _logger.LogInformation(LoggingId.ReturnToSchedulingInCrmCommandProcessed, $"Processed ReturnToSchedulingInCrmCommand: {message}");
        }
    }
}
