namespace AllocationDeliveryDomain.Endpoint.Services
{
    using System;
    using System.Linq;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class MonthEndService : IMonthEndService
    {
        private const double MonthEndCompletionCheckInitialDeferralPeriodMinutes = 10;
        private const double MonthEndCompletionCheckFrequencyMinutes = 5;
        private static readonly string[] MonthEndQueueNames =
        {
            "allocationdeliverydomain.actualspull",
            "allocationdeliverydomain.actualspullcomplete",
            "allocationdeliverydomain.paymentinstructionvalidation",
            "allocationdeliverydomain.releaseheldreportedactuals",
            "allocationdeliverydomain.routing",
            "allocationdeliverydomain.validation",
            "xrm.receiveforpaymentaggregation" // required as deferred events will be found in subscribing XRM adapter's queue
        };
        private static readonly string[] MonthEndTopicNames =
        {
            "allocationdeliverydomain.validation.events",
            "paymentmanagementdomain.paymentschedule.events",
            "paymentmanagementdomain.paymentaggregation.events",
            "paymentgenerationdomain.aggregatepayment.events"
        };

        private readonly IMonthEndHistoryRepository _monthEndHistoryRepository;
        private readonly IAzureServiceBusQueryService _azureServiceBusQueryService;

        public MonthEndService(
            IMonthEndHistoryRepository monthEndHistoryRepository,
            IAzureServiceBusQueryService azureServiceBusQueryService)
        {
            _monthEndHistoryRepository = monthEndHistoryRepository;
            _azureServiceBusQueryService = azureServiceBusQueryService;
        }

        public TimeSpan MonthEndCheckDeferralTime => TimeSpan.FromMinutes(MonthEndCompletionCheckFrequencyMinutes);

        public void MarkMonthEndAsStarted(ConnectionInfo connectionInfo)
        {
            _monthEndHistoryRepository.StartMonthEnd(connectionInfo);
        }

        public void MarkMonthEndAsCompleted(ConnectionInfo connectionInfo)
        {
            _monthEndHistoryRepository.StopMonthEnd(connectionInfo);
        }

        public bool HasMonthEndInitialDeferralPeriodExpired(ConnectionInfo connectionInfo)
        {
            DateTime? latestMonthEndStartTime = _monthEndHistoryRepository.GetCurrentMonthEndStartTime(connectionInfo);

            if (latestMonthEndStartTime.HasValue)
            {
                DateTime currentTime = DateTime.UtcNow;
                TimeSpan timeElapsed = currentTime.Subtract(latestMonthEndStartTime.Value);
                return timeElapsed > TimeSpan.FromMinutes(MonthEndCompletionCheckInitialDeferralPeriodMinutes);
            }

            return true;
        }

        public bool HasMonthEndServiceBusActivityCompleted()
        {
            return
                MonthEndQueueNames.All(q => _azureServiceBusQueryService.GetQueueMessageCount(q) == 0) &&
                MonthEndTopicNames.All(t => _azureServiceBusQueryService.GetTopicMessageCount(t) == 0);
        }
    }
}