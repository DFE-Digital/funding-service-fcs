namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using BusinessLogic;
    using BusinessLogic.Services;
    using Common;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Events;
    using Extensions;
    using Framework.Logging.Interfaces;
    using Infrastructure;
    using NServiceBus;
    using PaymentManagement.Calculation;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;
    using Services;
    using Allocation = CrossDomain.Integration.Entities.PaymentSchedule.Allocation;

    public class AllocationActualsVerifiedHandler : IHandleMessages<AllocationActualsVerified>, IHandleMessages<AllocationActualsUpdated>
    {
        private readonly ILogger _logger;
        private readonly IPaymentScheduleService _paymentScheduleService;
        private readonly IPayCalcPolicyQueryRepository _payCalcPolicyQueryRepository;
        private readonly IPaymentScheduleCreator _nonCalculationPaymentScheduleCreator;
        private readonly IDate _dateProvider;
        private readonly IActualVolumeApplicator _actualVolumeApplicator;
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;
        private readonly IPaymentValuesCalculationService _paymentValuesCalculationService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public AllocationActualsVerifiedHandler(
            ILogger logger,
            IPaymentScheduleService paymentScheduleService,
            IPayCalcPolicyQueryRepository payCalcPolicyQueryRepository,
            IPaymentScheduleCreator nonCalculationPaymentScheduleCreator,
            IDate dateProvider,
            IActualVolumeApplicator actualVolumeApplicator,
            IActualValueNullResetService actualValueNullResetService,
            IDeliverablePaymentRepository deliverablePaymentRepository,
            IPaymentValuesCalculationService paymentValuesCalculationService,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _paymentScheduleService = paymentScheduleService;
            _payCalcPolicyQueryRepository = payCalcPolicyQueryRepository;
            _nonCalculationPaymentScheduleCreator = nonCalculationPaymentScheduleCreator;
            _dateProvider = dateProvider;
            _actualVolumeApplicator = actualVolumeApplicator;
            _deliverablePaymentRepository = deliverablePaymentRepository;
            _paymentValuesCalculationService = paymentValuesCalculationService;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(AllocationActualsVerified message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PaymentManagementLoggingEvents.AllocationActualsVerifiedStart,
                "Payment Schedule - START: Allocation Actuals Verified Event for Contract Allocation Number {0}",
                message.AllocationActuals.ContractAllocationNumber);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            Allocation paymentScheduleForAllocation;
            IReadOnlyCollection<DeliverablePayment> deliverablePayments;
            PolicyFundingStreamPeriod fsp =
                _payCalcPolicyQueryRepository.GetFundingStreamPeriod(message.AllocationActuals.FundingStreamPeriodCode, connectionInfo);

            if (!fsp.IsActive(_dateProvider.GetCalculationDate()))
            {
                throw new ArgumentException($"Unable to process IAllocationActualsVerified for {message.AllocationActuals.ContractAllocationNumber}, inactive Funding Stream Period {fsp.FundingStreamPeriod}");
            }

            if (fsp.IsCalculationRequiredForActuals())
            {
                paymentScheduleForAllocation = _paymentValuesCalculationService.ProducePaymentScheduleOnActualsReceived(message.AllocationActuals, connectionInfo);
                deliverablePayments = new List<DeliverablePayment>();
            }
            else
            {
                PaymentScheduleWithPayments paymentScheduleWithPayments = _nonCalculationPaymentScheduleCreator.CreatePaymentScheduleFromActuals(message.AllocationActuals, connectionInfo);
                paymentScheduleForAllocation = paymentScheduleWithPayments.PaymentScheduleAllocation;
                deliverablePayments = paymentScheduleWithPayments.DeliverablePayments;
            }
            
            if (paymentScheduleForAllocation != null)
            {
                ClearPayOnProfilePaymentValues(paymentScheduleForAllocation);
            }
            
            if (fsp.PaymentMethod != PaymentMethod.PayOnProfile)
            {
                _actualVolumeApplicator.MutatePaymentScheduleWithActualVolume(paymentScheduleForAllocation: paymentScheduleForAllocation,
                    deliverablePayments: deliverablePayments,
                    allocationActuals: message.AllocationActuals);

                _paymentScheduleService.SavePaymentSchedule(
                    paymentScheduleForAllocation: paymentScheduleForAllocation, 
                    deliverablePayments: deliverablePayments,
                    processingMode: ProcessingMode.ActualsReceived,
                    allocationStartDate: null,
                    allocationEndDate: null,
                    connectionInfo);

                deliverablePayments = _deliverablePaymentRepository.GetDeliverablePaymentsForAllocation(
                    paymentScheduleForAllocation.AllocationNumber,
                    paymentScheduleForAllocation.ContractVersionNumber,
                    connectionInfo);

                await context.Publish(new PaymentScheduleEvent
                {
                    PaymentScheduleAllocation = deliverablePayments.ToPaymentSchedule(
                        fsp.FundingStreamPeriod,
                        paymentScheduleForAllocation.ContractNumber,
                        paymentScheduleForAllocation.Organisation),
                    PaymentEventOrigin = message.Origin == ActualsOrigin.ActualsUpdated ? PaymentEventOrigin.AllocationActualsUpdated : PaymentEventOrigin.AllocationActualsVerified
                }).ConfigureAwait(false);
            }
            else
            {
                _deliverablePaymentRepository.UpdateActualValuesAndVolumes(deliverablePayments, connectionInfo);
            }

            _logger.LogInformation(
                PaymentManagementLoggingEvents.PaymentManagementEnd,
                "Payment Schedule - END: Handling Allocation Actuals Verified Event complete - processed contract num {0}, contract version {1}, allocation id {2}, orgID {3} ",
                message.AllocationActuals.ContractReference.ContractNumber,
                message.AllocationActuals.ContractReference.ContractVersionNumber,
                message.AllocationActuals.ContractAllocationNumber,
                message.AllocationActuals.ContractorReference.OrganisationIdentifier);
        }

        public async Task Handle(AllocationActualsUpdated message, IMessageHandlerContext context)
        {
            await Handle(new AllocationActualsVerified
            {
                AllocationActuals = message.AllocationActuals,
                Origin = ActualsOrigin.ActualsUpdated
            }, context).ConfigureAwait(false);
        }

        private static void ClearPayOnProfilePaymentValues(Allocation allocation)
        {
            allocation.AllocationDeliverables.ForEach(deliverable =>
            {
                deliverable.ScheduledPayments.ForEach(scheduledPayment =>
                {
                    scheduledPayment.ProfilePaymentAmount = null;
                    scheduledPayment.BalancingPaymentAmount = null;
                });
            });
        }
    }
}
