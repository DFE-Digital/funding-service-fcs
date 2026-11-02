namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using BusinessLogic.FundingClaimReconciliation.Repositories;
    using Common;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos;
    using CrossDomain.Integration.Events;
    using Extensions;
    using NServiceBus;
    using Framework.Logging.Interfaces;
    using Infrastructure;
    using PaymentManagement.Calculation;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

    public class FundingClaimReconciliationPublishedHandler : IHandleMessages<FundingClaimReconciliationPublishedEvent>
    {
        private readonly ILogger _logger;
        private readonly IFcrPaymentValuesCalculationService _fcrPaymentValuesCalculationService;
        private readonly IPaymentScheduleAllocationCommandRepository _paymentScheduleAllocationCommandRepository;
        private readonly IPublishedPayableFcrAllocationRepository _publishedPayableFcrAllocationRepository;
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public FundingClaimReconciliationPublishedHandler(
            ILogger logger,
            IFcrPaymentValuesCalculationService fcrPaymentValuesCalculationService,
            IPaymentScheduleAllocationCommandRepository paymentScheduleAllocationCommandRepository,
            IPublishedPayableFcrAllocationRepository publishedPayableFcrAllocationRepository,
            IDeliverablePaymentRepository deliverablePaymentRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _fcrPaymentValuesCalculationService = fcrPaymentValuesCalculationService;
            _paymentScheduleAllocationCommandRepository = paymentScheduleAllocationCommandRepository;
            _publishedPayableFcrAllocationRepository = publishedPayableFcrAllocationRepository;
            _deliverablePaymentRepository = deliverablePaymentRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(FundingClaimReconciliationPublishedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PaymentManagementLoggingEvents.FcrPublishedStart,
                $"Payment Schedule - START: Funding Claim Reconciliation Publish Event for: {message.FundingClaimReconciliationName}," +
                $" IsClaimCollectionPayable {message.IsClaimCollectionPayable}, IsForManualPublication {message.IsForManualPublication}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            if (message.IsClaimCollectionPayable)
            {
                AddToPublishedPayableFcrAllocation(message.ContractInfo, connectionInfo);

                if (!message.IsForManualPublication)
                {
                    IReadOnlyCollection<Allocation> paymentScheduleAllocations = _fcrPaymentValuesCalculationService.CalculateAllocationSchedules(message.ContractInfo, connectionInfo, message.ShouldStaggerPayments);

                    foreach (Allocation paymentScheduleAllocation in paymentScheduleAllocations)
                    {
                        AllocationInfo allocationInfo = message.ContractInfo.FindAllocationInfo(paymentScheduleAllocation.AllocationNumber);

                        _paymentScheduleAllocationCommandRepository.UpdateDeliverablePaymentsForAllocation(
                            paymentScheduleAllocation, allocationInfo.StartDate, allocationInfo.EndDate, connectionInfo);

                        var deliverablePayments = _deliverablePaymentRepository.GetDeliverablePaymentsForAllocation(
                            paymentScheduleAllocation.AllocationNumber,
                            paymentScheduleAllocation.ContractVersionNumber,
                            connectionInfo);
                        await context.Publish(new PaymentScheduleEvent
                        {
                            PaymentEventOrigin = PaymentEventOrigin.FundingClaimReconciliationPublished,
                            PaymentScheduleAllocation = deliverablePayments.ToPaymentSchedule(
                                paymentScheduleAllocation.FundingStreamPeriodCode,
                                paymentScheduleAllocation.ContractNumber,
                                paymentScheduleAllocation.Organisation)
                        }).ConfigureAwait(false);
                    }
                }
            }

            _logger.LogInformation(
                PaymentManagementLoggingEvents.FcrPublishedEnd,
                $"Payment Schedule - END: Funding Claim Reconciliation Publish Event for: {message.FundingClaimReconciliationName}");
        }

        private void AddToPublishedPayableFcrAllocation(ContractInfo contractInfo, ConnectionInfo connectionInfo)
        {
            contractInfo.AllocationInfos.Select(a => a.AllocationNumber).ToList().ForEach(a => _publishedPayableFcrAllocationRepository.Add(a, connectionInfo));
        }
    }
}
