namespace PaymentManagementDomain.PaymentSchedule.DeliverableAggregation
{
    extern alias IntegrationEntities;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Infrastructure;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.Common;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;

    public class AggregateDeliverablesHandler : IHandleMessages<AggregateDeliverablesCommand>
    {
        private readonly ILogger _logger;
        private readonly IAggregateDeliverablesService _aggregateDeliverablesService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly ICrmDeliverableRepository _crmDeliverableRepository;

        public AggregateDeliverablesHandler(ILogger logger,
            IAggregateDeliverablesService aggregateDeliverablesService,
            ISessionConnectionFactory sessionConnectionFactory,
            ICrmDeliverableRepository crmDeliverableRepository)
        {
            _logger = logger;
            _aggregateDeliverablesService = aggregateDeliverablesService;
            _sessionConnectionFactory = sessionConnectionFactory;
            _crmDeliverableRepository = crmDeliverableRepository;
        }

        public Task Handle(AggregateDeliverablesCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PaymentManagementLoggingEvents.AggregateDeliverablesStarted,
                $"AggregateDeliverablesCommand for {message} received");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            IReadOnlyCollection<DeliverableActual> aggregatedDeliverables = _aggregateDeliverablesService.GetAggregatedDeliverablesForAllocation(
                allocationNumber: message.AllocationNumber,
                version: message.ContractVersionNumber,
                fundingStreamPeriodCode: message.FundingStreamPeriodCode,
                connectionInfo: connectionInfo);

            _crmDeliverableRepository.UpdateDeliverablesInCrmForAllocation(allocationNumber: message.AllocationNumber,
                version: message.ContractVersionNumber,
                subVersion: message.SubVersionNumber,
                deliverableActuals: aggregatedDeliverables);

            _logger.LogInformation(
                PaymentManagementLoggingEvents.AggregateDeliverablesCompleted,
                $"AggregateDeliverablesCommand for {message} completed");

            return Task.FromResult(0);
        }
    }
}
