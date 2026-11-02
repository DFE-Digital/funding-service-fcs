namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunErrorEndpoint
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using BusinessLogic;
    using Common;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ProcessPaymentRunErrorHandler : IHandleMessages<ProcessPaymentRunErrorCommand> 
    {
        public IDataAccessManager DataManager { get; set; }

        public ILogger Logger { get; set; }

        public ISessionConnectionFactory SessionConnectionFactory { get; set; }

        public Task Handle(ProcessPaymentRunErrorCommand message, IMessageHandlerContext context)
        {
            ConnectionInfo connectionInfo = SessionConnectionFactory.GetConnection(context);

            string fundingStreamPeriodCode = !string.IsNullOrEmpty(message.FundingStreamPeriodCode)
                ? message.FundingStreamPeriodCode
                : DataManager.GetFundingStreamPeriodCodeFromShortCode(
                    message.FundingStreamShortCode,
                    message.FundingStreamPeriodStartDate,
                    message.FundingStreamPeriodEndDate,
                    connectionInfo);

            var calendarPeriod = DataManager.GetCalendarPeriodForPaymentTimetableFspAndCensusEndDate(
                fundingStreamPeriodCode,
                message.CensusEndDate,
                connectionInfo);

            DataManager.UpdateTimetableStatusForFailedPaymentRun(
                fundingStreamPeriodCode,
                calendarPeriod,
                connectionInfo);

            Logger.LogError(
                PaymentGenerationDomainLoggingEventId.PaymentGenerationError,
                "The payment run failed for FundingStreamShortCode: {0}, Calendar Period:{1} ,{2}{3}",
                message.FundingStreamShortCode,
                calendarPeriod,
                Environment.NewLine,
                message.FailureDescription);

            return Task.CompletedTask;
        }
    }
}
