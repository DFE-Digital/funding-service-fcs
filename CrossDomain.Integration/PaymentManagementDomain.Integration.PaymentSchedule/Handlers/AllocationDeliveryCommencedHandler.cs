namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers
{
    using BusinessLogic;
    using BusinessLogic.Services;
    using Common;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Events;
    using Extensions;
    using Framework.Logging.Interfaces;
    using NServiceBus;
    using PaymentManagement.Calculation;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;
    using Services;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using CrossDomain.Integration.Entities.Data;
    using Infrastructure;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;

    public class AllocationDeliveryCommencedHandler : IHandleMessages<AllocationDeliveryCommencedEvent>
    {
        private readonly ILogger _logger;
        private readonly IPayCalcPolicyQueryRepository _payCalcPolicyQueryRepository;
        private readonly IPaymentScheduleService _paymentScheduleService;
        private readonly IPaymentScheduleCreator _nonCalculationPaymentScheduleCreator;
        private readonly IDate _dateProvider;
        private readonly IActualValueNullResetService _actualValueNullResetService;
        private readonly IActualVolumeService _actualVolumeService;
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;
        private readonly IPaymentValuesCalculationService _paymentValuesCalculationService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public AllocationDeliveryCommencedHandler(
            ILogger logger,
            IPayCalcPolicyQueryRepository payCalcPolicyQueryRepository,
            IPaymentScheduleService paymentScheduleService,
            IPaymentScheduleCreator nonCalculationPaymentScheduleCreator,
            IDate dateProvider, 
            IActualValueNullResetService actualValueNullResetService,
            IActualVolumeService actualVolumeService, 
            IDeliverablePaymentRepository deliverablePaymentRepository,
            IPaymentValuesCalculationService paymentValuesCalculationService,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _payCalcPolicyQueryRepository = payCalcPolicyQueryRepository;
            _paymentScheduleService = paymentScheduleService;
            _nonCalculationPaymentScheduleCreator = nonCalculationPaymentScheduleCreator;
            _dateProvider = dateProvider;
            _actualValueNullResetService = actualValueNullResetService;
            _actualVolumeService = actualVolumeService;
            _deliverablePaymentRepository = deliverablePaymentRepository;
            _paymentValuesCalculationService = paymentValuesCalculationService;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(AllocationDeliveryCommencedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PaymentManagementLoggingEvents.PaymentManagementStart,
                "Payment Schedule - START: Allocation Delivery Commenced Event for Contract Allocation {0} received",
                message.Allocation.contractAllocationNumber);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            if (ShouldCalculatePayments(message.Allocation.fundingStreamPeriod.fundingStreamPeriodCode, connectionInfo))
            {
                PaymentSchedule.Allocation paymentScheduleAllocation = _paymentValuesCalculationService.ProducePaymentScheduleOnApproval(
                    message.Allocation, connectionInfo);

                PlannedValueCopier.CopyDeliveryCommencedValuesToPaymentSchedule(sourceContractDeliverables: message.Allocation.contractDeliverables,
                    destinationAllocationDeliverables: paymentScheduleAllocation.AllocationDeliverables);

                PaymentSchedule.Allocation paymentScheduleAllocationWithNullValues =
                    _actualValueNullResetService.ConditionallyResetActualValuesToNullOnApproval(
                        allocation: paymentScheduleAllocation, connectionInfo);

                _actualVolumeService.UpdatePaymentScheduleWithPreviousVersionVolume(paymentScheduleAllocationWithNullValues, connectionInfo);

                _paymentScheduleService.SavePaymentSchedule(
                    paymentScheduleAllocationWithNullValues,
                    new List<DeliverablePayment>(),
                    ProcessingMode.ContractApproved,
                    message.Allocation.startDate,
                    message.Allocation.endDate,
                    connectionInfo);
            }
            else
            {
                PaymentScheduleWithPayments paymentScheduleWithPayments = _nonCalculationPaymentScheduleCreator.CreatePaymentScheduleFromAllocation(message.Allocation, connectionInfo);

                _paymentScheduleService.SavePaymentSchedule(
                    paymentScheduleWithPayments.PaymentScheduleAllocation,
                    paymentScheduleWithPayments.DeliverablePayments,
                    ProcessingMode.ContractApproved,
                    message.Allocation.startDate,
                    message.Allocation.endDate,
                    connectionInfo);
            }

            var deliverablePayments = _deliverablePaymentRepository.GetDeliverablePaymentsForAllocation(
                message.Allocation.contractAllocationNumber,
                message.Allocation.contractReference.contractVersionNumber,
                connectionInfo);

            await context.Publish(new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = deliverablePayments.ToPaymentSchedule(
                    message.Allocation.fundingStreamPeriod.fundingStreamPeriodCode,
                    message.Allocation.contractReference.contractNumber,
                    message.Allocation.contractorReference.ToOrganisation()
                    ),
                PaymentEventOrigin = PaymentEventOrigin.AllocationDeliveryCommenced
            }).ConfigureAwait(false);

            _logger.LogInformation(
                PaymentManagementLoggingEvents.PaymentManagementEnd,
                "Payment Schedule - END: Handling Allocation Delivery Commenced Event complete - processed contract num {0}, contract version {1}, allocation id {2}, orgID {3}, deliverable count {4} ",
                message.Allocation.contractReference.contractNumber,
                message.Allocation.contractReference.contractVersionNumber,
                message.Allocation.contractAllocationNumber,
                message.Allocation.contractorReference.organisationIdentifier,
                message.Allocation.contractDeliverables.Count);
        }

        private bool ShouldCalculatePayments(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            PolicyFundingStreamPeriod fundingStreamPeriod = _payCalcPolicyQueryRepository.GetFundingStreamPeriod(fundingStreamPeriodCode, connectionInfo);

            return fundingStreamPeriod.IsCalculationRequiredForApproval() && fundingStreamPeriod.IsActive(_dateProvider.GetCalculationDate());
        }
    }
}
