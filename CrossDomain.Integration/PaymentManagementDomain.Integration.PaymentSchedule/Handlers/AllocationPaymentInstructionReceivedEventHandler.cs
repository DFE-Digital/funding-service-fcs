namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using BusinessLogic;
    using BusinessLogic.Services;
    using Common;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Events;
    using Extensions;
    using Framework.Logging.Interfaces;
    using Infrastructure;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    public class AllocationPaymentInstructionReceivedEventHandler : IHandleMessages<IAllocationPaymentInstructionReceivedEvent>
    {
        private readonly ILogger _logger;
        private readonly IPaymentScheduleService _paymentScheduleService;
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public AllocationPaymentInstructionReceivedEventHandler(
            ILogger logger,
            IPaymentScheduleService paymentScheduleService,
            IDeliverablePaymentRepository deliverablePaymentRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _paymentScheduleService = paymentScheduleService;
            _deliverablePaymentRepository = deliverablePaymentRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(IAllocationPaymentInstructionReceivedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PaymentManagementLoggingEvents.AllocationPaymentInstructionReceivedStart,
                $"Payment Schedule - START: Allocation Payment Instruction Received Event for: {message.AllocationPaymentInstruction.AllocationNumber}.");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            PaymentSchedule.Allocation paymentSchedule = AllocationPaymentInstructionTransformer.ToPaymentSchedule(message.AllocationPaymentInstruction);
            IReadOnlyCollection<DeliverablePayment> deliverablePayments = AllocationPaymentInstructionTransformer.ToDeliverablePayments(message.AllocationPaymentInstruction);

            _paymentScheduleService.SavePaymentSchedule(
                paymentSchedule,
                deliverablePayments,
                ProcessingMode.PaymentInstructionReceived,
                message.AllocationPaymentInstruction.AllocationStartDate,
                message.AllocationPaymentInstruction.AllocationEndDate,
                connectionInfo);

            deliverablePayments = _deliverablePaymentRepository.GetDeliverablePaymentsForAllocation(
                message.AllocationPaymentInstruction.AllocationNumber,
                message.AllocationPaymentInstruction.VersionNumber,
                connectionInfo);

            await context.Publish<PaymentScheduleEvent>(evt =>
            {
                evt.PaymentScheduleAllocation = deliverablePayments.ToPaymentSchedule(
                    paymentSchedule.FundingStreamPeriodCode,
                    paymentSchedule.ContractNumber,
                    paymentSchedule.Organisation);

                evt.PaymentEventOrigin = PaymentEventOrigin.PaymentInstructionReceived;
            }).ConfigureAwait(false);

            _logger.LogInformation(
                PaymentManagementLoggingEvents.AllocationPaymentInstructionReceivedEnd,
                $"Payment Schedule - END: Allocation Payment Instruction Received Event for: {message.AllocationPaymentInstruction.AllocationNumber}.");
        }
    }
}
