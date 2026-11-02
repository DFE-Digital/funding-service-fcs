namespace FCT.Operations.FundingConfirmationReport
{
    using System;
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Operations.Common;

    public class CreateFundingConfirmationReportHandler : IHandleMessages<CreateFundingConfirmationReportCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IFundingConfirmationReportRepository _reportRepository;
        private readonly ILAFundingConfirmationReportRepository _lareportRepository;

        public CreateFundingConfirmationReportHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IFundingConfirmationReportRepository reportRepository,
            ILAFundingConfirmationReportRepository lareportRepository)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _reportRepository = reportRepository;
            _lareportRepository = lareportRepository;
        }
     
        public async Task Handle(CreateFundingConfirmationReportCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(LoggingEventId.CreateFundingConfirmationReportForPeriodReceived, $"Received CreateFundingConfirmationReportCommand: {message}");

            var connectionInfo = _sessionConnectionFactory.GetReplicaConnection();
            var currentDate = DateTime.Now;
            var currentYear = currentDate.Year;
            var lastYear = currentYear - 1;
            var latestPeriod = $"{lastYear % 100}{currentYear % 100}"; 
            await context.SendLocal(new CreateFundingConfirmationReportForPeriodCommand(Convert.ToInt32(latestPeriod), message.Type));
            _logger.LogInformation(LoggingEventId.CreateFundingConfirmationReportForPeriodProcessed, $"Processed CreateFundingConfirmationReportCommand: {message}");
        }

    }
}
