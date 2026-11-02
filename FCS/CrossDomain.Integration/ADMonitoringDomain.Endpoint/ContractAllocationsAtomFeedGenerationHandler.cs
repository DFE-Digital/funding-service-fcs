namespace ADMonitoringDomain.Endpoint
{
    using System.Collections.Generic;
    using BusinessLogic;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Common;
    using BusinessLogic.EventExtensions;
    using Logging;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Threading.Tasks;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ContractAllocationsAtomFeedGenerationHandler :
        IHandleMessages<PaymentAggregatedEvent>,
        IHandleMessages<IPaymentPostedEvent>,
        IHandleMessages<AllocationActualsVerified>,
        IHandleMessages<PaymentScheduleEvent>,
        IHandleMessages<AllocationActualsUpdated>
    {
        private readonly IRulesEngine _feedGenerationRules;
        private readonly IAtomGenerator _atomGenerator;
        private readonly IADMonitoringDeliveryEventStore _store;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public IDate DateService{get;set;}

        public ContractAllocationsAtomFeedGenerationHandler(
            IRulesEngine feedGenerationRules,
            IAtomGenerator atomGenerator,
            IADMonitoringDeliveryEventStore store,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _atomGenerator = atomGenerator;
            _feedGenerationRules = feedGenerationRules;
            _store = store;
            _sessionConnectionFactory = sessionConnectionFactory;
            DateService = new SystemDate();
            
        }
        public ILogger Logger { get; set; }

        public Task Handle(PaymentAggregatedEvent message, IMessageHandlerContext context)
        {
            Logger.LogInformation(AdMonitoringDomainEventLoggingId.EventReceived, "Payment Aggregated event received by Contract Allocation Atom Feed Generation handler. Allocation no: {0}, Origin: {1}",
               message.Allocation.AllocationNumber,
               message.PaymentEventOrigin.ToString());

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            void StoreEventAndGenerateFeedAction(AllocationDeliveryEntryCategory category)
            {
                _store.StoreEvent(message.ToAllocationDeliveryEventReceived(DateService), message.GetType());

                GenerateFeedIfRequired(
                    message.Allocation.AllocationNumber,
                    message.Allocation.VersionNumber,
                    RulesEngine.EventName.PaymentAggregated,
                    new List<RulesEngine.RuleName> {RulesEngine.RuleName.ContractAllocationActualsReceived},
                    category,
                    connectionInfo);

                Logger.LogInformation(AdMonitoringDomainEventLoggingId.EventHandled, "Payment Aggregated event handled by Contract Allocation Atom Feed Generation handler. Allocation no: {0}",
                    message.Allocation.AllocationNumber);
            }

            switch (message.PaymentEventOrigin)
            {
                case PaymentEventOrigin.AllocationActualsVerified:
                    StoreEventAndGenerateFeedAction(AllocationDeliveryEntryCategory.ContractAllocationActualsReceived);
                    break;
                case PaymentEventOrigin.AllocationActualsUpdated:
                    StoreEventAndGenerateFeedAction(AllocationDeliveryEntryCategory.ContractAllocationActualsUpdated);
                    break;
            }

            return Task.CompletedTask;
        }

        public Task Handle(IPaymentPostedEvent message, IMessageHandlerContext context)
        {
            Logger.LogInformation(AdMonitoringDomainEventLoggingId.EventReceived, "Payment Posted event received by Contract Allocation Atom Feed Generation handler. Allocation no: {0}",
               message.Allocation.AllocationNumber);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            GenerateFeedIfRequired(
                message.Allocation.AllocationNumber,
                message.Allocation.VersionNumber,
                RulesEngine.EventName.PaymentPosted,
                new List<RulesEngine.RuleName>()
                {
                    RulesEngine.RuleName.ContractAllocationPaymentPosted
                },
                AllocationDeliveryEntryCategory.ContractAllocationPaymentReceived,
                connectionInfo);

            Logger.LogInformation(AdMonitoringDomainEventLoggingId.EventHandled, "Payment Posted event handled by Contract Allocation Atom Feed Generation handler. Allocation no: {0}",
               message.Allocation.AllocationNumber);

            return Task.CompletedTask;
        }

        public Task Handle(AllocationActualsVerified message, IMessageHandlerContext context)
        {
            Logger.LogInformation(AdMonitoringDomainEventLoggingId.EventReceived, "Allocation Actuals Verified event received by Contract Allocation Atom Feed Generation handler. Allocation no: {0}",
               message.AllocationActuals.ContractAllocationNumber);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            void GenerateFeedAction(AllocationDeliveryEntryCategory category) => 
                GenerateFeedIfRequired(
                    message.AllocationActuals.ContractAllocationNumber,
                    message.AllocationActuals.ContractReference.ContractVersionNumber,
                    RulesEngine.EventName.AllocationActualsVerified,
                    new List<RulesEngine.RuleName>{RulesEngine.RuleName.ContractAllocationActualsReceived}, 
                    category,
                    connectionInfo);

            GenerateFeedAction(message.Origin == ActualsOrigin.ActualsUpdated
                ? AllocationDeliveryEntryCategory.ContractAllocationActualsUpdated
                : AllocationDeliveryEntryCategory.ContractAllocationActualsReceived);

            Logger.LogInformation(AdMonitoringDomainEventLoggingId.EventHandled, "Allocation Actuals Verified event handled by Contract Allocation Atom Feed Generation handler. Allocation no: {0}",
              message.AllocationActuals.ContractAllocationNumber);

            return Task.CompletedTask;
        }

        public Task Handle(PaymentScheduleEvent message, IMessageHandlerContext context)
        {
            Logger.LogInformation(AdMonitoringDomainEventLoggingId.EventReceived, "Payment Schedule event received by Contract Allocation Atom Feed Generation handler. Allocation no: {0}, Origin: {1}",
               message.PaymentScheduleAllocation.AllocationNumber,
               message.PaymentEventOrigin.ToString());

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            void GenerateFeedAction(AllocationDeliveryEntryCategory category)
            {
                GenerateFeedIfRequired(
                    message.PaymentScheduleAllocation.AllocationNumber,
                    message.PaymentScheduleAllocation.ContractVersionNumber,
                    RulesEngine.EventName.PaymentCalculated,
                    new List<RulesEngine.RuleName> { RulesEngine.RuleName.ContractAllocationActualsReceived },
                    category,
                    connectionInfo);

                Logger.LogInformation(AdMonitoringDomainEventLoggingId.EventHandled, "Payment Schedule event handled by Contract Allocation Atom Feed Generation handler. Allocation no: {0}",
                    message.PaymentScheduleAllocation.AllocationNumber);
            }

            switch (message.PaymentEventOrigin)
            {
                case PaymentEventOrigin.AllocationActualsVerified:
                    GenerateFeedAction(AllocationDeliveryEntryCategory.ContractAllocationActualsReceived);
                    break;
                case PaymentEventOrigin.AllocationActualsUpdated:
                    GenerateFeedAction(AllocationDeliveryEntryCategory.ContractAllocationActualsUpdated);
                    break;
            }

            return Task.CompletedTask;
        }

        public async Task Handle(AllocationActualsUpdated message, IMessageHandlerContext context)
        {
            await Handle(new AllocationActualsVerified
            {
                AllocationActuals = message.AllocationActuals,
                Origin = ActualsOrigin.ActualsUpdated
            }, context).ConfigureAwait(false);
        }

        private void GenerateFeedIfRequired(
            string allocationNumber,
            int versionNumber,
            RulesEngine.EventName businessEvent,
            List<RulesEngine.RuleName> rules,
            AllocationDeliveryEntryCategory category,
            ConnectionInfo connectionInfo)
        {
            rules.ForEach(
                rule =>
                {
                    if (_feedGenerationRules.EvaluateRule(
                        rule,
                        businessEvent, allocationNumber,
                        versionNumber))
                    {
                        Logger.LogInformation(AdMonitoringDomainEventLoggingId.GeneratingFeed,
                            "Generating Feed for Contract Allocation Atom Feed. Allocation no: {0}",
                            allocationNumber);

                        _atomGenerator.GenerateAtomFeed(
                            allocationNumber,
                            versionNumber,
                            category,
                            connectionInfo);

                        Logger.LogInformation(AdMonitoringDomainEventLoggingId.GeneratedFeed,
                            "Generated Feed for Contract Allocation Atom Feed. Allocation no: {0}",
                            allocationNumber);
                    }
                });
        }
    }
}
