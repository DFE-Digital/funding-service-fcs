namespace ADMonitoringDomain.Endpoint
{
    extern alias Entities;
    using BusinessLogic;
    using Logging;
    using NServiceBus;    
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using BusinessLogic.EventExtensions;
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using System.Threading.Tasks;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ContractAllocationApprovedHandler :
        IHandleMessages<AllocationDeliveryCommencedEvent>,
        IHandleMessages<PaymentScheduleEvent>,
        IHandleMessages<PaymentAggregatedEvent>
    {
        private readonly ILogger _logger;
        private readonly IAllocationDeliveryMonitoringRepository _allocationDeliveryMonitoringRepository;
        private readonly IAllocationDeliveryPerformanceMapper _allocationDeliveryPerformanceMapper;
        private readonly IDate _dateService;
        private readonly IAtomGenerator _atomGenerator;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public ContractAllocationApprovedHandler(
            ILogger logger,
            IAllocationDeliveryMonitoringRepository allocationDeliveryMonitoringAllocationDeliveryMonitoringRepository,
            IAllocationDeliveryPerformanceMapper allocationDeliveryPerformanceAllocationDeliveryPerformanceMapper,
            IDate dateService,
            IAtomGenerator atomGenerator,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _allocationDeliveryMonitoringRepository = allocationDeliveryMonitoringAllocationDeliveryMonitoringRepository;
            _allocationDeliveryPerformanceMapper = allocationDeliveryPerformanceAllocationDeliveryPerformanceMapper;
            _dateService = dateService;
            _atomGenerator = atomGenerator;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public Task Handle(AllocationDeliveryCommencedEvent message, IMessageHandlerContext context)
        {
            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var isNewContract = message.Allocation.contractReference.contractVersionNumber == 1;
            var isAmendedContract = message.Allocation.contractReference.contractVersionNumber > 1;
            var isPoP = IsPaymentMethod(message.Allocation.fundingStreamPeriod.fundingStreamPeriodCode, PaymentMethod.PayOnProfile, connectionInfo);
            var isPoA = IsPaymentMethod(message.Allocation.fundingStreamPeriod.fundingStreamPeriodCode, PaymentMethod.PayOnActuals, connectionInfo);
            var isExternallyPaid = IsPaymentMethod(message.Allocation.fundingStreamPeriod.fundingStreamPeriodCode, PaymentMethod.NoPay, connectionInfo);
            var isPayOnInstruction = IsPaymentMethod(message.Allocation.fundingStreamPeriod.fundingStreamPeriodCode, PaymentMethod.PayOnInstruction, connectionInfo);
            var category = isNewContract? AllocationDeliveryEntryCategory.NewContractAllocationApproved: AllocationDeliveryEntryCategory.AmendedContractAllocationApproved;
            var allocationNo = message.Allocation.contractAllocationNumber;
            PaymentMethod paymentMethod = _allocationDeliveryMonitoringRepository.GetPaymentMethod(message.Allocation.fundingStreamPeriod.fundingStreamPeriodCode, connectionInfo);

            _logger.LogInformation(AdMonitoringDomainEventLoggingId.EventReceived, "Allocation Delivery Commenced event received by New Contract Allocation Approved handler for monitoring. Allocation no: {0}", allocationNo);

            if(isNewContract && (isPoA || isExternallyPaid || isPayOnInstruction))
            {
                var newContractAllocationApprovedEvent = _allocationDeliveryPerformanceMapper.Map(message, connectionInfo);
                _logger.LogInformation(AdMonitoringDomainEventLoggingId.EventMapped, "Allocation Delivery Commenced event was mapped to New Contract Allocation Approved event. Allocation no: {0}", allocationNo);

                _allocationDeliveryMonitoringRepository.StoreEvent(newContractAllocationApprovedEvent, category, connectionInfo);
                _logger.LogInformation(AdMonitoringDomainEventLoggingId.EventStoredForFeed, "New Contract Allocation Approved event was stored for the monitoring feed. Allocation no: {0}", allocationNo);
            }
            else if (paymentMethod == PaymentMethod.NoCalcAndNoPay)
            {
                _allocationDeliveryMonitoringRepository.StoreEvent(_allocationDeliveryPerformanceMapper.Map(message, connectionInfo), category, connectionInfo);
            }
            else if ((isNewContract && isPoP) || (isAmendedContract && isPoP))
            {
                _allocationDeliveryMonitoringRepository.StoreMessagePayload(message.ToAllocationDeliveryEventReceived(_dateService, category.ToString()), connectionInfo, message.GetType());
                ProcessAllocationDeliveryCommencedPaymentCalculatedAndPaymentAggregatedEvents(message.Allocation.contractAllocationNumber, message.Allocation.contractReference.contractVersionNumber, category, connectionInfo);
            }

            return Task.CompletedTask;
        }

        public Task Handle(PaymentScheduleEvent message, IMessageHandlerContext context)
        {
            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var isNewContract = message.PaymentScheduleAllocation.ContractVersionNumber == 1;
            var isAmendedContract = message.PaymentScheduleAllocation.ContractVersionNumber > 1;
            var eventOrigin = message.PaymentEventOrigin;
            var isPoP = IsPaymentMethod(message.PaymentScheduleAllocation.FundingStreamPeriodCode, PaymentMethod.PayOnProfile, connectionInfo);
            var isExternallyPaid = IsPaymentMethod(message.PaymentScheduleAllocation.FundingStreamPeriodCode, PaymentMethod.NoPay, connectionInfo);
            var category = isNewContract ? AllocationDeliveryEntryCategory.NewContractAllocationApproved : AllocationDeliveryEntryCategory.AmendedContractAllocationApproved;           
            var allocationNo = message.PaymentScheduleAllocation.AllocationNumber;

            _logger.LogInformation(AdMonitoringDomainEventLoggingId.EventReceived, "Payment Calculated event received by Contract Allocation Approved handler for monitoring. Allocation no: {0}, Origin: {1}",
                allocationNo, eventOrigin.ToString());

            if (isNewContract && isPoP)
            {
                _allocationDeliveryMonitoringRepository.StoreMessagePayload(message.ToAllocationDeliveryEventReceived(_dateService, category.ToString()), connectionInfo, message.GetType());
                ProcessAllocationDeliveryCommencedPaymentCalculatedAndPaymentAggregatedEvents(message.PaymentScheduleAllocation.AllocationNumber, message.PaymentScheduleAllocation.ContractVersionNumber, category, connectionInfo);
            }
            else if (isAmendedContract && isExternallyPaid && eventOrigin == PaymentEventOrigin.AllocationDeliveryCommenced)
            {
                _atomGenerator.GenerateAtomFeed(allocationNo, message.PaymentScheduleAllocation.ContractVersionNumber, AllocationDeliveryEntryCategory.AmendedContractAllocationApproved, connectionInfo);
                _logger.LogInformation(AdMonitoringDomainEventLoggingId.EventStoredForFeed, "Amended Contract Allocation Approved event was stored for the monitoring feed. Allocation no: {0}", allocationNo);
            }

            return Task.CompletedTask;
        }

        public Task Handle(PaymentAggregatedEvent message, IMessageHandlerContext context)
        {
            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var isNewContract = message.Allocation.VersionNumber == 1;
            var isAmendedContract = message.Allocation.VersionNumber > 1;
            var eventOrigin = message.PaymentEventOrigin;
            PaymentMethod paymentMethod = _allocationDeliveryMonitoringRepository.GetPaymentMethod(message.Allocation.FundingStreamPeriodCode, connectionInfo);
            var category = isNewContract ? AllocationDeliveryEntryCategory.NewContractAllocationApproved : AllocationDeliveryEntryCategory.AmendedContractAllocationApproved;
            var allocationNo = message.Allocation.AllocationNumber;

            _logger.LogInformation(AdMonitoringDomainEventLoggingId.EventReceived, "Payment Aggregated event received by Contract Allocation Approved handler for monitoring. Allocation no: {0}, Origin: {1}",
                allocationNo, eventOrigin.ToString());

            if (isNewContract && paymentMethod == PaymentMethod.PayOnProfile)
            {
                _allocationDeliveryMonitoringRepository.StoreMessagePayload(message.ToAllocationDeliveryEventReceived(_dateService, category.ToString()), connectionInfo, message.GetType());
                ProcessAllocationDeliveryCommencedPaymentCalculatedAndPaymentAggregatedEvents(message.Allocation.AllocationNumber, message.Allocation.VersionNumber, category, connectionInfo);
            }
            else if (isAmendedContract && paymentMethod == PaymentMethod.PayOnProfile)
            {
                _allocationDeliveryMonitoringRepository.StoreMessagePayload(message.ToAllocationDeliveryEventReceived(_dateService, category.ToString()), connectionInfo, message.GetType());
                _atomGenerator.GenerateAtomFeed(allocationNo, message.Allocation.VersionNumber, category, connectionInfo);
            }
            else if (isAmendedContract && (paymentMethod == PaymentMethod.PayOnActuals 
                  || paymentMethod == PaymentMethod.PayOnInstruction) 
                  && eventOrigin == PaymentEventOrigin.AllocationDeliveryCommenced)
            {
                _atomGenerator.GenerateAtomFeed(allocationNo, message.Allocation.VersionNumber, AllocationDeliveryEntryCategory.AmendedContractAllocationApproved, connectionInfo);
                _logger.LogInformation(AdMonitoringDomainEventLoggingId.EventStoredForFeed, "Amended Contract Allocation Approved event was stored for the monitoring feed. Allocation no: {0}", allocationNo);
            }

            return Task.CompletedTask;
        }

        /// <summary/>
        /// Attempts to retrieve all three Allocation Delivery Commenced, Payment Calculated (Schedule) and Payment Aggregated events
        /// from local AllocationDeliveryEventReceived data store. If all three events have arrived and been stored then
        /// publish a New/Amended Contract Allocation Approved event. 
        private void ProcessAllocationDeliveryCommencedPaymentCalculatedAndPaymentAggregatedEvents(string allocationNumber, int versionNumber, AllocationDeliveryEntryCategory categoryName,
            ConnectionInfo connectionInfo)
        {
            AllocationDeliveryEventReceived allocationDeliveryCommencedEntity = _allocationDeliveryMonitoringRepository.GetAllocationDeliveryEventReceivedEntity(
                allocationNumber,
                versionNumber,
                categoryName.ToString(),
                typeof(AllocationDeliveryCommencedEvent).Name,
                connectionInfo);
            if (allocationDeliveryCommencedEntity != null && allocationDeliveryCommencedEntity.Object == null)
            {
                allocationDeliveryCommencedEntity.Object = allocationDeliveryCommencedEntity.SerializedXml
                    .DeserializeXml<AllocationDeliveryCommencedEvent>();
            }

            if (allocationDeliveryCommencedEntity != null)
            {
                AllocationDeliveryEventReceived paymentCalculatedEntity = _allocationDeliveryMonitoringRepository.GetAllocationDeliveryEventReceivedEntity(
                    allocationNumber,
                    versionNumber,
                     categoryName.ToString(),
                    typeof(PaymentScheduleEvent).Name,
                    connectionInfo);
                if (paymentCalculatedEntity != null && paymentCalculatedEntity.Object == null)
                {
                    paymentCalculatedEntity.Object =
                        paymentCalculatedEntity.SerializedXml.DeserializeXml<PaymentScheduleEvent>();
                }

                if (paymentCalculatedEntity != null)
                {
                    AllocationDeliveryEventReceived paymentAggregatedEntity = _allocationDeliveryMonitoringRepository.GetAllocationDeliveryEventReceivedEntity(
                        allocationNumber,
                        versionNumber,
                         categoryName.ToString(),
                        typeof(PaymentAggregatedEvent).Name,
                        connectionInfo);

                    if (paymentAggregatedEntity != null && paymentAggregatedEntity.Object == null)
                    {
                        paymentAggregatedEntity.Object =
                            paymentAggregatedEntity.SerializedXml.DeserializeXml<PaymentAggregatedEvent>();
                    }

                    if (paymentAggregatedEntity != null)
                    {
                        PublishEvent(
                            //// Cast each object to their original event types
                            (AllocationDeliveryCommencedEvent)allocationDeliveryCommencedEntity.Object,
                            (PaymentScheduleEvent)paymentCalculatedEntity.Object,
                            (PaymentAggregatedEvent)paymentAggregatedEntity.Object,
                            categoryName,
                            connectionInfo);
                    }
                }
            }
        }

        private void PublishEvent(AllocationDeliveryCommencedEvent allocationDeliveryCommenced, PaymentScheduleEvent paymentCalculated, PaymentAggregatedEvent paymentAggregated, AllocationDeliveryEntryCategory category,
            ConnectionInfo connectionInfo)
        {
            AllocationDeliveryPerformance contractAllocationApprovedEvent = _allocationDeliveryPerformanceMapper.Map(allocationDeliveryCommenced, paymentCalculated, paymentAggregated, connectionInfo);
           
            _logger.LogInformation(AdMonitoringDomainEventLoggingId.EventMapped,
                    "Allocation Delivery Commenced/Payment Calculated/Payment Aggregated events were mapped to {0} event. Allocation no: {1}",
                    category.ToString(), contractAllocationApprovedEvent.contractAllocationNumber);

            // Store the output event
            _allocationDeliveryMonitoringRepository.StoreEvent(contractAllocationApprovedEvent, category, connectionInfo);

            _logger.LogInformation(AdMonitoringDomainEventLoggingId.EventStoredForFeed,
                    "{0} event was stored for the monitoring feed. Allocation no: {1}",
                    category.ToString(), contractAllocationApprovedEvent.contractAllocationNumber);
        }

        private bool IsPaymentMethod(string fspCode, PaymentMethod method, ConnectionInfo connectionInfo)
        {
            return method == _allocationDeliveryMonitoringRepository.GetPaymentMethod(fspCode, connectionInfo);
        }
    }
}
