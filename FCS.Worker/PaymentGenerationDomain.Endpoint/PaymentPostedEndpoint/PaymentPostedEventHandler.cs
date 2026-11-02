namespace PaymentGenerationDomain.Endpoint.PaymentPostedEndpoint
{
    using System.Linq;
    using System.Threading.Tasks;
    using BusinessLogic;
    using NServiceBus;
    using PaymentGenerationDomain.BusinessLogic.Exceptions;
    using PaymentGenerationDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class PaymentPostedEventHandler : IHandleMessages<PaymentPostedEvent>
    {
        private readonly IXrmAllocationManager _allocationCrmManager;
        private readonly ILogger _logger;

        public PaymentPostedEventHandler(IXrmAllocationManager allocationCrmManager, ILogger logger)
        {
            _allocationCrmManager = allocationCrmManager;
            _logger = logger;
        }

        public Task Handle(PaymentPostedEvent message, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                PaymentGenerationDomainLoggingEventId.UpdateTransmissionStatusStarted,
                "Updating Payment Transmission Status Started for Allocation : {0}, Calendar Period(s) : {1} ",
                message.Allocation.AllocationNumber,
                string.Join(", ", message.Allocation.AllocationPeriods.Select(p => p.Period)));

            try
            {
                _allocationCrmManager.UpdatePaymentTransmissionStatus(message.Allocation, true);

                _logger.LogInformation(
                    PaymentGenerationDomainLoggingEventId.UpdateTransmissionStatusCompleted,
                    "Updating Payment Transmission Status Completed for Allocation : {0}, Calendar Period(s) : {1} ",
                    message.Allocation.AllocationNumber,
                    string.Join(", ", message.Allocation.AllocationPeriods.Select(p => p.Period)));
            }
            catch (ContractAllocationNotFoundException ex)
            {
                _logger.LogError(
                    PaymentGenerationDomainLoggingEventId.UpdateTransmissionStatusError,
                    ex.Message);
            }

            return Task.CompletedTask;
        }
    }
}
