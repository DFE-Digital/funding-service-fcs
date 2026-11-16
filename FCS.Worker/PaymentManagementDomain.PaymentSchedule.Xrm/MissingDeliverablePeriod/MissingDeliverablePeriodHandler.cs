namespace PaymentManagementDomain.PaymentSchedule.MissingDeliverablePeriod
{
    extern alias IntegrationEntities;
    using System.Threading.Tasks;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Infrastructure;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.Common;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

    public class MissingDeliverablePeriodHandler : IHandleMessages<AddMissingDeliverablePeriodCommand>
    {
        private readonly ILogger _logger;
        private readonly IDeliverablePaymentCommandRepository _deliverablePaymentCommandRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public MissingDeliverablePeriodHandler(
            ILogger logger,
            IDeliverablePaymentCommandRepository deliverablePaymentCommandRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _deliverablePaymentCommandRepository = deliverablePaymentCommandRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(AddMissingDeliverablePeriodCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PaymentManagementLoggingEvents.AddMissingDeliverablePeriodStarted,
                $"AddMissingDeliverablePeriodCommand for {message} received");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            await _deliverablePaymentCommandRepository.AddDeliverablePeriodIfNotPresent(
                allocationNumber: message.AllocationNumber,
                version: message.VersionNumber,
                deliverableCode: message.DeliverableCode,
                period: message.Period,
                connectionInfo: connectionInfo);

            _logger.LogInformation(
                PaymentManagementLoggingEvents.AddMissingDeliverablePeriodStarted,
                $"AddMissingDeliverablePeriodCommand for {message} completed");
        }
    }
}
