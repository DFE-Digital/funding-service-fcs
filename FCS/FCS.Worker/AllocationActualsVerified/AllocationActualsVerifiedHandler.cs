namespace PaymentManagementDomain.AllocationActualsVerified
{
    using System.Threading.Tasks;
    using NServiceBus;
    using PaymentManagementDomain.AllocationActualsVerified.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.Common;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;

    /***
     * This class writes actuals to CRM
     */
    public class AllocationActualsVerifiedHandler : IHandleMessages<AllocationActualsVerified>, IHandleMessages<AllocationActualsUpdated>
    {
        private readonly ILogger _logger;
        private readonly IAllocationActualsRepository _xrmAllocationEvidenceManager;
        private readonly IPayCalcPolicyQueryRepository _payCalcPolicyQueryRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public AllocationActualsVerifiedHandler(
            ILogger logger,
            IAllocationActualsRepository xrmAllocationEvidenceManager,
            IPayCalcPolicyQueryRepository payCalcPolicyQueryRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _xrmAllocationEvidenceManager = xrmAllocationEvidenceManager;
            _payCalcPolicyQueryRepository = payCalcPolicyQueryRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public Task Handle(AllocationActualsVerified message, IMessageHandlerContext context)
        {
            string correlationId = context.MessageHeaders[Headers.CorrelationId];

            _logger.LogInformation(
                PaymentManagementLoggingEvents.AllocationActualsVerifiedStarted,
                "Beginning processing allocation {0} actual(s) for Allocation: {1} - CorrelationID: {2}",
                message.AllocationActuals.ActualsSummary.Count,
                message.AllocationActuals.ContractAllocationNumber,
                correlationId);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            PolicyFundingStreamPeriod policyFsp =
                _payCalcPolicyQueryRepository.GetFundingStreamPeriod(connectionInfo, message.AllocationActuals.FundingStreamPeriodCode);

            if (ShouldWriteActualsToCrm(policyFsp.PaymentMethod))
            {
                _xrmAllocationEvidenceManager.WriteAllocationActualsToCrm(message.AllocationActuals);
            }

            _logger.LogInformation(
                PaymentManagementLoggingEvents.AllocationActualsVerifiedCompleted,
                "Completed processing allocation {0} actual(s) for Allocation: {1} - CorrelationID: {2}",
                message.AllocationActuals.ActualsSummary.Count,
                message.AllocationActuals.ContractAllocationNumber,
                correlationId);

            return Task.FromResult(0);
        }

        public Task Handle(AllocationActualsUpdated message, IMessageHandlerContext context)
        {
            return Handle(new AllocationActualsVerified
            {
                AllocationActuals = message.AllocationActuals
            }, context);
        }

        private bool ShouldWriteActualsToCrm(PaymentMethod paymentMethod)
        {
            return paymentMethod == PaymentMethod.PayOnProfile || paymentMethod == PaymentMethod.NoPay;
        }
    }
}