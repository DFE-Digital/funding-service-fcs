namespace AllocationDeliveryDomain.Endpoint.MonthEndCheck
{
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.Commands;
    using Infrastructure;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class CheckForMonthEndCompletionCommandHandler : IHandleMessages<CheckForMonthEndCompletionCommand>
    {
        private readonly ILogger _logger;
        private readonly IMonthEndService _monthEndService;
        private readonly IHeldReportedActualGroupEvaluator _heldReportedActualGroupEvaluator;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public CheckForMonthEndCompletionCommandHandler(ILogger logger, IMonthEndService monthEndService, IHeldReportedActualGroupEvaluator heldReportedActualGroupEvaluator, ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _monthEndService = monthEndService;
            _heldReportedActualGroupEvaluator = heldReportedActualGroupEvaluator;
            _sessionConnectionFactory = sessionConnectionFactory;
        }
        
        public async Task Handle(CheckForMonthEndCompletionCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.StartCheckingForMonthEndCompletion, "CheckForMonthEndCompletionCommand arrived." );

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            bool heldReportedActualGroupsReadyToBeProcessed = _heldReportedActualGroupEvaluator.AreAnyHeldReportedActualGroupsReadyToBeProcessed(connectionInfo);

            bool hasMonthEndCompleted = HasMonthEndCompleted(connectionInfo);

            if (hasMonthEndCompleted && !heldReportedActualGroupsReadyToBeProcessed)
            {
                _monthEndService.MarkMonthEndAsCompleted(connectionInfo);
                _logger.LogInformation(AllocationDeliverDomainEventLoggingId.MarkMonthEndAsCompleted, "Month-end marked as completed.");

                await context.Publish(new MonthEndCompletedEvent())
                    .ConfigureAwait(false);
            }
            else
            {
                if (hasMonthEndCompleted)
                {
                    // month end is complete and the held actuals table has data to be processed
                    await context.Send(new ReleaseHeldReportedActualsCommand())
                        .ConfigureAwait(false);
                }

                SendOptions sendOptions = new SendOptions();
                sendOptions.DelayDeliveryWith(_monthEndService.MonthEndCheckDeferralTime);
                sendOptions.RouteToThisEndpoint();

                await context.Send(message, sendOptions)
                    .ConfigureAwait(false);

                _logger.LogInformation(AllocationDeliverDomainEventLoggingId.DeferCheckForMonthEndCompletion, "Month-end in progress. Check deferred.");
            }
            
            _logger.LogInformation(AllocationDeliverDomainEventLoggingId.FinishCheckingForMonthEndCompletion, "CheckForMonthEndCompletionCommand handling ended.");
        }

        private bool HasMonthEndCompleted(ConnectionInfo connectionInfo)
        {
            return _monthEndService.HasMonthEndInitialDeferralPeriodExpired(connectionInfo) && _monthEndService.HasMonthEndServiceBusActivityCompleted();
        }
    }
}
