namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentBatchEndpoint
{
    using System.Linq;
    using System.Threading.Tasks;
    using Common;
    using Common.Commands;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using BusinessLogic;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class InitiatePaymentBatchHandler : IHandleMessages<InitiatePaymentBatchCommand>
    {
        private readonly ILogger _logger;
        private readonly IDate _date;
        private readonly IDataAccessManager _dataManager;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public InitiatePaymentBatchHandler(ILogger logger, IDate date, IDataAccessManager dataManager, ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _date = date;
            _dataManager = dataManager;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(InitiatePaymentBatchCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(PaymentGenerationDomainLoggingEventId.InitiatePaymentBatchStart, "Initiate Payment Batch Started");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var scheduleItems = _dataManager.GetPaymentTimetableByDateAndStatus(_date.GetCalculationDate(), PaymentRunStatus.NotStarted, connectionInfo);

            foreach (var item in scheduleItems.ToList())
            {
                await context.Send(new InitiatePaymentRunCommand { PaymentTimetable = item })
                    .ConfigureAwait(false);
            }

            _logger.LogInformation(PaymentGenerationDomainLoggingEventId.InitiatePaymentBatchEnd, "Initiate Payment Batch Ended");
        }
    }
}
