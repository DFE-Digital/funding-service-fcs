namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.DTOs;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Repositories;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Services;
    using SFA.FCT.PaymentManagementDomain.Common;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using Xrm.Infrastructure;

    public class PaymentAggregatedHandler : IHandleMessages<AllocationPaymentsChangedOnAggregationEvent>
    {
        // retry delayed delivery every 30 seconds for 20 minutes when awaiting CDP creation in CRM
        private const int DeferralSeconds = 30;
        private const int MaxDeferrals = 40;

        private readonly ILogger _logger;
        private readonly IContractDeliverablePeriodRepository _contractDeliverablePeriodRepository;
        private readonly IContractDeliverablePeriodPresenceChecker _contractDeliverablePeriodPresenceChecker;
        private readonly IPaymentAggregationXrmManager _paymentAggregationXrmManager;
        private readonly IProcessedMessageRepository _processedMessageRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public PaymentAggregatedHandler(
            ILogger logger,
            IContractDeliverablePeriodRepository contractDeliverablePeriodRepository,
            IContractDeliverablePeriodPresenceChecker contractDeliverablePeriodPresenceChecker,
            IPaymentAggregationXrmManager paymentAggregationXrmManager,
            IProcessedMessageRepository processedMessageRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _contractDeliverablePeriodRepository = contractDeliverablePeriodRepository;
            _contractDeliverablePeriodPresenceChecker = contractDeliverablePeriodPresenceChecker;
            _paymentAggregationXrmManager = paymentAggregationXrmManager;
            _processedMessageRepository = processedMessageRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(AllocationPaymentsChangedOnAggregationEvent message, IMessageHandlerContext context)
        {
            if (message?.Allocation?.AllocationPeriods == null || !message.Allocation.AllocationPeriods.Any())
            {
                _logger.LogError(PaymentManagementLoggingEvents.PaymentAggregationXrmServiceNoMessageToProcess,
                    "Payment Aggregation XRM: No Allocation or AllocationPeriods in message.");
                return;
            }

            _logger.LogInformation(PaymentManagementLoggingEvents.PaymentAggregationXrmServiceStart,
                $"Payment Aggregation XRM - START: PaymentAggregationsHaveChangedEvent received for {message}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);
            if (_processedMessageRepository.Add(context.MessageId, connectionInfo))
            {
                IReadOnlyCollection<ContractDeliverablePeriodInfo> existingContractDeliverablePeriods =
                    _contractDeliverablePeriodRepository.GetContractDeliverablePeriodsForAllocation(message.Allocation.AllocationNumber);

                if (_contractDeliverablePeriodPresenceChecker.AreAllRequiredContractDeliverablePeriodsPresent(message.Allocation, existingContractDeliverablePeriods))
                {
                    _paymentAggregationXrmManager.SavePaymentAggregation(message.Allocation, existingContractDeliverablePeriods);
                }
                else
                {
                    await DeferMessage(message, context)
                        .ConfigureAwait(false);

                    _logger.LogInformation(PaymentManagementLoggingEvents.PaymentAggregationXrmMessageDeferred,
                        $"Payment Aggregation XRM: All Contract Deliverable Periods not present for {message}, PaymentAggregatedEvent deferred {DeferralSeconds} seconds for retry attempt {message.TimesMessageDeferred} of {MaxDeferrals}.");
                }
            }
            else
            {
                _logger.LogInformation(PaymentManagementLoggingEvents.PaymentAggregationXrmServiceAlreadyLocked,
                    $"Payment Aggregation XRM: Already processed this message {message}");
            }
            
            _logger.LogInformation(PaymentManagementLoggingEvents.PaymentAggregationXrmServiceEnd,
                $"Payment Aggregation XRM - END: PaymentAggregationsHaveChangedEvent processed for {message}");
        }

        private static async Task DeferMessage(AllocationPaymentsChangedOnAggregationEvent message, IMessageHandlerContext context)
        {
            if (message.TimesMessageDeferred >= MaxDeferrals)
            {
                throw new ArgumentOutOfRangeException($"Payment Aggregation XRM: The PaymentAggregationsHaveChangedEvent for Allocation {message.Allocation.AllocationNumber} has been deferred the maximum of {MaxDeferrals} deferrals.");
            }

            message.TimesMessageDeferred++;

            SendOptions sendOptions = new SendOptions();
            sendOptions.DelayDeliveryWith(TimeSpan.FromSeconds(DeferralSeconds));
            sendOptions.RouteToThisEndpoint();
            sendOptions.DoNotEnforceBestPractices();

            await context.Send(message, sendOptions)
                .ConfigureAwait(false);
        }
    }
}