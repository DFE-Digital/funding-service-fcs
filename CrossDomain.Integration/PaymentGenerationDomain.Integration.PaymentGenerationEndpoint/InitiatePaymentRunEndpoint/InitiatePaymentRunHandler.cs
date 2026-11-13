namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.InitiatePaymentRunEndpoint
{
    extern alias Entities;
    using System.Threading.Tasks;
    using BusinessLogic;
    using Common;
    using Common.Commands;
    using Infrastructure;
    using NServiceBus;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class InitiatePaymentRunHandler : IHandleMessages<InitiatePaymentRunCommand>
    {
        public IDataAccessManager DataManager { get; set; }

        public ILogger Logger { get; set; }

        public ISessionConnectionFactory SessionConnectionFactory { get; set; }

        public async Task Handle(InitiatePaymentRunCommand message, IMessageHandlerContext context)
        {
            Logger.LogInformation(
                PaymentGenerationDomainLoggingEventId.InitiatePaymentRunStart,
                "Payment Run Started for funding stream period : {0}, Calendar Period : {1} ", 
                message.PaymentTimetable.FundingStreamPeriodCode, 
                message.PaymentTimetable.CalendarPeriod);

            ConnectionInfo connectionInfo = SessionConnectionFactory.GetConnection(context);
           
            DataManager.UpdateTimetableStatusForPaymentRun(
                message.PaymentTimetable.FundingStreamPeriodCode,
                message.PaymentTimetable.CalendarPeriod,
                connectionInfo);

            var paymentCommand = new ProcessPaymentRunCommand()
            {
                PaymentTimetable = message.PaymentTimetable
            };

            await context.Send(paymentCommand)
                .ConfigureAwait(false);

            Logger.LogInformation(
                PaymentGenerationDomainLoggingEventId.InitiatePaymentRunEnd,
                "Payment Run Ended for funding stream period : {0}, Calendar Period : {1} ", 
                message.PaymentTimetable.FundingStreamPeriodCode, 
                message.PaymentTimetable.CalendarPeriod);
        }
    }
}
