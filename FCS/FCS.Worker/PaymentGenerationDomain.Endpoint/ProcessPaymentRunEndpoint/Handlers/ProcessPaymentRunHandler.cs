namespace PaymentGenerationDomain.Endpoint.ProcessPaymentRunEndpoint.Handlers
{
    using System.Linq;
    using System.Threading.Tasks;
    using BusinessLogic.Services;
    using Common;
    using Common.Commands;
    using Integration.DataStore.Model;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using CorporateSchema = SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    public class ProcessPaymentRunHandler : IHandleMessages<ProcessPaymentRunCommand>
    {
        private readonly ILogger _logger;
        private ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IPaymentRunService _paymentRunService;

        public ProcessPaymentRunHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IPaymentRunService paymentRunService)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _paymentRunService = paymentRunService;
        }

        public async Task Handle(ProcessPaymentRunCommand message, IMessageHandlerContext context)
        {
            PaymentTimetable paymentTimetable = message.PaymentTimetable;

            _logger.LogInformation(PaymentGenerationDomainLoggingEventId.ProcessPaymentHandleStarted, $"ProcessPaymentRunCommand processing started for {paymentTimetable}");

            _logger.LogInformation(PaymentGenerationDomainLoggingEventId.DiagnosticInfo, $"context.SynchronizedStorageSession = {context.SynchronizedStorageSession}");

            await _paymentRunService.PublishPaymentPeriod(
                paymentTimetable,
                PaymentPeriodPublished,
                PaymentPeriodValidationFailed,
                _sessionConnectionFactory.GetConnection(context));

            _logger.LogInformation(PaymentGenerationDomainLoggingEventId.ProcessPaymentHandleEnded, $"ProcessPaymentRunCommand processing ended for {paymentTimetable}");

            async Task PaymentPeriodPublished(CorporateSchema.PaymentPeriod period, int feedId)
            {
                _logger.LogInformation(PaymentGenerationDomainLoggingEventId.SendingProcessPaymentRunCompleteCommand, $"Sending ProcessPaymentRunCompleteCommand for {paymentTimetable}");

                await context.Send(new ProcessPaymentRunCompleteCommand
                {
                    CensusEndDate = paymentTimetable.CensusEndDate,
                    FundingStreamPeriodCode = paymentTimetable.FundingStreamPeriodCode,
                    FundingStreamPeriodStartDate = paymentTimetable.PeriodStartDate,
                    FundingStreamPeriodEndDate = paymentTimetable.PeriodEndDate,
                    LinkCode = paymentTimetable.LinkCodeSuffix
                }).ConfigureAwait(continueOnCapturedContext: false);
            }

            Task PaymentPeriodValidationFailed(string errors)
            {
                _logger.LogInformation(PaymentGenerationDomainLoggingEventId.SendingProcessPaymentRunErrorCommand, $"Sending ProcessPaymentRunErrorCommand for {paymentTimetable}");

                return context.Send(new ProcessPaymentRunErrorCommand
                {
                    CensusEndDate = paymentTimetable.CensusEndDate,
                    FundingStreamPeriodCode = paymentTimetable.FundingStreamPeriodCode,
                    FailureDescription = errors,
                    FundingStreamPeriodStartDate = paymentTimetable.PeriodStartDate,
                    FundingStreamPeriodEndDate = paymentTimetable.PeriodEndDate
                });
            }
        }
    }
}
