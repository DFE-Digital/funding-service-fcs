namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint
{ 
    extern alias Entities;
    using System.Linq;
    using System.Threading.Tasks;
    using BusinessLogic;
    using Common;
    using Common.Exceptions;
    using DTOs;
    using Extensions;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class AggregatePaymentHandler : IHandleMessages<PaymentAggregatedEvent>
    {
        private readonly ILogger _logger;
        private readonly IOutstandingPaymentsChecker _outstandingPaymentsChecker;
        private readonly ISubnominalAggregationRepository _subnominalAggregationRepository;
        private readonly IUpSertSubmoninalAggregationService _upSertSubmoninalAggregationService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public AggregatePaymentHandler(
            ILogger logger,
            IOutstandingPaymentsChecker outstandingPaymentsChecker,
            IUpSertSubmoninalAggregationService upSertSubmoninalAggregationService,
            ISubnominalAggregationRepository subnominalAggregationRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _outstandingPaymentsChecker = outstandingPaymentsChecker;
            _upSertSubmoninalAggregationService = upSertSubmoninalAggregationService;
            _subnominalAggregationRepository = subnominalAggregationRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(PaymentAggregatedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PaymentGenerationDomainLoggingEventId.PaymentAggregatedHandleStarted,
                "Payment Aggregation handling started - Allocation {0} - Version {1}",
                message.Allocation.AllocationNumber, message.Allocation.VersionNumber);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            if (message.Allocation != null &&
                message.Allocation.AllocationPeriods.Any(
                    x => x.PeriodTypeCode != AllocationPeriodPeriodTypeCode.CM))
            {
                throw new InvalidPeriodTypeCodeException(
                    "One or more of the Allocation periods in the allocation contains a periodTypeCode of something other than 'CM'.");
            }

            var allocationPeriodsWithExistingData = message.Allocation.AllocationPeriods.Select(ap =>
            {
                var existingSubnominalAggregations = _subnominalAggregationRepository.GetSubnominalAggregations(
                    message.Allocation.AllocationNumber,
                    ap.Period,
                    connectionInfo);

                return new AllocationPeriodWithExistingData(allocationPeriod: ap, existingSubnominalAggregations: existingSubnominalAggregations);
            }).ToList();

            var unpostedAllocationPeriods =
                allocationPeriodsWithExistingData.Where(a => !a.ExistingSubnominalAggregations.ArePosted()).ToList();

            _upSertSubmoninalAggregationService.UpSert(unpostedAllocationPeriods, message.Allocation, connectionInfo);

            bool hasOutstandingPaymentsForAllocation = _outstandingPaymentsChecker.HasOutstandingPaymentsForAllocation(
                message.Allocation.FundingStreamPeriodCode,
                message.Allocation.AllocationNumber,
                connectionInfo);

            message.Allocation.AllocationPeriods = unpostedAllocationPeriods
                .Select(unPostedPeriod => unPostedPeriod.AllocationPeriod).ToList();

            AllocationPaymentsChangedOnAggregationEvent aggregationEvent =
                new AllocationPaymentsChangedOnAggregationEvent
                {
                    Allocation = message.Allocation,
                    AllocationNumber = message.Allocation.AllocationNumber,
                    HasOutstandingPayments = hasOutstandingPaymentsForAllocation,
                    PaymentEventOrigin = message.PaymentEventOrigin
                };

            await context.Publish(aggregationEvent)
                .ConfigureAwait(false);

            _logger.LogInformation(
                PaymentGenerationDomainLoggingEventId.PaymentAggregatedHandleEnded,
                "Payment Aggregation handling ended.");
        }
    }
}
