
extern alias CrossdomainCommon;

namespace PaymentGenerationDomain.Endpoint.PaymentPostedEndpoint
{
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.BusinessLogic.Exceptions;
    using PaymentGenerationDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    // ✅ Explicit interface binding (fixes ambiguity)
    using IXrmAllocationManager =
        PaymentGenerationDomain.BusinessLogic.IXrmAllocationManager;

    // ✅ Domain types (CRM expects these)
    using DomainAllocation =
        SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation;

    using DomainAllocationPeriod =
        SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.AllocationPeriod;

    // ✅ Integration types (from aliased project reference)
    using IntegrationAllocation =
        CrossdomainCommon::SFA.FCT.CrossDomain.Integration.Entities
            .CorporatePaymentAggregation.Allocation;

    public class PaymentPostedEventHandler : IHandleMessages<PaymentPostedEvent>
    {
        private readonly IXrmAllocationManager _allocationCrmManager;
        private readonly ILogger _logger;

        public PaymentPostedEventHandler(
            IXrmAllocationManager allocationCrmManager,
            ILogger logger)
        {
            _allocationCrmManager = allocationCrmManager;
            _logger = logger;
        }

        public Task Handle(PaymentPostedEvent message, IMessageHandlerContext context)
        {
            // ✅ ORIGINAL START LOG
            _logger.LogInformation(
                PaymentGenerationDomainLoggingEventId.UpdateTransmissionStatusStarted,
                "Updating Payment Transmission Status Started for Allocation : {0}, Calendar Period(s) : {1}",
                message.Allocation.AllocationNumber,
                string.Join(", ",
                    message.Allocation.AllocationPeriods.Select(p => p.Period)));

            try
            {
                // ✅ Map Integration → Domain
                var domainAllocation = MapToDomainAllocation(message.Allocation);

                _allocationCrmManager.UpdatePaymentTransmissionStatus(
                    domainAllocation,
                    true);

                // ✅ ORIGINAL COMPLETION LOG
                _logger.LogInformation(
                    PaymentGenerationDomainLoggingEventId.UpdateTransmissionStatusCompleted,
                    "Updating Payment Transmission Status Completed for Allocation : {0}, Calendar Period(s) : {1}",
                    domainAllocation.AllocationNumber,
                    string.Join(", ",
                        domainAllocation.AllocationPeriods.Select(p => p.Period)));
            }
            catch (ContractAllocationNotFoundException ex)
            {
                // ✅ ORIGINAL ERROR LOG
                _logger.LogError(
                    PaymentGenerationDomainLoggingEventId.UpdateTransmissionStatusError,
                    ex.Message);
            }

            return Task.CompletedTask;
        }

        private static DomainAllocation MapToDomainAllocation(IntegrationAllocation source)
        {
            return new DomainAllocation
            {
                AllocationNumber = source.AllocationNumber,
                AllocationPeriods = source.AllocationPeriods
                    .Select(p => new DomainAllocationPeriod
                    {
                        Period = p.Period
                    })
                    .ToList()
            };
        }
    }
}
