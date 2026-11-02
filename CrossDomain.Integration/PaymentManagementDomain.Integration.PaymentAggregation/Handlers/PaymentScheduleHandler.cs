namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Handlers
{
    using Common;
    using CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;
    using Services;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Entities.Data;
    using Infrastructure;

    public class PaymentScheduleHandler : IHandleMessages<PaymentScheduleEvent>
    {
        private readonly ILogger _logger;
        private readonly IPaymentAggregationService _paymentAggregationService;
        private readonly IPayCalcPolicyQueryRepository _payCalcPolicyQueryRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public PaymentScheduleHandler(
            ILogger logger,
            IPaymentAggregationService paymentAggregationService,
            IPayCalcPolicyQueryRepository payCalcPolicyQueryRepository, ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _paymentAggregationService = paymentAggregationService;
            _payCalcPolicyQueryRepository = payCalcPolicyQueryRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(PaymentScheduleEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PaymentManagementLoggingEvents.PaymentsAggregationHandlerStart,
                "Payment Aggregation - START: Payment Schedule Event for Contract Allocation Number {0} received",
                message.PaymentScheduleAllocation.AllocationNumber);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            PolicyFundingStreamPeriod fundingStreamPeriod = _payCalcPolicyQueryRepository.GetFundingStreamPeriod(message.PaymentScheduleAllocation.FundingStreamPeriodCode,
                connectionInfo);

            if (fundingStreamPeriod.PaymentMethod != PaymentMethod.NoPay)
            {
                Allocation aggregatedAllocation = _paymentAggregationService.CalculateAggregatedPayments(message.PaymentScheduleAllocation, connectionInfo);

                await context.Publish(new PaymentAggregatedEvent
                {
                    Allocation = aggregatedAllocation,
                    PaymentEventOrigin = message.PaymentEventOrigin
                }).ConfigureAwait(false);
            }

            _logger.LogInformation(
                PaymentManagementLoggingEvents.PaymentsAggregationHandlerEnd,
                "Payment Aggregation - END: Handling Payment Schedule Event complete - Contact Allocation Number {0}",
                message.PaymentScheduleAllocation.AllocationNumber);
        }
    }
}