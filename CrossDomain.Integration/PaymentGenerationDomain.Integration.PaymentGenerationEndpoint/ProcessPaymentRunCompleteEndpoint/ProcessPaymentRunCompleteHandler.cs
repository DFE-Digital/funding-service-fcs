namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunCompleteEndpoint
{
    extern alias Entities;
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using BusinessLogic;
    using Common;
    using Infrastructure;
    using NServiceBus;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ProcessPaymentRunCompleteHandler : IHandleMessages<ProcessPaymentRunCompleteCommand>
    {
        private readonly IDataAccessManager _dataManager;
        private readonly IAggregatedPaymentMapper _mapper;
        private readonly IOutstandingPaymentsChecker _outstandingPaymentsChecker;
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public ProcessPaymentRunCompleteHandler(
            IDataAccessManager dataManager,
            IAggregatedPaymentMapper mapper,
            IOutstandingPaymentsChecker outstandingPaymentsChecker,
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _dataManager = dataManager;
            _mapper = mapper;
            _outstandingPaymentsChecker = outstandingPaymentsChecker;
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(ProcessPaymentRunCompleteCommand message, IMessageHandlerContext context)
        {
            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var calendarPeriod = string.Empty;
            try
            {
                string fundingStreamPeriodCode = !string.IsNullOrEmpty(message.FundingStreamPeriodCode)
                    ? message.FundingStreamPeriodCode
                    : _dataManager.GetFundingStreamPeriodCodeFromShortCode(
                        message.FundingStreamShortCode,
                        message.FundingStreamPeriodStartDate,
                        message.FundingStreamPeriodEndDate,
                        connectionInfo);

                calendarPeriod = _dataManager.GetCalendarPeriodForPaymentTimetableFspAndCensusEndDate(fundingStreamPeriodCode, message.CensusEndDate, connectionInfo);

                _dataManager.UpdateTimetableForCompletedPaymentRun(
                    fundingStreamPeriodCode,
                    calendarPeriod,
                    message.LinkCode,
                    connectionInfo);

                var subnominalAggregation = _dataManager.UpdatePaymentsToPostedForPaymentRun(fundingStreamPeriodCode, calendarPeriod, connectionInfo);

                // Publish event for generation
                var allocations = _mapper.MapDbEntitiesToAggregatedPaymentCorporateSchema(subnominalAggregation.ToList(), connectionInfo);
                        
                foreach (var allocation in allocations)
                {
                    if (allocation != null)
                    {
                        bool hasOutstandingPayments =
                            _outstandingPaymentsChecker.HasOutstandingPaymentsForAllocation(
                                allocation.FundingStreamPeriodCode,
                                allocation.AllocationNumber,
                                connectionInfo);

                        PaymentPostedEvent paymentPostedEvent = new PaymentPostedEvent
                        {
                            Allocation = allocation,
                            AllocationNumber = allocation.AllocationNumber,
                            HasOutstandingPayments = hasOutstandingPayments
                        };
                        await context.Publish(paymentPostedEvent)
                            .ConfigureAwait(false);
                    }
                }
                        
                _logger.LogInformation(
                    PaymentGenerationDomainLoggingEventId.ProcessPaymentRunCompleted,
                    "The payment run completed successfully for FundingStreamShortCode: {0}, Calendar Period: {1}",
                    message.FundingStreamShortCode,
                    calendarPeriod);

            }
            catch (Exception e)
            {
                _logger.LogError(
                    PaymentGenerationDomainLoggingEventId.PaymentGenerationError,
                        e,
                    "The payment run completetion failed for FundingStreamShortCode: {0}, Calendar Period: {1}",
                    message.FundingStreamShortCode,
                    calendarPeriod);
                throw;
            }
        }
    }
}